<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.sasindi.globaltrade.entity.AuditLog" %>
<%@ page import="lk.sasindi.globaltrade.entity.User" %>

<%


    jakarta.servlet.http.HttpSession adminSession =
    request.getSession(false);

    if (adminSession == null ||
    !Boolean.TRUE.equals(
    adminSession.getAttribute("authenticated")
    )) {

    response.sendRedirect(
    request.getContextPath() +
    "/signin"
    );

    return;
    }


    String role =
    String.valueOf(
    adminSession.getAttribute("role")
    );


    if (!"ADMIN".equalsIgnoreCase(role)) {

    response.sendError(
    HttpServletResponse.SC_FORBIDDEN,
    "Access denied."
    );

    return;
    }


    List<AuditLog> auditLogs =
    (List<AuditLog>) request.getAttribute(
    "auditLogs"
    );


    if (auditLogs == null) {

    auditLogs =
    java.util.Collections.emptyList();
    }


    String search =
    request.getParameter("search");


    Object totalLogs =
    request.getAttribute("totalLogs");

    Object todayLogs =
    request.getAttribute("todayLogs");

    Object createLogs =
    request.getAttribute("createLogs");

    Object updateLogs =
    request.getAttribute("updateLogs");

    Object deleteLogs =
    request.getAttribute("deleteLogs");



    String successMessage =
    (String) adminSession.getAttribute(
    "successMessage"
    );

    String errorMessage =
    (String) adminSession.getAttribute(
    "errorMessage"
    );


    adminSession.removeAttribute(
    "successMessage"
    );

    adminSession.removeAttribute(
    "errorMessage"
    );


%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width,
               initial-scale=1.0">


    <title>
        Audit Logs | GlobalTrade
    </title>

    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link
            rel="preconnect"
            href="https://fonts.googleapis.com">

    <link
            rel="preconnect"
            href="https://fonts.googleapis.com"
            crossorigin>

    <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
            rel="stylesheet">

    <style>

        :root {

            --navy: #003049;

            --yellow: #FCBF49;

            --orange: #F77F00;

            --red: #D62828;

            --background: #FFF9E8;

            --card: #FFFFFF;

            --text: #003049;

            --muted: #64748B;

            --border:
                    rgba(0, 48, 73, 0.10);

            --sidebar-width: 250px;

            --soft-yellow: #FFF3CD;

            --green: #28A745;

            --blue: #2563EB;
        }

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
                    var(--orange);

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
                    var(--orange);

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
                    var(--soft-yellow);

            color:
                    var(--orange);

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


        .profile-link.active {

            color:
                    var(--yellow);
        }

        .main {

            margin-left:
                    var(--sidebar-width);

            min-height: 100vh;
        }

        .topbar {

            height: 65px;

            display: flex;

            align-items: center;

            padding: 0 22px;

            background:
                    var(--card);

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

            color:
                    var(--navy);

            font-size: 19px;

            cursor: pointer;

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .menu-btn:hover {

            color:
                    var(--orange);
        }


        .search {

            width: 285px;

            height: 35px;

            display: flex;

            align-items: center;

            gap: 9px;

            padding: 0 11px;

            background:
                    var(--card);

            border:
                    1px solid
                    #F8E4A9;

            border-radius: 7px;

            color:
                    var(--muted);
        }


        .search:focus-within {

            border-color:
                    var(--yellow);

            box-shadow:
                    0 0 0 3px
                    rgba(252,191,73,.12);
        }


        .search i {

            font-size: 13px;

            color:
                    var(--muted);
        }


        .search input {

            width: 100%;

            height: 100%;

            border: none;

            outline: none;

            background: transparent;

            color:
                    var(--navy);

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

            color:
                    var(--navy);

            font-size: 16px;

            cursor: pointer;

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .icon-btn:hover {

            color:
                    var(--orange);
        }


        .notification-count {

            position: absolute;

            top: -5px;

            right: -7px;

            min-width: 17px;

            height: 17px;

            padding: 0 4px;

            border-radius: 50%;

            background:
                    var(--red);

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

            color:
                    var(--navy);

            font-size: 12px;

            font-weight: 600;

            white-space: nowrap;
        }


        .top-user:hover {

            color:
                    var(--orange);
        }


        .top-avatar {

            width: 33px;

            height: 33px;

            border-radius: 50%;

            background:
                    var(--soft-yellow);

            color:
                    var(--orange);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 14px;

            font-weight: 700;
        }

        .content {

            padding:
                    20px 25px 18px;
        }

        .page-heading {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 17px;

            gap: 15px;
        }


        .page-heading h1 {

            color:
                    var(--navy);

            font-size: 24px;

            font-weight: 700;

            letter-spacing: -.5px;
        }


        .page-heading p {

            margin-top: 4px;

            font-size: 12px;

            color:
                    var(--muted);
        }

        .btn {

            height: 38px;

            padding: 0 15px;

            border-radius: 7px;

            font-size: 10px;

            font-weight: 700;

            cursor: pointer;

            border:
                    1px solid transparent;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            transition: .2s ease;
        }


        .btn-primary {

            background:
                    var(--yellow);

            color:
                    var(--navy);
        }


        .btn-primary:hover {

            background:
                    var(--orange);

            color: white;
        }


        .btn-secondary {

            background: white;

            border-color:
                    var(--border);

            color:
                    var(--navy);
        }


        .btn-secondary:hover {

            border-color:
                    var(--yellow);

            background:
                    #FFFDF5;
        }

        .alert {

            padding:
                    10px 13px;

            border-radius: 7px;

            margin-bottom: 14px;

            display: flex;

            align-items: center;

            gap: 8px;

            font-size: 9px;

            font-weight: 600;
        }


        .alert-success {

            background:
                    #EAF7EE;

            color:
                    var(--green);
        }


        .alert-error {

            background:
                    #FEF0F0;

            color:
                    var(--red);
        }

        .stats-grid {

            display: grid;

            grid-template-columns:
                repeat(5, 1fr);

            gap: 12px;

            margin-bottom: 14px;
        }


        .stat-card {

            background:
                    var(--card);

            border:
                    1px solid
                    var(--border);

            border-radius: 11px;

            padding: 15px;

            display: flex;

            align-items: center;

            gap: 12px;
        }


        .stat-top {

            width: 100%;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 8px;
        }


        .stat-label {

            display: block;

            color:
                    var(--muted);

            font-size: 8px;

            font-weight: 600;

            margin-bottom: 6px;

            text-transform: uppercase;

            letter-spacing: .3px;
        }


        .stat-value {

            color:
                    var(--navy);

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

            color:
                    var(--orange);

            font-size: 14px;

            flex-shrink: 0;
        }

        .inventory-panel {

            background:
                    #ffffff;

            border:
                    1px solid
                    var(--border);

            border-radius: 10px;

            box-shadow:
                    0 5px 20px
                    rgba(0,0,0,.05);

            overflow: hidden;
        }

        .panel-header {

            padding:
                    15px 16px;

            display: flex;

            justify-content: space-between;

            align-items: center;

            border-bottom:
                    1px solid
                    var(--border);

            gap: 12px;
        }


        .panel-header h2 {

            font-size: 13px;

            color:
                    var(--navy);

            font-weight: 700;
        }


        .panel-header p {

            font-size: 8px;

            color:
                    var(--muted);

            margin-top: 3px;
        }

        .search-area {

            display: flex;

            align-items: center;

            gap: 8px;
        }


        .search-box {

            position: relative;
        }


        .search-box i {

            position: absolute;

            left: 11px;

            top: 50%;

            transform:
                    translateY(-50%);

            color:
                    #94A3B8;

            font-size: 10px;
        }


        .search-box input {

            width: 220px;

            height: 34px;

            padding:
                    0 10px 0 31px;

            border:
                    1px solid
                    var(--border);

            border-radius: 7px;

            outline: none;

            font-size: 9px;

            background:
                    #fff;

            color:
                    var(--navy);
        }


        .search-box input:focus {

            border-color:
                    var(--yellow);

            box-shadow:
                    0 0 0 3px
                    rgba(252,191,73,.10);
        }


        .filter-select {

            height: 34px;

            padding:
                    0 10px;

            border:
                    1px solid
                    var(--border);

            border-radius: 7px;

            background:
                    #fff;

            outline: none;

            font-size: 9px;

            color:
                    var(--navy);
        }

        .search-button {

            height: 34px;

            padding:
                    0 13px;

            border: none;

            border-radius: 7px;

            background:
                    var(--yellow);

            color:
                    var(--navy);

            font-size: 9px;

            font-weight: 700;

            cursor: pointer;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 5px;

            transition: .2s ease;
        }


        .search-button:hover {

            background:
                    var(--orange);

            color: white;
        }

        .table-wrapper {

            width: 100%;

            overflow-x: auto;
        }


        .audit-table {

            width: 100%;

            border-collapse: collapse;

            min-width: 900px;
        }


        .audit-table thead {

            background:
                    #FFF9E8;
        }


        .audit-table th {

            padding:
                    12px 14px;

            text-align: left;

            color:
                    var(--muted);

            font-size: 9px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: .3px;

            border-bottom:
                    1px solid
                    var(--border);

            white-space: nowrap;
        }


        .audit-table td {

            padding:
                    13px 14px;

            color:
                    var(--navy);

            font-size: 10px;

            border-bottom:
                    1px solid
                    rgba(0,48,73,.06);

            vertical-align: middle;
        }


        .audit-table tbody tr {

            transition: .15s ease;
        }


        .audit-table tbody tr:hover {

            background:
                    #FFFDF5;
        }


        .audit-table tbody tr:last-child td {

            border-bottom: none;
        }

        .log-id {

            color:
                    var(--orange);

            font-weight: 700;

            font-size: 10px;
        }

        .action-badge {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            padding:
                    5px 8px;

            border-radius: 5px;

            font-size: 8px;

            font-weight: 700;

            white-space: nowrap;
        }


        .action-create {

            background:
                    rgba(40,167,69,.10);

            color:
                    var(--green);
        }


        .action-update {

            background:
                    rgba(37,99,235,.10);

            color:
                    var(--blue);
        }


        .action-delete {

            background:
                    rgba(214,40,40,.10);

            color:
                    var(--red);
        }


        .action-optimize {

            background:
                    rgba(252,191,73,.20);

            color:
                    #946200;
        }

        .entity-badge {

            display: inline-flex;

            align-items: center;

            padding:
                    5px 8px;

            border-radius: 5px;

            background:
                    #FFF3CD;

            color:
                    var(--navy);

            font-size: 8px;

            font-weight: 700;

            white-space: nowrap;
        }

        .user-cell {

            display: flex;

            align-items: center;

            gap: 8px;
        }


        .mini-avatar {

            width: 30px;

            height: 30px;

            border-radius: 50%;

            background:
                    var(--soft-yellow);

            color:
                    var(--orange);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 9px;

            font-weight: 800;

            flex-shrink: 0;
        }


        .user-cell strong {

            color:
                    var(--navy);

            font-size: 9px;

            font-weight: 700;
        }

        .details-cell {

            max-width: 300px;

            color:
                    var(--muted);

            font-size: 9px;

            line-height: 1.5;
        }

        .date-cell {

            color:
                    var(--muted);

            font-size: 9px;

            white-space: nowrap;
        }

        .empty-state {

            padding:
                    55px 20px;

            text-align: center;

            color:
                    var(--muted);
        }


        .empty-state i {

            font-size: 35px;

            color:
                    #CBD5E1;

            margin-bottom: 12px;
        }


        .empty-state div {

            color:
                    var(--navy);

            font-size: 11px;

            font-weight: 600;
        }

        .table-footer {

            min-height: 48px;

            padding:
                    10px 16px;

            border-top:
                    1px solid
                    rgba(0,48,73,.06);

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 10px;
        }


        .table-info {

            color:
                    var(--muted);

            font-size: 9px;
        }

        @media (max-width: 1200px) {

            .stats-grid {

                grid-template-columns:
                    repeat(3, 1fr);
            }
        }


        @media (max-width: 1000px) {

            .panel-header {

                align-items: flex-start;

                flex-direction: column;
            }


            .search-area {

                width: 100%;
            }


            .search-box {

                flex: 1;
            }


            .search-box input {

                width: 100%;
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


            .stats-grid {

                grid-template-columns:
                    repeat(2, 1fr);
            }


            .topbar {

                padding:
                        0 15px;
            }


            .content {

                padding:
                        18px 15px;
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

                padding:
                        15px 12px;
            }


            .stats-grid {

                grid-template-columns:
                    1fr;
            }


            .page-heading {

                align-items: flex-start;

                flex-direction: column;
            }


            .search-area {

                flex-direction: column;

                align-items: stretch;
            }


            .search-button {

                width: 100%;
            }


            .table-wrapper {

                overflow-x: auto;
            }
        }


    </style>


</head>

<body>

<jsp:include page="admin-sidebar.jsp"/>

<main class="main">

    <jsp:include page="admin-topbar.jsp"/>

    <section class="content">

        <div class="page-heading">

            <div>

                <h1>
                    Audit Logs
                </h1>

                <p>
                    Monitor and review system activities.
                </p>

            </div>

        </div>

        <% if (successMessage != null &&
            !successMessage.trim().isEmpty()) { %>

        <div
                class="alert alert-success"
                id="successAlert">

            <i class="fa-solid fa-circle-check"></i>

            <span>
            <%=successMessage%>
        </span>

        </div>

        <% } %>


        <% if (errorMessage != null &&
            !errorMessage.trim().isEmpty()) { %>

        <div
                class="alert alert-error"
                id="errorAlert">

            <i class="fa-solid fa-circle-exclamation"></i>

            <span>
            <%=errorMessage%>
        </span>

        </div>

        <% } %>

        <div class="stats-grid">

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                    <span class="stat-label">
                        Total Audit Logs
                    </span>

                        <div class="stat-value">

                            <%=totalLogs != null
                                ? totalLogs
                                : 0%>

                        </div>

                    </div>


                    <div class="stat-icon">

                        <i class="fa-solid fa-list-check"></i>

                    </div>

                </div>

            </div>

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                    <span class="stat-label">
                        Today's Activity
                    </span>

                        <div class="stat-value">

                            <%=todayLogs != null
                                ? todayLogs
                                : 0%>

                        </div>

                    </div>


                    <div class="stat-icon">

                        <i class="fa-solid fa-calendar-day"></i>

                    </div>

                </div>

            </div>

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                    <span class="stat-label">
                        Create Actions
                    </span>

                        <div class="stat-value">

                            <%=createLogs != null
                                ? createLogs
                                : 0%>

                        </div>

                    </div>


                    <div class="stat-icon">

                        <i class="fa-solid fa-plus"></i>

                    </div>

                </div>

            </div>

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                    <span class="stat-label">
                        Update Actions
                    </span>

                        <div class="stat-value">

                            <%=updateLogs != null
                                ? updateLogs
                                : 0%>

                        </div>

                    </div>


                    <div class="stat-icon">

                        <i class="fa-solid fa-pen"></i>

                    </div>

                </div>

            </div>

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                    <span class="stat-label">
                        Delete Actions
                    </span>

                        <div class="stat-value">

                            <%=deleteLogs != null
                                ? deleteLogs
                                : 0%>

                        </div>

                    </div>


                    <div class="stat-icon">

                        <i class="fa-solid fa-trash"></i>

                    </div>

                </div>

            </div>


        </div>

        <div class="inventory-panel">

            <div class="panel-header">


                <div>

                    <h2>
                        System Activity
                    </h2>

                    <p>
                        Persistent audit records generated by
                        enterprise operations.
                    </p>

                </div>

                <form
                        class="search-area"
                        method="get"
                        action="<%=request.getContextPath()%>/audit-logs">


                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input
                                type="text"
                                name="search"
                                value="<%=search != null ? search : ""%>"
                                placeholder="Search audit logs...">

                    </div>


                    <button
                            type="submit"
                            class="search-button">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        Search

                    </button>


                </form>

            </div>

            <div class="table-wrapper">

                <table class="audit-table">

                    <thead>

                    <tr>

                        <th>
                            ID
                        </th>

                        <th>
                            Action
                        </th>

                        <th>
                            Entity
                        </th>

                        <th>
                            User
                        </th>

                        <th>
                            Details
                        </th>

                        <th>
                            Timestamp
                        </th>

                    </tr>

                    </thead>


                    <tbody>


                    <% if (auditLogs.isEmpty()) { %>

                    <tr>

                        <td colspan="6">

                            <div class="empty-state">

                                <i class="fa-solid fa-clock-rotate-left"></i>

                                <div>
                                    No audit records found.
                                </div>

                            </div>

                        </td>

                    </tr>


                    <% } else { %>

                    <% for (AuditLog log :
                        auditLogs) { %>


                    <tr>

                        <td>

                        <span class="log-id">

                            #<%=log.getId()%>

                        </span>

                        </td>

                        <td>

                            <%
                                String action =
                                log.getAction();

                                String actionClass =
                                "action-update";


                                if ("CREATE".equalsIgnoreCase(action)) {

                                actionClass =
                                "action-create";

                                } else if (
                                "DELETE".equalsIgnoreCase(action)
                                ) {

                                actionClass =
                                "action-delete";

                                } else if (
                                "OPTIMIZE".equalsIgnoreCase(action)
                                ) {

                                actionClass =
                                "action-optimize";
                                }
                            %>


                            <span
                                    class="action-badge <%=actionClass%>">

                            <%=action%>

                        </span>

                        </td>

                        <td>

                        <span class="entity-badge">

                            <%=log.getEntityType().getName()%>

                            #

                            <%=log.getEntityId()%>

                        </span>

                        </td>

                        <td>

                            <div class="user-cell">


                                <div class="mini-avatar">

                                    <%
                                        String firstInitial =
                                        "?";

                                        String lastInitial =
                                        "?";


                                        if (log.getUser() != null) {

                                        if (log.getUser().getFirstName() != null &&
                                        !log.getUser()
                                        .getFirstName()
                                        .isEmpty()) {

                                        firstInitial =
                                        log.getUser()
                                        .getFirstName()
                                        .substring(0, 1);
                                        }


                                        if (log.getUser().getLastName() != null &&
                                        !log.getUser()
                                        .getLastName()
                                        .isEmpty()) {

                                        lastInitial =
                                        log.getUser()
                                        .getLastName()
                                        .substring(0, 1);
                                        }
                                        }
                                    %>

                                    <%=(
                                        firstInitial +
                                        lastInitial
                                        ).toUpperCase()%>

                                </div>


                                <div>

                                    <strong>

                                        <%
                                            if (log.getUser() != null) {

                                            out.print(
                                            log.getUser()
                                            .getUsername()
                                            );

                                            } else {

                                            out.print(
                                            "System"
                                            );
                                            }
                                        %>

                                    </strong>

                                </div>

                            </div>

                        </td>

                        <td>

                            <div class="details-cell">

                                <%
                                    if (log.getDetails() != null &&
                                    !log.getDetails()
                                    .trim()
                                    .isEmpty()) {

                                    out.print(
                                    log.getDetails()
                                    );

                                    } else {

                                    out.print("-");
                                    }
                                %>

                            </div>

                        </td>

                        <td>

                            <div class="date-cell">

                                <%=log.getTimestamp()%>

                            </div>

                        </td>


                    </tr>


                    <% } %>


                    <% } %>


                    </tbody>

                </table>

            </div>


        </div>


    </section>


</main>

<script>

    setTimeout(function () {

        document
            .querySelectorAll('.alert')
            .forEach(function (element) {

                element.style.transition =
                    'opacity .4s ease';

                element.style.opacity =
                    '0';

                setTimeout(function () {

                    element.remove();

                }, 400);

            });

    }, 5000);

</script>

</body>

</html>
