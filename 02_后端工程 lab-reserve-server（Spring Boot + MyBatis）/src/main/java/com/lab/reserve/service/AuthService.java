package com.lab.reserve.service;

import com.lab.reserve.common.BusinessException;
import com.lab.reserve.common.JwtUtil;
import com.lab.reserve.common.PasswordUtil;
import com.lab.reserve.dto.LoginRequest;
import com.lab.reserve.dto.LoginResponse;
import com.lab.reserve.dto.RegisterRequest;
import com.lab.reserve.entity.Role;
import com.lab.reserve.entity.User;
import com.lab.reserve.mapper.RoleMapper;
import com.lab.reserve.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private JwtUtil jwtUtil;

    public LoginResponse login(LoginRequest request) {
        if (request == null || isBlank(request.getUsername()) || isBlank(request.getPassword())) {
            throw new BusinessException("请输入账号和密码");
        }
        User user = userMapper.selectByUsername(request.getUsername().trim());
        if (user == null) {
            throw new BusinessException("账号不存在");
        }
        if (!PasswordUtil.matches(request.getPassword(), user.getPassword())) {
            throw new BusinessException("密码错误");
        }
        if (user.getStatus() == null || user.getStatus() == 0) {
            throw new BusinessException("账号已被冻结，请联系管理员");
        }
        // 渐进式密码升级：明文密码登录成功后自动加密为 BCrypt
        if (user.getPassword() != null && !user.getPassword().startsWith("$2")) {
            User update = new User();
            update.setId(user.getId());
            update.setPassword(PasswordUtil.encode(request.getPassword()));
            userMapper.updateById(update);
        }
        String roleCode = user.getRoleCode() == null ? "STUDENT" : user.getRoleCode();
        String token = jwtUtil.createToken(user.getId(), user.getUsername(), roleCode);
        return new LoginResponse(token, user.getId(), user.getUsername(), user.getRealName(), roleCode);
    }

    public void register(RegisterRequest request) {
        if (request == null || isBlank(request.getUsername()) || isBlank(request.getPassword())) {
            throw new BusinessException("用户名和密码不能为空");
        }
        if (request.getPassword().length() < 6 || request.getPassword().length() > 32) {
            throw new BusinessException("密码长度必须为6到32位");
        }
        if (userMapper.countByUsername(request.getUsername().trim()) > 0) {
            throw new BusinessException("用户名已存在");
        }
        Role student = findRoleByCode("STUDENT");
        if (student == null) {
            throw new BusinessException("系统缺少学生角色");
        }
        User user = new User();
        user.setUsername(request.getUsername().trim());
        user.setPassword(PasswordUtil.encode(request.getPassword()));
        user.setRealName(request.getRealName());
        user.setPhone(request.getPhone());
        user.setEmail(request.getEmail());
        user.setRoleId(student.getId());
        user.setStatus(1);
        userMapper.insert(user);
    }

    private Role findRoleByCode(String code) {
        for (Role role : roleMapper.selectList()) {
            if (code.equals(role.getRoleCode())) return role;
        }
        return null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
