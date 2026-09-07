package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Consumable {
    private Long id;
    private String name;
    private String spec;
    private String unit;
    private Integer quantity;
    private String category;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
