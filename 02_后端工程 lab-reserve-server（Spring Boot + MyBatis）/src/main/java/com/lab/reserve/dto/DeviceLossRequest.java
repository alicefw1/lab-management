package com.lab.reserve.dto;

import lombok.Data;

@Data
public class DeviceLossRequest {
    private Long recordId;
    private String reason;
}
