package com.lab.reserve.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class AlarmRecord {
    private Long id;
    private String targetType;
    private Long targetId;
    private String targetName;
    private String metric;
    private BigDecimal value;
    private String level;
    private String message;
    private Integer status;
    private Long handlerId;
    private LocalDateTime handleTime;
    private String handleRemark;
    private LocalDateTime createTime;

    // 关联展示字段
    private String handlerName;
    private String levelText;
    private String statusText;
}
