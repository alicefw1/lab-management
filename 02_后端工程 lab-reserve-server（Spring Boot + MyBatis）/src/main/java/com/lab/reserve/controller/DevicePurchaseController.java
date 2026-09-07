package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.dto.AuditRequest;
import com.lab.reserve.entity.DevicePurchase;
import com.lab.reserve.mapper.DevicePurchaseMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/purchases")
public class DevicePurchaseController {

    @Autowired
    private DevicePurchaseMapper devicePurchaseMapper;

    @GetMapping
    public Result<List<DevicePurchase>> list(@RequestParam(required = false) Integer status) {
        return Result.ok(devicePurchaseMapper.selectList(status));
    }

    @PostMapping
    public Result<?> save(@RequestBody DevicePurchase purchase) {
        if (purchase.getDeviceName() == null || purchase.getDeviceName().trim().isEmpty()) {
            throw new BusinessException("设备名称不能为空");
        }
        if (purchase.getQuantity() == null || purchase.getQuantity() <= 0) {
            purchase.setQuantity(1);
        }
        purchase.setApplicantId(AuthContext.getUserId());
        purchase.setStatus(0);
        devicePurchaseMapper.insert(purchase);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/audit")
    public Result<?> audit(@RequestBody AuditRequest request) {
        if (request.getId() == null) throw new BusinessException("采购单ID不能为空");
        DevicePurchase purchase = devicePurchaseMapper.selectById(request.getId());
        if (purchase == null) throw new BusinessException("采购单不存在");
        if (purchase.getStatus() != null && purchase.getStatus() != 0) {
            throw new BusinessException("该采购单已处理");
        }
        purchase.setStatus(request.getStatus());
        purchase.setAuditUserId(AuthContext.getUserId());
        purchase.setAuditTime(LocalDateTime.now());
        devicePurchaseMapper.updateById(purchase);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        devicePurchaseMapper.deleteById(id);
        return Result.ok();
    }
}
