package com.lab.reserve.mapper;

import com.lab.reserve.entity.OperationLog;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OperationLogMapper {
    int insert(OperationLog log);

    List<OperationLog> selectList(@Param("module") String module, @Param("keyword") String keyword, @Param("limit") Integer limit);
}
