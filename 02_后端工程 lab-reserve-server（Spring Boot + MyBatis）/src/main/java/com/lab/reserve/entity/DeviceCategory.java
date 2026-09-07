package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class DeviceCategory {
    private Long id;
    private String categoryName;
    private String description;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
