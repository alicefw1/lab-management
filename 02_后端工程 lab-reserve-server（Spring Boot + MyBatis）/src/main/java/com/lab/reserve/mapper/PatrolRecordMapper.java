package com.lab.reserve.mapper;

import com.lab.reserve.entity.PatrolRecord;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PatrolRecordMapper {
    List<PatrolRecord> selectList(@Param("userId") Long userId);

    int insert(PatrolRecord patrol);
}
