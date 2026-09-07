package com.lab.reserve.mapper;

import com.lab.reserve.entity.Knowledge;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface KnowledgeMapper {
    List<Knowledge> selectList(@Param("category") String category, @Param("keyword") String keyword);

    Knowledge selectById(Long id);

    int insert(Knowledge knowledge);

    int updateById(Knowledge knowledge);

    int deleteById(Long id);

    int incrementView(Long id);
}
