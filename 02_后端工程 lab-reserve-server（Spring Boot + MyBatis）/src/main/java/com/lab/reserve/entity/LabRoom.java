package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class LabRoom {
    private Long id;
    private String name;
    private String location;
    private Integer capacity;
    private String manager;
    private String description;
    private Integer status;
    private Long typeId;
    private String imageUrl;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    // 关联展示字段
    private String typeName;
}
