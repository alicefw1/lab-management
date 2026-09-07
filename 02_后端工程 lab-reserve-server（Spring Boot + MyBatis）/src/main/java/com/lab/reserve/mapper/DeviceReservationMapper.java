package com.lab.reserve.mapper;

import com.lab.reserve.entity.DeviceReservation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DeviceReservationMapper {
    List<DeviceReservation> selectList(@Param("status") Integer status, @Param("userId") Long userId);

    DeviceReservation selectById(Long id);

    int insert(DeviceReservation reservation);

    int updateById(DeviceReservation reservation);

    int countConflict(@Param("deviceId") Long deviceId, @Param("reserveDate") String reserveDate,
                      @Param("timeSlot") String timeSlot, @Param("excludeId") Long excludeId);
}
