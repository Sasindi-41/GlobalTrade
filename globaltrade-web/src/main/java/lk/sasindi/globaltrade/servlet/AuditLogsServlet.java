package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.AuditLog;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/audit-logs")
public class AuditLogsServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @EJB
    private AuditLogServiceBean auditLogService;


    @EJB
    private UserService userService;

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
                    request.getContextPath() +
                            "/signin"
            );

            return;
        }

        String role =
                String.valueOf(
                        session.getAttribute("role")
                );


        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access denied."
            );

            return;
        }

        Object userObject =
                session.getAttribute("userId");


        if (!(userObject instanceof Number)) {

            response.sendRedirect(
                    request.getContextPath() +
                            "/signin"
            );

            return;
        }


        Integer userId =
                ((Number) userObject)
                        .intValue();


        User user =
                userService.findById(userId);


        if (user == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Administrator profile could not be loaded."
            );

            return;
        }


        request.setAttribute(
                "user",
                user
        );

        String keyword =
                request.getParameter("search");


        try {

            List<AuditLog> logs;


            if (keyword != null &&
                    !keyword.trim().isEmpty()) {

                logs =
                        auditLogService.searchLogs(
                                keyword
                        );

            } else {

                logs =
                        auditLogService.getAllLogs();
            }


            request.setAttribute(
                    "auditLogs",
                    logs
            );

            request.setAttribute(
                    "totalLogs",
                    auditLogService.getTotalCount()
            );


            request.setAttribute(
                    "todayLogs",
                    auditLogService.getTodayCount()
            );


            request.setAttribute(
                    "createLogs",
                    auditLogService.getCreateCount()
            );


            request.setAttribute(
                    "updateLogs",
                    auditLogService.getUpdateCount()
            );


            request.setAttribute(
                    "deleteLogs",
                    auditLogService.getDeleteCount()
            );


        } catch (Exception e) {

            e.printStackTrace();


            request.setAttribute(
                    "auditLogs",
                    Collections.emptyList()
            );


            request.setAttribute(
                    "errorMessage",
                    "Unable to load audit logs."
            );
        }

        request.setAttribute(
                "activePage",
                "audit"
        );

        request.getRequestDispatcher(
                "/admin/audit-logs.jsp"
        ).forward(
                request,
                response
        );
    }
}