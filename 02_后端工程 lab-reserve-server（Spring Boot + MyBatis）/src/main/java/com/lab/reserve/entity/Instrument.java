package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Instrument {
    private Long id;
    private String instrumentNo;
    private String name;
    private Long deviceId;
    private Long categoryId;
    private String model;
    private String brand;
    private String specification;
    private String accuracy;
    private String serialNo;
    private LocalDate purchaseDate;
    private LocalDate lastCheckDate;
    private LocalDate nextCheckDate;
    private Integer checkCycle;
    private Integer status;
    private String location;
    private String imageUrl;
    private String description;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    // 关联展示字段
    private String categoryName;
}
