<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sasindi.globaltrade.dto.ReportSummary" %>
<%@ page import="java.time.LocalDate" %>
<%
    // =========================================================
// ADMIN SESSION
// =========================================================

    jakarta.servlet.http.HttpSession adminSession =
    request.getSession(false);

//    if (adminSession == null ||
//    adminSession.getAttribute("loggedUser") == null) {
//
//    response.sendRedirect(
//    request.getContextPath() + "/signin"
//    );
//
//    return;
//    }

    String role = String.valueOf(
    adminSession.getAttribute("role")
    );

    if (!"ADMIN".equalsIgnoreCase(role)) {

    response.sendError(
    HttpServletResponse.SC_FORBIDDEN,
    "Access denied."
    );

    return;
    }


// =========================================================
// REPORT SUMMARY
// =========================================================

    ReportSummary reportSummary =
    (ReportSummary) request.getAttribute("reportSummary");

    if (reportSummary == null) {
    reportSummary = new ReportSummary();
    }


// =========================================================
// FILTER VALUES
// =========================================================

    String reportType =
    request.getParameter("reportType");

    String startDate =
    request.getParameter("startDate");

    String endDate =
    request.getParameter("endDate");

    if (reportType == null) {
    reportType = "";
    }

    if (startDate == null) {
    startDate = "";
    }

    if (endDate == null) {
    endDate = "";
    }

    String todayDate =
            LocalDate.now().toString();


// =========================================================
// ERROR MESSAGE
// =========================================================


    String errorMessage =
            (String) request.getAttribute("errorMessage");

    if (errorMessage == null) {

        errorMessage =
                (String) adminSession.getAttribute("reportError");

        adminSession.removeAttribute("reportError");
    }



// =========================================================
// REPORT VALUES
// =========================================================

    long totalShipments =
    reportSummary.getTotalShipments();

    long pendingShipments =
    reportSummary.getPendingShipments();

    long deliveredShipments =
    reportSummary.getDeliveredShipments();

    long cancelledShipments =
    reportSummary.getCancelledShipments();

    long totalVendors =
    reportSummary.getTotalVendors();

    long activeVendors =
    reportSummary.getActiveVendors();

    long totalInventoryItems =
    reportSummary.getTotalInventoryItems();

    long lowStockItems =
    reportSummary.getLowStockItems();

    long totalRoutes =
    reportSummary.getTotalRoutes();

    long highScoreRoutes =
    reportSummary.getHighScoreRoutes();

    long totalAuditLogs =
    reportSummary.getTotalAuditLogs();

    long createAuditLogs =
    reportSummary.getCreateAuditLogs();

    long updateAuditLogs =
    reportSummary.getUpdateAuditLogs();

    long deleteAuditLogs =
    reportSummary.getDeleteAuditLogs();


// =========================================================
// DECIMAL VALUES
// =========================================================

    String averageVendorPerformance =
    reportSummary.getAverageVendorPerformance() != null
    ? reportSummary.getAverageVendorPerformance().toString()
    : "0.00";

    String totalInventoryValue =
    reportSummary.getTotalInventoryValue() != null
    ? reportSummary.getTotalInventoryValue().toString()
    : "0.00";

    String averageOptimizationScore =
    reportSummary.getAverageOptimizationScore() != null
    ? reportSummary.getAverageOptimizationScore().toString()
    : "0.00";

    String averageDistance =
    reportSummary.getAverageDistance() != null
    ? reportSummary.getAverageDistance().toString()
    : "0.00";


// =========================================================
// SELECTED REPORT TITLE
// =========================================================

    String selectedReportTitle = "Operational Summary";

    if ("SHIPMENT".equalsIgnoreCase(reportType)) {

    selectedReportTitle = "Shipment Report";

    } else if ("INVENTORY".equalsIgnoreCase(reportType)) {

    selectedReportTitle = "Inventory Report";

    } else if ("VENDOR".equalsIgnoreCase(reportType)) {

    selectedReportTitle = "Vendor Performance Report";

    } else if ("ROUTE".equalsIgnoreCase(reportType)) {

    selectedReportTitle = "Route Optimization Report";

    } else if ("ALERT".equalsIgnoreCase(reportType)) {

    selectedReportTitle = "Alert & Exception Report";

    } else if ("AUDIT".equalsIgnoreCase(reportType)) {

    selectedReportTitle = "Audit & Compliance Report";

    } else if ("PERFORMANCE".equalsIgnoreCase(reportType)) {

    selectedReportTitle = "System Performance Report";
    }


%>

<!DOCTYPE html>

<html lang="en">

<head>


    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Reports | GlobalTrade
    </title>


    <!-- =========================================================
         FONT AWESOME
         ========================================================= -->

    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- =========================================================
         GOOGLE FONT
         ========================================================= -->

    <link
            rel="preconnect"
            href="https://fonts.googleapis.com">

    <link
            rel="preconnect"
            href="https://fonts.gstatic.com"
            crossorigin>

    <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
            rel="stylesheet">


    <style>

        /* =========================================================
           ROOT
           ========================================================= */

        :root {

            --navy: #003049;

            --yellow: #FCBF49;

            --orange: #F77F00;

            --red: #D62828;

            --green: #28A745;

            --blue: #2563EB;

            --purple: #7C3AED;

            --teal: #0F766E;

            --background: #FFF9E8;

            --card: #FFFFFF;

            --text: #003049;

            --muted: #64748B;

            --border: rgba(0,48,73,.10);

            --soft-yellow: #FFF3CD;

            --sidebar-width: 250px;
        }


        /* =========================================================
           RESET
           ========================================================= */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        html {
            scroll-behavior: smooth;
        }


        body {

            font-family:
                    "Inter",
                    "Segoe UI",
                    Arial,
                    sans-serif;

            background: var(--background);

            color: var(--text);

            min-height: 100vh;
        }


        a {
            text-decoration: none;
            color: inherit;
        }


        button,
        input,
        select {
            font-family: inherit;
        }


        /* =========================================================
           SIDEBAR
           ========================================================= */

        .sidebar {

            position: fixed;

            top: 0;
            left: 0;
            bottom: 0;

            width: var(--sidebar-width);

            background: var(--navy);

            color: white;

            display: flex;

            flex-direction: column;

            z-index: 1000;

            overflow-y: auto;

            box-shadow:
                    2px 0 10px
                    rgba(0,0,0,.08);
        }


        .brand {

            height: 75px;

            display: flex;

            align-items: center;

            padding: 0 18px;

            gap: 10px;

            border-bottom:
                    1px solid
                    rgba(255,255,255,.08);

            flex-shrink: 0;
        }


        .brand-logo {

            width: 38px;
            height: 38px;

            border-radius: 9px;

            background: var(--orange);

            color: white;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 17px;

            flex-shrink: 0;
        }


        .brand-copy {

            display: flex;

            flex-direction: column;

            min-width: 0;
        }


        .brand-title {

            color: white;

            font-size: 16px;

            font-weight: 700;

            line-height: 1.2;
        }


        .brand-subtitle {

            color:
                    rgba(255,255,255,.65);

            font-size: 9px;

            margin-top: 3px;
        }


        .nav {

            flex: 1;

            padding: 12px 10px;

            overflow-y: auto;
        }


        .nav-item {

            height: 39px;

            display: flex;

            align-items: center;

            gap: 11px;

            padding: 0 11px;

            margin-bottom: 3px;

            border-radius: 7px;

            color:
                    rgba(255,255,255,.75);

            font-size: 11px;

            font-weight: 500;

            transition: .2s ease;

            white-space: nowrap;
        }


        .nav-item i:first-child {

            width: 17px;

            text-align: center;

            font-size: 13px;

            flex-shrink: 0;
        }


        .nav-item span {

            overflow: hidden;

            text-overflow: ellipsis;
        }


        .nav-item .chevron {

            margin-left: auto;

            font-size: 8px;

            opacity: .7;
        }


        .nav-item:hover {

            background:
                    rgba(255,255,255,.08);

            color: white;
        }


        .nav-item.active {

            background: var(--orange);

            color: white;

            font-weight: 600;
        }

        .sidebar::-webkit-scrollbar,
        .nav::-webkit-scrollbar {

            width: 4px;
        }


        .sidebar::-webkit-scrollbar-thumb,
        .nav::-webkit-scrollbar-thumb {

            background: rgba(255,255,255,.2);

            border-radius: 5px;
        }

        .profile-mini {

            padding: 12px;

            border-top:
                    1px solid
                    rgba(255,255,255,.08);

            display: flex;

            align-items: center;

            gap: 10px;

            background:
                    rgba(0,0,0,.08);

            flex-shrink: 0;
        }


        .avatar {

            width: 35px;
            height: 35px;

            border-radius: 50%;

            background: var(--soft-yellow);

            color: var(--orange);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 13px;

            flex-shrink: 0;
        }


        .profile-copy {

            min-width: 0;

            flex: 1;
        }


        .profile-copy .profile-name {

            color: white;

            font-size: 10px;

            font-weight: 600;

            margin-bottom: 4px;
        }


        .profile-link {

            display: flex;

            align-items: center;

            gap: 6px;

            color:
                    rgba(255,255,255,.65);

            font-size: 9px;
        }


        .profile-link:hover {
            color: white;
        }


        /* =========================================================
           MAIN
           ========================================================= */

        .main {

            margin-left: var(--sidebar-width);

            min-height: 100vh;
        }


        /* =========================================================
           TOPBAR
           ========================================================= */

        .topbar {

            height: 65px;

            display: flex;

            align-items: center;

            padding: 0 22px;

            background: var(--card);

            border-bottom:
                    1px solid
                    var(--border);

            gap: 15px;

            position: relative;

            z-index: 900;
        }


        .menu-btn {

            width: 35px;
            height: 35px;

            border: none;

            background: transparent;

            color: var(--navy);

            font-size: 19px;

            cursor: pointer;

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .menu-btn:hover {
            color: var(--orange);
        }


        .search {

            width: 285px;

            height: 35px;

            display: flex;

            align-items: center;

            gap: 9px;

            padding: 0 11px;

            background: var(--card);

            border:
                    1px solid
                    #F8E4A9;

            border-radius: 7px;

            color: var(--muted);
        }


        .search:focus-within {

            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px
                    rgba(252,191,73,.12);
        }


        .search i {
            font-size: 13px;
        }


        .search input {

            width: 100%;
            height: 100%;

            border: none;

            outline: none;

            background: transparent;

            color: var(--navy);

            font-size: 11px;
        }


        .top-actions {

            margin-left: auto;

            display: flex;

            align-items: center;

            gap: 16px;
        }


        .icon-btn {

            position: relative;

            border: none;

            background: transparent;

            color: var(--navy);

            font-size: 16px;

            cursor: pointer;

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .icon-btn:hover {
            color: var(--orange);
        }


        .top-user {

            display: flex;

            align-items: center;

            gap: 8px;

            color: var(--navy);

            font-size: 12px;

            font-weight: 600;

            white-space: nowrap;
        }


        .top-user:hover {
            color: var(--orange);
        }


        .top-avatar {

            width: 33px;
            height: 33px;

            border-radius: 50%;

            background: var(--soft-yellow);

            color: var(--orange);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 14px;

            font-weight: 700;
        }


        /* =========================================================
           CONTENT
           ========================================================= */

        .content {

            padding: 20px 25px 25px;
        }


        .page-heading {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 17px;
        }


        .page-heading h1 {

            color: var(--navy);

            font-size: 24px;

            font-weight: 700;

            letter-spacing: -.5px;
        }


        .page-heading p {

            margin-top: 4px;

            font-size: 12px;

            color: var(--muted);
        }


        /* =========================================================
           ALERT
           ========================================================= */

        .alert {

            padding: 10px 13px;

            border-radius: 7px;

            margin-bottom: 14px;

            display: flex;

            align-items: center;

            gap: 8px;

            font-size: 9px;

            font-weight: 600;
        }


        .alert-error {

            background: #FEF0F0;

            color: var(--red);
        }


        /* =========================================================
           SUMMARY CARDS
           ========================================================= */

        .stats-grid {

            display: grid;

            grid-template-columns:
                repeat(4,1fr);

            gap: 12px;

            margin-bottom: 15px;
        }


        .stat-card {

            background: var(--card);

            border:
                    1px solid
                    var(--border);

            border-radius: 11px;

            padding: 15px;

            min-height: 85px;

            display: flex;

            align-items: center;
        }


        .stat-top {

            width: 100%;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 10px;
        }


        .stat-label {

            display: block;

            color: var(--muted);

            font-size: 8px;

            font-weight: 600;

            margin-bottom: 6px;

            text-transform: uppercase;

            letter-spacing: .3px;
        }


        .stat-value {

            color: var(--navy);

            font-size: 20px;

            font-weight: 800;
        }


        .stat-icon {

            width: 36px;
            height: 36px;

            border-radius: 9px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                    rgba(252,191,73,.20);

            color: var(--orange);

            font-size: 14px;

            flex-shrink: 0;
        }


        /* =========================================================
           REPORT GENERATOR
           ========================================================= */

        .report-generator {

            background: var(--card);

            border:
                    1px solid
                    var(--border);

            border-radius: 10px;

            box-shadow:
                    0 5px 20px
                    rgba(0,0,0,.05);

            margin-bottom: 15px;

            overflow: hidden;
        }


        .panel-header {

            padding: 15px 16px;

            display: flex;

            justify-content: space-between;

            align-items: center;

            border-bottom:
                    1px solid
                    var(--border);
        }


        .panel-header h2 {

            font-size: 13px;

            color: var(--navy);

            font-weight: 700;
        }


        .panel-header p {

            font-size: 8px;

            color: var(--muted);

            margin-top: 3px;
        }


        .generator-body {
            padding: 16px;
        }


        .filter-grid {

            display: grid;

            grid-template-columns:
                1.5fr
                1fr
                1fr
                auto;

            gap: 10px;

            align-items: end;
        }


        .field {

            display: flex;

            flex-direction: column;

            gap: 5px;
        }


        .field label {

            color: var(--muted);

            font-size: 8px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: .3px;
        }


        .field select,
        .field input {

            height: 36px;

            padding: 0 10px;

            border:
                    1px solid
                    var(--border);

            border-radius: 7px;

            background: white;

            color: var(--navy);

            outline: none;

            font-size: 9px;
        }


        .field select:focus,
        .field input:focus {

            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px
                    rgba(252,191,73,.10);
        }


        .generate-btn {

            height: 36px;

            padding: 0 15px;

            border: none;

            border-radius: 7px;

            background: var(--yellow);

            color: var(--navy);

            font-size: 9px;

            font-weight: 700;

            cursor: pointer;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 6px;

            transition: .2s ease;
        }


        .generate-btn:hover {

            background: var(--orange);

            color: white;
        }


        /* =========================================================
           SELECTED REPORT
           ========================================================= */

        .selected-report {

            margin-bottom: 15px;

            background: var(--card);

            border:
                    1px solid
                    var(--border);

            border-radius: 10px;

            overflow: hidden;

            box-shadow:
                    0 5px 20px
                    rgba(0,0,0,.05);
        }


        .selected-header {

            padding: 14px 16px;

            background: #FFFDF5;

            border-bottom:
                    1px solid
                    var(--border);

            display: flex;

            align-items: center;

            gap: 10px;
        }


        .selected-header-icon {

            width: 32px;
            height: 32px;

            border-radius: 8px;

            background:
                    rgba(252,191,73,.20);

            color: var(--orange);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 12px;
        }


        .selected-header h2 {

            color: var(--navy);

            font-size: 12px;

            font-weight: 700;
        }


        .selected-header p {

            margin-top: 3px;

            color: var(--muted);

            font-size: 8px;
        }


        .selected-body {

            padding: 15px 16px;

            display: grid;

            grid-template-columns:
                repeat(4,1fr);

            gap: 10px;
        }


        .metric {

            padding: 12px;

            border:
                    1px solid
                    var(--border);

            border-radius: 8px;

            background: #FFFEFA;
        }


        .metric-label {

            display: block;

            color: var(--muted);

            font-size: 7px;

            text-transform: uppercase;

            font-weight: 700;

            letter-spacing: .3px;

            margin-bottom: 5px;
        }


        .metric-value {

            color: var(--navy);

            font-size: 17px;

            font-weight: 800;
        }


        .metric-description {

            margin-top: 3px;

            color: var(--muted);

            font-size: 7px;
        }


        /* =========================================================
           QUICK REPORTS
           ========================================================= */

        .quick-reports {
            margin-bottom: 15px;
        }


        .section-heading {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 10px;
        }


        .section-heading h2 {

            font-size: 13px;

            color: var(--navy);

            font-weight: 700;
        }


        .section-heading p {

            font-size: 8px;

            color: var(--muted);
        }


        .report-grid {

            display: grid;

            grid-template-columns:
                repeat(4,1fr);

            gap: 12px;
        }


        .report-card {

            background: var(--card);

            border:
                    1px solid
                    var(--border);

            border-radius: 10px;

            padding: 15px;

            min-height: 145px;

            display: flex;

            flex-direction: column;

            transition:
                    transform .2s ease,
                    box-shadow .2s ease,
                    border-color .2s ease;

            overflow: hidden;
        }


        .report-card:hover {

            transform:
                    translateY(-2px);

            box-shadow:
                    0 7px 20px
                    rgba(0,0,0,.07);

            border-color:
                    rgba(252,191,73,.50);
        }


        .report-icon {

            width: 38px;
            height: 38px;

            border-radius: 9px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                    rgba(252,191,73,.20);

            color: var(--orange);

            font-size: 15px;

            margin-bottom: 11px;
        }


        .report-card h3 {

            font-size: 11px;

            color: var(--navy);

            font-weight: 700;

            margin-bottom: 5px;
        }


        .report-card p {

            font-size: 8px;

            color: var(--muted);

            line-height: 1.5;

            flex: 1;
        }


        .report-link {

            margin-top: 12px;

            display: inline-flex;

            align-items: center;

            gap: 5px;

            color: var(--orange);

            font-size: 8px;

            font-weight: 700;

            width: fit-content;
        }


        .report-link:hover {
            color: var(--navy);
        }

        .report-link {

            border: none;

            background: transparent;

            padding: 0;

            font-family: inherit;

            cursor: pointer;
        }

        .report-link i {

            transition: transform .2s ease;
        }

        .report-link:hover i {

            transform: translateX(2px);
        }
        .report-card.shipment .report-icon {

            background:
                    rgba(37,99,235,.10);

            color: var(--blue);
        }


        .report-card.inventory .report-icon {

            background:
                    rgba(40,167,69,.10);

            color: var(--green);
        }


        .report-card.vendor .report-icon {

            background:
                    rgba(124,58,237,.10);

            color: var(--purple);
        }


        .report-card.route .report-icon {

            background:
                    rgba(15,118,110,.10);

            color: var(--teal);
        }


        .report-card.alerts .report-icon {

            background:
                    rgba(214,40,40,.10);

            color: var(--red);
        }


        .report-card.audit .report-icon {

            background:
                    rgba(252,191,73,.20);

            color: #946200;
        }


        .report-card.performance .report-icon {

            background:
                    rgba(37,99,235,.10);

            color: var(--blue);
        }


        /* =========================================================
           REPORT DETAILS
           ========================================================= */

        .details-panel {

            background: var(--card);

            border:
                    1px solid
                    var(--border);

            border-radius: 10px;

            overflow: hidden;

            box-shadow:
                    0 5px 20px
                    rgba(0,0,0,.05);

            margin-bottom: 15px;
        }


        .details-grid {

            padding: 15px 16px;

            display: grid;

            grid-template-columns:
                repeat(4,1fr);

            gap: 10px;
        }


        .detail-card {

            padding: 13px;

            border:
                    1px solid
                    var(--border);

            border-radius: 8px;

            background: #FFFEFA;
        }


        .detail-card h3 {

            color: var(--navy);

            font-size: 9px;

            font-weight: 700;

            margin-bottom: 8px;
        }


        .detail-row {

            display: flex;

            justify-content: space-between;

            align-items: center;

            gap: 8px;

            padding: 5px 0;

            border-bottom:
                    1px solid
                    rgba(0,48,73,.05);
        }


        .detail-row:last-child {
            border-bottom: none;
        }


        .detail-row span:first-child {

            color: var(--muted);

            font-size: 7px;
        }


        .detail-row span:last-child {

            color: var(--navy);

            font-size: 8px;

            font-weight: 700;

            text-align: right;
        }


        /* =========================================================
           NOTICE
           ========================================================= */

        .report-notice {

            background: #FFFDF5;

            border:
                    1px solid
                    rgba(252,191,73,.35);

            border-radius: 8px;

            padding: 11px 13px;

            display: flex;

            align-items: flex-start;

            gap: 9px;
        }


        .report-notice i {

            color: var(--orange);

            font-size: 12px;

            margin-top: 1px;
        }


        .report-notice strong {

            display: block;

            color: var(--navy);

            font-size: 9px;

            margin-bottom: 3px;
        }


        .report-notice span {

            color: var(--muted);

            font-size: 8px;

            line-height: 1.5;
        }


        /* =========================================================
           RESPONSIVE
           ========================================================= */

        @media (max-width: 1250px) {

            .report-grid {

                grid-template-columns:
                    repeat(3,1fr);
            }
        }


        @media (max-width: 1100px) {

            .filter-grid {

                grid-template-columns:
                    repeat(2,1fr);
            }

            .generate-btn {
                width: 100%;
            }

            .selected-body,
            .details-grid {

                grid-template-columns:
                    repeat(2,1fr);
            }
        }


        @media (max-width: 1000px) {

            .report-grid {

                grid-template-columns:
                    repeat(2,1fr);
            }

            .stats-grid {

                grid-template-columns:
                    repeat(2,1fr);
            }
        }


        @media (max-width: 900px) {

            .sidebar {
                width: 70px;
            }

            .brand-copy,
            .nav-item span,
            .nav-item .chevron,
            .profile-copy {
                display: none;
            }

            .brand {

                justify-content: center;

                padding: 0;
            }

            .nav-item {

                justify-content: center;

                padding: 0;
            }

            .nav-item i:first-child {
                width: auto;
            }

            .main {
                margin-left: 70px;
            }

            .content {
                padding: 18px 15px;
            }
        }


        @media (max-width: 650px) {

            .main {
                margin-left: 0;
            }

            .sidebar {
                display: none;
            }

            .content {
                padding: 15px 12px;
            }

            .stats-grid,
            .report-grid,
            .selected-body,
            .details-grid,
            .filter-grid {

                grid-template-columns: 1fr;
            }

            .page-heading {

                align-items: flex-start;

                flex-direction: column;
            }

            .search {
                width: 200px;
            }
        }


        @media (max-width: 450px) {

            .search {
                display: none;
            }

            .top-actions {
                gap: 10px;
            }
        }

    </style>


</head>

<body>

<!-- =========================================================
     SIDEBAR
     ========================================================= -->

<jsp:include page="admin-sidebar.jsp"/>

<!-- =========================================================
     MAIN
     ========================================================= -->

<main class="main">


    <!-- =====================================================
         TOPBAR
         ===================================================== -->

    <jsp:include page="admin-topbar.jsp"/>


    <!-- =====================================================
         CONTENT
         ===================================================== -->

    <section class="content">


        <!-- =================================================
             PAGE HEADING
             ================================================= -->

        <div class="page-heading">

            <div>

                <h1>
                    Reports
                </h1>

                <p>
                    Generate, analyse and monitor GlobalTrade
                    operational reports.
                </p>

            </div>

        </div>


        <!-- =================================================
             ERROR
             ================================================= -->

        <% if (errorMessage != null &&
            !errorMessage.trim().isEmpty()) { %>

        <div class="alert alert-error">

            <i class="fa-solid fa-circle-exclamation"></i>

            <span>
            <%=errorMessage%>
        </span>

        </div>

        <% } %>


        <!-- =================================================
             SUMMARY STATISTICS
             ================================================= -->

        <div class="stats-grid">


            <!-- TOTAL SHIPMENTS -->

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                    <span class="stat-label">
                        Total Shipments
                    </span>

                        <div class="stat-value">
                            <%=totalShipments%>
                        </div>

                    </div>

                    <div class="stat-icon">

                        <i class="fa-solid fa-truck-fast"></i>

                    </div>

                </div>

            </div>


            <!-- INVENTORY -->

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                    <span class="stat-label">
                        Inventory Items
                    </span>

                        <div class="stat-value">
                            <%=totalInventoryItems%>
                        </div>

                    </div>

                    <div class="stat-icon">

                        <i class="fa-solid fa-boxes-stacked"></i>

                    </div>

                </div>

            </div>


            <!-- VENDORS -->

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                    <span class="stat-label">
                        Total Vendors
                    </span>

                        <div class="stat-value">
                            <%=totalVendors%>
                        </div>

                    </div>

                    <div class="stat-icon">

                        <i class="fa-solid fa-building"></i>

                    </div>

                </div>

            </div>


            <!-- ROUTES -->

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                    <span class="stat-label">
                        Optimized Routes
                    </span>

                        <div class="stat-value">
                            <%=totalRoutes%>
                        </div>

                    </div>

                    <div class="stat-icon">

                        <i class="fa-solid fa-route"></i>

                    </div>

                </div>

            </div>


        </div>


        <!-- =================================================
             REPORT GENERATOR
             ================================================= -->

        <div class="report-generator">


            <div class="panel-header">

                <div>

                    <h2>
                        Report Generator
                    </h2>

                    <p>
                        Select a report category and optional
                        reporting period.
                    </p>

                </div>

            </div>


            <div class="generator-body">


                <form
                        method="post"
                        action="<%=request.getContextPath()%>/reports"
                        id="reportForm"
                        target="_blank">


                    <div class="filter-grid">


                        <!-- REPORT TYPE -->

                        <div class="field">

                            <label for="reportType">
                                Report Type
                            </label>

                            <select
                                    id="reportType"
                                    name="reportType">

                                <option
                                        value=""
                                        <%=reportType.isEmpty()
                                            ? "selected"
                                            : ""%>>

                                    Operational Summary

                                </option>

                                <option
                                        value="SHIPMENT"
                                        <%="SHIPMENT".equalsIgnoreCase(reportType)
                                            ? "selected"
                                            : ""%>>

                                    Shipment Report

                                </option>

                                <option
                                        value="INVENTORY"
                                        <%="INVENTORY".equalsIgnoreCase(reportType)
                                            ? "selected"
                                            : ""%>>

                                    Inventory Report

                                </option>

                                <option
                                        value="VENDOR"
                                        <%="VENDOR".equalsIgnoreCase(reportType)
                                            ? "selected"
                                            : ""%>>

                                    Vendor Performance Report

                                </option>

                                <option
                                        value="ROUTE"
                                        <%="ROUTE".equalsIgnoreCase(reportType)
                                            ? "selected"
                                            : ""%>>

                                    Route Optimization Report

                                </option>

                                <option
                                        value="ALERT"
                                        <%="ALERT".equalsIgnoreCase(reportType)
                                            ? "selected"
                                            : ""%>>

                                    Alert & Exception Report

                                </option>

                                <option
                                        value="AUDIT"
                                        <%="AUDIT".equalsIgnoreCase(reportType)
                                            ? "selected"
                                            : ""%>>

                                    Audit & Compliance Report

                                </option>

                                <option
                                        value="PERFORMANCE"
                                        <%="PERFORMANCE".equalsIgnoreCase(reportType)
                                            ? "selected"
                                            : ""%>>

                                    System Performance Report

                                </option>

                            </select>

                        </div>


                        <!-- START DATE -->

                        <div class="field">

                            <label for="startDate">
                                Start Date
                            </label>

                            <input
                                    type="date"
                                    id="startDate"
                                    name="startDate"
                                    value="<%=startDate%>">

                        </div>


                        <!-- END DATE -->

                        <div class="field">

                            <label for="endDate">
                                End Date
                            </label>

                            <input
                                    type="date"
                                    id="endDate"
                                    name="endDate"
                                    value="<%=endDate%>">

                        </div>


                        <!-- GENERATE -->

                        <div class="field">

                            <label>
                                &nbsp;
                            </label>

                            <button
                                    type="submit"
                                    class="generate-btn">

                                <i class="fa-solid fa-chart-column"></i>

                                Generate Report

                            </button>

                        </div>


                    </div>


                </form>

            </div>

        </div>


        <!-- =================================================
             SELECTED REPORT
             ================================================= -->

        <div class="selected-report">


            <div class="selected-header">

                <div class="selected-header-icon">

                    <i class="fa-solid fa-chart-pie"></i>

                </div>

                <div>

                    <h2>
                        <%=selectedReportTitle%>
                    </h2>

                    <p>
                        Current information calculated from
                        the GlobalTrade database.
                    </p>

                </div>

            </div>


            <div class="selected-body">


                <!-- SHIPMENTS -->

                <div class="metric">

                <span class="metric-label">
                    Total Shipments
                </span>

                    <div class="metric-value">
                        <%=totalShipments%>
                    </div>

                    <div class="metric-description">
                        All recorded shipments
                    </div>

                </div>


                <!-- DELIVERED -->

                <div class="metric">

                <span class="metric-label">
                    Delivered
                </span>

                    <div class="metric-value">
                        <%=deliveredShipments%>
                    </div>

                    <div class="metric-description">
                        Completed deliveries
                    </div>

                </div>


                <!-- PENDING -->

                <div class="metric">

                <span class="metric-label">
                    Pending
                </span>

                    <div class="metric-value">
                        <%=pendingShipments%>
                    </div>

                    <div class="metric-description">
                        Shipments awaiting completion
                    </div>

                </div>


                <!-- CANCELLED -->

                <div class="metric">

                <span class="metric-label">
                    Cancelled
                </span>

                    <div class="metric-value">
                        <%=cancelledShipments%>
                    </div>

                    <div class="metric-description">
                        Cancelled shipments
                    </div>

                </div>


            </div>

        </div>


        <!-- =================================================
             QUICK REPORTS
             ================================================= -->

        <!-- =================================================
       QUICK REPORTS
       ================================================= -->

        <div class="quick-reports">


            <div class="section-heading">

                <div>

                    <h2>
                        Quick Reports
                    </h2>

                    <p>
                        Generate frequently used operational reports instantly
                    </p>

                </div>

            </div>


            <div class="report-grid">


                <!-- =================================================
                     TODAY'S SHIPMENTS
                     ================================================= -->

                <div class="report-card shipment">

                    <div class="report-icon">

                        <i class="fa-solid fa-truck"></i>

                    </div>

                    <h3>
                        Today's Shipments
                    </h3>

                    <p>
                        Generate today's shipment activity including
                        pending, delivered and cancelled shipments.
                    </p>

                    <form
                            method="post"
                            action="<%=request.getContextPath()%>/reports"
                            target="_blank">

                        <input
                                type="hidden"
                                name="reportType"
                                value="SHIPMENT">

                        <input
                                type="hidden"
                                name="startDate"
                                value="<%=todayDate%>">

                        <input
                                type="hidden"
                                name="endDate"
                                value="<%=todayDate%>">

                        <button
                                type="submit"
                                class="report-link"
                                style="border:none;background:none;padding:0;cursor:pointer;">

                            Generate PDF

                            <i class="fa-solid fa-file-pdf"></i>

                        </button>

                    </form>

                </div>


                <!-- =================================================
                     INVENTORY STATUS
                     ================================================= -->

                <div class="report-card inventory">

                    <div class="report-icon">

                        <i class="fa-solid fa-boxes-stacked"></i>

                    </div>

                    <h3>
                        Inventory Status
                    </h3>

                    <p>
                        Generate the current inventory report including
                        stock quantities, low-stock items and inventory value.
                    </p>

                    <form
                            method="post"
                            action="<%=request.getContextPath()%>/reports"
                            target="_blank">

                        <input
                                type="hidden"
                                name="reportType"
                                value="INVENTORY">

                        <input
                                type="hidden"
                                name="startDate"
                                value="<%=todayDate%>">

                        <input
                                type="hidden"
                                name="endDate"
                                value="<%=todayDate%>">

                        <button
                                type="submit"
                                class="report-link"
                                style="border:none;background:none;padding:0;cursor:pointer;">

                            Generate PDF

                            <i class="fa-solid fa-file-pdf"></i>

                        </button>

                    </form>

                </div>


                <!-- =================================================
                     VENDOR PERFORMANCE
                     ================================================= -->

                <div class="report-card vendor">

                    <div class="report-icon">

                        <i class="fa-solid fa-building"></i>

                    </div>

                    <h3>
                        Vendor Performance
                    </h3>

                    <p>
                        Generate the current vendor performance report
                        including vendor count and average performance.
                    </p>

                    <form
                            method="post"
                            action="<%=request.getContextPath()%>/reports"
                            target="_blank">

                        <input
                                type="hidden"
                                name="reportType"
                                value="VENDOR">

                        <input
                                type="hidden"
                                name="startDate"
                                value="<%=todayDate%>">

                        <input
                                type="hidden"
                                name="endDate"
                                value="<%=todayDate%>">

                        <button
                                type="submit"
                                class="report-link"
                                style="border:none;background:none;padding:0;cursor:pointer;">

                            Generate PDF

                            <i class="fa-solid fa-file-pdf"></i>

                        </button>

                    </form>

                </div>


                <!-- =================================================
                     ROUTE OPTIMIZATION
                     ================================================= -->

                <div class="report-card route">

                    <div class="report-icon">

                        <i class="fa-solid fa-route"></i>

                    </div>

                    <h3>
                        Route Optimization
                    </h3>

                    <p>
                        Generate the current route optimization report
                        including scores, high-score routes and distance.
                    </p>

                    <form
                            method="post"
                            action="<%=request.getContextPath()%>/reports"
                            target="_blank">

                        <input
                                type="hidden"
                                name="reportType"
                                value="ROUTE">

                        <input
                                type="hidden"
                                name="startDate"
                                value="<%=todayDate%>">

                        <input
                                type="hidden"
                                name="endDate"
                                value="<%=todayDate%>">

                        <button
                                type="submit"
                                class="report-link"
                                style="border:none;background:none;padding:0;cursor:pointer;">

                            Generate PDF

                            <i class="fa-solid fa-file-pdf"></i>

                        </button>

                    </form>

                </div>


                <!-- =================================================
                     ALERTS SUMMARY
                     ================================================= -->

                <div class="report-card alerts">

                    <div class="report-icon">

                        <i class="fa-solid fa-triangle-exclamation"></i>

                    </div>

                    <h3>
                        Today's Alerts
                    </h3>

                    <p>
                        Generate today's alert report covering shipment
                        conditions and inventory items requiring attention.
                    </p>

                    <form
                            method="post"
                            action="<%=request.getContextPath()%>/reports"
                            target="_blank">

                        <input
                                type="hidden"
                                name="reportType"
                                value="ALERT">

                        <input
                                type="hidden"
                                name="startDate"
                                value="<%=todayDate%>">

                        <input
                                type="hidden"
                                name="endDate"
                                value="<%=todayDate%>">

                        <button
                                type="submit"
                                class="report-link"
                                style="border:none;background:none;padding:0;cursor:pointer;">

                            Generate PDF

                            <i class="fa-solid fa-file-pdf"></i>

                        </button>

                    </form>

                </div>


                <!-- =================================================
                     TODAY'S AUDIT ACTIVITY
                     ================================================= -->

                <div class="report-card audit">

                    <div class="report-icon">

                        <i class="fa-solid fa-shield-halved"></i>

                    </div>

                    <h3>
                        Today's Audit Activity
                    </h3>

                    <p>
                        Generate today's audit activity including
                        create, update and delete operations.
                    </p>

                    <form
                            method="post"
                            action="<%=request.getContextPath()%>/reports"
                            target="_blank">

                        <input
                                type="hidden"
                                name="reportType"
                                value="AUDIT">

                        <input
                                type="hidden"
                                name="startDate"
                                value="<%=todayDate%>">

                        <input
                                type="hidden"
                                name="endDate"
                                value="<%=todayDate%>">

                        <button
                                type="submit"
                                class="report-link"
                                style="border:none;background:none;padding:0;cursor:pointer;">

                            Generate PDF

                            <i class="fa-solid fa-file-pdf"></i>

                        </button>

                    </form>

                </div>


                <!-- =================================================
                     SYSTEM PERFORMANCE
                     ================================================= -->

                <div class="report-card performance">

                    <div class="report-icon">

                        <i class="fa-solid fa-gauge-high"></i>

                    </div>

                    <h3>
                        System Performance
                    </h3>

                    <p>
                        Review vendor performance and route optimization
                        measurements from the current operational data.
                    </p>

                    <a
                            class="report-link"
                            href="<%=request.getContextPath()%>/reports?reportType=PERFORMANCE">

                        View Report

                        <i class="fa-solid fa-arrow-right"></i>

                    </a>

                </div>


            </div>

        </div>


        <!-- =================================================
             REPORT DETAILS
             ================================================= -->

        <div class="details-panel">


            <div class="panel-header">

                <div>

                    <h2>
                        Report Insights
                    </h2>

                    <p>
                        Detailed indicators calculated by the
                        ReportServiceBean.
                    </p>

                </div>

            </div>


            <div class="details-grid">


                <!-- SHIPMENT -->

                <div class="detail-card">

                    <h3>
                        Shipment Performance
                    </h3>

                    <div class="detail-row">

                    <span>
                        Total
                    </span>

                        <span>
                        <%=totalShipments%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Delivered
                    </span>

                        <span>
                        <%=deliveredShipments%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Pending
                    </span>

                        <span>
                        <%=pendingShipments%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Cancelled
                    </span>

                        <span>
                        <%=cancelledShipments%>
                    </span>

                    </div>

                </div>


                <!-- INVENTORY -->

                <div class="detail-card">

                    <h3>
                        Inventory Analysis
                    </h3>

                    <div class="detail-row">

                    <span>
                        Items
                    </span>

                        <span>
                        <%=totalInventoryItems%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Low Stock
                    </span>

                        <span>
                        <%=lowStockItems%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Inventory Value
                    </span>

                        <span>
                        <%=totalInventoryValue%>
                    </span>

                    </div>

                </div>


                <!-- VENDOR -->

                <div class="detail-card">

                    <h3>
                        Vendor Analysis
                    </h3>

                    <div class="detail-row">

                    <span>
                        Total Vendors
                    </span>

                        <span>
                        <%=totalVendors%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Active Vendors
                    </span>

                        <span>
                        <%=activeVendors%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Avg. Performance
                    </span>

                        <span>
                        <%=averageVendorPerformance%>
                    </span>

                    </div>

                </div>


                <!-- ROUTES -->

                <div class="detail-card">

                    <h3>
                        Route Analysis
                    </h3>

                    <div class="detail-row">

                    <span>
                        Total Routes
                    </span>

                        <span>
                        <%=totalRoutes%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        High Score
                    </span>

                        <span>
                        <%=highScoreRoutes%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Avg. Score
                    </span>

                        <span>
                        <%=averageOptimizationScore%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Avg. Distance
                    </span>

                        <span>
                        <%=averageDistance%>
                    </span>

                    </div>

                </div>


                <!-- AUDIT -->

                <div class="detail-card">

                    <h3>
                        Audit Activity
                    </h3>

                    <div class="detail-row">

                    <span>
                        Total Logs
                    </span>

                        <span>
                        <%=totalAuditLogs%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Creates
                    </span>

                        <span>
                        <%=createAuditLogs%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Updates
                    </span>

                        <span>
                        <%=updateAuditLogs%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Deletes
                    </span>

                        <span>
                        <%=deleteAuditLogs%>
                    </span>

                    </div>

                </div>


                <!-- OPERATIONAL ALERTS -->

                <div class="detail-card">

                    <h3>
                        Operational Alerts
                    </h3>

                    <div class="detail-row">

                    <span>
                        Low Stock Items
                    </span>

                        <span>
                        <%=lowStockItems%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Pending Shipments
                    </span>

                        <span>
                        <%=pendingShipments%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Cancelled
                    </span>

                        <span>
                        <%=cancelledShipments%>
                    </span>

                    </div>

                </div>


                <!-- PERFORMANCE -->

                <div class="detail-card">

                    <h3>
                        Performance Indicators
                    </h3>

                    <div class="detail-row">

                    <span>
                        Vendor Score
                    </span>

                        <span>
                        <%=averageVendorPerformance%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Route Score
                    </span>

                        <span>
                        <%=averageOptimizationScore%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        High Score Routes
                    </span>

                        <span>
                        <%=highScoreRoutes%>
                    </span>

                    </div>

                </div>


                <!-- AUDIT COMPLIANCE -->

                <div class="detail-card">

                    <h3>
                        Compliance Monitoring
                    </h3>

                    <div class="detail-row">

                    <span>
                        Audit Logs
                    </span>

                        <span>
                        <%=totalAuditLogs%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Create Activity
                    </span>

                        <span>
                        <%=createAuditLogs%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Update Activity
                    </span>

                        <span>
                        <%=updateAuditLogs%>
                    </span>

                    </div>

                    <div class="detail-row">

                    <span>
                        Delete Activity
                    </span>

                        <span>
                        <%=deleteAuditLogs%>
                    </span>

                    </div>

                </div>


            </div>

        </div>


        <!-- =================================================
             ENTERPRISE NOTICE
             ================================================= -->

        <div class="report-notice">

            <i class="fa-solid fa-circle-info"></i>

            <div>

                <strong>
                    Enterprise Reporting & Compliance
                </strong>

                <span>
                This reporting module provides operational
                statistics generated through the
                ReportServiceBean using JPA queries against
                shipments, shipment statuses, vendors,
                inventory, route optimization records and
                audit logs. These indicators support
                monitoring, decision-making and enterprise
                system evaluation.
            </span>

            </div>

        </div>


    </section>


</main>

<script>

    document.addEventListener(
        "DOMContentLoaded",
        function () {

            // =====================================================
            // DATE VALIDATION
            // =====================================================

            const reportForm =
                document.getElementById("reportForm");

            const startDate =
                document.getElementById("startDate");

            const endDate =
                document.getElementById("endDate");


            if (reportForm) {

                reportForm.addEventListener(
                    "submit",
                    function (event) {

                        if (
                            startDate.value &&
                            endDate.value &&
                            startDate.value > endDate.value
                        ) {

                            event.preventDefault();

                            alert(
                                "Start date cannot be later than end date."
                            );

                            return false;
                        }

                    }
                );

            }


            // =====================================================
            // END DATE MINIMUM
            // =====================================================

            if (startDate && endDate) {

                startDate.addEventListener(
                    "change",
                    function () {

                        if (startDate.value) {

                            endDate.min =
                                startDate.value;
                        }

                    }
                );

                if (startDate.value) {

                    endDate.min =
                        startDate.value;
                }

            }


            // =====================================================
            // AUTO HIDE ERROR
            // =====================================================

            setTimeout(
                function () {

                    document
                        .querySelectorAll(".alert")
                        .forEach(
                            function (element) {

                                element.style.transition =
                                    "opacity .4s ease";

                                element.style.opacity = "0";

                                setTimeout(
                                    function () {

                                        if (element.parentNode) {

                                            element.remove();
                                        }

                                    },
                                    400
                                );

                            }
                        );

                },
                5000
            );

        }
    );

</script>

</body>

</html>
