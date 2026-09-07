package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.entity.AlarmRecord;
import com.lab.reserve.mapper.AlarmRecordMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/alarms")
public class AlarmController {

    @Autowired
    private AlarmRecordMapper alarmMapper;

    @GetMapping
    public Result<List<AlarmRecord>> list(@RequestParam(required = false) Integer status,
                                          @RequestParam(required = false) String level) {
        return Result.ok(alarmMapper.selectList(status, level));
    }

    @GetMapping("/statistics")
    public Result<List<Map<String, Object>>> statistics() {
        return Result.ok(alarmMapper.statistics());
    }

    @RequireRole({"ADMIN", "LAB_ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/handle")
    public Result<?> handle(@RequestBody AlarmRecord alarm) {
        if (alarm.getId() == null) throw new BusinessException("报警ID不能为空");
        AlarmRecord exist = alarmMapper.selectById(alarm.getId());
        if (exist == null) throw new BusinessException("报警不存在");
        exist.setStatus(alarm.getStatus() == null ? 2 : alarm.getStatus());
        exist.setHandlerId(AuthContext.getUserId());
        exist.setHandleTime(LocalDateTime.now());
        exist.setHandleRemark(alarm.getHandleRemark());
        alarmMapper.updateById(exist);
        return Result.ok();
    }
}
