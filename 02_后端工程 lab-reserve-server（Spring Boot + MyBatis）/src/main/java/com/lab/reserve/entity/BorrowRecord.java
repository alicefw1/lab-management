package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BorrowRecord {
    private Long id;
    private Long applyId;
    private Long deviceId;
    private Long userId;
    private LocalDateTime borrowTime;
    private LocalDateTime returnTime;
    private Integer status;
    private String remark;

    // 关联展示字段
    private String deviceName;
    private String deviceNo;
    private String userName;
    private LocalDateTime expectedReturnTime;
}
