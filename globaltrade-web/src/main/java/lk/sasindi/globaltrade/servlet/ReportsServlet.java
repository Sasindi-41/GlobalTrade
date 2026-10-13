package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.dto.ReportSummary;
import lk.sasindi.globaltrade.ejb.ReportServiceBean;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/reports")
public class ReportsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private ReportServiceBean reportServiceBean;

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

        String reportType =
                request.getParameter("reportType");

        String startDateString =
                request.getParameter("startDate");

        String endDateString =
                request.getParameter("endDate");


        LocalDate startDate = null;
        LocalDate endDate = null;

        if (startDateString != null &&
                !startDateString.trim().isEmpty()) {

            try {

                startDate =
                        LocalDate.parse(
                                startDateString
                        );

            } catch (Exception e) {

                request.setAttribute(
                        "errorMessage",
                        "Invalid start date."
                );
            }
        }


        if (endDateString != null &&
                !endDateString.trim().isEmpty()) {

            try {

                endDate =
                        LocalDate.parse(
                                endDateString
                        );

            } catch (Exception e) {

                request.setAttribute(
                        "errorMessage",
                        "Invalid end date."
                );
            }
        }

        if (startDate != null &&
                endDate != null &&
                startDate.isAfter(endDate)) {

            request.setAttribute(
                    "errorMessage",
                    "Start date cannot be after end date."
            );

            startDate = null;
            endDate = null;
        }

        try {

            ReportSummary summary;

            if (reportType != null &&
                    !reportType.trim().isEmpty()) {

                summary =
                        reportServiceBean.generateReport(
                                reportType.trim(),
                                startDate,
                                endDate
                        );

            } else {

                summary =
                        reportServiceBean.generateSummary();
            }


            request.setAttribute(
                    "reportSummary",
                    summary
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Unable to load report information."
            );
        }

        request.setAttribute(
                "activePage",
                "reports"
        );


        String adminName =
                session.getAttribute("firstName") != null
                        ? String.valueOf(
                        session.getAttribute("firstName")
                )
                        : "Administrator";

        request.setAttribute(
                "adminName",
                adminName
        );


        request.getRequestDispatcher(
                "/admin/reports.jsp"
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

        String reportType =
                request.getParameter("reportType");

        String startDateString =
                request.getParameter("startDate");

        String endDateString =
                request.getParameter("endDate");

        if (reportType == null ||
                reportType.trim().isEmpty()) {

            redirectWithError(
                    request,
                    response,
                    "Please select a report type."
            );

            return;
        }

        if (startDateString == null ||
                startDateString.trim().isEmpty() ||
                endDateString == null ||
                endDateString.trim().isEmpty()) {

            redirectWithError(
                    request,
                    response,
                    "Please select a start date and end date."
            );

            return;
        }


        LocalDate startDate;
        LocalDate endDate;


        try {

            startDate =
                    LocalDate.parse(
                            startDateString
                    );

            endDate =
                    LocalDate.parse(
                            endDateString
                    );

        } catch (Exception e) {

            redirectWithError(
                    request,
                    response,
                    "Invalid date format."
            );

            return;
        }

        if (startDate.isAfter(endDate)) {

            redirectWithError(
                    request,
                    response,
                    "Start date cannot be after end date."
            );

            return;
        }

        String normalizedReportType =
                reportType.trim().toUpperCase();

        if (!"SHIPMENT".equals(normalizedReportType)
                && !"INVENTORY".equals(normalizedReportType)
                && !"VENDOR".equals(normalizedReportType)
                && !"ROUTE".equals(normalizedReportType)
                && !"ALERT".equals(normalizedReportType)
                && !"AUDIT".equals(normalizedReportType)) {

            redirectWithError(
                    request,
                    response,
                    "Unsupported report type."
            );

            return;
        }

        try {

            byte[] pdf =
                    reportServiceBean.generatePdfReport(
                            reportType.trim(),
                            startDate,
                            endDate
                    );

            if (pdf == null ||
                    pdf.length == 0) {

                redirectWithError(
                        request,
                        response,
                        "No data was found for the selected report and date range."
                );

                return;
            }

            response.reset();

            response.setContentType(
                    "application/pdf"
            );

            response.setHeader(
                    "Content-Disposition",
                    "inline; filename=\"GlobalTrade-"
                            + reportType.trim().toUpperCase()
                            + "-Report.pdf\""
            );

            response.setContentLength(
                    pdf.length
            );


            response.getOutputStream()
                    .write(pdf);

            response.getOutputStream()
                    .flush();

        } catch (Exception e) {

            e.printStackTrace();

            redirectWithError(
                    request,
                    response,
                    "Unable to generate the report."
            );
        }
    }

    private void redirectWithError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws IOException {

        request.getSession()
                .setAttribute(
                        "reportError",
                        message
                );

        response.sendRedirect(
                request.getContextPath()
                        + "/reports"
        );
    }
}