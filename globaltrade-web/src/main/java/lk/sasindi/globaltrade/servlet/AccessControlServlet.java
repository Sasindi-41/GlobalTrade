package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.AccessControlSessionBean;

import java.io.IOException;

@WebServlet("/access-control")
public class AccessControlServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private AccessControlSessionBean accessControlSessionBean;


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {

            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        String role = String.valueOf(session.getAttribute("role"));

        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access denied."
            );
            return;
        }

        request.setAttribute("activePage", "access-control");

        request.setAttribute("roles", accessControlSessionBean.getAllRoles());
        request.setAttribute("permissions", accessControlSessionBean.getAllPermissions());
        request.setAttribute("rolePermissions", accessControlSessionBean.getAllRolePermissions());

        Object errorMessage = session.getAttribute("errorMessage");
        Object successMessage = session.getAttribute("successMessage");

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage");
        }

        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }

        request.getRequestDispatcher(
                "/admin/access-control.jsp"
        ).forward(request, response);
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                !Boolean.TRUE.equals(session.getAttribute("authenticated")) ||
                !"ADMIN".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))) {

            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
            return;
        }

        String action = request.getParameter("action");

        try {

            if ("grant".equals(action)) {

                accessControlSessionBean.grantPermission(
                        parseIntOrNull(request.getParameter("roleId")),
                        parseIntOrNull(request.getParameter("permissionId"))
                );

                session.setAttribute("successMessage", "Permission granted.");

            } else if ("revoke".equals(action)) {

                accessControlSessionBean.revokePermission(
                        parseIntOrNull(request.getParameter("rolePermissionId"))
                );

                session.setAttribute("successMessage", "Permission revoked.");

            } else if ("createPermission".equals(action)) {

                accessControlSessionBean.createPermission(
                        request.getParameter("name"),
                        request.getParameter("description")
                );

                session.setAttribute("successMessage", "Permission created.");
            }

        } catch (IllegalArgumentException e) {

            session.setAttribute("errorMessage", e.getMessage());

        } catch (Exception e) {

            e.printStackTrace();
            session.setAttribute("errorMessage", "Unable to process your request.");
        }

        response.sendRedirect(request.getContextPath() + "/access-control");
    }

    private Integer parseIntOrNull(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
