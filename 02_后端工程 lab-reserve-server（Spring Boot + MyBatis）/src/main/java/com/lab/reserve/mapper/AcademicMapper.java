package com.lab.reserve.mapper;

import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface AcademicMapper {
    List<Map<String, Object>> selectClasses(@Param("keyword") String keyword);
    int insertClass(Map<String, Object> data);
    int updateClass(Map<String, Object> data);
    int deleteClass(Long id);
    List<Map<String, Object>> selectClassStudents(@Param("classId") Long classId);
    int addClassStudent(@Param("classId") Long classId, @Param("studentId") Long studentId);
    int removeClassStudent(@Param("classId") Long classId, @Param("studentId") Long studentId);

    List<Map<String, Object>> selectProjects(@Param("keyword") String keyword);
    int insertProject(Map<String, Object> data);
    int updateProject(Map<String, Object> data);
    int deleteProject(Long id);
    int countManageableProject(@Param("id") Long id, @Param("userId") Long userId, @Param("roleCode") String roleCode);

    List<Map<String, Object>> selectSchedules(@Param("userId") Long userId,
                                               @Param("roleCode") String roleCode,
                                               @Param("status") Integer status);
    int countScheduleConflict(Map<String, Object> data);
    int insertSchedule(Map<String, Object> data);
    int updateSchedule(Map<String, Object> data);
    int deleteSchedule(Long id);
    int countManageableSchedule(@Param("id") Long id, @Param("userId") Long userId, @Param("roleCode") String roleCode);
    int countStudentSchedule(@Param("id") Long id, @Param("userId") Long userId);
    int countStudentCheckInWindow(@Param("id") Long id, @Param("userId") Long userId);

    List<Map<String, Object>> selectAttendance(@Param("scheduleId") Long scheduleId);
    int upsertAttendance(Map<String, Object> data);

    List<Map<String, Object>> selectReports(@Param("scheduleId") Long scheduleId,
                                            @Param("userId") Long userId,
                                            @Param("roleCode") String roleCode);
    int upsertReport(Map<String, Object> data);
    int gradeReport(Map<String, Object> data);
    int countManageableReport(@Param("id") Long id, @Param("userId") Long userId, @Param("roleCode") String roleCode);
    int countLockedReport(@Param("scheduleId") Long scheduleId, @Param("studentId") Long studentId);
    Map<String, Object> selectSummary(@Param("userId") Long userId,
                                      @Param("roleCode") String roleCode);
}
