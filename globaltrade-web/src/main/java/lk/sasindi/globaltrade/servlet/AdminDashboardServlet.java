package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.AlertServiceBean;
import lk.sasindi.globaltrade.dto.ReportSummary;

import lk.sasindi.globaltrade.ejb.ReportServiceBean;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private ReportServiceBean reportServiceBean;

    @EJB
    private AlertServiceBean alertServiceBean;

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

        String firstName =
                session.getAttribute("firstName") != null
                        ? String.valueOf(
                        session.getAttribute("firstName")
                )
                        : "Administrator";


        request.setAttribute(
                "adminName",
                firstName
        );

        ReportSummary summary =
                null;


        try {

            summary =
                    reportServiceBean.generateSummary();


            request.setAttribute(
                    "reportSummary",
                    summary
            );


        } catch (Exception e) {

            e.printStackTrace();


            request.setAttribute(
                    "dashboardError",
                    "Unable to load live dashboard statistics."
            );
        }

        try {

            long activeAlerts =
                    alertServiceBean.getOpenCount();


            request.setAttribute(
                    "activeAlerts",
                    activeAlerts
            );


        } catch (Exception e) {

            e.printStackTrace();


            request.setAttribute(
                    "activeAlerts",
                    0L
            );
        }

        request.setAttribute(
                "activePage",
                "dashboard"
        );

        request.getRequestDispatcher(
                "/admin/dashboard.jsp"
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

        doGet(
                request,
                response
        );
    }
}