package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.Instrument;
import com.lab.reserve.mapper.InstrumentMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/instruments")
public class InstrumentController {

    @Autowired
    private InstrumentMapper instrumentMapper;

    @GetMapping
    public Result<List<Instrument>> list(@RequestParam(required = false) String keyword,
                                          @RequestParam(required = false) Integer status) {
        return Result.ok(instrumentMapper.selectList(keyword, status));
    }

    @GetMapping("/{id}")
    public Result<Instrument> get(@PathVariable Long id) {
        Instrument instrument = instrumentMapper.selectById(id);
        if (instrument == null) throw new BusinessException("仪器不存在");
        return Result.ok(instrument);
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping
    public Result<?> save(@RequestBody Instrument instrument) {
        if (instrument.getName() == null || instrument.getName().trim().isEmpty()) {
            throw new BusinessException("仪器名称不能为空");
        }
        if (instrument.getStatus() == null) instrument.setStatus(1);
        instrumentMapper.insert(instrument);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PutMapping
    public Result<?> update(@RequestBody Instrument instrument) {
        if (instrument.getId() == null) throw new BusinessException("仪器ID不能为空");
        instrumentMapper.updateById(instrument);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        instrumentMapper.deleteById(id);
        return Result.ok();
    }

    @GetMapping("/statistics")
    public Result<Map<String, Object>> statistics() {
        Map<String, Object> data = new HashMap<>();
        data.put("normal", instrumentMapper.countByStatus(1));
        data.put("checking", instrumentMapper.countByStatus(2));
        data.put("disabled", instrumentMapper.countByStatus(3));
        data.put("scrapped", instrumentMapper.countByStatus(4));
        data.put("total", instrumentMapper.countByStatus(1) + instrumentMapper.countByStatus(2) + instrumentMapper.countByStatus(3) + instrumentMapper.countByStatus(4));
        return Result.ok(data);
    }
}
