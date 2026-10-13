package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.entity.City;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.service.CityService;
import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;

@WebServlet("/admin/update-profile")
public class AdminUpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private UserService userService;

    @EJB
    private CityService cityService;


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

        String role =
                String.valueOf(
                        session.getAttribute("role")
                );


        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/user/dashboard"
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

        String firstName =
                request.getParameter("firstName");

        String lastName =
                request.getParameter("lastName");

        String mobile =
                request.getParameter("mobile");

        String company =
                request.getParameter("company");

        String jobTitle =
                request.getParameter("jobTitle");

        String address =
                request.getParameter("address");

        String postalCode =
                request.getParameter("postalCode");

        String cityIdParameter =
                request.getParameter("cityId");

        if (firstName != null) {
            firstName = firstName.trim();
        }

        if (lastName != null) {
            lastName = lastName.trim();
        }

        if (mobile != null) {
            mobile = mobile.trim();
        }

        if (company != null) {
            company = company.trim();
        }

        if (jobTitle != null) {
            jobTitle = jobTitle.trim();
        }

        if (address != null) {
            address = address.trim();
        }

        if (postalCode != null) {
            postalCode = postalCode.trim();
        }

        if (firstName == null ||
                firstName.isEmpty() ||

                lastName == null ||
                lastName.isEmpty() ||

                mobile == null ||
                mobile.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/profile?error=required"
            );

            return;
        }

        if (!mobile.matches("\\d{10}")) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/profile?error=mobile"
            );

            return;
        }

        City city = null;


        if (cityIdParameter != null &&
                !cityIdParameter.trim().isEmpty()) {

            try {

                Integer cityId =
                        Integer.parseInt(
                                cityIdParameter.trim()
                        );


                city =
                        cityService.findById(cityId);


                if (city == null) {

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/admin/profile?error=city"
                    );

                    return;
                }

            } catch (NumberFormatException e) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/profile?error=city"
                );

                return;
            }
        }

        User updatedUser =
                userService.updateAdminProfile(
                        userId,
                        firstName,
                        lastName,
                        mobile,
                        company,
                        jobTitle,
                        address,
                        postalCode,
                        city
                );

        if (updatedUser == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/profile?error=update"
            );

            return;
        }

        session.setAttribute(
                "successMessage",
                "Your administrator profile has been updated successfully."
        );

        String updatedAdminName =
                (
                        updatedUser.getFirstName()
                                + " "
                                + updatedUser.getLastName()
                ).trim();


        if (updatedAdminName.isEmpty()) {

            updatedAdminName =
                    updatedUser.getUsername();
        }


        session.setAttribute(
                "adminName",
                updatedAdminName
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/profile"
        );
    }
}