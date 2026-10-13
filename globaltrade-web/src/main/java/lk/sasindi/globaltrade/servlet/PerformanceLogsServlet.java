package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.dao.PerformanceLogDAO;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/performance-logs")
public class PerformanceLogsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private PerformanceLogDAO performanceLogDAO;


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

        if (!"ADMIN".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))) {

            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
            return;
        }

        request.setAttribute("activePage", "performance-logs");

        try {

            request.setAttribute("performanceLogs", performanceLogDAO.findRecent(200));
            request.setAttribute("averageExecutionTime", performanceLogDAO.findAverageExecutionTime());
            request.setAttribute("slowCount", performanceLogDAO.countByStatusName("SLOW"));
            request.setAttribute("errorCount", performanceLogDAO.countByStatusName("ERROR"));
            request.setAttribute("totalCount", performanceLogDAO.countAll());

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("performanceLogs", Collections.emptyList());
            request.setAttribute("error", "Unable to load performance logs.");
        }

        request.getRequestDispatcher(
                "/admin/performance-logs.jsp"
        ).forward(request, response);
    }
}
