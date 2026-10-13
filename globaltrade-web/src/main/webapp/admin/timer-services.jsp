<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="lk.sasindi.globaltrade.entity.JobExecutionLog" %>
<%@ page import="lk.sasindi.globaltrade.entity.JobExecutionStatus" %>


<%
    /*
     * ============================================================
     * ADMIN SESSION CHECK
     * ============================================================
     */

    jakarta.servlet.http.HttpSession adminSession =
            request.getSession(false);

    if (adminSession == null ||
            !Boolean.TRUE.equals(
                    adminSession.getAttribute("authenticated"))) {

        response.sendRedirect(
                request.getContextPath() + "/signin"
        );

        return;
    }


    /*
     * ============================================================
     * DATA FROM SERVLET
     * ============================================================
     */

    List<JobExecutionLog> jobExecutionLogs =
            (List<JobExecutionLog>)
                    request.getAttribute("jobExecutionLogs");

    if (jobExecutionLogs == null) {

        jobExecutionLogs =
                Collections.emptyList();
    }


    String success =
            (String) request.getAttribute("success");

    String error =
            (String) request.getAttribute("error");


    /*
     * ============================================================
     * ADMIN INFORMATION
     * ============================================================
     */

    String adminName =
            String.valueOf(
                    adminSession.getAttribute("firstName")
            );

    if (adminName == null ||
            "null".equalsIgnoreCase(adminName) ||
            adminName.isBlank()) {

        adminName = "Administrator";
    }

    String initial =
            adminName.substring(0, 1).toUpperCase();


    /*
     * ============================================================
     * JOB STATISTICS
     * ============================================================
     */

    long totalExecutions =
            jobExecutionLogs.size();


    long successfulExecutions =
            jobExecutionLogs.stream()
                    .filter(log ->
                            log.getJobExecutionStatus() != null &&
                                    "SUCCESS".equalsIgnoreCase(
                                            log.getJobExecutionStatus().getName()
                                    ))
                    .count();


    long failedExecutions =
            jobExecutionLogs.stream()
                    .filter(log ->
                            log.getJobExecutionStatus() != null &&
                                    "FAILED".equalsIgnoreCase(
                                            log.getJobExecutionStatus().getName()
                                    ))
                    .count();


    long runningExecutions =
            jobExecutionLogs.stream()
                    .filter(log ->
                            log.getJobExecutionStatus() != null &&
                                    "RUNNING".equalsIgnoreCase(
                                            log.getJobExecutionStatus().getName()
                                    ))
                    .count();


    /*
     * ============================================================
     * PERFORMANCE STATISTICS
     * ============================================================
     */

    long performanceCount =
            jobExecutionLogs.stream()
                    .filter(log ->
                            log.getExecutionTimeMs() != null)
                    .count();


    long totalExecutionTime =
            jobExecutionLogs.stream()
                    .filter(log ->
                            log.getExecutionTimeMs() != null)
                    .mapToLong(
                            JobExecutionLog::getExecutionTimeMs
                    )
                    .sum();


    long averageExecutionTime = 0;


    if (performanceCount > 0) {

        averageExecutionTime =
                totalExecutionTime /
                        performanceCount;
    }


    /*
     * ============================================================
     * SUCCESS RATE
     * ============================================================
     */

    double successRate = 0;


    if (totalExecutions > 0) {

        successRate =
                ((double) successfulExecutions /
                        (double) totalExecutions) * 100;
    }


    String successRateText =
            String.format(
                    "%.1f",
                    successRate
            );

%>


<!DOCTYPE html>

<html lang="en">


<head>

    <meta charset="UTF-8">


    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">


    <title>
        Timer Services | GlobalTrade
    </title>


    <!-- =========================================================
         FONT AWESOME
         ========================================================= -->

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- =========================================================
         GOOGLE FONT
         ========================================================= -->

    <link rel="preconnect"
          href="https://fonts.googleapis.com">


    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>


    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">


    <!-- =========================================================
         ADMIN SHARED CSS
         ========================================================= -->

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/admin.css">


    <!-- =========================================================
         PAGE CSS
         Based on Custom Documents design
         ========================================================= -->

    <style>


        :root {

            --primary: #0B4080;
            --primary-dark: #083563;

            --accent: #0066FF;

            --background: #F4F7F9;

            --card: #FFFFFF;

            --border: #E2E8F0;

            --text: #172033;

            --muted: #718096;

            --green: #16865A;
            --green-bg: #EAF8F1;

            --yellow: #C58A00;
            --yellow-bg: #FFF7DF;

            --red: #D64545;
            --red-bg: #FFF0F0;

            --blue-bg: #EDF5FF;

            --orange: #D97706;
            --orange-bg: #FFF4E5;

            --navy: #003049;

            --sidebar-width: 250px;
        }


        /* ============================================================
           RESET
           ============================================================ */

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

            background:
                    var(--background);

            color:
                    var(--text);

            min-height: 100vh;

            font-size: 12px;

            overflow-x: hidden;
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


        button {

            border: none;
        }


        /* ============================================================
           SIDEBAR
           Same visual language as Custom Documents
           ============================================================ */

        .sidebar {

            position: fixed;

            top: 0;
            left: 0;
            bottom: 0;

            width:
                    var(--sidebar-width);

            background:
                    var(--navy);

            color: white;

            display: flex;

            flex-direction: column;

            z-index: 1000;

            overflow-y: auto;

            box-shadow:
                    2px 0 10px
                    rgba(0, 0, 0, 0.08);
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

            background:
                    #F77F00;

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

            background:
                    #F77F00;

            color: white;

            font-weight: 600;
        }


        .sidebar::-webkit-scrollbar,
        .nav::-webkit-scrollbar {

            width: 4px;
        }


        .sidebar::-webkit-scrollbar-thumb,
        .nav::-webkit-scrollbar-thumb {

            background:
                    rgba(255,255,255,.2);

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

            background:
                    #FFF3CD;

            color:
                    #F77F00;

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


        /* ============================================================
           MAIN
           ============================================================ */

        .main {

            margin-left:
                    var(--sidebar-width);

            min-height: 100vh;
        }


        /* ============================================================
    MAIN
    ============================================================ */

        .main {
            margin-left: var(--sidebar-width);

            min-height: 100vh;
        }


        /* ============================================================
           TOPBAR
           ============================================================ */

        .topbar {
            height: 65px;

            display: flex;
            align-items: center;

            padding: 0 22px;

            background: var(--card);

            border-bottom:
                    1px solid var(--border);

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
                    1px solid #F8E4A9;

            border-radius: 7px;

            color: var(--muted);
        }


        .search:focus-within {
            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252,191,73,.12);
        }


        .search i {
            font-size: 13px;

            color: var(--muted);
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


        .search input::placeholder {
            color: #94A3B8;
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


        .notification-count {
            position: absolute;

            top: -5px;
            right: -7px;

            min-width: 17px;
            height: 17px;

            padding: 0 4px;

            border-radius: 50%;

            background: var(--red);

            color: white;

            font-size: 9px;

            display: flex;
            align-items: center;
            justify-content: center;

            font-weight: 700;
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
        /* ============================================================
           CONTENT
           ============================================================ */

        .content {

            padding:
                    28px 32px 30px;
        }


        /* ============================================================
           PAGE HEADING
           ============================================================ */

        .page-heading {

            display: flex;

            justify-content:
                    space-between;

            align-items:
                    center;

            margin-bottom:
                    25px;

            gap: 20px;
        }


        .page-heading h1 {

            margin: 0;

            font-size: 25px;

            font-weight: 800;

            color:
                    var(--text);
        }


        .page-heading p {

            margin:
                    7px 0 0;

            color:
                    var(--muted);

            font-size: 13px;
        }


        /* ============================================================
           REFRESH BUTTON
           ============================================================ */

        .btn {

            border: none;

            border-radius: 8px;

            padding:
                    11px 17px;

            font-size: 12px;

            font-weight: 700;

            cursor: pointer;

            display: inline-flex;

            align-items: center;

            gap: 8px;

            transition:
                    .2s ease;
        }


        .btn-primary {

            background:
                    var(--accent);

            color: #fff;
        }


        .btn-primary:hover {

            background:
                    #0055D4;

            transform:
                    translateY(-1px);
        }


        /* ============================================================
           TIMER STATUS BANNER
           ============================================================ */

        .timer-banner {

            background:
                    var(--card);

            border:
                    1px solid
                    var(--border);

            border-radius:
                    14px;

            padding:
                    17px 20px;

            margin-bottom:
                    24px;

            display: flex;

            align-items: center;

            justify-content:
                    space-between;

            gap: 20px;

            box-shadow:
                    0 3px 12px
                    rgba(15, 48, 64, .04);
        }


        .timer-banner-left {

            display: flex;

            align-items: center;

            gap: 13px;
        }


        .timer-banner-icon {

            width: 45px;
            height: 45px;

            border-radius: 10px;

            background:
                    var(--blue-bg);

            color:
                    var(--accent);

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 18px;

            flex-shrink: 0;
        }


        .timer-banner h2 {

            margin: 0;

            color:
                    var(--text);

            font-size: 14px;

            font-weight: 800;
        }


        .timer-banner p {

            margin:
                    5px 0 0;

            color:
                    var(--muted);

            font-size: 10px;

            line-height: 1.5;
        }


        .container-status {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            padding:
                    8px 12px;

            border-radius: 20px;

            background:
                    var(--green-bg);

            color:
                    var(--green);

            font-size: 9px;

            font-weight: 700;

            white-space: nowrap;
        }


        .status-dot {

            width: 7px;
            height: 7px;

            border-radius: 50%;

            background:
                    var(--green);

            box-shadow:
                    0 0 0 3px
                    rgba(22,134,90,.10);
        }


        /* ============================================================
           STATISTICS
           ============================================================ */

        .stats-grid {

            display: grid;

            grid-template-columns:
                    repeat(4, minmax(0, 1fr));

            gap: 17px;

            margin-bottom:
                    24px;
        }


        .stat-card {

            background:
                    var(--card);

            border:
                    1px solid
                    var(--border);

            border-radius:
                    13px;

            padding:
                    19px;

            display: flex;

            align-items: center;

            justify-content:
                    space-between;

            box-shadow:
                    0 3px 12px
                    rgba(15, 48, 64, .04);
        }


        .stat-content h4 {

            margin:
                    0 0 8px;

            color:
                    var(--muted);

            font-size: 11px;

            font-weight: 600;
        }


        .number {

            font-size: 24px;

            font-weight: 800;

            color:
                    var(--text);
        }


        .stat-description {

            margin-top: 5px;

            color:
                    #98A2B3;

            font-size: 9px;
        }


        .stat-icon {

            width: 43px;
            height: 43px;

            border-radius: 10px;

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 17px;

            flex-shrink: 0;
        }


        .stat-blue {

            background:
                    var(--blue-bg);

            color:
                    var(--accent);
        }


        .stat-green {

            background:
                    var(--green-bg);

            color:
                    var(--green);
        }


        .stat-yellow {

            background:
                    var(--yellow-bg);

            color:
                    var(--yellow);
        }


        .stat-red {

            background:
                    var(--red-bg);

            color:
                    var(--red);
        }


        /* ============================================================
           EXECUTION PANEL
           ============================================================ */

        .document-panel {

            background:
                    var(--card);

            border:
                    1px solid
                    var(--border);

            border-radius:
                    14px;

            box-shadow:
                    0 3px 12px
                    rgba(15, 48, 64, .04);

            overflow: hidden;
        }


        .panel-header {

            padding:
                    20px 22px;

            border-bottom:
                    1px solid
                    var(--border);

            display: flex;

            justify-content:
                    space-between;

            align-items:
                    center;

            gap: 20px;
        }


        .panel-header h2 {

            margin: 0;

            font-size: 16px;

            font-weight: 800;

            color:
                    var(--text);
        }


        .panel-header p {

            margin:
                    5px 0 0;

            color:
                    var(--muted);

            font-size: 11px;
        }


        /* ============================================================
           SEARCH
           ============================================================ */

        .search-area {

            display: flex;

            align-items: center;

            gap: 9px;
        }


        .search-box {

            position: relative;
        }


        .search-box i {

            position: absolute;

            left: 12px;

            top: 50%;

            transform:
                    translateY(-50%);

            color:
                    #98A2B3;

            font-size: 12px;
        }


        .search-box input {

            width: 210px;

            height: 37px;

            padding:
                    0 12px 0 34px;

            border:
                    1px solid
                    var(--border);

            border-radius: 8px;

            outline: none;

            font-size: 11px;

            font-family: inherit;

            background: #fff;

            color:
                    var(--text);
        }


        .search-box input:focus {

            border-color:
                    var(--accent);

            box-shadow:
                    0 0 0 3px
                    rgba(0,102,255,.08);
        }


        /* ============================================================
           TABLE
           ============================================================ */

        .table-wrapper {

            overflow-x: auto;
        }


        .document-table {

            width: 100%;

            border-collapse:
                    collapse;

            min-width:
                    1050px;
        }


        .document-table th {

            background:
                    #F8FAFC;

            padding:
                    13px 15px;

            text-align: left;

            font-size: 10px;

            color:
                    #64748B;

            text-transform:
                    uppercase;

            letter-spacing:
                    .35px;

            font-weight: 700;

            border-bottom:
                    1px solid
                    var(--border);

            white-space: nowrap;
        }


        .document-table td {

            padding:
                    14px 15px;

            border-bottom:
                    1px solid
                    #EDF1F5;

            font-size: 11px;

            color:
                    #344054;

            vertical-align: middle;
        }


        .document-table tbody tr {

            transition:
                    background .15s ease;
        }


        .document-table tbody tr:hover {

            background:
                    #FAFCFE;
        }


        .document-table tbody tr:last-child td {

            border-bottom: none;
        }


        /* ============================================================
           JOB INFORMATION
           ============================================================ */

        .document-info {

            display: flex;

            align-items: center;

            gap: 11px;
        }


        .document-icon {

            width: 37px;
            height: 37px;

            border-radius: 9px;

            background:
                    var(--blue-bg);

            color:
                    var(--accent);

            display: flex;

            align-items: center;
            justify-content: center;

            flex-shrink: 0;

            font-size: 13px;
        }


        .document-name {

            font-weight: 700;

            color:
                    var(--text);

            font-size: 11px;
        }


        .document-number {

            color:
                    #8A94A6;

            font-size: 9px;

            margin-top: 3px;
        }


        /* ============================================================
           STATUS
           ============================================================ */

        .status-badge {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            padding:
                    5px 9px;

            border-radius: 20px;

            font-size: 9px;

            font-weight: 700;

            white-space: nowrap;
        }


        .status-badge i {

            font-size: 8px;
        }


        .status-success {

            background:
                    var(--green-bg);

            color:
                    var(--green);
        }


        .status-failed {

            background:
                    var(--red-bg);

            color:
                    var(--red);
        }


        .status-running {

            background:
                    var(--yellow-bg);

            color:
                    var(--yellow);
        }


        .status-unknown {

            background:
                    #EEF2F6;

            color:
                    #687385;
        }


        /* ============================================================
           EXECUTION TIME
           ============================================================ */

        .execution-time {

            font-weight: 700;

            color:
                    var(--text);
        }


        .execution-unit {

            margin-left: 2px;

            color:
                    var(--muted);

            font-size: 8px;
        }


        /* ============================================================
           RECORD COUNT
           ============================================================ */

        .record-count {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            min-width: 29px;

            padding:
                    5px 8px;

            border-radius: 6px;

            background:
                    var(--blue-bg);

            color:
                    var(--accent);

            font-weight: 700;

            font-size: 10px;
        }


        /* ============================================================
           ERROR
           ============================================================ */

        .error-text {

            max-width: 220px;

            color:
                    var(--red);

            font-size: 9px;

            line-height: 1.45;

            overflow: hidden;

            text-overflow: ellipsis;
        }


        .no-error {

            color:
                    #98A2B3;

            font-size: 9px;
        }


        /* ============================================================
           EMPTY STATE
           ============================================================ */

        .empty-state {

            padding:
                    60px 20px;

            text-align: center;
        }


        .empty-icon {

            width: 55px;
            height: 55px;

            margin:
                    0 auto 13px;

            border-radius: 12px;

            background:
                    var(--blue-bg);

            color:
                    var(--accent);

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 21px;
        }


        .empty-state h3 {

            margin: 0;

            color:
                    var(--text);

            font-size: 14px;

            font-weight: 800;
        }


        .empty-state p {

            margin:
                    6px 0 0;

            color:
                    var(--muted);

            font-size: 10px;

            line-height: 1.5;
        }


        /* ============================================================
           MONITORING NOTE
           ============================================================ */

        .monitoring-note {

            margin-top:
                    15px;

            padding:
                    14px 17px;

            border:
                    1px solid
                    var(--border);

            border-radius:
                    10px;

            background:
                    var(--card);

            display: flex;

            align-items:
                    flex-start;

            gap: 11px;

            box-shadow:
                    0 3px 12px
                    rgba(15, 48, 64, .025);
        }


        .monitoring-note > i {

            margin-top: 2px;

            color:
                    var(--accent);

            font-size: 13px;
        }


        .monitoring-note strong {

            display: block;

            color:
                    var(--text);

            font-size: 10px;

            margin-bottom: 4px;
        }


        .monitoring-note span {

            color:
                    var(--muted);

            font-size: 9px;

            line-height: 1.5;
        }


        /* ============================================================
           TOASTS
           ============================================================ */

        .success-toast,
        .error-toast {

            position: fixed;

            top: 88px;

            right: 28px;

            min-width: 330px;

            max-width: 430px;

            display: flex;

            align-items: center;

            gap: 11px;

            padding:
                    14px 16px;

            border-radius: 11px;

            font-size: 12px;

            font-weight: 600;

            box-shadow:
                    0 12px 30px
                    rgba(0, 0, 0, 0.12);

            z-index: 5000;

            animation:
                    toastSlideIn .35s ease;
        }


        .success-toast {

            background:
                    #ECFDF5;

            border:
                    1px solid
                    #A7F3D0;

            color:
                    #047857;
        }


        .error-toast {

            background:
                    #FFF0F0;

            border:
                    1px solid
                    #F5C2C7;

            color:
                    var(--red);
        }


        .toast-close {

            margin-left: auto;

            background: transparent;

            color: inherit;

            cursor: pointer;

            font-size: 12px;
        }


        @keyframes toastSlideIn {

            from {

                opacity: 0;

                transform:
                        translateX(20px);
            }

            to {

                opacity: 1;

                transform:
                        translateX(0);
            }
        }


        /* ============================================================
           RESPONSIVE
           ============================================================ */

        @media (max-width: 1100px) {

            .stats-grid {

                grid-template-columns:
                        repeat(2, minmax(0, 1fr));
            }
        }


        @media (max-width: 800px) {

            .main {

                margin-left: 0;
            }


            .content {

                padding:
                        20px;
            }


            .page-heading {

                align-items:
                        flex-start;

                flex-direction:
                        column;

                gap: 15px;
            }


            .timer-banner {

                align-items:
                        flex-start;

                flex-direction:
                        column;
            }


            .panel-header {

                align-items:
                        flex-start;

                flex-direction:
                        column;
            }


            .search-area {

                width: 100%;
            }


            .search-box {

                flex: 1;

                width: 100%;
            }


            .search-box input {

                width: 100%;
            }
        }


        @media (max-width: 600px) {

            .stats-grid {

                grid-template-columns:
                        1fr;
            }


            .content {

                padding:
                        18px 14px;
            }


            .success-toast,
            .error-toast {

                left: 14px;

                right: 14px;

                min-width: 0;

                max-width: none;
            }
        }

    </style>

</head>


<body>


<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<jsp:include page="admin-sidebar.jsp"/>


<main class="main">


    <!-- ========================================================
         TOPBAR
         ======================================================== -->

    <jsp:include page="admin-topbar.jsp"/>


    <section class="content">


        <!-- ====================================================
             PAGE HEADING
             ==================================================== -->

        <div class="page-heading">

            <div>

                <h1>
                    Timer Services
                </h1>

                <p>
                    Monitor automated EJB jobs, execution performance
                    and scheduled process history.
                </p>

            </div>


            <button
                    class="btn btn-primary"
                    type="button"
                    onclick="refreshJobs()"
            >

                <i class="fa-solid fa-rotate"></i>

                Refresh

            </button>

        </div>


        <!-- ====================================================
             ERROR MESSAGE
             ==================================================== -->

        <% if (error != null &&
                !error.trim().isEmpty()) { %>

        <div
                class="error-toast"
                id="errorToast"
        >

            <i class="fa-solid fa-circle-exclamation"></i>

            <span>
                <%= error %>
            </span>

            <button
                    type="button"
                    class="toast-close"
                    onclick="closeToast('errorToast')"
            >

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <% } %>


        <!-- ====================================================
             TIMER SERVICE STATUS
             ==================================================== -->

        <div class="timer-banner">


            <div class="timer-banner-left">


                <div class="timer-banner-icon">

                    <i class="fa-solid fa-clock"></i>

                </div>


                <div>

                    <h2>
                        EJB Timer Service
                    </h2>

                    <p>
                        Automated GlobalTrade business jobs are
                        managed by the Jakarta Enterprise Beans
                        container and recorded in the execution history.
                    </p>

                </div>

            </div>


            <div class="container-status">

                <span class="status-dot"></span>

                Timer Service Active

            </div>


        </div>


        <!-- ====================================================
             STATISTICS
             ==================================================== -->

        <div class="stats-grid">


            <!-- =================================================
                 TOTAL EXECUTIONS
                 ================================================= -->

            <div class="stat-card">

                <div class="stat-content">

                    <h4>
                        Total Executions
                    </h4>

                    <div class="number">
                        <%= totalExecutions %>
                    </div>

                    <div class="stat-description">
                        Recorded timer executions
                    </div>

                </div>


                <div class="stat-icon stat-blue">

                    <i class="fa-solid fa-list-check"></i>

                </div>

            </div>


            <!-- =================================================
                 SUCCESSFUL
                 ================================================= -->

            <div class="stat-card">

                <div class="stat-content">

                    <h4>
                        Successful
                    </h4>

                    <div class="number">
                        <%= successfulExecutions %>
                    </div>

                    <div class="stat-description">
                        Success rate <%= successRateText %>%
                    </div>

                </div>


                <div class="stat-icon stat-green">

                    <i class="fa-solid fa-circle-check"></i>

                </div>

            </div>


            <!-- =================================================
                 FAILED
                 ================================================= -->

            <div class="stat-card">

                <div class="stat-content">

                    <h4>
                        Failed
                    </h4>

                    <div class="number">
                        <%= failedExecutions %>
                    </div>

                    <div class="stat-description">
                        Requires investigation
                    </div>

                </div>


                <div class="stat-icon stat-red">

                    <i class="fa-solid fa-circle-exclamation"></i>

                </div>

            </div>


            <!-- =================================================
                 RUNNING / PERFORMANCE
                 ================================================= -->

            <div class="stat-card">

                <div class="stat-content">

                    <h4>
                        Avg. Execution
                    </h4>

                    <div class="number">
                        <%= averageExecutionTime %>
                    </div>

                    <div class="stat-description">
                        Milliseconds
                    </div>

                </div>


                <div class="stat-icon stat-yellow">

                    <i class="fa-solid fa-gauge-high"></i>

                </div>

            </div>


        </div>


        <!-- ====================================================
             EXECUTION HISTORY PANEL
             ==================================================== -->

        <div class="document-panel">


            <!-- =================================================
                 PANEL HEADER
                 ================================================= -->

            <div class="panel-header">


                <div>

                    <h2>
                        Job Execution History
                    </h2>

                    <p>
                        View execution status, processing time,
                        records and errors for automated EJB jobs.
                    </p>

                </div>


                <div class="search-area">


                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input
                                type="text"
                                id="jobSearch"
                                placeholder="Search jobs..."
                                onkeyup="filterJobs()"
                        >

                    </div>


                </div>


            </div>


            <!-- =================================================
                 TABLE
                 ================================================= -->

            <div class="table-wrapper">


                <table
                        class="document-table"
                        id="jobsTable"
                >


                    <thead>

                    <tr>

                        <th>
                            Job
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Started
                        </th>

                        <th>
                            Completed
                        </th>

                        <th>
                            Execution Time
                        </th>

                        <th>
                            Records
                        </th>

                        <th>
                            Error
                        </th>

                    </tr>

                    </thead>


                    <tbody>


                    <%
                        if (jobExecutionLogs.isEmpty()) {
                    %>


                    <!-- =================================================
                         EMPTY STATE
                         ================================================= -->

                    <tr>

                        <td colspan="7">

                            <div class="empty-state">


                                <div class="empty-icon">

                                    <i class="fa-solid fa-clock-rotate-left"></i>

                                </div>


                                <h3>
                                    No Job Executions Yet
                                </h3>


                                <p>
                                    Timer execution history will appear
                                    here once the scheduled EJB jobs begin
                                    running.
                                </p>


                            </div>

                        </td>

                    </tr>


                    <%
                    } else {

                        for (JobExecutionLog log :
                                jobExecutionLogs) {


                            JobExecutionStatus status =
                                    log.getJobExecutionStatus();


                            String statusName =
                                    status != null &&
                                            status.getName() != null
                                            ? status.getName()
                                            : "UNKNOWN";


                            String statusClass =
                                    "SUCCESS".equalsIgnoreCase(
                                            statusName)
                                            ? "status-success"
                                            : "FAILED".equalsIgnoreCase(
                                            statusName)
                                            ? "status-failed"
                                            : "RUNNING".equalsIgnoreCase(
                                            statusName)
                                            ? "status-running"
                                            : "status-unknown";


                            String statusIcon =
                                    "SUCCESS".equalsIgnoreCase(
                                            statusName)
                                            ? "fa-circle-check"
                                            : "FAILED".equalsIgnoreCase(
                                            statusName)
                                            ? "fa-circle-xmark"
                                            : "RUNNING".equalsIgnoreCase(
                                            statusName)
                                            ? "fa-spinner"
                                            : "fa-circle-question";


                            String jobName =
                                    log.getName() != null
                                            ? log.getName()
                                            : "Unnamed Job";


                            String errorMessage =
                                    log.getError();

                    %>


                    <!-- =================================================
                         JOB ROW
                         ================================================= -->

                    <tr
                            class="job-row"
                            data-job-name="<%= jobName.toLowerCase() %>"
                    >


                        <!-- =================================================
                             JOB
                             ================================================= -->

                        <td>

                            <div class="document-info">


                                <div class="document-icon">

                                    <i class="fa-solid fa-gears"></i>

                                </div>


                                <div>


                                    <div class="document-name">

                                        <%= jobName %>

                                    </div>


                                    <div class="document-number">

                                        Automated EJB timer job

                                    </div>


                                </div>


                            </div>

                        </td>


                        <!-- =================================================
                             STATUS
                             ================================================= -->

                        <td>

                            <span
                                    class="status-badge <%= statusClass %>"
                            >

                                <i
                                        class="fa-solid <%= statusIcon %>"
                                ></i>

                                <%= statusName %>

                            </span>

                        </td>


                        <!-- =================================================
                             STARTED
                             ================================================= -->

                        <td>

                            <%
                                if (log.getStartedAt() != null) {
                            %>

                            <%= log.getStartedAt() %>

                            <%
                            } else {
                            %>

                            <span class="no-error">
                                —
                            </span>

                            <%
                                }
                            %>

                        </td>


                        <!-- =================================================
                             COMPLETED
                             ================================================= -->

                        <td>

                            <%
                                if (log.getCompletedAt() != null) {
                            %>

                            <%= log.getCompletedAt() %>

                            <%
                            } else {
                            %>

                            <span class="no-error">
                                Running...
                            </span>

                            <%
                                }
                            %>

                        </td>


                        <!-- =================================================
                             EXECUTION TIME
                             ================================================= -->

                        <td>

                            <%
                                if (log.getExecutionTimeMs() != null) {
                            %>

                            <span class="execution-time">

                                <%= log.getExecutionTimeMs() %>

                            </span>


                            <span class="execution-unit">
                                ms
                            </span>

                            <%
                            } else {
                            %>

                            <span class="no-error">
                                —
                            </span>

                            <%
                                }
                            %>

                        </td>


                        <!-- =================================================
                             RECORDS
                             ================================================= -->

                        <td>

                            <%
                                if (log.getRecords() != null) {
                            %>

                            <span class="record-count">

                                <%= log.getRecords() %>

                            </span>

                            <%
                            } else {
                            %>

                            <span class="no-error">
                                —
                            </span>

                            <%
                                }
                            %>

                        </td>


                        <!-- =================================================
                             ERROR
                             ================================================= -->

                        <td>

                            <%
                                if (errorMessage != null &&
                                        !errorMessage.isBlank()) {
                            %>

                            <div
                                    class="error-text"
                                    title="<%= errorMessage %>"
                            >

                                <%= errorMessage %>

                            </div>

                            <%
                            } else {
                            %>

                            <span class="no-error">
                                No errors
                            </span>

                            <%
                                }
                            %>

                        </td>


                    </tr>


                    <%
                            }

                        }
                    %>


                    </tbody>

                </table>


            </div>


        </div>


        <!-- ====================================================
             MONITORING INFORMATION
             ==================================================== -->

        <div class="monitoring-note">


            <i class="fa-solid fa-circle-info"></i>


            <div>


                <strong>
                    Timer Service Performance Monitoring
                </strong>


                <span>
                    Execution duration and processed-record counts
                    are stored for every automated job. Successful,
                    failed and running executions can be reviewed
                    from this page to monitor the reliability and
                    performance of GlobalTrade scheduled processes.
                </span>


            </div>


        </div>


    </section>


</main>


<!-- ============================================================
     JAVASCRIPT
     ============================================================ -->

<script>


    /*
     * ======================================================
     * REFRESH
     * ======================================================
     */

    function refreshJobs() {

        window.location.reload();

    }


    /*
     * ======================================================
     * SEARCH / FILTER
     * ======================================================
     */

    function filterJobs() {


        const input =
            document.getElementById("jobSearch");


        const search =
            input.value
                .toLowerCase()
                .trim();


        const rows =
            document.querySelectorAll(
                ".job-row"
            );


        rows.forEach(function (row) {


            const jobName =
                row.getAttribute(
                    "data-job-name"
                ) || "";


            if (jobName.includes(search)) {

                row.style.display = "";

            } else {

                row.style.display = "none";

            }

        });

    }


    /*
     * ======================================================
     * CLOSE TOAST
     * ======================================================
     */

    function closeToast(id) {

        const toast =
            document.getElementById(id);


        if (!toast) {
            return;
        }


        toast.style.opacity = "0";


        setTimeout(
            function () {

                toast.remove();

            },
            300
        );

    }


</script>


</body>

</html>