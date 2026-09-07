package com.lab.reserve.mapper;

import com.lab.reserve.entity.Role;

import java.util.List;

public interface RoleMapper {
    List<Role> selectList();

    Role selectById(Long id);
}
