package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.ScrapApply;
import com.lab.reserve.mapper.DeviceMapper;
import com.lab.reserve.mapper.ScrapApplyMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/scraps")
public class ScrapController {

    @Autowired
    private ScrapApplyMapper scrapApplyMapper;

    @Autowired
    private DeviceMapper deviceMapper;

    @GetMapping
    public Result<List<ScrapApply>> list(@RequestParam(required = false) Integer status) {
        String role = AuthContext.getRoleCode();
        Long userId = null;
        if ("STUDENT".equals(role) || "TEACHER".equals(role)) {
            userId = AuthContext.getUserId();
        }
        return Result.ok(scrapApplyMapper.selectList(status, userId));
    }

    @PostMapping
    public Result<?> apply(@RequestBody ScrapApply scrapApply) {
        if (scrapApply.getDeviceId() == null) throw new BusinessException("请选择设备");
        if (scrapApply.getReason() == null || scrapApply.getReason().trim().isEmpty()) {
            throw new BusinessException("请填写报废理由");
        }
        if (deviceMapper.selectById(scrapApply.getDeviceId()) == null) {
            throw new BusinessException("设备不存在");
        }
        scrapApply.setUserId(AuthContext.getUserId());
        scrapApply.setStatus(0);
        scrapApplyMapper.insert(scrapApply);
        return Result.ok();
    }

    @RequireRole({"LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/audit")
    public Result<?> audit(@RequestBody ScrapApply scrapApply) {
        if (scrapApply.getId() == null) throw new BusinessException("申请ID不能为空");
        ScrapApply exist = scrapApplyMapper.selectById(scrapApply.getId());
        if (exist == null) throw new BusinessException("申请不存在");
        if (exist.getStatus() != null && exist.getStatus() != 0) {
            throw new BusinessException("该申请已处理");
        }
        exist.setStatus(scrapApply.getStatus());
        exist.setAuditUserId(AuthContext.getUserId());
        exist.setAuditTime(LocalDateTime.now());
        exist.setAuditRemark(scrapApply.getAuditRemark());
        scrapApplyMapper.updateById(exist);
        // 审核通过：设备置为报废状态
        if (scrapApply.getStatus() != null && scrapApply.getStatus() == 1) {
            deviceMapper.updateStatus(exist.getDeviceId(), 4);
        }
        return Result.ok();
    }
}
