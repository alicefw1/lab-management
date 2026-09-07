package com.lab.reserve.dto;

import lombok.Data;

@Data
public class CreditChangeRequest {
    private Long userId;
    private Integer scoreChange;
    private String changeType;
    private String reason;
}
