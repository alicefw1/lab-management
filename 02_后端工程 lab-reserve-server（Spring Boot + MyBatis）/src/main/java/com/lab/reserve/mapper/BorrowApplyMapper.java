package com.lab.reserve.mapper;

import com.lab.reserve.entity.BorrowApply;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BorrowApplyMapper {
    List<BorrowApply> selectList(@Param("status") Integer status, @Param("userId") Long userId);

    BorrowApply selectById(Long id);

    int insert(BorrowApply apply);

    int updateById(BorrowApply apply);

    int count(@Param("deviceId") Long deviceId, @Param("userId") Long userId, @Param("status") Integer status);
}
