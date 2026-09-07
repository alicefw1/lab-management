package com.lab.reserve.config;

import com.lab.reserve.annotation.RequireRole;
import com.lab.reserve.common.AuthContext;
import com.lab.reserve.common.JwtUtil;
import com.lab.reserve.common.TokenUser;
import com.lab.reserve.entity.User;
import com.lab.reserve.mapper.UserMapper;
import com.lab.reserve.util.Result;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserMapper userMapper;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }
        if (!(handler instanceof HandlerMethod)) {
            return true;
        }

        String token = resolveToken(request);
        TokenUser user = null;
        if (token != null && !token.isEmpty()) {
            try {
                user = jwtUtil.parseToken(token);
            } catch (Exception ignored) {
                user = null;
            }
        }

        if (user == null) {
            writeUnauthorized(response, "未登录或登录已过期，请重新登录");
            return false;
        }

        // 每次请求核对账号实时状态和角色，确保冻结、删除或降权立即生效。
        User current = userMapper.selectById(user.getUserId());
        if (current == null || current.getStatus() == null || current.getStatus() == 0) {
            writeUnauthorized(response, "账号已停用，请重新登录或联系管理员");
            return false;
        }
        user = new TokenUser(current.getId(), current.getUsername(), current.getRoleCode());

        HandlerMethod handlerMethod = (HandlerMethod) handler;
        RequireRole requireRole = handlerMethod.getMethodAnnotation(RequireRole.class);
        if (requireRole == null) {
            requireRole = handlerMethod.getBeanType().getAnnotation(RequireRole.class);
        }
        if (requireRole != null) {
            List<String> allowed = Arrays.asList(requireRole.value());
            if (!allowed.isEmpty() && !allowed.contains(user.getRoleCode())) {
                writeForbidden(response, "没有权限访问该接口");
                return false;
            }
        }

        AuthContext.set(user.getUserId(), user.getUsername(), user.getRoleCode());
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        AuthContext.clear();
    }

    private String resolveToken(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            return header.substring(7);
        }
        return null;
    }

    private void writeUnauthorized(HttpServletResponse response, String message) throws IOException {
        response.setStatus(401);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(Result.unauthorized(message)));
    }

    private void writeForbidden(HttpServletResponse response, String message) throws IOException {
        response.setStatus(403);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(Result.forbidden(message)));
    }
}
