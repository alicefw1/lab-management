package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Device {
    private Long id;
    private Long categoryId;
    private String deviceNo;
    private String deviceName;
    private String model;
    private String location;
    private Integer status;
    private LocalDate purchaseDate;
    private String description;
    private String brand;
    private String specification;
    private String imageUrl;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    // 关联展示字段
    private String categoryName;
}
