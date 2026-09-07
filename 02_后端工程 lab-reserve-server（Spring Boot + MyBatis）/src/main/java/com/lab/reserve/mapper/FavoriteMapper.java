package com.lab.reserve.mapper;

import com.lab.reserve.entity.Favorite;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface FavoriteMapper {
    List<Favorite> selectByUser(@Param("userId") Long userId, @Param("targetType") String targetType);

    int insert(Favorite favorite);

    int delete(@Param("userId") Long userId, @Param("targetType") String targetType, @Param("targetId") Long targetId);

    int countByUserTarget(@Param("userId") Long userId, @Param("targetType") String targetType, @Param("targetId") Long targetId);
}
