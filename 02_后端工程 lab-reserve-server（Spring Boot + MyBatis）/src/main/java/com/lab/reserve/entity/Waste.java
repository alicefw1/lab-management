package com.lab.reserve.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Waste {
    private Long id;
    private String wasteNo;
    private String type;
    private String source;
    private BigDecimal quantity;
    private String unit;
    private Long reporterId;
    private Integer status;
    private Long auditUserId;
    private LocalDateTime auditTime;
    private String auditRemark;
    private Long disposeUserId;
    private LocalDateTime disposeTime;
    private String disposeRemark;
    private LocalDateTime createTime;

    // 关联展示字段
    private String reporterName;
}
