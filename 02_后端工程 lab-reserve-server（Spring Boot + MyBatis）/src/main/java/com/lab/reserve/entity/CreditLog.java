package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CreditLog {
    private Long id;
    private Long userId;
    private String changeType;
    private Integer scoreChange;
    private String reason;
    private LocalDateTime createTime;

    // 关联展示字段
    private String userName;
}
