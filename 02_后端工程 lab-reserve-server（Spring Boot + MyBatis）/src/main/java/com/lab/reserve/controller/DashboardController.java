package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.entity.LabReservation;
import com.lab.reserve.entity.LabRoom;
import com.lab.reserve.mapper.*;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    @Autowired
    private LabRoomMapper labRoomMapper;

    @Autowired
    private LabReservationMapper labReservationMapper;

    @Autowired
    private DeviceMapper deviceMapper;

    @Autowired
    private DeviceReservationMapper deviceReservationMapper;

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Autowired
    private RepairRecordMapper repairRecordMapper;

    @Autowired
    private ConsumableMapper consumableMapper;

    @Autowired
    private WasteMapper wasteMapper;

    @RequireRole({"ADMIN", "LAB_ADMIN", "DEPARTMENT_HEAD"})
    @GetMapping("/overview")
    public Result<Map<String, Object>> overview() {
        Map<String, Object> data = new LinkedHashMap<>();

        // 基础统计
        data.put("labRoomCount", labRoomMapper.countAll());
        data.put("deviceCount", deviceMapper.countAll());
        data.put("consumableCount", consumableMapper.selectList(null).size());
        data.put("wasteCount", wasteMapper.selectList(null).size());
        data.put("pendingLabReservation", labReservationMapper.selectList(0, null).size());
        data.put("pendingDeviceReservation", deviceReservationMapper.selectList(0, null).size());

        // 实验室使用率
        List<LabRoom> rooms = labRoomMapper.selectList(null);
        List<LabReservation> labReservations = labReservationMapper.selectList(1, null);
        Map<Long, Integer> labUsage = new HashMap<>();
        for (LabReservation r : labReservations) {
            labUsage.merge(r.getLabId(), 1, Integer::sum);
        }
        List<Map<String, Object>> labUsageList = new ArrayList<>();
        for (LabRoom room : rooms) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("name", room.getName());
            int count = labUsage.getOrDefault(room.getId(), 0);
            // 使用率 = 预约次数 / (容量上限) 简化为相对占比
            m.put("reservationCount", count);
            m.put("capacity", room.getCapacity());
            labUsageList.add(m);
        }
        data.put("labUsage", labUsageList);

        // 设备使用率
        int totalDevices = deviceMapper.countAll();
        int borrowedDevices = deviceMapper.selectList(null, 2).size();
        int repairingDevices = deviceMapper.selectList(null, 3).size();
        int availableDevices = deviceMapper.selectList(null, 1).size();
        data.put("availableDevices", availableDevices);
        data.put("borrowedDevices", borrowedDevices);
        data.put("repairingDevices", repairingDevices);
        data.put("deviceUsageRate", totalDevices == 0 ? 0 : Math.round((borrowedDevices * 100.0) / totalDevices));

        // 借用记录统计
        data.put("borrowingRecords", borrowRecordMapper.selectList(1, null).size());
        data.put("overdueRecords", borrowRecordMapper.selectList(3, null).size());
        data.put("returnedRecords", borrowRecordMapper.selectList(2, null).size());

        // 报修统计
        data.put("pendingRepairs", repairRecordMapper.selectList(0, null).size());
        data.put("processingRepairs", repairRecordMapper.selectList(1, null).size());
        data.put("finishedRepairs", repairRecordMapper.selectList(2, null).size());

        return Result.ok(data);
    }
}
