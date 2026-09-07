package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.mapper.AcademicMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/academic")
public class AcademicController {
    @Autowired private AcademicMapper mapper;

    @GetMapping("/summary")
    public Result<Map<String, Object>> summary() {
        return Result.ok(mapper.selectSummary(AuthContext.getUserId(), AuthContext.getRoleCode()));
    }

    @GetMapping("/classes")
    public Result<List<Map<String, Object>>> classes(@RequestParam(required = false) String keyword) {
        return Result.ok(mapper.selectClasses(trim(keyword)));
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/classes")
    public Result<?> createClass(@RequestBody Map<String, Object> data) {
        required(data, "className", "班级名称");
        required(data, "gradeYear", "年级");
        mapper.insertClass(data);
        return Result.ok("班级创建成功", data);
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PutMapping("/classes")
    public Result<?> updateClass(@RequestBody Map<String, Object> data) {
        idRequired(data); mapper.updateClass(data); return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/classes/{id}")
    public Result<?> deleteClass(@PathVariable Long id) {
        mapper.deleteClass(id); return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @GetMapping("/classes/{id}/students")
    public Result<List<Map<String, Object>>> classStudents(@PathVariable Long id) {
        return Result.ok(mapper.selectClassStudents(id));
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/classes/{id}/students/{studentId}")
    public Result<?> addClassStudent(@PathVariable Long id, @PathVariable Long studentId) {
        mapper.addClassStudent(id, studentId); return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/classes/{id}/students/{studentId}")
    public Result<?> removeClassStudent(@PathVariable Long id, @PathVariable Long studentId) {
        mapper.removeClassStudent(id, studentId); return Result.ok();
    }

    @GetMapping("/projects")
    public Result<List<Map<String, Object>>> projects(@RequestParam(required = false) String keyword) {
        return Result.ok(mapper.selectProjects(trim(keyword)));
    }

    @RequireRole({"TEACHER", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/projects")
    public Result<?> createProject(@RequestBody Map<String, Object> data) {
        required(data, "projectName", "实验项目名称");
        data.put("creatorId", AuthContext.getUserId());
        mapper.insertProject(data);
        return Result.ok("实验项目创建成功", data);
    }

    @RequireRole({"TEACHER", "ADMIN", "DEPARTMENT_HEAD"})
    @PutMapping("/projects")
    public Result<?> updateProject(@RequestBody Map<String, Object> data) {
        idRequired(data); assertProjectOwner(longValue(data.get("id"))); mapper.updateProject(data); return Result.ok();
    }

    @RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/projects/{id}")
    public Result<?> deleteProject(@PathVariable Long id) {
        mapper.deleteProject(id); return Result.ok();
    }

    @GetMapping("/schedules")
    public Result<List<Map<String, Object>>> schedules(@RequestParam(required = false) Integer status) {
        return Result.ok(mapper.selectSchedules(AuthContext.getUserId(), AuthContext.getRoleCode(), status));
    }

    @RequireRole({"TEACHER", "LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/schedules")
    public Result<?> createSchedule(@RequestBody Map<String, Object> data) {
        required(data, "projectId", "实验项目"); required(data, "classId", "班级");
        required(data, "labId", "实验室"); required(data, "startTime", "开始时间");
        required(data, "endTime", "结束时间");
        data.put("teacherId", data.get("teacherId") == null ? AuthContext.getUserId() : data.get("teacherId"));
        if (mapper.countScheduleConflict(data) > 0) throw new BusinessException("该实验室或教师在所选时段已有安排");
        mapper.insertSchedule(data);
        return Result.ok("实验安排创建成功", data);
    }

    @RequireRole({"TEACHER", "LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @PutMapping("/schedules")
    public Result<?> updateSchedule(@RequestBody Map<String, Object> data) {
        idRequired(data); assertScheduleOwner(longValue(data.get("id")));
        if (mapper.countScheduleConflict(data) > 0) throw new BusinessException("该实验室或教师在所选时段已有安排");
        mapper.updateSchedule(data); return Result.ok();
    }

    @RequireRole({"TEACHER", "ADMIN", "DEPARTMENT_HEAD"})
    @DeleteMapping("/schedules/{id}")
    public Result<?> deleteSchedule(@PathVariable Long id) {
        assertScheduleOwner(id); mapper.deleteSchedule(id); return Result.ok();
    }

    @RequireRole({"TEACHER", "LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @GetMapping("/attendance")
    public Result<List<Map<String, Object>>> attendance(@RequestParam Long scheduleId) {
        assertScheduleOwner(scheduleId);
        return Result.ok(mapper.selectAttendance(scheduleId));
    }

    @RequireRole({"TEACHER", "LAB_ADMIN", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/attendance")
    public Result<?> markAttendance(@RequestBody Map<String, Object> data) {
        required(data, "scheduleId", "实验安排"); required(data, "studentId", "学生");
        assertScheduleOwner(longValue(data.get("scheduleId")));
        required(data, "status", "考勤状态"); data.put("operatorId", AuthContext.getUserId());
        if (mapper.upsertAttendance(data) == 0) throw new BusinessException("该学生不属于实验安排对应班级");
        return Result.ok();
    }

    @RequireRole({"STUDENT"})
    @PostMapping("/attendance/check-in")
    public Result<?> checkIn(@RequestBody Map<String, Object> data) {
        required(data, "scheduleId", "实验安排");
        Long scheduleId = longValue(data.get("scheduleId"));
        if (mapper.countStudentSchedule(scheduleId, AuthContext.getUserId()) == 0)
            throw new BusinessException("您不属于该实验安排对应班级");
        if (mapper.countStudentCheckInWindow(scheduleId, AuthContext.getUserId()) == 0)
            throw new BusinessException("当前不在签到时间范围内");
        data.put("studentId", AuthContext.getUserId()); data.put("status", "PRESENT");
        data.put("operatorId", AuthContext.getUserId()); data.put("remark", "学生自主签到");
        mapper.upsertAttendance(data); return Result.ok("签到成功", null);
    }

    @GetMapping("/reports")
    public Result<List<Map<String, Object>>> reports(@RequestParam(required = false) Long scheduleId) {
        return Result.ok(mapper.selectReports(scheduleId, AuthContext.getUserId(), AuthContext.getRoleCode()));
    }

    @RequireRole({"STUDENT"})
    @PostMapping("/reports")
    public Result<?> submitReport(@RequestBody Map<String, Object> data) {
        required(data, "scheduleId", "实验安排"); required(data, "title", "报告标题");
        required(data, "content", "报告内容"); data.put("studentId", AuthContext.getUserId());
        Long scheduleId = longValue(data.get("scheduleId"));
        if (mapper.countStudentSchedule(scheduleId, AuthContext.getUserId()) == 0)
            throw new BusinessException("您不属于该实验安排对应班级");
        if (mapper.countLockedReport(scheduleId, AuthContext.getUserId()) > 0)
            throw new BusinessException("报告已批改，如需重交请先联系任课教师退回");
        mapper.upsertReport(data); return Result.ok("实验报告提交成功", null);
    }

    @RequireRole({"TEACHER", "ADMIN", "DEPARTMENT_HEAD"})
    @PostMapping("/reports/grade")
    public Result<?> grade(@RequestBody Map<String, Object> data) {
        required(data, "reportId", "实验报告"); required(data, "score", "成绩");
        Long reportId = longValue(data.get("reportId"));
        if (mapper.countManageableReport(reportId, AuthContext.getUserId(), AuthContext.getRoleCode()) == 0)
            throw new BusinessException("无权批改该实验报告");
        BigDecimal score = new BigDecimal(String.valueOf(data.get("score")));
        if (score.compareTo(BigDecimal.ZERO) < 0 || score.compareTo(new BigDecimal("100")) > 0)
            throw new BusinessException("成绩必须在0到100之间");
        data.put("graderId", AuthContext.getUserId());
        if (mapper.gradeReport(data) == 0) throw new BusinessException("报告不存在");
        return Result.ok();
    }

    private static void idRequired(Map<String, Object> data) { required(data, "id", "记录ID"); }
    private void assertScheduleOwner(Long id) {
        if (mapper.countManageableSchedule(id, AuthContext.getUserId(), AuthContext.getRoleCode()) == 0)
            throw new BusinessException("无权操作该实验安排");
    }
    private void assertProjectOwner(Long id) {
        if (mapper.countManageableProject(id, AuthContext.getUserId(), AuthContext.getRoleCode()) == 0)
            throw new BusinessException("无权修改该实验项目");
    }
    private static Long longValue(Object value) {
        try { return Long.valueOf(String.valueOf(value)); }
        catch (Exception e) { throw new BusinessException("记录ID格式错误"); }
    }
    private static String trim(String value) { return value == null ? null : value.trim(); }
    private static void required(Map<String, Object> data, String key, String label) {
        Object value = data == null ? null : data.get(key);
        if (value == null || String.valueOf(value).trim().isEmpty()) throw new BusinessException(label + "不能为空");
    }
}
