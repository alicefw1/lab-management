package com.lab.reserve.mapper;

import com.lab.reserve.entity.ScrapApply;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ScrapApplyMapper {
    List<ScrapApply> selectList(@Param("status") Integer status, @Param("userId") Long userId);

    ScrapApply selectById(Long id);

    int insert(ScrapApply scrapApply);

    int updateById(ScrapApply scrapApply);
}
