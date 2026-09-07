package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Favorite {
    private Long id;
    private Long userId;
    private String targetType;
    private Long targetId;
    private LocalDateTime createTime;

    // 关联展示字段（实验室或设备信息）
    private String targetName;
    private String targetImage;
    private String targetSub;
}
