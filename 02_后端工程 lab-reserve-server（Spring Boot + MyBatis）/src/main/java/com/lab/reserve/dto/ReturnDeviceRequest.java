package com.lab.reserve.dto;

import lombok.Data;

@Data
public class ReturnDeviceRequest {
    private Long recordId;
    private String remark;
}
