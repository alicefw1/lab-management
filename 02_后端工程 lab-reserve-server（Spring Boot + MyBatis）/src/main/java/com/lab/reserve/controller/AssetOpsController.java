package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.mapper.AssetOpsMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/asset-ops")
@RequireRole({"LAB_ADMIN","ADMIN","DEPARTMENT_HEAD"})
public class AssetOpsController {
    @Autowired private AssetOpsMapper mapper;

    @GetMapping("/suppliers")
    public Result<List<Map<String,Object>>> suppliers(@RequestParam(required=false) String keyword,
                                                       @RequestParam(required=false) Integer status) {
        return Result.ok(mapper.selectSuppliers(keyword == null ? null : keyword.trim(), status));
    }
    @RequireRole({"ADMIN","DEPARTMENT_HEAD"})
    @PostMapping("/suppliers") public Result<?> createSupplier(@RequestBody Map<String,Object> data) {
        required(data,"supplierName","供应商名称"); mapper.insertSupplier(data); return Result.ok("供应商创建成功",data);
    }
    @RequireRole({"ADMIN","DEPARTMENT_HEAD"})
    @PutMapping("/suppliers") public Result<?> updateSupplier(@RequestBody Map<String,Object> data) {
        required(data,"id","供应商ID"); mapper.updateSupplier(data); return Result.ok();
    }
    @RequireRole({"ADMIN","DEPARTMENT_HEAD"})
    @DeleteMapping("/suppliers/{id}") public Result<?> deleteSupplier(@PathVariable Long id) {
        mapper.deleteSupplier(id); return Result.ok();
    }

    @GetMapping("/maintenance-plans")
    public Result<List<Map<String,Object>>> plans(@RequestParam(required=false) Integer status) {
        return Result.ok(mapper.selectMaintenancePlans(status));
    }
    @PostMapping("/maintenance-plans") public Result<?> createPlan(@RequestBody Map<String,Object> data) {
        required(data,"deviceId","设备"); required(data,"planName","维护计划名称"); required(data,"nextDate","下次维护日期");
        data.put("creatorId",AuthContext.getUserId()); mapper.insertMaintenancePlan(data); return Result.ok("维护计划创建成功",data);
    }
    @PutMapping("/maintenance-plans") public Result<?> updatePlan(@RequestBody Map<String,Object> data) {
        required(data,"id","维护计划ID"); mapper.updateMaintenancePlan(data); return Result.ok();
    }
    @RequireRole({"ADMIN","DEPARTMENT_HEAD"})
    @DeleteMapping("/maintenance-plans/{id}") public Result<?> deletePlan(@PathVariable Long id) {
        mapper.deleteMaintenancePlan(id); return Result.ok();
    }
    @GetMapping("/maintenance-records")
    public Result<List<Map<String,Object>>> records(@RequestParam(required=false) Long planId) {
        return Result.ok(mapper.selectMaintenanceRecords(planId));
    }
    @Transactional
    @PostMapping("/maintenance-records") public Result<?> complete(@RequestBody Map<String,Object> data) {
        required(data,"planId","维护计划"); required(data,"result","维护结果");
        data.put("operatorId",AuthContext.getUserId()); mapper.insertMaintenanceRecord(data); mapper.finishMaintenancePlan(data);
        return Result.ok("维护登记完成",null);
    }
    private static void required(Map<String,Object> data,String key,String label) {
        Object value=data==null?null:data.get(key);
        if(value==null||String.valueOf(value).trim().isEmpty()) throw new BusinessException(label+"不能为空");
    }
}
