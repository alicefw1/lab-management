package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class HazardousChemical {
    private Long id;
    private String casNo;
    private String name;
    private String riskLevel;
    private String category;
    private String unit;
    private String description;
    private LocalDateTime createTime;
}
