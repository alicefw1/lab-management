package com.lab.reserve.mapper;

import com.lab.reserve.entity.BorrowRecord;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BorrowRecordMapper {
    List<BorrowRecord> selectList(@Param("status") Integer status, @Param("userId") Long userId);

    BorrowRecord selectById(Long id);

    int insert(BorrowRecord record);

    int updateById(BorrowRecord record);

    int countActiveByDeviceId(@Param("deviceId") Long deviceId);
}
