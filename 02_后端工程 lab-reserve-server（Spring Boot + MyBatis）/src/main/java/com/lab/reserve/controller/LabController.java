package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.dto.AuditRequest;
import com.lab.reserve.entity.LabReservation;
import com.lab.reserve.entity.LabRoom;
import com.lab.reserve.mapper.LabReservationMapper;
import com.lab.reserve.mapper.LabRoomMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/labs")
public class LabController {

    @Autowired
    private LabRoomMapper labRoomMapper;

    @Autowired
    private LabReservationMapper labReservationMapper;

    // ---------- 实验室信息 ----------
    @GetMapping
    public Result<List<LabRoom>> list(@RequestParam(required = false) String keyword) {
        return Result.ok(labRoomMapper.selectList(keyword));
    }

    @RequireRole({"ADMIN", "LAB_ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping
    public Result<?> save(@RequestBody LabRoom labRoom) {
        if (labRoom.getName() == null || labRoom.getName().trim().isEmpty()) {
            throw new BusinessException("实验室名称不能为空");
        }
        if (labRoom.getStatus() == null) labRoom.setStatus(1);
        labRoomMapper.insert(labRoom);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "LAB_ADMIN", "DEPARTMENT_HEAD"})
    @PutMapping
    public Result<?> update(@RequestBody LabRoom labRoom) {
        if (labRoom.getId() == null) throw new BusinessException("实验室ID不能为空");
        labRoomMapper.updateById(labRoom);
        return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        labRoomMapper.deleteById(id);
        return Result.ok();
    }

    // ---------- 实验室预约 ----------
    @GetMapping("/reservations")
    public Result<List<LabReservation>> reservations(@RequestParam(required = false) Integer status,
                                                     @RequestParam(required = false) Long userId) {
        String role = AuthContext.getRoleCode();
        if ("STUDENT".equals(role) || "TEACHER".equals(role)) {
            userId = AuthContext.getUserId();
        }
        return Result.ok(labReservationMapper.selectList(status, userId));
    }

    @PostMapping("/reservations")
    public Result<?> reserve(@RequestBody LabReservation reservation) {
        if (reservation.getLabId() == null) throw new BusinessException("请选择实验室");
        if (reservation.getReserveDate() == null) throw new BusinessException("请选择预约日期");
        if (reservation.getTimeSlot() == null || reservation.getTimeSlot().trim().isEmpty()) {
            throw new BusinessException("请选择预约时间段");
        }
        int conflict = labReservationMapper.countConflict(
                reservation.getLabId(), reservation.getReserveDate().toString(), reservation.getTimeSlot(), null);
        if (conflict > 0) {
            throw new BusinessException("该实验室在该时间段已被预约");
        }
        reservation.setUserId(AuthContext.getUserId());
        reservation.setStatus(0);
        labReservationMapper.insert(reservation);
        return Result.ok();
    }

    @RequireRole({"LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/reservations/audit")
    public Result<?> audit(@RequestBody AuditRequest request) {
        if (request.getId() == null) throw new BusinessException("预约ID不能为空");
        LabReservation reservation = labReservationMapper.selectById(request.getId());
        if (reservation == null) throw new BusinessException("预约不存在");
        if (reservation.getStatus() != null && reservation.getStatus() != 0) {
            throw new BusinessException("该预约已处理");
        }
        reservation.setStatus(request.getStatus());
        reservation.setAuditUserId(AuthContext.getUserId());
        reservation.setAuditTime(LocalDateTime.now());
        labReservationMapper.updateById(reservation);
        return Result.ok();
    }

    @PutMapping("/reservations/cancel")
    public Result<?> cancel(@RequestBody LabReservation reservation) {
        if (reservation.getId() == null) throw new BusinessException("预约ID不能为空");
        LabReservation exist = labReservationMapper.selectById(reservation.getId());
        if (exist == null) throw new BusinessException("预约不存在");
        // 学生/教师只能取消自己的预约，管理员可取消任意预约
        String role = AuthContext.getRoleCode();
        if (("STUDENT".equals(role) || "TEACHER".equals(role)) && !exist.getUserId().equals(AuthContext.getUserId())) {
            throw new BusinessException("只能取消自己的预约");
        }
        exist.setStatus(3);
        labReservationMapper.updateById(exist);
        return Result.ok();
    }
}
