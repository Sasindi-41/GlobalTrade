package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.service.CityService;
import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;

@WebServlet("/admin/profile")
public class AdminProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private UserService userService;

    @EJB
    private CityService cityService;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );

            return;
        }

        if (!Boolean.TRUE.equals(
                session.getAttribute("authenticated")
        )) {

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );

            return;
        }

        Object roleObject =
                session.getAttribute("role");

        if (roleObject == null ||
                !"ADMIN".equalsIgnoreCase(
                        roleObject.toString()
                )) {

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );

            return;
        }

        Object userIdObject =
                session.getAttribute("userId");

        if (userIdObject == null) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );

            return;
        }

        int userId;

        try {

            userId = Integer.parseInt(
                    userIdObject.toString()
            );

        } catch (NumberFormatException e) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );

            return;
        }

        User admin =
                userService.findById(userId);

        if (admin == null) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );

            return;
        }

        request.setAttribute(
                "cities",
                cityService.findAll()
        );

        request.setAttribute(
                "user",
                admin
        );

        request.getRequestDispatcher(
                "/admin/profile.jsp"
        ).forward(
                request,
                response
        );
    }
}