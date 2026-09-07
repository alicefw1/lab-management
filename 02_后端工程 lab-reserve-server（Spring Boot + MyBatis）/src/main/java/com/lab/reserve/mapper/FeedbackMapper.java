package com.lab.reserve.mapper;

import com.lab.reserve.entity.Feedback;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface FeedbackMapper {
    List<Feedback> selectList(@Param("status") Integer status, @Param("userId") Long userId);

    Feedback selectById(Long id);

    int insert(Feedback feedback);

    int updateById(Feedback feedback);
}
