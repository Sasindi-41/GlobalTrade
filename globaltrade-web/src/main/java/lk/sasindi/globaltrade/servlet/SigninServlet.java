package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.exception.AuthenticationException;
import lk.sasindi.globaltrade.service.AuthenticationService;

import java.io.IOException;

@WebServlet("/signin")
public class SigninServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private AuthenticationService authenticationService;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.getRequestDispatcher(
                "/signin.jsp"
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

        String username =
                request.getParameter("username");

        String password =
                request.getParameter("password");


        if (username == null ||
                password == null ||
                username.trim().isEmpty() ||
                password.isEmpty()) {

            setError(
                    request,
                    response,
                    "Please enter your username and password.",
                    username
            );

            return;
        }


        username = username.trim();

        try {

            User user =
                    authenticationService.authenticate(
                            username,
                            password
                    );



            HttpSession session =
                    request.getSession(false);

            if (session == null) {

                session =
                        request.getSession(true);

            } else {

                try {

                    request.changeSessionId();

                } catch (IllegalStateException e) {

                    session.invalidate();

                    session =
                            request.getSession(true);
                }
            }

            session.setMaxInactiveInterval(
                    30 * 60
            );

            session.setAttribute(
                    "authenticated",
                    Boolean.TRUE
            );

            session.setAttribute(
                    "userId",
                    user.getId()
            );

            session.setAttribute(
                    "username",
                    user.getUsername()
            );

            session.setAttribute(
                    "firstName",
                    user.getFirstName()
            );

            session.setAttribute(
                    "role",
                    user.getRole().getName()
            );

            String role =
                    user.getRole()
                            .getName()
                            .toUpperCase();

            switch (role) {

                case "ADMIN":

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/admin/dashboard"
                    );

                    break;

                case "USER":

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/user/dashboard"
                    );

                    break;


                default:

                    session.invalidate();

                    setError(
                            request,
                            response,
                            "Your account has an invalid role.",
                            username
                    );
            }


        } catch (AuthenticationException e) {


            setError(
                    request,
                    response,
                    e.getMessage(),
                    username
            );


        } catch (Exception e) {


            e.printStackTrace();

            setError(
                    request,
                    response,
                    "Unable to sign in at this time. Please try again later.",
                    username
            );
        }
    }

    private void setError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message,
            String username
    ) throws ServletException, IOException {

        request.setAttribute(
                "errorMessage",
                message
        );


        request.setAttribute(
                "username",
                username
        );


        request.getRequestDispatcher(
                "/signin.jsp"
        ).forward(
                request,
                response
        );
    }

}