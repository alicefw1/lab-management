package com.lab.reserve.mapper;

import com.lab.reserve.entity.Instrument;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface InstrumentMapper {
    List<Instrument> selectList(@Param("keyword") String keyword, @Param("status") Integer status);

    Instrument selectById(Long id);

    int insert(Instrument instrument);

    int updateById(Instrument instrument);

    int deleteById(Long id);

    int countByStatus(@Param("status") Integer status);
}
