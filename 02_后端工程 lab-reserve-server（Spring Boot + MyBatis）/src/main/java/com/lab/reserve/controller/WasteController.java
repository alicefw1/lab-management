package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.dto.AuditRequest;
import com.lab.reserve.dto.WasteDisposeRequest;
import com.lab.reserve.entity.Waste;
import com.lab.reserve.mapper.WasteMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/wastes")
public class WasteController {

    @Autowired
    private WasteMapper wasteMapper;

    @GetMapping
    public Result<List<Waste>> list(@RequestParam(required = false) Integer status) {
        return Result.ok(wasteMapper.selectList(status));
    }

    @PostMapping
    public Result<?> report(@RequestBody Waste waste) {
        if (waste.getType() == null || waste.getType().trim().isEmpty()) {
            throw new BusinessException("废弃物类型不能为空");
        }
        waste.setReporterId(AuthContext.getUserId());
        waste.setStatus(0);
        if (waste.getWasteNo() == null || waste.getWasteNo().trim().isEmpty()) {
            waste.setWasteNo("W" + System.currentTimeMillis());
        }
        wasteMapper.insert(waste);
        return Result.ok();
    }

    // 废弃物审核验收
    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/audit")
    public Result<?> audit(@RequestBody AuditRequest request) {
        if (request.getId() == null) throw new BusinessException("废弃物ID不能为空");
        Waste waste = wasteMapper.selectById(request.getId());
        if (waste == null) throw new BusinessException("废弃物记录不存在");
        if (waste.getStatus() != null && waste.getStatus() != 0) {
            throw new BusinessException("该记录已处理");
        }
        // status: 1 验收通过, 3 驳回
        waste.setStatus(request.getStatus() == 1 ? 1 : 3);
        waste.setAuditUserId(AuthContext.getUserId());
        waste.setAuditTime(LocalDateTime.now());
        waste.setAuditRemark(request.getRemark());
        wasteMapper.updateById(waste);
        return Result.ok();
    }

    // 废弃物处置
    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/dispose")
    public Result<?> dispose(@RequestBody WasteDisposeRequest request) {
        if (request.getId() == null) throw new BusinessException("废弃物ID不能为空");
        Waste waste = wasteMapper.selectById(request.getId());
        if (waste == null) throw new BusinessException("废弃物记录不存在");
        if (waste.getStatus() == null || waste.getStatus() != 1) {
            throw new BusinessException("只有已验收的废弃物才能处置");
        }
        waste.setStatus(2);
        waste.setDisposeUserId(AuthContext.getUserId());
        waste.setDisposeTime(LocalDateTime.now());
        waste.setDisposeRemark(request.getDisposeRemark());
        wasteMapper.updateById(waste);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        wasteMapper.deleteById(id);
        return Result.ok();
    }
}
