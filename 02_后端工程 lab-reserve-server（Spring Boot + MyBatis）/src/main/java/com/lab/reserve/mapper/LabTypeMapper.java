package com.lab.reserve.mapper;

import com.lab.reserve.entity.LabType;

import java.util.List;

public interface LabTypeMapper {
    List<LabType> selectList();

    LabType selectById(Long id);

    int insert(LabType labType);

    int updateById(LabType labType);

    int deleteById(Long id);
}
