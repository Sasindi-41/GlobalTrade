<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="lk.sasindi.globaltrade.dto.ReportSummary" %>

<%

    ReportSummary summary =
            (ReportSummary) request.getAttribute(
                    "reportSummary"
            );


    String adminName =
            (String) request.getAttribute(
                    "adminName"
            );


    if (adminName == null ||
            adminName.trim().isEmpty()) {

        adminName = "Administrator";
    }


    Object activeAlertsObject =
            request.getAttribute(
                    "activeAlerts"
            );


    long activeAlerts = 0;


    if (activeAlertsObject != null) {

        try {

            activeAlerts =
                    Long.parseLong(
                            String.valueOf(
                                    activeAlertsObject
                            )
                    );

        } catch (NumberFormatException ignored) {

            activeAlerts = 0;
        }
    }


    String dashboardError =
            (String) request.getAttribute(
                    "dashboardError"
            );

    long totalShipments = 0;
    long pendingShipments = 0;
    long deliveredShipments = 0;
    long cancelledShipments = 0;

    long totalVendors = 0;
    long activeVendors = 0;

    long totalInventoryItems = 0;
    long lowStockItems = 0;

    long totalRoutes = 0;

    long totalAuditLogs = 0;

    String vendorPerformance = "0.00";
    String routeScore = "0.00";
    String inventoryValue = "0.00";
    String averageDistance = "0.00";


    if (summary != null) {

        totalShipments =
                summary.getTotalShipments();

        pendingShipments =
                summary.getPendingShipments();

        deliveredShipments =
                summary.getDeliveredShipments();

        cancelledShipments =
                summary.getCancelledShipments();


        totalVendors =
                summary.getTotalVendors();

        activeVendors =
                summary.getActiveVendors();


        totalInventoryItems =
                summary.getTotalInventoryItems();

        lowStockItems =
                summary.getLowStockItems();


        totalRoutes =
                summary.getTotalRoutes();


        totalAuditLogs =
                summary.getTotalAuditLogs();


        if (summary.getAverageVendorPerformance() != null) {

            vendorPerformance =
                    summary
                            .getAverageVendorPerformance()
                            .toString();
        }


        if (summary.getAverageOptimizationScore() != null) {

            routeScore =
                    summary
                            .getAverageOptimizationScore()
                            .toString();
        }


        if (summary.getTotalInventoryValue() != null) {

            inventoryValue =
                    summary
                            .getTotalInventoryValue()
                            .toString();
        }


        if (summary.getAverageDistance() != null) {

            averageDistance =
                    summary
                            .getAverageDistance()
                            .toString();
        }
    }

    long otherShipments =
            Math.max(
                    0,
                    totalShipments
                            - pendingShipments
                            - deliveredShipments
                            - cancelledShipments
            );

    request.setAttribute(
            "activePage",
            "dashboard"
    );
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        GlobalTrade | Admin Dashboard
    </title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/admin/assets/admin-style.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


    <style>

        .dashboard-content {
            padding: 20px 22px 25px;
        }


        .dashboard-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 18px;
        }


        .dashboard-header h1 {
            font-size: 23px;
            color: var(--navy);
            margin-bottom: 5px;
        }


        .dashboard-header p {
            color: var(--muted);
            font-size: 12px;
        }


        .live-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 12px;
            border-radius: 20px;
            background: #EAF7EE;
            color: #218838;
            font-size: 10px;
            font-weight: 700;
        }


        .live-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #28A745;
        }

        .dashboard-kpis {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 14px;
        }


        .dashboard-kpi {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 16px;
            min-height: 125px;
        }


        .dashboard-kpi-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }


        .dashboard-kpi-label {
            color: var(--muted);
            font-size: 10px;
            font-weight: 600;
        }


        .dashboard-kpi-icon {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--soft-yellow);
            color: var(--orange);
            font-size: 14px;
        }


        .dashboard-kpi-number {
            margin-top: 13px;
            font-size: 26px;
            font-weight: 700;
            color: var(--navy);
        }


        .dashboard-kpi-note {
            margin-top: 4px;
            color: var(--muted);
            font-size: 9px;
        }

        .secondary-kpis {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 14px;
        }


        .mini-kpi {
            background: white;
            border: 1px solid var(--border);
            border-radius: 9px;
            padding: 14px;
        }


        .mini-kpi-label {
            font-size: 9px;
            color: var(--muted);
        }


        .mini-kpi-value {
            margin-top: 7px;
            font-size: 19px;
            font-weight: 700;
            color: var(--navy);
        }

        .chart-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 14px;
            margin-bottom: 14px;
        }


        .dashboard-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 16px;
        }


        .dashboard-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }


        .dashboard-card-header h2 {
            font-size: 13px;
            color: var(--navy);
        }


        .dashboard-card-header span {
            font-size: 9px;
            color: var(--muted);
        }


        .chart-container {
            height: 260px;
            position: relative;
        }

        .operational-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }


        .operation-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 11px 0;
            border-bottom: 1px solid var(--border);
        }


        .operation-row:last-child {
            border-bottom: none;
        }


        .operation-label {
            display: flex;
            align-items: center;
            gap: 9px;
            font-size: 10px;
            color: var(--text);
        }


        .operation-icon {
            width: 28px;
            height: 28px;
            border-radius: 7px;
            background: var(--soft-yellow);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--orange);
            font-size: 11px;
        }


        .operation-value {
            font-size: 12px;
            font-weight: 700;
            color: var(--navy);
        }


        .dashboard-error {
            background: #FCE5E5;
            color: #9B1C1C;
            border: 1px solid #F3BABA;
            border-radius: 8px;
            padding: 11px 13px;
            font-size: 10px;
            margin-bottom: 14px;
        }


        .dashboard-footer {
            margin-top: 16px;
            text-align: center;
            color: var(--muted);
            font-size: 9px;
        }

        @media (max-width: 1100px) {

            .dashboard-kpis {
                grid-template-columns: repeat(2, 1fr);
            }

            .secondary-kpis {
                grid-template-columns: repeat(2, 1fr);
            }

            .chart-grid {
                grid-template-columns: 1fr;
            }

            .operational-grid {
                grid-template-columns: 1fr;
            }
        }


        @media (max-width: 650px) {

            .dashboard-content {
                padding: 15px 12px;
            }

            .dashboard-header {
                flex-direction: column;
                gap: 10px;
            }

            .dashboard-kpis,
            .secondary-kpis {
                grid-template-columns: 1fr;
            }
        }

    </style>

</head>


<body>

<jsp:include page="admin-sidebar.jsp"/>

<main class="main">

    <jsp:include page="admin-topbar.jsp"/>

    <section class="dashboard-content">

        <div class="dashboard-header">

            <div>

                <h1>
                    Welcome back, <%= adminName %> 👋
                </h1>

                <p>
                    Live overview of the GlobalTrade supply chain.
                </p>

            </div>


            <div class="live-badge">

                <span class="live-dot"></span>

                LIVE DATA

            </div>

        </div>


        <% if (dashboardError != null) { %>

        <div class="dashboard-error">

            <i class="fa-solid fa-triangle-exclamation"></i>

            <%= dashboardError %>

        </div>

        <% } %>

        <div class="dashboard-kpis">

            <div class="dashboard-kpi">

                <div class="dashboard-kpi-top">

                    <span class="dashboard-kpi-label">
                        Total Shipments
                    </span>

                    <div class="dashboard-kpi-icon">
                        <i class="fa-solid fa-truck-fast"></i>
                    </div>

                </div>

                <div class="dashboard-kpi-number">
                    <%= totalShipments %>
                </div>

                <div class="dashboard-kpi-note">
                    All registered shipments
                </div>

            </div>

            <div class="dashboard-kpi">

                <div class="dashboard-kpi-top">

                    <span class="dashboard-kpi-label">
                        Pending Shipments
                    </span>

                    <div class="dashboard-kpi-icon">
                        <i class="fa-solid fa-clock"></i>
                    </div>

                </div>

                <div class="dashboard-kpi-number">
                    <%= pendingShipments %>
                </div>

                <div class="dashboard-kpi-note">
                    Awaiting completion
                </div>

            </div>

            <div class="dashboard-kpi">

                <div class="dashboard-kpi-top">

                    <span class="dashboard-kpi-label">
                        Delivered
                    </span>

                    <div class="dashboard-kpi-icon">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>

                </div>

                <div class="dashboard-kpi-number">
                    <%= deliveredShipments %>
                </div>

                <div class="dashboard-kpi-note">
                    Successfully delivered
                </div>

            </div>

            <div class="dashboard-kpi">

                <div class="dashboard-kpi-top">

                    <span class="dashboard-kpi-label">
                        Active Alerts
                    </span>

                    <div class="dashboard-kpi-icon">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>

                </div>

                <div class="dashboard-kpi-number">
                    <%= activeAlerts %>
                </div>

                <div class="dashboard-kpi-note">
                    Open supply-chain alerts
                </div>

            </div>

        </div>


        <div class="secondary-kpis">


            <div class="mini-kpi">

                <div class="mini-kpi-label">
                    Total Vendors
                </div>

                <div class="mini-kpi-value">
                    <%= totalVendors %>
                </div>

            </div>


            <div class="mini-kpi">

                <div class="mini-kpi-label">
                    Active Vendors
                </div>

                <div class="mini-kpi-value">
                    <%= activeVendors %>
                </div>

            </div>


            <div class="mini-kpi">

                <div class="mini-kpi-label">
                    Inventory Items
                </div>

                <div class="mini-kpi-value">
                    <%= totalInventoryItems %>
                </div>

            </div>


            <div class="mini-kpi">

                <div class="mini-kpi-label">
                    Low Stock Items
                </div>

                <div class="mini-kpi-value">
                    <%= lowStockItems %>
                </div>

            </div>

        </div>


        <div class="chart-grid">

            <div class="dashboard-card">

                <div class="dashboard-card-header">

                    <h2>
                        Shipment Status Overview
                    </h2>

                    <span>
                        Live database summary
                    </span>

                </div>


                <div class="chart-container">

                    <canvas id="shipmentStatusChart"></canvas>

                </div>

            </div>

            <div class="dashboard-card">

                <div class="dashboard-card-header">

                    <h2>
                        Operational Health
                    </h2>

                    <span>
                        Current
                    </span>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-route"></i>
                        </div>

                        Routes

                    </div>

                    <div class="operation-value">
                        <%= totalRoutes %>
                    </div>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-star"></i>
                        </div>

                        Avg. Route Score

                    </div>

                    <div class="operation-value">
                        <%= routeScore %>
                    </div>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-building"></i>
                        </div>

                        Vendor Performance

                    </div>

                    <div class="operation-value">
                        <%= vendorPerformance %>
                    </div>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-road"></i>
                        </div>

                        Avg. Distance

                    </div>

                    <div class="operation-value">
                        <%= averageDistance %>
                    </div>

                </div>

            </div>

        </div>

        <div class="operational-grid">

            <div class="dashboard-card">

                <div class="dashboard-card-header">

                    <h2>
                        Inventory
                    </h2>

                    <span>
                        Current value
                    </span>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-boxes-stacked"></i>
                        </div>

                        Total Items

                    </div>

                    <div class="operation-value">
                        <%= totalInventoryItems %>
                    </div>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-arrow-trend-down"></i>
                        </div>

                        Low Stock

                    </div>

                    <div class="operation-value">
                        <%= lowStockItems %>
                    </div>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-coins"></i>
                        </div>

                        Inventory Value

                    </div>

                    <div class="operation-value">
                        <%= inventoryValue %>
                    </div>

                </div>

            </div>

            <div class="dashboard-card">

                <div class="dashboard-card-header">

                    <h2>
                        Shipment Operations
                    </h2>

                    <span>
                        Current status
                    </span>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-hourglass-half"></i>
                        </div>

                        Pending

                    </div>

                    <div class="operation-value">
                        <%= pendingShipments %>
                    </div>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>

                        Delivered

                    </div>

                    <div class="operation-value">
                        <%= deliveredShipments %>
                    </div>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-ban"></i>
                        </div>

                        Cancelled

                    </div>

                    <div class="operation-value">
                        <%= cancelledShipments %>
                    </div>

                </div>

            </div>

            <div class="dashboard-card">

                <div class="dashboard-card-header">

                    <h2>
                        System Activity
                    </h2>

                    <span>
                        Recorded operations
                    </span>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-clipboard-list"></i>
                        </div>

                        Audit Logs

                    </div>

                    <div class="operation-value">
                        <%= totalAuditLogs %>
                    </div>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-bell"></i>
                        </div>

                        Active Alerts

                    </div>

                    <div class="operation-value">
                        <%= activeAlerts %>
                    </div>

                </div>


                <div class="operation-row">

                    <div class="operation-label">

                        <div class="operation-icon">
                            <i class="fa-solid fa-route"></i>
                        </div>

                        Route Records

                    </div>

                    <div class="operation-value">
                        <%= totalRoutes %>
                    </div>

                </div>

            </div>

        </div>


        <div class="dashboard-footer">

            GlobalTrade Logistics System · Live operational dashboard

        </div>

    </section>

</main>

<script>

    const shipmentStatusChart =
        document.getElementById(
            "shipmentStatusChart"
        );


    new Chart(
        shipmentStatusChart,
        {
            type: "doughnut",

            data: {

                labels: [
                    "Pending",
                    "Delivered",
                    "Cancelled",
                    "Other"
                ],

                datasets: [
                    {
                        data: [
                            <%= pendingShipments %>,
                            <%= deliveredShipments %>,
                            <%= cancelledShipments %>,
                            <%= otherShipments %>
                        ],

                        backgroundColor: [
                            "#FCBF49",
                            "#003049",
                            "#D62828",
                            "#F77F00"
                        ],

                        borderWidth: 0,

                        hoverOffset: 5
                    }
                ]
            },

            options: {

                responsive: true,

                maintainAspectRatio: false,

                cutout: "68%",

                plugins: {

                    legend: {

                        position: "bottom",

                        labels: {

                            usePointStyle: true,

                            boxWidth: 8,

                            font: {
                                size: 9
                            }
                        }
                    }
                }
            }
        }
    );

</script>


</body>

</html>