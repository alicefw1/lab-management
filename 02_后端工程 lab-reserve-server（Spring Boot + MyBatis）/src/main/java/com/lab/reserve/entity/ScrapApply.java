package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ScrapApply {
    private Long id;
    private Long deviceId;
    private Long userId;
    private String reason;
    private Integer status;
    private Long auditUserId;
    private LocalDateTime auditTime;
    private String auditRemark;
    private LocalDateTime createTime;

    // 关联展示字段
    private String deviceName;
    private String deviceNo;
    private String userName;
}
