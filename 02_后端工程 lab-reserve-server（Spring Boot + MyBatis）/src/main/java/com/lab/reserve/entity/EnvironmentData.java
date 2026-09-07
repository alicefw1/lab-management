package com.lab.reserve.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class EnvironmentData {
    private Long id;
    private Long sensorId;
    private BigDecimal value;
    private LocalDateTime collectTime;
}
