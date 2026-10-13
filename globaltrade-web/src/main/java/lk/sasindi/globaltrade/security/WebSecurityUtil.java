package lk.sasindi.globaltrade.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;


public final class WebSecurityUtil {

    private WebSecurityUtil() {
    }

    public static boolean isAuthenticated(
            HttpServletRequest request
    ) {

        if (request == null) {
            return false;
        }

        HttpSession session =
                request.getSession(false);

        return session != null
                &&
                Boolean.TRUE.equals(
                        session.getAttribute(
                                "authenticated"
                        )
                );
    }

    public static Integer getUserId(
            HttpServletRequest request
    ) {

        if (request == null) {
            return null;
        }

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            return null;
        }

        Object value =
                session.getAttribute("userId");

        if (value instanceof Integer) {
            return (Integer) value;
        }

        if (value instanceof Number) {
            return ((Number) value).intValue();
        }

        return null;
    }

    public static String getRole(
            HttpServletRequest request
    ) {

        if (request == null) {
            return null;
        }

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            return null;
        }

        Object role =
                session.getAttribute("role");

        return role == null
                ? null
                : role.toString().toUpperCase();
    }

    public static boolean hasRole(
            HttpServletRequest request,
            String requiredRole
    ) {

        if (!isAuthenticated(request) ||
                requiredRole == null) {

            return false;
        }

        String currentRole =
                getRole(request);

        return requiredRole.equalsIgnoreCase(
                currentRole
        );
    }

    public static boolean hasAnyRole(
            HttpServletRequest request,
            String... roles
    ) {

        if (!isAuthenticated(request) ||
                roles == null) {

            return false;
        }

        String currentRole =
                getRole(request);

        if (currentRole == null) {
            return false;
        }

        for (String role : roles) {

            if (role != null &&
                    role.equalsIgnoreCase(currentRole)) {

                return true;
            }
        }

        return false;
    }

    public static void invalidateSession(
            HttpServletRequest request
    ) {

        if (request == null) {
            return;
        }

        HttpSession session =
                request.getSession(false);

        if (session != null) {
            session.invalidate();
        }
    }
}

