package com.lab.reserve.mapper;

import com.lab.reserve.entity.Waste;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface WasteMapper {
    List<Waste> selectList(@Param("status") Integer status);

    Waste selectById(Long id);

    int insert(Waste waste);

    int updateById(Waste waste);

    int deleteById(Long id);
}
