<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sasindi.globaltrade.entity.Shipment" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("activePage", "dashboard");
%>
<%
    // ============================================================
    // USER DASHBOARD DATA
    // Populated by UserDashboardServlet from real EJB data (your
    // shipments, documents, invoices, tickets). Falls back to safe
    // defaults if a value wasn't set, so this page never breaks.
    // ============================================================

    Object userNameAttr = request.getAttribute("userName");
    String userName = userNameAttr != null ? String.valueOf(userNameAttr) : "User Name";

    Object totalShipmentsAttr = request.getAttribute("totalShipments");
    int totalShipments = totalShipmentsAttr != null ? (Integer) totalShipmentsAttr : 0;

    Object inTransitAttr = request.getAttribute("inTransit");
    int inTransit = inTransitAttr != null ? (Integer) inTransitAttr : 0;

    Object delayedShipmentsAttr = request.getAttribute("delayedShipments");
    int delayedShipments = delayedShipmentsAttr != null ? (Integer) delayedShipmentsAttr : 0;

    Object deliveredShipmentsAttr = request.getAttribute("deliveredShipments");
    int deliveredShipments = deliveredShipmentsAttr != null ? (Integer) deliveredShipmentsAttr : 0;

    Object pendingDocumentsAttr = request.getAttribute("pendingDocuments");
    int pendingDocuments = pendingDocumentsAttr != null ? (Integer) pendingDocumentsAttr : 0;

    Object totalSpentAttr = request.getAttribute("totalSpent");
    String totalSpent = totalSpentAttr != null ? String.valueOf(totalSpentAttr) : "$0.00";

    Object notificationCountAttr = request.getAttribute("notificationCount");
    int notificationCount = notificationCountAttr != null ? (Integer) notificationCountAttr : 0;

    List<Shipment> recentShipments =
            (List<Shipment>) request.getAttribute("recentShipments");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>GlobalTrade | User Dashboard</title>

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


    <style>

        /* ============================================================
           GLOBAL COLORS
           ============================================================ */

        :root {

            --navy: #003049;
            --yellow: #FCBF49;
            --orange: #F77F00;
            --red: #D62828;

            --background: #FFF9E8;
            --card: #FFFFFF;

            --text: #003049;
            --muted: #64748B;

            --border: rgba(0, 48, 73, 0.10);

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


        /* ============================================================
           SIDEBAR
           ============================================================ */

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
        }


        /* ============================================================
           BRAND
           ============================================================ */

        .brand {

            height: 105px;

            display: flex;

            align-items: center;

            padding: 0 22px;

            gap: 12px;

            flex-shrink: 0;
        }


        .brand-logo {

            width: 52px;
            height: 52px;

            border-radius: 13px;

            background: var(--yellow);

            color: var(--navy);

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 23px;

            box-shadow:
                    0 7px 20px rgba(0, 0, 0, .20);
        }


        .brand-title {

            font-size: 20px;

            font-weight: 700;

            letter-spacing: -.4px;
        }


        .brand-subtitle {

            font-size: 11px;

            margin-top: 3px;

            color: rgba(255,255,255,.72);
        }


        /* ============================================================
           SIDEBAR NAVIGATION
           ============================================================ */

        .nav {

            flex: 1;

            padding: 8px 14px 20px;

            overflow-y: auto;

            /*
             * Keep scrolling functionality
             * but hide scrollbar.
             */

            scrollbar-width: none;

            -ms-overflow-style: none;
        }


        .nav::-webkit-scrollbar {
            display: none;
        }


        .nav-item {

            height: 46px;

            display: flex;

            align-items: center;

            gap: 14px;

            padding: 0 15px;

            margin: 4px 0;

            border-radius: 9px;

            color: rgba(255,255,255,.88);

            font-size: 12px;

            transition: .2s ease;
        }


        .nav-item i {

            width: 20px;

            text-align: center;

            font-size: 16px;
        }


        .nav-item:hover {

            background: rgba(255,255,255,.08);

            color: white;
        }


        .nav-item.active {

            background: var(--yellow);

            color: var(--navy);

            font-weight: 700;

            box-shadow:
                    0 7px 18px rgba(252,191,73,.20);
        }


        /* ============================================================
           SUPPORT BOX
           ============================================================ */

        .support-box {

            margin: 14px;

            padding: 17px;

            background: rgba(255,255,255,.07);

            border: 1px solid rgba(255,255,255,.08);

            border-radius: 12px;

            flex-shrink: 0;
        }


        .support-box h3 {

            font-size: 14px;

            margin-bottom: 7px;
        }


        .support-box p {

            color: rgba(255,255,255,.72);

            font-size: 11px;

            line-height: 1.5;

            margin-bottom: 13px;
        }


        .support-button {

            width: 100%;

            height: 37px;

            border: none;

            border-radius: 7px;

            background: var(--yellow);

            color: var(--navy);

            font-size: 11px;

            font-weight: 700;

            cursor: pointer;
        }


        .support-button:hover {

            background: var(--orange);

            color: white;
        }


        /* ============================================================
           MAIN AREA
           ============================================================ */

        .main {

            margin-left: var(--sidebar-width);

            min-height: 100vh;
        }


        /* ============================================================
           TOPBAR
           ============================================================ */

        .topbar {

            height: 70px;

            display: flex;

            align-items: center;

            padding: 0 28px;

            background: rgba(255,255,255,.65);

            border-bottom: 1px solid var(--border);

            gap: 18px;
        }


        .menu-btn {

            width: 35px;
            height: 35px;

            border: none;

            background: transparent;

            color: var(--navy);

            font-size: 19px;

            cursor: pointer;
        }


        .top-actions {

            margin-left: auto;

            display: flex;

            align-items: center;

            gap: 20px;
        }


        .icon-btn {

            position: relative;

            border: none;

            background: transparent;

            color: var(--navy);

            font-size: 17px;

            cursor: pointer;
        }


        .notification-count {

            position: absolute;

            top: -8px;
            right: -8px;

            width: 17px;
            height: 17px;

            border-radius: 50%;

            background: var(--red);

            color: white;

            font-size: 9px;

            display: flex;

            align-items: center;
            justify-content: center;
        }


        .top-user {

            display: flex;

            align-items: center;

            gap: 9px;

            color: var(--navy);

            font-size: 13px;

            font-weight: 600;
        }


        .top-user small {

            display: block;

            font-size: 9px;

            color: var(--muted);

            font-weight: 400;
        }


        .top-avatar {

            width: 38px;
            height: 38px;

            border-radius: 50%;

            background: var(--orange);

            color: white;

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 15px;

            font-weight: 700;
        }
        /* ============================================================
           TOPBAR PAGE INFORMATION
           ============================================================ */

        .topbar-page {

            display: flex;

            align-items: center;

            gap: 9px;
        }


        .topbar-page-title {

            color: var(--navy);

            font-size: 15px;

            font-weight: 700;
        }


        .topbar-page-subtitle {

            color: var(--muted);

            font-size: 10px;

            padding-left: 9px;

            border-left: 1px solid var(--border);
        }

        /* ============================================================
           CONTENT
           ============================================================ */

        .content {

            padding: 20px 25px 18px;
        }


        /* ============================================================
           PAGE HEADING
           ============================================================ */

        .page-heading {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 17px;
        }


        .page-heading h1 {

            color: var(--navy);

            font-size: 24px;

            letter-spacing: -.5px;
        }


        .page-heading p {

            margin-top: 4px;

            font-size: 12px;

            color: var(--muted);
        }


        .date-select {

            height: 38px;

            padding: 0 12px;

            border: 1px solid var(--border);

            border-radius: 7px;

            background: white;

            color: var(--navy);

            font-size: 11px;

            outline: none;
        }


        /* ============================================================
           KPI GRID
           ============================================================ */

        .kpi-grid {

            display: grid;

            grid-template-columns:
                repeat(6, 1fr);

            gap: 12px;

            margin-bottom: 14px;
        }


        .kpi-card {

            min-height: 126px;

            background: var(--card);

            border: 1px solid var(--border);

            border-radius: 11px;

            padding: 14px;

            position: relative;

            overflow: hidden;
        }


        .kpi-top {

            display: flex;

            align-items: center;

            gap: 9px;
        }


        .kpi-icon {

            width: 38px;
            height: 38px;

            border-radius: 9px;

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 15px;
        }


        .kpi-card:nth-child(1) .kpi-icon {

            background: rgba(252,191,73,.25);

            color: var(--orange);
        }


        .kpi-card:nth-child(2) .kpi-icon {

            background: rgba(247,127,0,.15);

            color: var(--orange);
        }


        .kpi-card:nth-child(3) .kpi-icon {

            background: rgba(214,40,40,.12);

            color: var(--red);
        }


        .kpi-card:nth-child(4) .kpi-icon {

            background: rgba(252,191,73,.25);

            color: var(--navy);
        }


        .kpi-card:nth-child(5) .kpi-icon {

            background: rgba(0,48,73,.09);

            color: var(--navy);
        }


        .kpi-card:nth-child(6) .kpi-icon {

            background: rgba(247,127,0,.14);

            color: var(--orange);
        }


        .kpi-title {

            font-size: 10px;

            color: var(--muted);

            font-weight: 600;
        }


        .kpi-number {

            font-size: 24px;

            color: var(--navy);

            font-weight: 700;

            margin-top: 9px;
        }


        .kpi-description {

            font-size: 9px;

            color: var(--muted);

            margin-top: 4px;
        }


        /* ============================================================
           MAIN DASHBOARD GRID
           ============================================================ */

        .dashboard-grid {

            display: grid;

            grid-template-columns:
                1.55fr 1fr;

            gap: 14px;

            margin-bottom: 14px;
        }


        .card {

            background: var(--card);

            border: 1px solid var(--border);

            border-radius: 11px;

            overflow: hidden;
        }


        .card-header {

            height: 52px;

            padding: 0 16px;

            display: flex;

            align-items: center;

            justify-content: space-between;
        }


        .card-header h2 {

            color: var(--navy);

            font-size: 14px;
        }


        .view-all {

            border: none;

            background: transparent;

            color: var(--red);

            font-size: 10px;

            font-weight: 700;

            cursor: pointer;
        }


        .small-select {

            height: 31px;

            border: 1px solid var(--border);

            border-radius: 6px;

            padding: 0 8px;

            background: white;

            color: var(--navy);

            font-size: 10px;

            outline: none;
        }


        /* ============================================================
           STATUS CARD
           ============================================================ */

        .status-content {

            height: 250px;

            display: flex;

            align-items: center;

            padding: 5px 18px 18px;

            gap: 20px;
        }


        .donut-wrap {

            width: 215px;

            height: 215px;

            flex-shrink: 0;
        }


        .status-list {

            list-style: none;

            width: 100%;
        }


        .status-list li {

            display: flex;

            align-items: center;

            margin: 16px 0;

            font-size: 10px;

            color: var(--navy);
        }


        .status-dot {

            width: 8px;
            height: 8px;

            border-radius: 50%;

            margin-right: 8px;

            flex-shrink: 0;
        }


        .status-value {

            margin-left: auto;

            font-weight: 700;

            color: var(--navy);
        }


        /* ============================================================
           TRACKING CARD
           ============================================================ */

        .tracking-content {

            padding: 5px 16px 16px;
        }


        .map {

            height: 205px;

            border-radius: 9px;

            position: relative;

            overflow: hidden;

            background:

                    radial-gradient(
                            circle at 25% 42%,
                            rgba(252,191,73,.20) 0 9%,
                            transparent 10%
                    ),

                    radial-gradient(
                            circle at 62% 40%,
                            rgba(252,191,73,.16) 0 12%,
                            transparent 13%
                    ),

                    radial-gradient(
                            circle at 78% 65%,
                            rgba(252,191,73,.15) 0 9%,
                            transparent 10%
                    ),

                    linear-gradient(
                            180deg,
                            #FFFDF5,
                            #FFF7DC
                    );
        }


        .map-grid {

            position: absolute;

            inset: 0;

            opacity: .3;

            background:

                    repeating-linear-gradient(
                            0deg,
                            transparent 0 28px,
                            rgba(0,48,73,.08) 29px
                    ),

                    repeating-linear-gradient(
                            90deg,
                            transparent 0 38px,
                            rgba(0,48,73,.06) 39px
                    );
        }


        .route {

            position: absolute;

            height: 2px;

            background: var(--red);

            opacity: .9;

            transform-origin: left center;

            border-top: 2px dashed var(--red);
        }


        .route-one {

            width: 160px;

            left: 25%;

            top: 45%;

            transform: rotate(-7deg);
        }


        .route-two {

            width: 145px;

            left: 53%;

            top: 42%;

            transform: rotate(13deg);
        }


        .marker {

            position: absolute;

            width: 29px;
            height: 29px;

            border-radius: 50%;

            display: flex;

            align-items: center;
            justify-content: center;

            color: white;

            font-size: 11px;

            border: 3px solid white;

            box-shadow:
                    0 4px 9px rgba(0,0,0,.16);
        }


        .marker-origin {

            background: var(--navy);

            left: 21%;

            top: 36%;
        }


        .marker-transit {

            background: var(--red);

            left: 51%;

            top: 33%;
        }


        .marker-destination {

            background: var(--yellow);

            color: var(--navy);

            right: 15%;

            top: 43%;
        }


        .location-name {

            position: absolute;

            font-size: 9px;

            color: var(--navy);

            font-weight: 600;

            text-align: center;
        }


        .location-origin {

            left: 17%;

            top: 54%;
        }


        .location-transit {

            left: 47%;

            top: 51%;
        }


        .location-destination {

            right: 9%;

            top: 61%;
        }


        .tracking-progress {

            position: absolute;

            left: 11%;

            right: 11%;

            bottom: 19px;

            height: 4px;

            background: rgba(0,48,73,.15);

            border-radius: 4px;
        }


        .tracking-progress::before {

            content: "";

            display: block;

            width: 74%;

            height: 100%;

            background: linear-gradient(
                    90deg,
                    var(--navy),
                    var(--red)
            );

            border-radius: 4px;
        }


        /* ============================================================
           RECENT SHIPMENTS
           ============================================================ */

        .bottom-grid {

            display: grid;

            grid-template-columns:
                1.65fr .9fr;

            gap: 14px;
        }


        .table-wrap {

            overflow-x: auto;
        }


        table {

            width: 100%;

            border-collapse: collapse;
        }


        th,
        td {

            padding: 9px 13px;

            text-align: left;

            border-top: 1px solid rgba(0,48,73,.07);

            white-space: nowrap;
        }


        th {

            font-size: 9px;

            color: var(--muted);

            background: rgba(252,191,73,.08);

            font-weight: 700;
        }


        td {

            font-size: 9px;

            color: var(--muted);
        }


        td strong {

            color: var(--navy);

            font-weight: 700;
        }


        .status-pill {

            display: inline-flex;

            align-items: center;

            height: 21px;

            padding: 0 8px;

            border-radius: 5px;

            font-size: 8px;

            font-weight: 700;
        }


        .status-transit {

            background: rgba(0,48,73,.10);

            color: var(--navy);
        }


        .status-delayed {

            background: rgba(214,40,40,.10);

            color: var(--red);
        }


        .status-delivered {

            background: rgba(252,191,73,.28);

            color: var(--navy);
        }


        .table-footer {

            padding: 9px 13px;

            border-top: 1px solid rgba(0,48,73,.07);

            font-size: 9px;

            color: var(--muted);
        }


        /* ============================================================
           QUICK ACTIONS
           ============================================================ */

        .quick-actions {

            padding: 2px 13px 13px;

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 9px;
        }


        .quick-action {

            min-height: 92px;

            border: 1px solid var(--border);

            border-radius: 9px;

            background: #FFFDF7;

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;

            gap: 7px;

            color: var(--navy);

            cursor: pointer;

            transition: .2s ease;
        }


        .quick-action:hover {

            transform: translateY(-2px);

            border-color: var(--yellow);

            background: #FFF7D8;
        }


        .quick-action i {

            width: 33px;
            height: 33px;

            border-radius: 50%;

            background: var(--yellow);

            color: var(--navy);

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 13px;
        }


        .quick-action span {

            font-size: 9px;

            font-weight: 700;

            text-align: center;
        }


        /* ============================================================
           ALERTS
           ============================================================ */

        .alert-list {

            padding: 2px 13px 10px;
        }


        .alert-item {

            display: flex;

            align-items: center;

            gap: 9px;

            padding: 9px 0;

            border-bottom: 1px solid rgba(0,48,73,.07);
        }


        .alert-item:last-child {

            border-bottom: none;
        }


        .alert-icon {

            width: 31px;
            height: 31px;

            flex-shrink: 0;

            border-radius: 7px;

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 12px;
        }


        .alert-danger {

            background: rgba(214,40,40,.11);

            color: var(--red);
        }


        .alert-warning {

            background: rgba(247,127,0,.12);

            color: var(--orange);
        }


        .alert-info {

            background: rgba(252,191,73,.20);

            color: var(--navy);
        }


        .alert-text {

            flex: 1;

            min-width: 0;
        }


        .alert-text strong {

            display: block;

            color: var(--navy);

            font-size: 9px;

            margin-bottom: 3px;
        }


        .alert-text span {

            color: var(--muted);

            font-size: 8px;

            line-height: 1.4;
        }


        .alert-time {

            color: var(--muted);

            font-size: 8px;

            white-space: nowrap;
        }


        /* ============================================================
           FOOTER
           ============================================================ */

        .footer {

            margin-top: 14px;

            padding: 11px 0 2px;

            border-top: 1px solid var(--border);

            display: flex;

            justify-content: space-between;

            color: var(--muted);

            font-size: 9px;
        }


        /* ============================================================
           RESPONSIVE
           ============================================================ */

        @media (max-width: 1250px) {

            .kpi-grid {

                grid-template-columns:
                    repeat(3, 1fr);
            }

            .dashboard-grid {

                grid-template-columns:
                    1fr;
            }

            .bottom-grid {

                grid-template-columns:
                    1fr;
            }
        }


        @media (max-width: 900px) {

            :root {

                --sidebar-width: 72px;
            }


            .brand {

                justify-content: center;

                padding: 0;
            }


            .brand-copy {

                display: none;
            }


            .nav-item span {

                display: none;
            }


            .nav-item {

                justify-content: center;

                padding: 0;
            }


            .support-box {

                display: none;
            }


            .kpi-grid {

                grid-template-columns:
                    repeat(2, 1fr);
            }


            .main {

                margin-left:
                        var(--sidebar-width);
            }
        }


        @media (max-width: 650px) {

            .content {

                padding:
                        15px 12px;
            }


            .topbar {

                padding:
                        0 12px;
            }


            .top-user span,
            .top-user small {

                display: none;
            }


            .page-heading {

                align-items:
                        flex-start;

                flex-direction:
                        column;

                gap: 10px;
            }


            .kpi-grid {

                grid-template-columns:
                    1fr;
            }


            .status-content {

                flex-direction:
                        column;

                height: auto;

                padding-bottom: 20px;
            }


            .donut-wrap {

                width: 180px;

                height: 180px;
            }


            .bottom-grid {

                grid-template-columns:
                    1fr;
            }


            .footer {

                flex-direction:
                        column;

                gap: 5px;
            }
        }

    </style>

</head>


<body>


<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<jsp:include page="user-sidebar.jsp"/>


<!-- ============================================================
     MAIN
     ============================================================ -->

<main class="main">


    <!-- ============================================================
         TOP BAR
         ============================================================ -->

    <jsp:include page="user-topbar.jsp"/>


    <!-- ============================================================
         CONTENT
         ============================================================ -->

    <section class="content">


        <!-- ========================================================
             PAGE HEADING
             ======================================================== -->

        <div class="page-heading">


            <div>

                <h1>

                    Welcome back,
                    <%= userName %>! 👋

                </h1>


                <p>

                    Here's an overview of your shipments and activities.

                </p>

            </div>


            <select class="date-select">

                <option>
                    May 21, 2026
                </option>

                <option>
                    May 20, 2026
                </option>

                <option>
                    May 19, 2026
                </option>

            </select>


        </div>


        <!-- ========================================================
             KPI CARDS
             ======================================================== -->

        <div class="kpi-grid">


            <!-- TOTAL SHIPMENTS -->

            <div class="kpi-card">

                <div class="kpi-top">

                    <div class="kpi-icon">

                        <i class="fa-solid fa-box"></i>

                    </div>

                    <div class="kpi-title">
                        Total Shipments
                    </div>

                </div>


                <div class="kpi-number">
                    <%= totalShipments %>
                </div>


                <div class="kpi-description">
                    All time shipments
                </div>

            </div>


            <!-- IN TRANSIT -->

            <div class="kpi-card">

                <div class="kpi-top">

                    <div class="kpi-icon">

                        <i class="fa-solid fa-truck-fast"></i>

                    </div>

                    <div class="kpi-title">
                        In Transit
                    </div>

                </div>


                <div class="kpi-number">
                    <%= inTransit %>
                </div>


                <div class="kpi-description">
                    Currently on the way
                </div>

            </div>


            <!-- DELAYED -->

            <div class="kpi-card">

                <div class="kpi-top">

                    <div class="kpi-icon">

                        <i class="fa-solid fa-clock"></i>

                    </div>

                    <div class="kpi-title">
                        Delayed
                    </div>

                </div>


                <div class="kpi-number">
                    <%= delayedShipments %>
                </div>


                <div class="kpi-description">
                    Require attention
                </div>

            </div>


            <!-- DELIVERED -->

            <div class="kpi-card">

                <div class="kpi-top">

                    <div class="kpi-icon">

                        <i class="fa-solid fa-circle-check"></i>

                    </div>

                    <div class="kpi-title">
                        Delivered
                    </div>

                </div>


                <div class="kpi-number">
                    <%= deliveredShipments %>
                </div>


                <div class="kpi-description">
                    Successfully delivered
                </div>

            </div>


            <!-- DOCUMENTS -->

            <div class="kpi-card">

                <div class="kpi-top">

                    <div class="kpi-icon">

                        <i class="fa-solid fa-file-lines"></i>

                    </div>

                    <div class="kpi-title">
                        Pending Documents
                    </div>

                </div>


                <div class="kpi-number">
                    <%= pendingDocuments %>
                </div>


                <div class="kpi-description">
                    Action required
                </div>

            </div>


            <!-- TOTAL SPENT -->

            <div class="kpi-card">

                <div class="kpi-top">

                    <div class="kpi-icon">

                        <i class="fa-solid fa-wallet"></i>

                    </div>

                    <div class="kpi-title">
                        Total Spent
                    </div>

                </div>


                <div class="kpi-number"
                     style="font-size:21px;">

                    <%= totalSpent %>

                </div>


                <div class="kpi-description">
                    This year
                </div>

            </div>


        </div>


        <!-- ========================================================
             STATUS + TRACKING
             ======================================================== -->

        <div class="dashboard-grid">


            <!-- ====================================================
                 SHIPMENT STATUS
                 ==================================================== -->

            <div class="card">


                <div class="card-header">

                    <h2>
                        Shipment Status Overview
                    </h2>


                    <select class="small-select">

                        <option>
                            This Month
                        </option>

                        <option>
                            Last Month
                        </option>

                        <option>
                            This Year
                        </option>

                    </select>

                </div>


                <div class="status-content">


                    <div class="donut-wrap">

                        <canvas id="shipmentStatusChart"></canvas>

                    </div>


                    <ul class="status-list">


                        <li>

                            <span class="status-dot"
                                  style="background:#003049;">
                            </span>

                            In Transit

                            <span class="status-value">
                                5 (41.7%)
                            </span>

                        </li>


                        <li>

                            <span class="status-dot"
                                  style="background:#FCBF49;">
                            </span>

                            Delivered

                            <span class="status-value">
                                5 (41.7%)
                            </span>

                        </li>


                        <li>

                            <span class="status-dot"
                                  style="background:#F77F00;">
                            </span>

                            Pending

                            <span class="status-value">
                                1 (8.3%)
                            </span>

                        </li>


                        <li>

                            <span class="status-dot"
                                  style="background:#D62828;">
                            </span>

                            Delayed

                            <span class="status-value">
                                1 (8.3%)
                            </span>

                        </li>


                    </ul>


                </div>

            </div>


            <!-- ====================================================
                 LIVE TRACKING
                 ==================================================== -->

            <div class="card">


                <div class="card-header">

                    <h2>
                        Live Shipment Tracking
                    </h2>


                    <button class="view-all"
                            type="button">

                        View all

                    </button>

                </div>


                <div class="tracking-content">


                    <div class="map">


                        <div class="map-grid"></div>


                        <div class="route route-one"></div>

                        <div class="route route-two"></div>


                        <!-- ORIGIN -->

                        <div class="marker marker-origin">

                            <i class="fa-solid fa-ship"></i>

                        </div>


                        <div class="location-name location-origin">

                            Singapore<br>
                            Origin

                        </div>


                        <!-- TRANSIT -->

                        <div class="marker marker-transit">

                            <i class="fa-solid fa-truck"></i>

                        </div>


                        <div class="location-name location-transit">

                            In Transit

                        </div>


                        <!-- DESTINATION -->

                        <div class="marker marker-destination">

                            <i class="fa-solid fa-location-dot"></i>

                        </div>


                        <div class="location-name location-destination">

                            Colombo, Sri Lanka<br>
                            Destination

                        </div>


                        <div class="tracking-progress"></div>


                    </div>


                </div>

            </div>


        </div>


        <!-- ========================================================
             RECENT SHIPMENTS + QUICK ACTIONS
             ======================================================== -->

        <div class="bottom-grid">


            <!-- ====================================================
                 RECENT SHIPMENTS
                 ==================================================== -->

            <div class="card">


                <div class="card-header">

                    <h2>
                        Recent Shipments
                    </h2>


                    <button class="view-all"
                            type="button">

                        View all

                    </button>

                </div>


                <div class="table-wrap">


                    <table>


                        <thead>

                        <tr>

                            <th>
                                Tracking No.
                            </th>

                            <th>
                                Item / Description
                            </th>

                            <th>
                                Origin
                            </th>

                            <th>
                                Destination
                            </th>

                            <th>
                                Status
                            </th>

                            <th>
                                Est. Delivery
                            </th>

                        </tr>

                        </thead>


                        <tbody>

                        <%
                            if (recentShipments == null || recentShipments.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="6" style="text-align:center; color: var(--muted); padding: 30px;">
                                You have no shipments yet.
                                <a href="${pageContext.request.contextPath}/shipments">Request one &rarr;</a>
                            </td>
                        </tr>
                        <%
                        } else {
                            for (Shipment shipment : recentShipments) {

                                String statusName = shipment.getShipmentStatus() != null
                                        ? shipment.getShipmentStatus().getName() : "-";

                                String statusClass = "status-pill status-"
                                        + statusName.toLowerCase().replace(" ", "-");

                                String origin = shipment.getOriginAddress() != null
                                        && shipment.getOriginAddress().getCity() != null
                                        ? shipment.getOriginAddress().getCity().getName() : "-";

                                String destination = shipment.getDestinationAddress() != null
                                        && shipment.getDestinationAddress().getCity() != null
                                        ? shipment.getDestinationAddress().getCity().getName() : "-";

                                String itemName = "-";
                                if (shipment.getShipmentItems() != null
                                        && !shipment.getShipmentItems().isEmpty()
                                        && shipment.getShipmentItems().get(0).getInventory() != null) {
                                    itemName = shipment.getShipmentItems().get(0).getInventory().getProductName();
                                }
                        %>
                        <tr>
                            <td><strong><%= shipment.getTrackingNumber() %></strong></td>
                            <td><%= itemName %></td>
                            <td><%= origin %></td>
                            <td><%= destination %></td>
                            <td><span class="<%= statusClass %>"><%= statusName %></span></td>
                            <td>
                                <%= shipment.getExpectedDelivery() != null
                                        ? shipment.getExpectedDelivery().toLocalDate() : "-" %>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>


                    </table>


                </div>


                <div class="table-footer">

                    Showing 1 to 5 of
                    <%= totalShipments %>
                    shipments

                </div>


            </div>


            <!-- ====================================================
                 QUICK ACTIONS
                 ==================================================== -->

            <div class="card">


                <div class="card-header">

                    <h2>
                        Quick Actions
                    </h2>

                </div>


                <div class="quick-actions">


                    <a href="${pageContext.request.contextPath}/track"
                       class="quick-action">

                        <i class="fa-solid fa-location-dot"></i>

                        <span>
                            Track Shipment
                        </span>

                    </a>


                    <a href="${pageContext.request.contextPath}/orders"
                       class="quick-action">

                        <i class="fa-solid fa-box"></i>

                        <span>
                            My Orders
                        </span>

                    </a>


                    <a href="${pageContext.request.contextPath}/documents"
                       class="quick-action">

                        <i class="fa-solid fa-file-lines"></i>

                        <span>
                            Documents
                        </span>

                    </a>


                    <a href="${pageContext.request.contextPath}/support"
                       class="quick-action">

                        <i class="fa-solid fa-headset"></i>

                        <span>
                            Contact Support
                        </span>

                    </a>


                </div>

            </div>


        </div>


        <!-- ========================================================
             ALERTS
             ======================================================== -->

        <div class="card"
             style="margin-top:14px;">


            <div class="card-header">

                <h2>
                    Recent Alerts
                </h2>


                <button class="view-all"
                        type="button">

                    View all

                </button>

            </div>


            <div class="alert-list">


                <!-- ALERT 1 -->

                <div class="alert-item">


                    <div class="alert-icon alert-danger">

                        <i class="fa-solid fa-triangle-exclamation"></i>

                    </div>


                    <div class="alert-text">

                        <strong>
                            Shipment GT-2026-00127 is delayed
                        </strong>

                        <span>
                            Expected delivery was May 20, 2026
                        </span>

                    </div>


                    <div class="alert-time">
                        10:30 AM
                    </div>

                </div>


                <!-- ALERT 2 -->

                <div class="alert-item">


                    <div class="alert-icon alert-warning">

                        <i class="fa-solid fa-box"></i>

                    </div>


                    <div class="alert-text">

                        <strong>
                            Your shipment is ready for pickup
                        </strong>

                        <span>
                            GT-2026-00128 is ready for the next stage
                        </span>

                    </div>


                    <div class="alert-time">
                        09:15 AM
                    </div>

                </div>


                <!-- ALERT 3 -->

                <div class="alert-item">


                    <div class="alert-icon alert-warning">

                        <i class="fa-solid fa-file-circle-exclamation"></i>

                    </div>


                    <div class="alert-text">

                        <strong>
                            Customs document requires attention
                        </strong>

                        <span>
                            GT-2026-00125 - Commercial Invoice
                        </span>

                    </div>


                    <div class="alert-time">
                        08:45 AM
                    </div>

                </div>


                <!-- ALERT 4 -->

                <div class="alert-item">


                    <div class="alert-icon alert-info">

                        <i class="fa-solid fa-circle-info"></i>

                    </div>


                    <div class="alert-text">

                        <strong>
                            Payment for invoice #INV-2026-045 is pending
                        </strong>

                        <span>
                            Kindly complete the payment
                        </span>

                    </div>


                    <div class="alert-time">
                        Yesterday
                    </div>

                </div>


            </div>


        </div>


        <!-- ========================================================
             FOOTER
             ======================================================== -->

        <footer class="footer">

            <span>
                © 2026 GlobalTrade Logistics System.
                All rights reserved.
            </span>

            <span>
                Version 1.0.0
            </span>

        </footer>


    </section>


</main>


<!-- ============================================================
     CHART JS
     ============================================================ -->

<script>


    /* ============================================================
       SHIPMENT STATUS DOUGHNUT
       ============================================================ */

    const shipmentStatus =
        document.getElementById(
            'shipmentStatusChart'
        );


    new Chart(shipmentStatus, {

        type: 'doughnut',

        data: {

            labels: [

                'In Transit',
                'Delivered',
                'Pending',
                'Delayed'

            ],

            datasets: [{

                data: [

                    5,
                    5,
                    1,
                    1

                ],

                backgroundColor: [

                    '#003049',
                    '#FCBF49',
                    '#F77F00',
                    '#D62828'

                ],

                borderWidth: 0,

                hoverOffset: 5

            }]

        },


        options: {

            responsive: true,

            maintainAspectRatio: false,

            cutout: '67%',


            plugins: {

                legend: {

                    display: false

                }

            }

        }

    });


</script>


</body>

</html>