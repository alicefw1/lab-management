package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class PatrolRecord {
    private Long id;
    private Long userId;
    private LocalDate patrolDate;
    private Long labId;
    private String items;
    private String result;
    private Integer status;
    private LocalDateTime createTime;

    // 关联展示字段
    private String userName;
    private String labName;
}
