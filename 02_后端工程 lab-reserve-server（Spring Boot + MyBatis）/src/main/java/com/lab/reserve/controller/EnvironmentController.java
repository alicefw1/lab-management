package com.lab.reserve.controller;

import com.lab.reserve.entity.EnergyMeter;
import com.lab.reserve.entity.EnvironmentSensor;
import com.lab.reserve.mapper.EnergyMeterMapper;
import com.lab.reserve.mapper.EnvironmentSensorMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/environment")
public class EnvironmentController {

    @Autowired
    private EnvironmentSensorMapper sensorMapper;

    @Autowired
    private EnergyMeterMapper energyMapper;

    @GetMapping("/sensors")
    public Result<List<EnvironmentSensor>> sensors() {
        return Result.ok(sensorMapper.selectList());
    }

    @GetMapping("/sensors/{id}/data")
    public Result<List<Map<String, Object>>> sensorData(@PathVariable Long id) {
        return Result.ok(sensorMapper.selectRecentData(id, 24));
    }

    @GetMapping("/energy")
    public Result<List<EnergyMeter>> energy() {
        return Result.ok(energyMapper.selectList());
    }

    @GetMapping("/dashboard")
    public Result<Map<String, Object>> dashboard() {
        Map<String, Object> data = new HashMap<>();
        data.put("sensorTotal", sensorMapper.selectList().size());
        data.put("sensorOnline", sensorMapper.countByStatus(1));
        data.put("sensorOffline", sensorMapper.countByStatus(0));
        data.put("meterTotal", energyMapper.selectList().size());
        data.put("sensors", sensorMapper.selectList());
        return Result.ok(data);
    }
}
