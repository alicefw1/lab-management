package com.lab.reserve.mapper;

import com.lab.reserve.entity.EnvironmentSensor;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface EnvironmentSensorMapper {
    List<EnvironmentSensor> selectList();

    EnvironmentSensor selectById(Long id);

    int countByStatus(@Param("status") Integer status);

    List<Map<String, Object>> selectRecentData(@Param("sensorId") Long sensorId, @Param("limit") Integer limit);
}
