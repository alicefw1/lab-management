package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class LabReservation {
    private Long id;
    private Long labId;
    private Long userId;
    private LocalDate reserveDate;
    private String timeSlot;
    private String purpose;
    private Integer status;
    private Long auditUserId;
    private LocalDateTime auditTime;
    private LocalDateTime createTime;

    // 关联展示字段
    private String labName;
    private String userName;
}
