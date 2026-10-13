<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sasindi.globaltrade.entity.*" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("activePage", "performance-logs");

    List<PerformanceLog> performanceLogs = (List<PerformanceLog>) request.getAttribute("performanceLogs");
    Double averageExecutionTime = (Double) request.getAttribute("averageExecutionTime");
    Long slowCount = (Long) request.getAttribute("slowCount");
    Long errorCount = (Long) request.getAttribute("errorCount");
    Long totalCount = (Long) request.getAttribute("totalCount");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GlobalTrade | Performance Logs</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/admin/assets/admin-style.css">

</head>
<body>

<jsp:include page="admin-sidebar.jsp"/>

<main class="main">

    <jsp:include page="admin-topbar.jsp"/>

    <section class="content">

        <div class="page-heading">
            <div>
                <h1>Performance Logs</h1>
                <p>Method-level timing captured by AlertPerformanceInterceptor
                    and RoutePerformanceInterceptor on every call.</p>
            </div>
        </div>

        <% if (error != null) { %>
        <div class="flash-message flash-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <%= error %>
        </div>
        <% } %>

        <div class="kpi-grid">

            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-title">Samples Recorded</span>
                    <div class="kpi-icon"><i class="fa-solid fa-gauge-high"></i></div>
                </div>
                <div class="kpi-number"><%= totalCount != null ? totalCount : 0 %></div>
            </div>

            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-title">Avg. Execution Time</span>
                    <div class="kpi-icon"><i class="fa-solid fa-stopwatch"></i></div>
                </div>
                <div class="kpi-number">
                    <%= averageExecutionTime != null
                            ? String.format("%.1f ms", averageExecutionTime) : "-" %>
                </div>
            </div>

            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-title">Slow Calls (&gt;500ms)</span>
                    <div class="kpi-icon"><i class="fa-solid fa-hourglass-half"></i></div>
                </div>
                <div class="kpi-number"><%= slowCount != null ? slowCount : 0 %></div>
            </div>

            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-title">Errors</span>
                    <div class="kpi-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
                </div>
                <div class="kpi-number"><%= errorCount != null ? errorCount : 0 %></div>
            </div>

        </div>

        <div class="card" style="margin-top:14px;">

            <div class="card-header">
                <h2>Recent Samples</h2>
            </div>

            <div class="table-wrap">

                <% if (performanceLogs == null || performanceLogs.isEmpty()) { %>

                <div class="empty-state">
                    <i class="fa-solid fa-gauge-high"></i>
                    <p>No performance samples yet - they appear as soon as an
                        intercepted method (Alert or Route services) is called.</p>
                </div>

                <% } else { %>

                <table>
                    <thead>
                    <tr>
                        <th>Class</th>
                        <th>Method</th>
                        <th>Execution Time</th>
                        <th>Status</th>
                        <th>Error</th>
                        <th>Recorded</th>
                    </tr>
                    </thead>
                    <tbody>

                    <% for (PerformanceLog log : performanceLogs) {

                        String statusName =
                                log.getPerformanceStatus() != null
                                        ? log.getPerformanceStatus().getName() : "-";

                        String statusClass =
                                "status-pill status-" + statusName.toLowerCase();
                    %>

                    <tr>
                        <td><%= log.getClassName() %></td>
                        <td><%= log.getMethod() %></td>
                        <td><%= log.getExecutionTimeMs() %> ms</td>
                        <td><span class="<%= statusClass %>"><%= statusName %></span></td>
                        <td><%= log.getError() != null ? log.getError() : "-" %></td>
                        <td><%= log.getCreatedAt() %></td>
                    </tr>

                    <% } %>

                    </tbody>
                </table>

                <% } %>

            </div>

        </div>

        <footer class="footer" style="margin-top:14px;">
            <span>&copy; 2026 GlobalTrade Logistics System. All rights reserved.</span>
            <span>Version 1.0.0</span>
        </footer>

    </section>

</main>

</body>
</html>
