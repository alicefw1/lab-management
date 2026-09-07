package com.lab.reserve.mapper;

import com.lab.reserve.entity.LabReservation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LabReservationMapper {
    List<LabReservation> selectList(@Param("status") Integer status, @Param("userId") Long userId);

    LabReservation selectById(Long id);

    int insert(LabReservation reservation);

    int updateById(LabReservation reservation);

    int countConflict(@Param("labId") Long labId, @Param("reserveDate") String reserveDate,
                      @Param("timeSlot") String timeSlot, @Param("excludeId") Long excludeId);
}
