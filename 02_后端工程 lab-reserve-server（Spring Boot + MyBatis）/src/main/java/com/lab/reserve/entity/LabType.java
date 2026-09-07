package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class LabType {
    private Long id;
    private String typeName;
    private String description;
    private LocalDateTime createTime;
}
