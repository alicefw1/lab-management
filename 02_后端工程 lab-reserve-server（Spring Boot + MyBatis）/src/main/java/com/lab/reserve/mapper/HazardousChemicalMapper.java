package com.lab.reserve.mapper;

import com.lab.reserve.entity.HazardousChemical;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface HazardousChemicalMapper {
    List<HazardousChemical> selectList(@Param("keyword") String keyword);

    HazardousChemical selectById(Long id);

    int insert(HazardousChemical chemical);

    int updateById(HazardousChemical chemical);

    int deleteById(Long id);
}
