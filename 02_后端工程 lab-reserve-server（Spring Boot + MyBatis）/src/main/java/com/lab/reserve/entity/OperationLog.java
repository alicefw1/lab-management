package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class OperationLog {
    private Long id;
    private Long userId;
    private String username;
    private String module;
    private String action;
    private String detail;
    private String ip;
    private LocalDateTime createTime;
}
