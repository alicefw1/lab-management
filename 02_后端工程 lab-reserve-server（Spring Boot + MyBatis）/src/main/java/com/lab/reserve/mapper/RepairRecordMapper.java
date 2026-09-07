package com.lab.reserve.mapper;

import com.lab.reserve.entity.RepairRecord;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface RepairRecordMapper {
    List<RepairRecord> selectList(@Param("status") Integer status, @Param("userId") Long userId);

    RepairRecord selectById(Long id);

    int insert(RepairRecord repair);

    int updateById(RepairRecord repair);

    int countPendingByDeviceId(@Param("deviceId") Long deviceId);
}
