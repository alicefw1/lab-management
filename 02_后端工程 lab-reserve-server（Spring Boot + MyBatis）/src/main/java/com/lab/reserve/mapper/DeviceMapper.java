package com.lab.reserve.mapper;

import com.lab.reserve.entity.Device;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DeviceMapper {
    List<Device> selectList(@Param("keyword") String keyword, @Param("status") Integer status);

    Device selectById(Long id);

    int insert(Device device);

    int updateById(Device device);

    int deleteById(Long id);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    List<Device> selectByCategoryId(Long categoryId);

    int countAll();
}
