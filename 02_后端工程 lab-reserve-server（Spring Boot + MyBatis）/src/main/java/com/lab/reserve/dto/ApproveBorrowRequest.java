package com.lab.reserve.dto;

import lombok.Data;

@Data
public class ApproveBorrowRequest {
    private Long applyId;
    private Integer status; // 1 通过，2 拒绝
    private String approveRemark;
}
