package com.lab.reserve.mapper;

import com.lab.reserve.entity.AlarmRecord;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface AlarmRecordMapper {
    List<AlarmRecord> selectList(@Param("status") Integer status, @Param("level") String level);

    AlarmRecord selectById(Long id);

    int insert(AlarmRecord alarm);

    int updateById(AlarmRecord alarm);

    int countByStatus(@Param("status") Integer status);

    List<Map<String, Object>> statistics();
}
