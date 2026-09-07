package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BorrowApply {
    private Long id;
    private Long deviceId;
    private Long userId;
    private String applyReason;
    private LocalDateTime expectedReturnTime;
    private LocalDateTime applyTime;
    private Integer status;
    private Long approveUserId;
    private LocalDateTime approveTime;
    private String approveRemark;

    // 关联展示字段
    private String deviceName;
    private String deviceNo;
    private String userName;
}
