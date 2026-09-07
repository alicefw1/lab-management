package com.lab.reserve.common;

public class AuthContext {
    private static final ThreadLocal<Long> USER_ID = new ThreadLocal<>();
    private static final ThreadLocal<String> USERNAME = new ThreadLocal<>();
    private static final ThreadLocal<String> ROLE_CODE = new ThreadLocal<>();

    public static void set(Long userId, String username, String roleCode) {
        USER_ID.set(userId);
        USERNAME.set(username);
        ROLE_CODE.set(roleCode);
    }

    public static Long getUserId() { return USER_ID.get(); }
    public static String getUsername() { return USERNAME.get(); }
    public static String getRoleCode() { return ROLE_CODE.get(); }

    public static void clear() {
        USER_ID.remove();
        USERNAME.remove();
        ROLE_CODE.remove();
    }
}
