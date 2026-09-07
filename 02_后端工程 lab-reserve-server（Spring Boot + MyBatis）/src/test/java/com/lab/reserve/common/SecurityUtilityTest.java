package com.lab.reserve.common;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class SecurityUtilityTest {
    @Test
    void jwtRoundTripPreservesIdentity() {
        JwtUtil jwt = new JwtUtil("0123456789abcdef0123456789abcdef", 60000);
        String token = jwt.createToken(7L, "student007", "STUDENT");
        TokenUser parsed = jwt.parseToken(token);
        assertEquals(7L, parsed.getUserId());
        assertEquals("student007", parsed.getUsername());
        assertEquals("STUDENT", parsed.getRoleCode());
    }

    @Test
    void weakJwtSecretIsRejected() {
        assertThrows(IllegalArgumentException.class, () -> new JwtUtil("too-short", 60000));
    }

    @Test
    void bcryptDoesNotStorePlainText() {
        String encoded = PasswordUtil.encode("SafePassword123!");
        assertNotEquals("SafePassword123!", encoded);
        assertTrue(PasswordUtil.matches("SafePassword123!", encoded));
        assertFalse(PasswordUtil.matches("wrong", encoded));
    }
}
