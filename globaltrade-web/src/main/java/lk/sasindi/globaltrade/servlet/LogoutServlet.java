package lk.sasindi.globaltrade.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        if (session != null) {

            session.invalidate();
        }

        response.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate"
        );

        response.setHeader(
                "Pragma",
                "no-cache"
        );

        response.setDateHeader(
                "Expires",
                0
        );

        response.setHeader(
                "X-Content-Type-Options",
                "nosniff"
        );

        response.setHeader(
                "X-Frame-Options",
                "SAMEORIGIN"
        );

        response.setHeader(
                "Referrer-Policy",
                "strict-origin-when-cross-origin"
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/signin?logout=true"
        );
    }
}

