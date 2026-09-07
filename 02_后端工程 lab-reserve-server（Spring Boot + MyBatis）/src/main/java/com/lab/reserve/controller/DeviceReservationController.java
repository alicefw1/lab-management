package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.dto.AuditRequest;
import com.lab.reserve.entity.DeviceReservation;
import com.lab.reserve.mapper.DeviceReservationMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/device-reservations")
public class DeviceReservationController {

    @Autowired
    private DeviceReservationMapper deviceReservationMapper;

    @GetMapping
    public Result<List<DeviceReservation>> list(@RequestParam(required = false) Integer status,
                                                @RequestParam(required = false) Long userId) {
        String role = AuthContext.getRoleCode();
        if ("STUDENT".equals(role) || "TEACHER".equals(role)) {
            userId = AuthContext.getUserId();
        }
        return Result.ok(deviceReservationMapper.selectList(status, userId));
    }

    @PostMapping
    public Result<?> reserve(@RequestBody DeviceReservation reservation) {
        if (reservation.getDeviceId() == null) throw new BusinessException("请选择设备");
        if (reservation.getReserveDate() == null) throw new BusinessException("请选择预约日期");
        if (reservation.getTimeSlot() == null || reservation.getTimeSlot().trim().isEmpty()) {
            throw new BusinessException("请选择预约时间段");
        }
        int conflict = deviceReservationMapper.countConflict(
                reservation.getDeviceId(), reservation.getReserveDate().toString(), reservation.getTimeSlot(), null);
        if (conflict > 0) {
            throw new BusinessException("该设备在该时间段已被预约");
        }
        reservation.setUserId(AuthContext.getUserId());
        reservation.setStatus(0);
        deviceReservationMapper.insert(reservation);
        return Result.ok();
    }

    @RequireRole({"LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/audit")
    public Result<?> audit(@RequestBody AuditRequest request) {
        if (request.getId() == null) throw new BusinessException("预约ID不能为空");
        DeviceReservation reservation = deviceReservationMapper.selectById(request.getId());
        if (reservation == null) throw new BusinessException("预约不存在");
        if (reservation.getStatus() != null && reservation.getStatus() != 0) {
            throw new BusinessException("该预约已处理");
        }
        reservation.setStatus(request.getStatus());
        reservation.setAuditUserId(AuthContext.getUserId());
        reservation.setAuditTime(LocalDateTime.now());
        deviceReservationMapper.updateById(reservation);
        return Result.ok();
    }

    @PutMapping("/cancel")
    public Result<?> cancel(@RequestBody DeviceReservation reservation) {
        if (reservation.getId() == null) throw new BusinessException("预约ID不能为空");
        DeviceReservation exist = deviceReservationMapper.selectById(reservation.getId());
        if (exist == null) throw new BusinessException("预约不存在");
        // 学生/教师只能取消自己的预约，管理员可取消任意预约
        String role = AuthContext.getRoleCode();
        if (("STUDENT".equals(role) || "TEACHER".equals(role)) && !exist.getUserId().equals(AuthContext.getUserId())) {
            throw new BusinessException("只能取消自己的预约");
        }
        exist.setStatus(3);
        deviceReservationMapper.updateById(exist);
        return Result.ok();
    }
}
