package com.lab.reserve.controller;

import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.common.PasswordUtil;
import com.lab.reserve.entity.Role;
import com.lab.reserve.entity.User;
import com.lab.reserve.mapper.RoleMapper;
import com.lab.reserve.mapper.UserMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/profile")
public class ProfileController {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RoleMapper roleMapper;

    @GetMapping
    public Result<Map<String, Object>> current() {
        User user = userMapper.selectById(AuthContext.getUserId());
        if (user == null) throw new BusinessException("用户不存在");
        user.setPassword(null);
        Role role = roleMapper.selectById(user.getRoleId());
        Map<String, Object> data = new HashMap<>();
        data.put("user", user);
        data.put("role", role);
        return Result.ok(data);
    }

    @PutMapping
    public Result<?> update(@RequestBody User input) {
        User user = userMapper.selectById(AuthContext.getUserId());
        if (user == null) throw new BusinessException("用户不存在");
        User update = new User();
        update.setId(user.getId());
        update.setRealName(input.getRealName());
        update.setPhone(input.getPhone());
        update.setEmail(input.getEmail());
        userMapper.updateById(update);
        return Result.ok();
    }

    @PutMapping("/password")
    public Result<?> updatePassword(@RequestBody Map<String, String> body) {
        String oldPassword = body.get("oldPassword");
        String newPassword = body.get("newPassword");
        if (newPassword == null || newPassword.length() < 6 || newPassword.length() > 32) {
            throw new BusinessException("新密码长度必须为6到32位");
        }
        User user = userMapper.selectById(AuthContext.getUserId());
        if (user == null) throw new BusinessException("用户不存在");
        if (!PasswordUtil.matches(oldPassword, user.getPassword())) {
            throw new BusinessException("原密码错误");
        }
        User update = new User();
        update.setId(user.getId());
        update.setPassword(PasswordUtil.encode(newPassword));
        userMapper.updateById(update);
        return Result.ok();
    }
}
