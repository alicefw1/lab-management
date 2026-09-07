package com.lab.reserve.mapper;

import com.lab.reserve.entity.DeviceCategory;

import java.util.List;

public interface DeviceCategoryMapper {
    List<DeviceCategory> selectList();

    DeviceCategory selectById(Long id);

    int insert(DeviceCategory category);

    int updateById(DeviceCategory category);

    int deleteById(Long id);
}
