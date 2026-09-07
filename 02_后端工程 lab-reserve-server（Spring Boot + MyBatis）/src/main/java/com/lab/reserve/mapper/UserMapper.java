package com.lab.reserve.mapper;

import com.lab.reserve.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {
    User selectByUsername(String username);

    User selectById(Long id);

    int insert(User user);

    int updateById(User user);

    List<User> selectList(@Param("keyword") String keyword, @Param("status") Integer status, @Param("roleId") Long roleId);

    int countByUsername(String username);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    int resetPassword(@Param("id") Long id, @Param("password") String password);

    int updateCreditScore(@Param("id") Long id, @Param("creditScore") Integer creditScore);
}
