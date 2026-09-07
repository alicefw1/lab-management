package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.mapper.BorrowApplyMapper;
import com.lab.reserve.mapper.BorrowRecordMapper;
import com.lab.reserve.mapper.DeviceMapper;
import com.lab.reserve.mapper.RepairRecordMapper;
import com.lab.reserve.mapper.UserMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/stats")
public class StatsController {

    @Autowired
    private DeviceMapper deviceMapper;

    @Autowired
    private BorrowApplyMapper borrowApplyMapper;

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Autowired
    private RepairRecordMapper repairRecordMapper;

    @Autowired
    private UserMapper userMapper;

    @RequireRole({"ADMIN", "LAB_ADMIN", "DEPARTMENT_HEAD"})
    @GetMapping("/overview")
    public Result<Map<String, Object>> overview() {
        Map<String, Object> m = new HashMap<>();
        int totalDevices = deviceMapper.countAll();
        m.put("userCount", userMapper.selectList(null, null, null).size());
        m.put("deviceTotal", totalDevices);
        m.put("availableDevices", deviceMapper.selectList(null, 1).size());
        m.put("borrowedDevices", deviceMapper.selectList(null, 2).size());
        m.put("repairingDevices", deviceMapper.selectList(null, 3).size());
        m.put("pendingApplies", borrowApplyMapper.selectList(0, null).size());
        m.put("borrowingRecords", borrowRecordMapper.selectList(1, null).size()
                + borrowRecordMapper.selectList(3, null).size());
        m.put("pendingRepairs", repairRecordMapper.selectList(0, null).size());
        return Result.ok(m);
    }
}
