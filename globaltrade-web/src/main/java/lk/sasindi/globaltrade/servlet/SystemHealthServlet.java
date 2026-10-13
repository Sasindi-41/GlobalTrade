package lk.sasindi.globaltrade.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/admin/system-health")
public class SystemHealthServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");


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

        Runtime runtime =
                Runtime.getRuntime();


        long totalMemory =
                runtime.totalMemory();


        long freeMemory =
                runtime.freeMemory();


        long usedMemory =
                totalMemory - freeMemory;


        long maxMemory =
                runtime.maxMemory();

        request.setAttribute(
                "applicationStatus",
                "RUNNING"
        );


        request.setAttribute(
                "serverTime",
                LocalDateTime.now()
                        .format(FORMATTER)
        );


        request.setAttribute(
                "javaVersion",
                System.getProperty("java.version")
        );


        request.setAttribute(
                "osName",
                System.getProperty("os.name")
        );


        request.setAttribute(
                "osVersion",
                System.getProperty("os.version")
        );


        request.setAttribute(
                "availableProcessors",
                runtime.availableProcessors()
        );


        request.setAttribute(
                "usedMemory",
                formatBytes(usedMemory)
        );


        request.setAttribute(
                "totalMemory",
                formatBytes(totalMemory)
        );


        request.setAttribute(
                "maxMemory",
                formatBytes(maxMemory)
        );


        request.setAttribute(
                "activePage",
                "system-health"
        );

        request.getRequestDispatcher(
                "/admin/system-health.jsp"
        ).forward(
                request,
                response
        );
    }


    private String formatBytes(long bytes) {

        if (bytes < 1024) {
            return bytes + " B";
        }


        double value =
                bytes / 1024.0;


        if (value < 1024) {
            return String.format(
                    "%.2f KB",
                    value
            );
        }


        value =
                value / 1024.0;


        if (value < 1024) {
            return String.format(
                    "%.2f MB",
                    value
            );
        }


        value =
                value / 1024.0;


        return String.format(
                "%.2f GB",
                value
        );
    }


}
