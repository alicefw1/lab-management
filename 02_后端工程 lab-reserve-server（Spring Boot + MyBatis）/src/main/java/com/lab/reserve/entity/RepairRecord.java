package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RepairRecord {
    private Long id;
    private Long deviceId;
    private Long userId;
    private String faultDesc;
    private Integer repairStatus;
    private String repairResult;
    private LocalDateTime reportTime;
    private LocalDateTime finishTime;

    // 关联展示字段
    private String deviceName;
    private String deviceNo;
    private String userName;
}
