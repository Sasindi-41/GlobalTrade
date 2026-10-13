package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lk.sasindi.globaltrade.entity.Role;
import lk.sasindi.globaltrade.entity.Status;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.service.UserService;
import lk.sasindi.globaltrade.util.PasswordUtil;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    @EJB
    private UserService userService;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.getRequestDispatcher("/signup.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String firstName =
                request.getParameter("firstName");

        String lastName =
                request.getParameter("lastName");

        String email =
                request.getParameter("email");

        String phone =
                request.getParameter("phone");

        String username =
                request.getParameter("username");

        String password =
                request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirmPassword");

        String terms =
                request.getParameter("terms");

        if (firstName == null ||
                lastName == null ||
                email == null ||
                phone == null ||
                username == null ||
                password == null ||
                confirmPassword == null) {

            setError(
                    request,
                    response,
                    "Please fill in all required fields."
            );

            return;
        }

        firstName = firstName.trim();
        lastName = lastName.trim();
        email = email.trim().toLowerCase();
        phone = phone.trim();
        username = username.trim();

        if (firstName.isEmpty() ||
                lastName.isEmpty() ||
                email.isEmpty() ||
                phone.isEmpty() ||
                username.isEmpty() ||
                password.isEmpty() ||
                confirmPassword.isEmpty()) {

            setError(
                    request,
                    response,
                    "Please fill in all required fields."
            );

            return;
        }

        if (terms == null) {

            setError(
                    request,
                    response,
                    "Please agree to the Terms & Conditions."
            );

            return;
        }

        if (firstName.length() < 2) {

            setError(
                    request,
                    response,
                    "First name must contain at least 2 characters."
            );

            return;
        }

        if (lastName.length() < 2) {

            setError(
                    request,
                    response,
                    "Last name must contain at least 2 characters."
            );

            return;
        }

        if (!phone.matches("^07[0-9]{8}$")) {

            setError(
                    request,
                    response,
                    "Please enter a valid Sri Lankan mobile number."
            );

            return;
        }

        if (!username.matches("^[A-Za-z0-9_]{4,50}$")) {

            setError(
                    request,
                    response,
                    "Username must contain 4-50 characters using letters, numbers or underscore."
            );

            return;
        }

        if (password.length() < 8) {

            setError(
                    request,
                    response,
                    "Password must contain at least 8 characters."
            );

            return;
        }


        if (!password.matches(".*[A-Z].*")) {

            setError(
                    request,
                    response,
                    "Password must contain at least one uppercase letter."
            );

            return;
        }


        if (!password.matches(".*[a-z].*")) {

            setError(
                    request,
                    response,
                    "Password must contain at least one lowercase letter."
            );

            return;
        }


        if (!password.matches(".*[0-9].*")) {

            setError(
                    request,
                    response,
                    "Password must contain at least one number."
            );

            return;
        }


        if (!password.matches(".*[^A-Za-z0-9].*")) {

            setError(
                    request,
                    response,
                    "Password must contain at least one special character."
            );

            return;
        }

        if (!password.equals(confirmPassword)) {

            setError(
                    request,
                    response,
                    "Passwords do not match."
            );

            return;
        }


        if (userService.usernameExists(username)) {

            setError(
                    request,
                    response,
                    "Username already exists. Please choose another username."
            );

            return;
        }

        if (userService.emailExists(email)) {

            setError(
                    request,
                    response,
                    "An account with this email already exists."
            );

            return;
        }


        Role role =
                userService.findRoleByName("USER");

        if (role == null) {

            setError(
                    request,
                    response,
                    "Default USER role could not be found."
            );

            return;
        }

        Status status =
                userService.findStatusByName("ACTIVE");

        if (status == null) {

            setError(
                    request,
                    response,
                    "Default account status could not be found."
            );

            return;
        }


        String passwordHash =
                PasswordUtil.hashPassword(password);

        User user = new User(
                username,
                passwordHash,
                firstName,
                lastName,
                email,
                phone,
                LocalDateTime.now(),
                role,
                status
        );

        try {

            userService.registerUser(user);

            response.sendRedirect(
                    request.getContextPath()
                            + "/signin?registered=true"
            );

        } catch (Exception e) {

            e.printStackTrace();

            setError(
                    request,
                    response,
                    "Something went wrong while creating your account."
            );
        }
    }

    private void setError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message
    ) throws ServletException, IOException {

        request.setAttribute(
                "errorMessage",
                message
        );

        request.setAttribute(
                "firstName",
                request.getParameter("firstName")
        );

        request.setAttribute(
                "lastName",
                request.getParameter("lastName")
        );

        request.setAttribute(
                "email",
                request.getParameter("email")
        );

        request.setAttribute(
                "phone",
                request.getParameter("phone")
        );

        request.setAttribute(
                "username",
                request.getParameter("username")
        );

        request.getRequestDispatcher(
                "/signup.jsp"
        ).forward(request, response);
    }
}