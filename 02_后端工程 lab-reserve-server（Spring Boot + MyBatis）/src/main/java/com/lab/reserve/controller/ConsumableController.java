package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.Consumable;
import com.lab.reserve.mapper.ConsumableMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/consumables")
public class ConsumableController {

    @Autowired
    private ConsumableMapper consumableMapper;

    @GetMapping
    public Result<List<Consumable>> list(@RequestParam(required = false) String keyword) {
        return Result.ok(consumableMapper.selectList(keyword));
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping
    public Result<?> save(@RequestBody Consumable consumable) {
        if (consumable.getName() == null || consumable.getName().trim().isEmpty()) {
            throw new BusinessException("耗材名称不能为空");
        }
        if (consumable.getStatus() == null) consumable.setStatus(1);
        if (consumable.getQuantity() == null) consumable.setQuantity(0);
        consumableMapper.insert(consumable);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PutMapping
    public Result<?> update(@RequestBody Consumable consumable) {
        if (consumable.getId() == null) throw new BusinessException("耗材ID不能为空");
        consumableMapper.updateById(consumable);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        consumableMapper.deleteById(id);
        return Result.ok();
    }
}
