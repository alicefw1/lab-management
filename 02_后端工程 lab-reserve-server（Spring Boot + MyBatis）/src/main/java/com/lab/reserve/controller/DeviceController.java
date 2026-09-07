package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.Device;
import com.lab.reserve.entity.DeviceCategory;
import com.lab.reserve.mapper.DeviceCategoryMapper;
import com.lab.reserve.mapper.DeviceMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class DeviceController {

    @Autowired
    private DeviceMapper deviceMapper;

    @Autowired
    private DeviceCategoryMapper categoryMapper;

    @GetMapping("/api/devices")
    public Result<List<Device>> devices(@RequestParam(required = false) String keyword,
                                        @RequestParam(required = false) Integer status) {
        return Result.ok(deviceMapper.selectList(keyword, status));
    }

    @RequireRole({"ADMIN", "LAB_ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/api/devices")
    public Result<?> save(@RequestBody Device device) {
        if (device.getStatus() == null) device.setStatus(1);
        deviceMapper.insert(device);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "LAB_ADMIN", "DEPARTMENT_HEAD"})
    @PutMapping("/api/devices")
    public Result<?> update(@RequestBody Device device) {
        if (device.getId() == null) throw new BusinessException("设备ID不能为空");
        deviceMapper.updateById(device);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/api/devices/{id}")
    public Result<?> delete(@PathVariable Long id) {
        deviceMapper.deleteById(id);
        return Result.ok();
    }

    @GetMapping("/api/categories")
    public Result<List<DeviceCategory>> categories() {
        return Result.ok(categoryMapper.selectList());
    }

    @RequireRole({"ADMIN", "LAB_ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/api/categories")
    public Result<?> saveCategory(@RequestBody DeviceCategory category) {
        if (category.getCategoryName() == null || category.getCategoryName().trim().isEmpty()) {
            throw new BusinessException("分类名称不能为空");
        }
        categoryMapper.insert(category);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PutMapping("/api/categories")
    public Result<?> updateCategory(@RequestBody DeviceCategory category) {
        if (category.getId() == null) throw new BusinessException("分类ID不能为空");
        categoryMapper.updateById(category);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/api/categories/{id}")
    public Result<?> deleteCategory(@PathVariable Long id) {
        categoryMapper.deleteById(id);
        return Result.ok();
    }
}
