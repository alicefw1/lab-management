package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Feedback {
    private Long id;
    private Long userId;
    private String title;
    private String content;
    private String type;
    private Integer status;
    private String reply;
    private Long replyUserId;
    private LocalDateTime replyTime;
    private LocalDateTime createTime;

    // 关联展示字段
    private String userName;
}
