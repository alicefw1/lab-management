package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.dto.RepairHandleRequest;
import com.lab.reserve.entity.BorrowRecord;
import com.lab.reserve.entity.Device;
import com.lab.reserve.entity.RepairRecord;
import com.lab.reserve.mapper.BorrowRecordMapper;
import com.lab.reserve.mapper.DeviceMapper;
import com.lab.reserve.mapper.RepairRecordMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/repairs")
public class RepairController {

    @Autowired
    private RepairRecordMapper repairRecordMapper;

    @Autowired
    private DeviceMapper deviceMapper;

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @PostMapping("/report")
    public Result<?> report(@RequestBody RepairRecord repair) {
        if (repair == null || repair.getDeviceId() == null) {
            throw new BusinessException("请选择要报修的设备");
        }
        if (repair.getFaultDesc() == null || repair.getFaultDesc().trim().isEmpty()) {
            throw new BusinessException("请填写故障描述");
        }
        Device device = deviceMapper.selectById(repair.getDeviceId());
        if (device == null) {
            throw new BusinessException("设备不存在");
        }
        if (device.getStatus() != null && device.getStatus() == 4) {
            throw new BusinessException("设备已停用，无需报修");
        }
        String role = AuthContext.getRoleCode();
        if ("STUDENT".equals(role) || "TEACHER".equals(role)) {
            int active = 0;
            List<BorrowRecord> records = borrowRecordMapper.selectList(null, AuthContext.getUserId());
            for (BorrowRecord r : records) {
                if (r.getDeviceId().equals(repair.getDeviceId())
                        && (r.getStatus() == 1 || r.getStatus() == 3)) {
                    active++;
                }
            }
            if (active == 0) {
                throw new BusinessException("只能报修自己正在借用的设备");
            }
        }
        int pending = repairRecordMapper.countPendingByDeviceId(repair.getDeviceId());
        if (pending > 0) {
            throw new BusinessException("该设备已有未完成的报修记录");
        }
        repair.setUserId(AuthContext.getUserId());
        repair.setReportTime(LocalDateTime.now());
        repair.setRepairStatus(0);
        repairRecordMapper.insert(repair);
        // 仅当设备不是「已借出」状态时才标记为维修中，避免覆盖借用状态
        if (device.getStatus() == null || device.getStatus() != 2) {
            deviceMapper.updateStatus(repair.getDeviceId(), 3);
        }
        return Result.ok();
    }

    @GetMapping
    public Result<List<RepairRecord>> page(@RequestParam(required = false) Integer status) {
        String role = AuthContext.getRoleCode();
        Long userId = ("STUDENT".equals(role) || "TEACHER".equals(role)) ? AuthContext.getUserId() : null;
        return Result.ok(repairRecordMapper.selectList(status, userId));
    }

    @RequireRole({"LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/handle")
    public Result<?> handle(@RequestBody RepairHandleRequest request) {
        if (request == null || request.getRepairId() == null) {
            throw new BusinessException("工单ID不能为空");
        }
        if (request.getStatus() == null || (request.getStatus() != 1 && request.getStatus() != 2)) {
            throw new BusinessException("处理状态只能是1或2");
        }
        RepairRecord record = repairRecordMapper.selectById(request.getRepairId());
        if (record == null) {
            throw new BusinessException("工单不存在");
        }
        record.setRepairStatus(request.getStatus());
        record.setRepairResult(request.getHandleResult());
        record.setFinishTime(LocalDateTime.now());
        repairRecordMapper.updateById(record);
        if (request.getStatus() == 2) {
            Device device = deviceMapper.selectById(record.getDeviceId());
            if (device != null) {
                int activeBorrow = borrowRecordMapper.countActiveByDeviceId(record.getDeviceId());
                deviceMapper.updateStatus(record.getDeviceId(), activeBorrow > 0 ? 2 : 1);
            }
        }
        return Result.ok();
    }
}
