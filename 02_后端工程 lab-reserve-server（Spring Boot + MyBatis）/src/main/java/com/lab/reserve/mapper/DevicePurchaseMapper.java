package com.lab.reserve.mapper;

import com.lab.reserve.entity.DevicePurchase;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DevicePurchaseMapper {
    List<DevicePurchase> selectList(@Param("status") Integer status);

    DevicePurchase selectById(Long id);

    int insert(DevicePurchase purchase);

    int updateById(DevicePurchase purchase);

    int deleteById(Long id);
}
