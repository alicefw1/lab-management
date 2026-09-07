package com.lab.reserve.mapper;

import com.lab.reserve.entity.Consumable;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ConsumableMapper {
    List<Consumable> selectList(@Param("keyword") String keyword);

    Consumable selectById(Long id);

    int insert(Consumable consumable);

    int updateById(Consumable consumable);

    int deleteById(Long id);
}
