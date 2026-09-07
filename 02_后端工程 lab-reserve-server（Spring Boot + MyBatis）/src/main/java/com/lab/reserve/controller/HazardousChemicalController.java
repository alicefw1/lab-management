package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.HazardousChemical;
import com.lab.reserve.mapper.HazardousChemicalMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/chemicals")
public class HazardousChemicalController {

    @Autowired
    private HazardousChemicalMapper hazardousChemicalMapper;

    @GetMapping
    public Result<List<HazardousChemical>> list(@RequestParam(required = false) String keyword) {
        return Result.ok(hazardousChemicalMapper.selectList(keyword));
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping
    public Result<?> save(@RequestBody HazardousChemical chemical) {
        if (chemical.getName() == null || chemical.getName().trim().isEmpty()) {
            throw new BusinessException("危化品名称不能为空");
        }
        hazardousChemicalMapper.insert(chemical);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PutMapping
    public Result<?> update(@RequestBody HazardousChemical chemical) {
        if (chemical.getId() == null) throw new BusinessException("危化品ID不能为空");
        hazardousChemicalMapper.updateById(chemical);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        hazardousChemicalMapper.deleteById(id);
        return Result.ok();
    }
}
