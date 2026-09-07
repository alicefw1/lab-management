package com.lab.reserve.controller;

import com.lab.reserve.dto.LoginRequest;
import com.lab.reserve.dto.RegisterRequest;
import com.lab.reserve.service.AuthService;
import com.lab.reserve.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public Result<?> login(@RequestBody LoginRequest request) {
        return Result.ok(authService.login(request));
    }

    @PostMapping("/register")
    public Result<?> register(@RequestBody RegisterRequest request) {
        authService.register(request);
        return Result.ok();
    }
}
