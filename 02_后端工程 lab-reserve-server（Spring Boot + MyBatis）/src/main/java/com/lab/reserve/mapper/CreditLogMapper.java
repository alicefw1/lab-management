package com.lab.reserve.mapper;

import com.lab.reserve.entity.CreditLog;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CreditLogMapper {
    List<CreditLog> selectList(@Param("userId") Long userId);

    int insert(CreditLog log);
}
