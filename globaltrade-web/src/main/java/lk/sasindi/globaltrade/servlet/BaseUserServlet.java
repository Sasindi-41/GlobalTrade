package lk.sasindi.globaltrade.servlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public abstract class BaseUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected Integer requireUser(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                !Boolean.TRUE.equals(
                        session.getAttribute("authenticated")
                )) {

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );

            return null;
        }

        String role =
                (String) session.getAttribute("role");

        if (role == null ||
                !"USER".equalsIgnoreCase(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access denied."
            );

            return null;
        }

        Object userIdObject =
                session.getAttribute("userId");

        if (userIdObject == null) {

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );

            return null;
        }

        return ((Number) userIdObject).intValue();
    }

    protected Integer parseIntOrNull(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    protected java.time.LocalDateTime parseDateTimeOrNull(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return java.time.LocalDateTime.parse(value.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
