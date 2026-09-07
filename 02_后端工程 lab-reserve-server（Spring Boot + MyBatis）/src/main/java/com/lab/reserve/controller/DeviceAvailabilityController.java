package com.lab.reserve.controller;

import com.lab.reserve.entity.Device;
import com.lab.reserve.mapper.BorrowApplyMapper;
import com.lab.reserve.mapper.BorrowRecordMapper;
import com.lab.reserve.mapper.DeviceMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/devices")
public class DeviceAvailabilityController {

    @Autowired
    private DeviceMapper deviceMapper;

    @Autowired
    private BorrowApplyMapper borrowApplyMapper;

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @GetMapping("/{id}/availability")
    public Result<Map<String, Object>> availability(@PathVariable Long id) {
        Map<String, Object> data = new HashMap<>();
        Device device = deviceMapper.selectById(id);
        if (device == null) {
            data.put("available", false);
            data.put("reason", "设备不存在");
            return Result.ok(data);
        }
        if (device.getStatus() == null || device.getStatus() != 1) {
            data.put("available", false);
            data.put("reason", "设备当前状态不可借");
            data.put("deviceStatus", device.getStatus());
            return Result.ok(data);
        }
        int activeRecords = borrowRecordMapper.countActiveByDeviceId(id);
        if (activeRecords > 0) {
            data.put("available", false);
            data.put("reason", "设备存在未归还记录");
            return Result.ok(data);
        }
        int pendingApplies = borrowApplyMapper.count(id, null, 0);
        if (pendingApplies > 0) {
            data.put("available", false);
            data.put("reason", "设备已有待审批申请");
            data.put("pendingApplyCount", pendingApplies);
            return Result.ok(data);
        }
        data.put("available", true);
        data.put("reason", "设备可借");
        data.put("pendingApplyCount", 0);
        return Result.ok(data);
    }
}
