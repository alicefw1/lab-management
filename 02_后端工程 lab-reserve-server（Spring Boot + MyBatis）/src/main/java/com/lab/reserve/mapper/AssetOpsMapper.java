package com.lab.reserve.mapper;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

public interface AssetOpsMapper {
    List<Map<String,Object>> selectSuppliers(@Param("keyword") String keyword, @Param("status") Integer status);
    int insertSupplier(Map<String,Object> data);
    int updateSupplier(Map<String,Object> data);
    int deleteSupplier(Long id);
    List<Map<String,Object>> selectMaintenancePlans(@Param("status") Integer status);
    int insertMaintenancePlan(Map<String,Object> data);
    int updateMaintenancePlan(Map<String,Object> data);
    int deleteMaintenancePlan(Long id);
    List<Map<String,Object>> selectMaintenanceRecords(@Param("planId") Long planId);
    int insertMaintenanceRecord(Map<String,Object> data);
    int finishMaintenancePlan(Map<String,Object> data);
}
