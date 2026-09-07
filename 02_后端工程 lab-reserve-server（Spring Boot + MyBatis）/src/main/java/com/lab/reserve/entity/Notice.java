package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Notice {
    private Long id;
    private String title;
    private String content;
    private Long publishUserId;
    private LocalDateTime publishTime;
    private Integer status;

    // 关联展示字段
    private String publisherName;
}
