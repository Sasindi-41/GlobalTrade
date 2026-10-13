package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.dao.JobExecutionLogDAO;
import lk.sasindi.globaltrade.entity.JobExecutionLog;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/timer-services")
public class TimerServiceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private JobExecutionLogDAO jobExecutionLogDAO;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

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

        request.setAttribute(
                "activePage",
                "timer-services"
        );

        try {

            List<JobExecutionLog> logs =
                    jobExecutionLogDAO.findAll();

            request.setAttribute(
                    "jobExecutionLogs",
                    logs
            );

            request.setAttribute(
                    "error",
                    null
            );


        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "jobExecutionLogs",
                    Collections.emptyList()
            );

            request.setAttribute(
                    "error",
                    "Unable to load timer execution history."
            );
        }

        request.getRequestDispatcher(
                "/admin/timer-services.jsp"
        ).forward(
                request,
                response
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}