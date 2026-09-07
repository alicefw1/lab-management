package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class EnvironmentSensor {
    private Long id;
    private String sensorCode;
    private String name;
    private String location;
    private Long labId;
    private String type;
    private String unit;
    private Integer status;
    private LocalDateTime createTime;

    // 关联展示字段
    private String labName;
    private Double currentValue;
}
