package com.lab.reserve.service;

import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.dto.ApproveBorrowRequest;
import com.lab.reserve.dto.ReturnDeviceRequest;
import com.lab.reserve.entity.BorrowApply;
import com.lab.reserve.entity.BorrowRecord;
import com.lab.reserve.entity.Device;
import com.lab.reserve.mapper.BorrowApplyMapper;
import com.lab.reserve.mapper.BorrowRecordMapper;
import com.lab.reserve.mapper.DeviceMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Objects;

@Service
public class BorrowBusinessService {

    @Autowired
    private BorrowApplyMapper borrowApplyMapper;

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Autowired
    private DeviceMapper deviceMapper;

    @Autowired
    private CreditService creditService;

    @Autowired
    private OperationLogService operationLogService;

    @Transactional(rollbackFor = Exception.class)
    public void apply(BorrowApply apply) {
        Long userId = requireLoginUserId();
        if (apply == null || apply.getDeviceId() == null) {
            throw new BusinessException("请选择要借用的设备");
        }
        // 诚信评分校验：低于阈值禁止借用
        creditService.checkBorrowEligibility(userId);
        if (apply.getExpectedReturnTime() == null) {
            throw new BusinessException("请填写预计归还时间");
        }
        if (!apply.getExpectedReturnTime().isAfter(LocalDateTime.now())) {
            throw new BusinessException("预计归还时间必须晚于当前时间");
        }
        Device device = deviceMapper.selectById(apply.getDeviceId());
        if (device == null) {
            throw new BusinessException("设备不存在");
        }
        if (!Objects.equals(device.getStatus(), 1)) {
            throw new BusinessException("该设备当前不可借用");
        }
        int ownPending = borrowApplyMapper.count(apply.getDeviceId(), userId, 0);
        if (ownPending > 0) {
            throw new BusinessException("你已提交该设备的待审批申请，请勿重复提交");
        }
        int devicePending = borrowApplyMapper.count(apply.getDeviceId(), null, 0);
        if (devicePending > 0) {
            throw new BusinessException("该设备已有待审批申请，请选择其他设备");
        }
        int activeRecord = borrowRecordMapper.countActiveByDeviceId(apply.getDeviceId());
        if (activeRecord > 0) {
            throw new BusinessException("该设备存在未归还记录");
        }
        apply.setUserId(userId);
        apply.setApplyTime(LocalDateTime.now());
        apply.setStatus(0);
        borrowApplyMapper.insert(apply);
        operationLogService.log("设备借用", "提交申请", "用户申请借用设备 #" + apply.getDeviceId());
    }

    @Transactional(rollbackFor = Exception.class)
    public void approve(ApproveBorrowRequest request) {
        if (request == null || request.getApplyId() == null) {
            throw new BusinessException("申请ID不能为空");
        }
        if (!Objects.equals(request.getStatus(), 1) && !Objects.equals(request.getStatus(), 2)) {
            throw new BusinessException("审核状态不合法");
        }
        BorrowApply apply = borrowApplyMapper.selectById(request.getApplyId());
        if (apply == null) {
            throw new BusinessException("申请不存在");
        }
        if (!Objects.equals(apply.getStatus(), 0)) {
            throw new BusinessException("该申请已处理");
        }
        apply.setStatus(request.getStatus());
        apply.setApproveUserId(requireLoginUserId());
        apply.setApproveTime(LocalDateTime.now());
        apply.setApproveRemark(request.getApproveRemark());
        borrowApplyMapper.updateById(apply);

        if (Objects.equals(request.getStatus(), 2)) {
            return;
        }
        int active = borrowRecordMapper.countActiveByDeviceId(apply.getDeviceId());
        if (active > 0) {
            throw new BusinessException("该设备存在未归还记录，无法通过审核");
        }
        int updated = 0;
        Device device = deviceMapper.selectById(apply.getDeviceId());
        if (device != null && Objects.equals(device.getStatus(), 1)) {
            deviceMapper.updateStatus(apply.getDeviceId(), 2);
            updated = 1;
        }
        if (updated == 0) {
            throw new BusinessException("设备状态已变化，无法通过审核");
        }
        BorrowRecord record = new BorrowRecord();
        record.setApplyId(apply.getId());
        record.setDeviceId(apply.getDeviceId());
        record.setUserId(apply.getUserId());
        record.setBorrowTime(LocalDateTime.now());
        record.setStatus(1);
        borrowRecordMapper.insert(record);
        operationLogService.log("借用审批", "通过申请", "审批通过借用申请 #" + apply.getId() + "，设备 #" + apply.getDeviceId());
    }

    @Transactional(rollbackFor = Exception.class)
    public void returnDevice(ReturnDeviceRequest request) {
        if (request == null || request.getRecordId() == null) {
            throw new BusinessException("借用记录ID不能为空");
        }
        BorrowRecord record = borrowRecordMapper.selectById(request.getRecordId());
        if (record == null) {
            throw new BusinessException("借用记录不存在");
        }
        if (!Objects.equals(record.getStatus(), 1) && !Objects.equals(record.getStatus(), 3)) {
            throw new BusinessException("该记录不是借用中状态");
        }
        // 逾期归还扣诚信分
        if (Objects.equals(record.getStatus(), 3)) {
            creditService.changeScore(record.getUserId(), "扣分", -10, "设备逾期归还");
        }
        record.setReturnTime(LocalDateTime.now());
        record.setRemark(request.getRemark());
        record.setStatus(2);
        borrowRecordMapper.updateById(record);
        deviceMapper.updateStatus(record.getDeviceId(), 1);
        operationLogService.log("设备归还", "归还设备", "归还设备 #" + record.getDeviceId());
    }

    // 设备损失登记：扣除借用者诚信分
    @Transactional(rollbackFor = Exception.class)
    public void reportLoss(Long recordId, String reason) {
        BorrowRecord record = borrowRecordMapper.selectById(recordId);
        if (record == null) {
            throw new BusinessException("借用记录不存在");
        }
        // 扣除诚信分（损失设备扣 30 分）
        creditService.changeScore(record.getUserId(), "扣分", -30, "设备损失：" + (reason == null ? "未说明" : reason));
        // 设备报废
        deviceMapper.updateStatus(record.getDeviceId(), 4);
        record.setStatus(2);
        record.setReturnTime(LocalDateTime.now());
        record.setRemark("设备损失：" + (reason == null ? "未说明" : reason));
        borrowRecordMapper.updateById(record);
        operationLogService.log("设备损失", "登记损失", "设备 #" + record.getDeviceId() + " 损失登记：" + (reason == null ? "未说明" : reason));
    }

    private Long requireLoginUserId() {
        Long id = AuthContext.getUserId();
        if (id == null) {
            throw new BusinessException("请先登录");
        }
        return id;
    }
}
