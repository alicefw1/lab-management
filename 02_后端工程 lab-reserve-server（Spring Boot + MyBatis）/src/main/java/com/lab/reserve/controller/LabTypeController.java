package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.LabType;
import com.lab.reserve.mapper.LabTypeMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/lab-types")
public class LabTypeController {

    @Autowired
    private LabTypeMapper labTypeMapper;

    @GetMapping
    public Result<List<LabType>> list() {
        return Result.ok(labTypeMapper.selectList());
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping
    public Result<?> save(@RequestBody LabType labType) {
        if (labType.getTypeName() == null || labType.getTypeName().trim().isEmpty()) {
            throw new BusinessException("类型名称不能为空");
        }
        labTypeMapper.insert(labType);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PutMapping
    public Result<?> update(@RequestBody LabType labType) {
        if (labType.getId() == null) throw new BusinessException("类型ID不能为空");
        labTypeMapper.updateById(labType);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        labTypeMapper.deleteById(id);
        return Result.ok();
    }
}
