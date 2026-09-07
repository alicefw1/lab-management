package com.lab.reserve.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class DevicePurchase {
    private Long id;
    private String deviceName;
    private String model;
    private Long categoryId;
    private Integer quantity;
    private BigDecimal unitPrice;
    private String supplier;
    private Long applicantId;
    private String purpose;
    private Integer status;
    private Long auditUserId;
    private LocalDateTime auditTime;
    private LocalDateTime createTime;

    // 关联展示字段
    private String categoryName;
    private String applicantName;
}
