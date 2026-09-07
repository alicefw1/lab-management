package com.lab.reserve.dto;

import lombok.Data;

@Data
public class AuditRequest {
    private Long id;
    private Integer status;
    private String remark;
}
