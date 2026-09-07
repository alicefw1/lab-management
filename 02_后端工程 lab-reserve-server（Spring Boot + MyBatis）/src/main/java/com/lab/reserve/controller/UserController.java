package com.lab.reserve.controller;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.BusinessException;
import com.lab.reserve.common.PasswordUtil;
import com.lab.reserve.entity.Role;
import com.lab.reserve.entity.User;
import com.lab.reserve.mapper.RoleMapper;
import com.lab.reserve.mapper.UserMapper;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequireRole({"ADMIN", "DEPARTMENT_HEAD"})
public class UserController {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RoleMapper roleMapper;

    @GetMapping
    public Result<List<User>> page(@RequestParam(required = false) String keyword,
                                   @RequestParam(required = false) Integer status,
                                   @RequestParam(required = false) Long roleId) {
        List<User> users = userMapper.selectList(keyword, status, roleId);
        users.forEach(u -> u.setPassword(null));
        return Result.ok(users);
    }

    @GetMapping("/{id}")
    public Result<User> get(@PathVariable Long id) {
        User user = userMapper.selectById(id);
        if (user == null) throw new BusinessException("用户不存在");
        user.setPassword(null);
        return Result.ok(user);
    }

    @PostMapping
    public Result<?> save(@RequestBody User user) {
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new BusinessException("用户名不能为空");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            user.setPassword("123456");
        }
        validatePassword(user.getPassword());
        if (userMapper.countByUsername(user.getUsername().trim()) > 0) {
            throw new BusinessException("用户名已存在");
        }
        if (user.getRoleId() == null) {
            throw new BusinessException("请选择角色");
        }
        if (roleMapper.selectById(user.getRoleId()) == null) {
            throw new BusinessException("角色不存在");
        }
        user.setPassword(PasswordUtil.encode(user.getPassword()));
        if (user.getStatus() == null) user.setStatus(1);
        userMapper.insert(user);
        return Result.ok();
    }

    @PutMapping
    public Result<?> update(@RequestBody User user) {
        if (user.getId() == null) throw new BusinessException("用户ID不能为空");
        User old = userMapper.selectById(user.getId());
        if (old == null) throw new BusinessException("用户不存在");
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            validatePassword(user.getPassword());
            user.setPassword(PasswordUtil.encode(user.getPassword()));
        } else {
            user.setPassword(null);
        }
        user.setUsername(null);
        userMapper.updateById(user);
        return Result.ok();
    }

    @PutMapping("/{id}/status")
    public Result<?> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        if (status != 0 && status != 1) throw new BusinessException("状态只能是0或1");
        if (userMapper.selectById(id) == null) throw new BusinessException("用户不存在");
        userMapper.updateStatus(id, status);
        return Result.ok();
    }

    @GetMapping("/roles")
    public Result<List<Role>> roles() {
        return Result.ok(roleMapper.selectList());
    }

    private void validatePassword(String password) {
        if (password == null || password.length() < 6 || password.length() > 32) {
            throw new BusinessException("密码长度必须为6到32位");
        }
    }
}
