package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Knowledge {
    private Long id;
    private String title;
    private String category;
    private String content;
    private Long authorId;
    private Integer viewCount;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
