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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {


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

        if (session == null ||
                !Boolean.TRUE.equals(
                        session.getAttribute("authenticated")
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

        User user =
                userService.findById(userId);

        if (user == null) {

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
                user
        );

        Object successMessage =
                session.getAttribute("successMessage");

        Object errorMessage =
                session.getAttribute("errorMessage");

        if (successMessage != null) {

            request.setAttribute(
                    "successMessage",
                    successMessage
            );

            session.removeAttribute("successMessage");
        }

        if (errorMessage != null) {

            request.setAttribute(
                    "errorMessage",
                    errorMessage
            );

            session.removeAttribute("errorMessage");
        }

        request.getRequestDispatcher(
                "/user/profile.jsp"
        ).forward(
                request,
                response
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                !Boolean.TRUE.equals(
                        session.getAttribute("authenticated")
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


        String action =
                request.getParameter("action");

        if ("changePassword".equals(action)) {

            try {

                String currentPassword =
                        request.getParameter("currentPassword");

                String newPassword =
                        request.getParameter("newPassword");

                String confirmPassword =
                        request.getParameter("confirmPassword");

                if (currentPassword == null ||
                        currentPassword.trim().isEmpty()) {

                    throw new IllegalArgumentException(
                            "Please enter your current password."
                    );
                }


                if (newPassword == null ||
                        newPassword.trim().isEmpty()) {

                    throw new IllegalArgumentException(
                            "Please enter a new password."
                    );
                }


                if (confirmPassword == null ||
                        confirmPassword.trim().isEmpty()) {

                    throw new IllegalArgumentException(
                            "Please confirm your new password."
                    );
                }

                if (newPassword.length() < 8) {

                    throw new IllegalArgumentException(
                            "New password must contain at least 8 characters."
                    );
                }

                if (!newPassword.equals(confirmPassword)) {

                    throw new IllegalArgumentException(
                            "New password and confirmation do not match."
                    );
                }

                if (currentPassword.equals(newPassword)) {

                    throw new IllegalArgumentException(
                            "New password must be different from your current password."
                    );
                }

                userService.changePassword(
                        userId,
                        currentPassword,
                        newPassword
                );

                session.setAttribute(
                        "successMessage",
                        "Your password has been updated successfully."
                );

            } catch (IllegalArgumentException e) {

                session.setAttribute(
                        "errorMessage",
                        e.getMessage()
                );

            } catch (Exception e) {

                e.printStackTrace();

                session.setAttribute(
                        "errorMessage",
                        "Unable to update password. Please try again."
                );
            }

            response.sendRedirect(
                    request.getContextPath() + "/profile"
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/profile"
        );
    }


}
