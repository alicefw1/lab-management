package com.lab.reserve.dto;

import lombok.Data;

@Data
public class RepairHandleRequest {
    private Long repairId;
    private Integer status; // 1 维修中，2 已完成
    private String handleResult;
}
