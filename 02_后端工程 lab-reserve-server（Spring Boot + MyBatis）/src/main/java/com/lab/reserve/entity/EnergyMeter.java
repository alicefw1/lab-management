package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class EnergyMeter {
    private Long id;
    private String meterCode;
    private String name;
    private String location;
    private Long labId;
    private String type;
    private String unit;
    private Integer status;
    private LocalDateTime createTime;

    // 当前最新能耗值
    private Double currentValue;
}
