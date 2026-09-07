package com.lab.reserve.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class User {
    private Long id;
    private String username;
    private String password;
    private String realName;
    private String phone;
    private String email;
    private Long roleId;
    private String roleCode;
    private String roleName;
    private Integer status;
    private Integer creditScore;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
