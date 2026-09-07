package com.lab.reserve.mapper;

import com.lab.reserve.entity.EnergyMeter;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface EnergyMeterMapper {
    List<EnergyMeter> selectList();

    EnergyMeter selectById(Long id);
}
