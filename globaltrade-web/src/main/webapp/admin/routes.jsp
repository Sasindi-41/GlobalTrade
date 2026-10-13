<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="lk.sasindi.globaltrade.entity.RouteOptimization" %>
<%@ page import="lk.sasindi.globaltrade.entity.Shipment" %>
<%@ page import="lk.sasindi.globaltrade.entity.Address" %>
<%!
    private String html(String value) {
        if (value == null) return "";
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String addressText(Address address) {
        if (address == null) return "N/A";
        StringBuilder text = new StringBuilder();

        if (address.getLine1() != null && !address.getLine1().trim().isEmpty()) {
            text.append(address.getLine1().trim());
        }
        if (address.getLine2() != null && !address.getLine2().trim().isEmpty()) {
            if (text.length() > 0) text.append(", ");
            text.append(address.getLine2().trim());
        }
        if (address.getCity() != null && address.getCity().getName() != null) {
            if (text.length() > 0) text.append(", ");
            text.append(address.getCity().getName());
        }
        if (address.getCountry() != null && address.getCountry().getName() != null) {
            if (text.length() > 0) text.append(", ");
            text.append(address.getCountry().getName());
        }
        if (address.getPostalCode() != null && !address.getPostalCode().trim().isEmpty()) {
            if (text.length() > 0) text.append(" - ");
            text.append(address.getPostalCode().trim());
        }
        return text.length() == 0 ? "N/A" : text.toString();
    }
%>


<%
    /*
     * ============================================================
     * CHECK ADMIN SESSION
     * ============================================================
     */

    jakarta.servlet.http.HttpSession adminSession =
            request.getSession(false);

    if (adminSession == null ||
            !Boolean.TRUE.equals(
                    adminSession.getAttribute("authenticated")
            )) {

        response.sendRedirect(
                request.getContextPath() + "/signin"
        );

        return;
    }


    /*
     * ============================================================
     * CHECK ADMIN ROLE
     * ============================================================
     */

    String sessionRole =
            String.valueOf(
                    adminSession.getAttribute("role")
            );

    if (!"ADMIN".equalsIgnoreCase(sessionRole)) {

        response.sendRedirect(
                request.getContextPath() +
                        "/user/dashboard"
        );

        return;
    }


    /*
     * ============================================================
     * SUCCESS / ERROR MESSAGES
     * ============================================================
     */

    String successMessage =
            (String) adminSession.getAttribute(
                    "successMessage"
            );

    if (successMessage != null) {

        adminSession.removeAttribute(
                "successMessage"
        );
    }


    String errorMessage =
            (String) adminSession.getAttribute(
                    "errorMessage"
            );

    if (errorMessage != null) {

        adminSession.removeAttribute(
                "errorMessage"
        );
    }


    /*
     * ============================================================
     * ADMIN USER
     * ============================================================
     *
     * Shipment.jsp uses the administrator information for the
     * top/profile area.
     *
     * ============================================================
     */

    lk.sasindi.globaltrade.entity.User user =
            (lk.sasindi.globaltrade.entity.User)
                    request.getAttribute("user");

    if (user == null) {

        response.sendError(
                jakarta.servlet.http.HttpServletResponse.SC_NOT_FOUND,
                "Administrator profile could not be loaded."
        );

        return;
    }


    /*
     * ============================================================
     * USER DATA
     * ============================================================
     */

    String username =
            user.getUsername() != null
                    ? user.getUsername()
                    : "";

    String firstName =
            user.getFirstName() != null
                    ? user.getFirstName()
                    : "";

    String lastName =
            user.getLastName() != null
                    ? user.getLastName()
                    : "";


    String displayName;

    if (!firstName.isEmpty() ||
            !lastName.isEmpty()) {

        displayName =
                (firstName + " " + lastName).trim();

    } else {

        displayName = username;
    }


    /*
     * ============================================================
     * AVATAR
     * ============================================================
     */

    String avatarLetter =
            !displayName.isEmpty()
                    ? displayName.substring(0, 1).toUpperCase()
                    : "A";


    /*
     * ============================================================
     * NOTIFICATIONS
     * ============================================================
     */

    int notificationCount = 0;


    /*
     * ============================================================
     * DATA FROM SERVLET
     * ============================================================
     */

    List<RouteOptimization> routes =
            (List<RouteOptimization>)
                    request.getAttribute("routes");

    if (routes == null) {
        routes = new ArrayList<>();
    }


    List<Shipment> shipments =
            (List<Shipment>)
                    request.getAttribute("shipments");

    if (shipments == null) {
        shipments = new ArrayList<>();
    }


    /*
     * ============================================================
     * STATISTICS
     * ============================================================
     */

    int totalRoutes =
            routes.size();

    double totalScore = 0;

    double totalDistance = 0;

    int totalDuration = 0;

    for (RouteOptimization route : routes) {

        if (route.getOptimizationScore() != null) {

            totalScore +=
                    route.getOptimizationScore()
                            .doubleValue();
        }

        if (route.getEstimatedDistance() != null) {

            totalDistance +=
                    route.getEstimatedDistance()
                            .doubleValue();
        }

        totalDuration +=
                route.getEstimatedDuration();
    }


    double averageScore =
            totalRoutes > 0
                    ? totalScore / totalRoutes
                    : 0;


    double averageDistance =
            totalRoutes > 0
                    ? totalDistance / totalRoutes
                    : 0;


    int averageDuration =
            totalRoutes > 0
                    ? totalDuration / totalRoutes
                    : 0;


    List<Address> addresses =
            (List<Address>) request.getAttribute("addresses");

    if (addresses == null) {
        addresses = java.util.Collections.emptyList();
    }

    List<lk.sasindi.globaltrade.entity.Country> countries =
            (List<lk.sasindi.globaltrade.entity.Country>)
                    request.getAttribute("countries");

    if (countries == null) {
        countries = java.util.Collections.emptyList();
    }

    List<lk.sasindi.globaltrade.entity.City> cities =
            (List<lk.sasindi.globaltrade.entity.City>)
                    request.getAttribute("cities");

    if (cities == null) {
        cities = java.util.Collections.emptyList();
    }


%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        GlobalTrade | Route Optimization
    </title>


    <!-- ============================================================
         FONT AWESOME
         ============================================================ -->

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- ============================================================
         EXISTING GLOBALTRADE ADMIN CSS
         SAME AS SHIPMENT.JSP
         ============================================================ -->

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/admin.css">


    <style>

        /* ============================================================
           GLOBAL VARIABLES
           SAME DESIGN AS SHIPMENT.JSP
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

            --soft-yellow: #FFF3CD;

            --green: #28A745;

            --blue: #2563EB;

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
        select,
        textarea {

            font-family: inherit;
        }


        /* ============================================================
           MAIN
           ============================================================ */

        /* ============================================================
   MAIN
   ============================================================ */

        .main {

            margin-left:
                    var(--sidebar-width);

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

            background:
                    var(--card);

            border-bottom:
                    1px solid var(--border);

            gap: 15px;

            position: relative;

            z-index: 900;
        }


        /* ============================================================
           MENU BUTTON
           ============================================================ */

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


        /* ============================================================
           TOPBAR SEARCH
           ============================================================ */

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
                    1px solid #F8E4A9;

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

            color:
                    #94A3B8;
        }


        /* ============================================================
           TOP ACTIONS
           ============================================================ */

        .top-actions {

            margin-left: auto;

            display: flex;

            align-items: center;

            gap: 16px;
        }


        /* ============================================================
           TOP ICON BUTTON
           ============================================================ */

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


        /* ============================================================
           NOTIFICATION COUNT
           ============================================================ */

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


        /* ============================================================
           TOP USER
           ============================================================ */

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


        /* ============================================================
           TOP AVATAR
           ============================================================ */

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


        /* ============================================================
           CONTENT
           ============================================================ */

        .content {

            padding:
                    20px 25px 18px;
        }


        /* ============================================================
           PAGE HEADER
           ============================================================ */

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

            letter-spacing: -.5px;
        }


        .page-heading p {

            margin-top: 4px;

            font-size: 12px;

            color:
                    var(--muted);
        }


        /* ============================================================
           BUTTONS
           ============================================================ */

        .btn {

            height: 38px;

            padding:
                    0 15px;

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

            transition:
                    .2s ease;
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

            background:
                    white;

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


        /* ============================================================
           STATISTICS
           ============================================================ */

        .stats-grid {

            display: grid;

            grid-template-columns:
                    repeat(4, 1fr);

            gap: 12px;

            margin-bottom: 14px;
        }


        .stat-card {

            background:
                    var(--card);

            border:
                    1px solid var(--border);

            border-radius: 11px;

            padding: 15px;

            display: flex;

            align-items: center;

            gap: 12px;
        }


        .stat-icon {

            width: 42px;

            height: 42px;

            border-radius: 9px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                    rgba(252,191,73,.20);

            color:
                    var(--orange);

            font-size: 15px;

            flex-shrink: 0;
        }


        .stat-text {

            min-width: 0;
        }


        .stat-label {

            display: block;

            color:
                    var(--muted);

            font-size: 9px;

            margin-bottom: 4px;
        }


        .stat-value {

            color:
                    var(--navy);

            font-size: 19px;

            font-weight: 700;
        }


        .stat-unit {

            color:
                    var(--muted);

            font-size: 8px;

            margin-left: 3px;
        }


        /* ============================================================
           MAIN CARD
           ============================================================ */

        .card {

            background:
                    var(--card);

            border:
                    1px solid var(--border);

            border-radius: 11px;

            overflow: hidden;
        }


        .card-header {

            min-height: 52px;

            padding:
                    10px 16px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            border-bottom:
                    1px solid rgba(0,48,73,.06);

            gap: 10px;
        }


        .card-header h2 {

            color:
                    var(--navy);

            font-size: 14px;
        }


        .card-header-right {

            display: flex;

            align-items: center;

            gap: 8px;
        }


        /* ============================================================
           FILTER AREA
           ============================================================ */

        .filter-area {

            padding:
                    13px 16px;

            border-bottom:
                    1px solid rgba(0,48,73,.06);

            display: grid;

            grid-template-columns:
                    1.5fr .9fr auto;

            gap: 9px;

            background:
                    #FFFDF7;
        }


        .filter-input {

            height: 35px;

            border:
                    1px solid var(--border);

            border-radius: 7px;

            background:
                    white;

            color:
                    var(--navy);

            font-size: 10px;

            padding:
                    0 10px;

            outline: none;

            width: 100%;
        }


        .filter-input:focus {

            border-color:
                    var(--yellow);

            box-shadow:
                    0 0 0 3px
                    rgba(252,191,73,.10);
        }


        .filter-select {

            height: 35px;

            border:
                    1px solid var(--border);

            border-radius: 7px;

            background:
                    white;

            color:
                    var(--navy);

            font-size: 10px;

            padding:
                    0 10px;

            outline: none;

            width: 100%;
        }


        .filter-select:focus {

            border-color:
                    var(--yellow);

            box-shadow:
                    0 0 0 3px
                    rgba(252,191,73,.10);
        }


        /* ============================================================
           TABLE
           ============================================================ */

        .table-wrapper {

            width: 100%;

            overflow-x: auto;
        }


        .route-table {

            width: 100%;

            border-collapse: collapse;

            min-width: 1050px;
        }


        .route-table thead {

            background:
                    #FFF9E8;
        }


        .route-table th {

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
                    1px solid var(--border);

            white-space: nowrap;
        }


        .route-table td {

            padding:
                    13px 14px;

            color:
                    var(--navy);

            font-size: 10px;

            border-bottom:
                    1px solid rgba(0,48,73,.06);

            vertical-align: middle;
        }


        .route-table tbody tr {

            transition:
                    .15s ease;
        }


        .route-table tbody tr:hover {

            background:
                    #FFFDF5;
        }


        .route-table tbody tr:last-child td {

            border-bottom: none;
        }


        /* ============================================================
           ROUTE ID
           ============================================================ */

        .route-id {

            color:
                    var(--orange);

            font-weight: 700;

            font-size: 10px;
        }


        .route-date {

            display: block;

            color:
                    var(--muted);

            font-size: 8px;

            margin-top: 3px;
        }


        /* ============================================================
           SHIPMENT
           ============================================================ */

        .shipment-reference {

            font-weight: 700;

            color:
                    var(--navy);

            display: block;
        }


        .shipment-id {

            display: block;

            color:
                    var(--muted);

            font-size: 8px;

            margin-top: 3px;
        }


        /* ============================================================
           LOCATION
           ============================================================ */

        .location {

            display: flex;

            align-items: center;

            gap: 7px;
        }


        .location i {

            color:
                    var(--orange);

            font-size: 10px;
        }


        .destination-icon {

            color:
                    var(--red) !important;
        }


        .location-text {

            max-width: 160px;

            overflow: hidden;

            text-overflow: ellipsis;

            white-space: nowrap;
        }


        /* ============================================================
           DISTANCE
           ============================================================ */

        .distance-value {

            font-weight: 700;

            color:
                    var(--navy);
        }


        .distance-unit {

            color:
                    var(--muted);

            font-size: 8px;
        }


        /* ============================================================
           DURATION
           ============================================================ */

        .duration-value {

            font-weight: 700;

            color:
                    var(--navy);
        }


        .duration-unit {

            color:
                    var(--muted);

            font-size: 8px;
        }


        /* ============================================================
           OPTIMIZATION SCORE
           ============================================================ */

        .score-wrapper {

            min-width: 100px;
        }


        .score-top {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 5px;
        }


        .score-value {

            font-weight: 700;

            color:
                    var(--navy);
        }


        .score-label {

            color:
                    var(--muted);

            font-size: 8px;
        }


        .score-bar {

            width: 100%;

            height: 6px;

            border-radius: 10px;

            background:
                    #E2E8F0;

            overflow: hidden;
        }


        .score-fill {

            height: 100%;

            border-radius: 10px;

            background:
                    var(--orange);
        }


        .score-high {

            background:
                    var(--green);
        }


        .score-medium {

            background:
                    var(--yellow);
        }


        .score-low {

            background:
                    var(--red);
        }


        /* ============================================================
           RECOMMENDED ROUTE
           ============================================================ */

        .recommended-route {

            max-width: 260px;

            color:
                    var(--muted);

            font-size: 9px;

            line-height: 1.5;

            display: -webkit-box;

            -webkit-line-clamp: 2;

            -webkit-box-orient: vertical;

            overflow: hidden;
        }


        /* ============================================================
           ACTION BUTTONS
           ============================================================ */

        .action-buttons {

            display: flex;

            align-items: center;

            gap: 5px;
        }


        .action-btn {

            width: 30px;

            height: 30px;

            border:
                    1px solid var(--border);

            border-radius: 6px;

            background:
                    white;

            color:
                    var(--navy);

            display: flex;

            align-items: center;

            justify-content: center;

            cursor: pointer;

            transition:
                    .2s ease;
        }


        .action-btn:hover {

            border-color:
                    var(--yellow);

            color:
                    var(--orange);

            background:
                    #FFFDF5;
        }


        .action-btn.delete:hover {

            border-color:
                    rgba(214,40,40,.25);

            color:
                    var(--red);

            background:
                    rgba(214,40,40,.04);
        }


        /* ============================================================
           EMPTY STATE
           ============================================================ */

        .empty-state {

            padding:
                    55px 20px;

            text-align: center;

            display: none;
        }


        .empty-state i {

            font-size: 35px;

            color:
                    #CBD5E1;

            margin-bottom: 12px;
        }


        .empty-state h3 {

            color:
                    var(--navy);

            font-size: 14px;

            margin-bottom: 5px;
        }


        .empty-state p {

            color:
                    var(--muted);

            font-size: 10px;
        }


        /* ============================================================
           TABLE FOOTER
           ============================================================ */

        .table-footer {

            min-height: 55px;

            padding:
                    10px 16px;

            border-top:
                    1px solid rgba(0,48,73,.06);

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


        /* ============================================================
    GLOBAL MODAL OVERLAY
    ============================================================ */

        .modal-overlay {
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;

            display: none;

            align-items: center;
            justify-content: center;

            padding: 20px;

            background: rgba(0, 48, 73, 0.45);

            z-index: 9999;
        }

        .modal-overlay.show {
            display: flex;
        }


        /* ============================================================
           ROUTE MODAL
           ============================================================ */

        .route-modal {
            width: 100%;
            max-width: 720px;

            max-height: 90vh;
            overflow-y: auto;

            background: #ffffff;

            border-radius: 12px;

            box-shadow:
                    0 20px 50px rgba(0, 0, 0, 0.18);

            animation: routeModalIn 0.2s ease;
        }

        @keyframes routeModalIn {
            from {
                opacity: 0;
                transform: translateY(10px) scale(0.98);
            }

            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }


        /* ============================================================
           MODAL HEADER
           ============================================================ */

        .modal-header {
            min-height: 58px;

            padding: 0 18px;

            display: flex;
            align-items: center;
            justify-content: space-between;

            border-bottom: 1px solid var(--border);
        }

        .modal-header h2 {
            margin: 0;

            display: flex;
            align-items: center;

            color: var(--navy);

            font-size: 15px;
            font-weight: 700;
        }

        .modal-close {
            width: 30px;
            height: 30px;

            border: none;

            background: transparent;

            color: var(--muted);

            cursor: pointer;

            font-size: 15px;

            border-radius: 6px;

            display: flex;
            align-items: center;
            justify-content: center;

            transition: 0.2s ease;
        }

        .modal-close:hover {
            background: #FFF3F0;
            color: var(--red);
        }


        /* ============================================================
           MODAL BODY
           ============================================================ */

        .modal-body {
            padding: 18px;
        }


        /* ============================================================
           FORM GRID
           ============================================================ */

        .form-grid {
            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 14px;
        }

        .form-group {
            min-width: 0;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }


        /* ============================================================
           FORM LABEL
           ============================================================ */

        .form-label {
            display: block;

            margin-bottom: 6px;

            color: var(--muted);

            font-size: 9px;
            font-weight: 600;
        }


        /* ============================================================
           FORM INPUT
           ============================================================ */

        .form-input {
            width: 100%;
            height: 38px;

            padding: 0 11px;

            border: 1px solid var(--border);

            border-radius: 7px;

            background: #FFFDF7;

            color: var(--navy);

            font-size: 10px;

            outline: none;

            transition: 0.2s ease;
        }

        .form-input:focus {
            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252, 191, 73, 0.10);
        }


        /* ============================================================
           FORM SELECT
           ============================================================ */

        .form-select {
            width: 100%;
            height: 38px;

            padding: 0 11px;

            border: 1px solid var(--border);

            border-radius: 7px;

            background: #FFFDF7;

            color: var(--navy);

            font-size: 10px;

            outline: none;

            transition: 0.2s ease;
        }

        .form-select:focus {
            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252, 191, 73, 0.10);
        }


        /* ============================================================
           ROUTE SELECTOR
           Shipment / Origin / Destination
           ============================================================ */

        .selector-field {
            display: flex;

            width: 100%;
            height: 38px;

            border: 1px solid var(--border);

            border-radius: 7px;

            background: #FFFDF7;

            overflow: hidden;

            transition: 0.2s ease;
        }

        .selector-field:focus-within {
            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252, 191, 73, 0.10);
        }


        /* ============================================================
           SELECTOR DISPLAY
           ============================================================ */

        .selector-display {
            flex: 1;

            min-width: 0;

            border: none;
            outline: none;

            background: transparent;

            color: var(--navy);

            padding: 0 11px;

            font-size: 10px;

            display: flex;
            align-items: center;

            overflow: hidden;

            text-overflow: ellipsis;

            white-space: nowrap;

            cursor: default;
        }

        .selector-display.placeholder {
            color: #94A3B8;

            font-weight: 400;
        }

        .selector-display.selected {
            color: var(--navy);

            font-weight: 600;
        }


        /* ============================================================
           SELECTOR BUTTON
           ============================================================ */

        .selector-button {
            width: 75px;

            flex-shrink: 0;

            border: none;

            border-left: 1px solid var(--border);

            background: #FFF9E8;

            color: var(--orange);

            font-size: 9px;

            font-weight: 700;

            cursor: pointer;

            display: flex;
            align-items: center;
            justify-content: center;

            gap: 5px;

            transition: 0.2s ease;
        }

        .selector-button:hover {
            background: var(--yellow);

            color: var(--navy);
        }

        .selector-button:active {
            transform: scale(0.98);
        }


        /* ============================================================
           SELECTED INFO
           ============================================================ */

        .selected-info {
            margin-top: 5px;

            display: flex;
            align-items: center;

            gap: 5px;

            color: var(--green);

            font-size: 8px;
            font-weight: 600;
        }


        /* ============================================================
           INFO BOX
           ============================================================ */

        .info-box {
            display: flex;
            align-items: flex-start;

            gap: 8px;

            padding: 10px 12px;

            border-radius: 7px;

            background: #F4F7F9;

            color: var(--muted);

            font-size: 9px;

            line-height: 1.5;
        }

        .info-box i {
            color: var(--orange);

            margin-top: 1px;
        }


        /* ============================================================
           MODAL FOOTER
           ============================================================ */

        .modal-footer {
            padding: 12px 18px;

            display: flex;
            align-items: center;
            justify-content: flex-end;

            gap: 8px;

            border-top: 1px solid var(--border);
        }


        /* ============================================================
           BODY LOCK WHEN MODAL IS OPEN
           ============================================================ */

        body.modal-open {
            overflow: hidden;
        }


        /* ============================================================
           ADDRESS MODAL
           ============================================================ */

        .address-overlay {
            position: fixed;
            inset: 0;

            display: none;

            align-items: center;
            justify-content: center;

            padding: 20px;

            background: rgba(0, 48, 73, 0.45);

            z-index: 12000;
        }

        .address-overlay.show {
            display: flex;
        }

        .address-modal {
            width: min(520px, 100%);

            max-height: 90vh;
            overflow-y: auto;

            background: #ffffff;

            border-radius: 10px;

            box-shadow:
                    0 20px 50px rgba(0, 0, 0, 0.20);
        }

        .address-modal-header {
            min-height: 58px;

            padding: 0 18px;

            display: flex;
            align-items: center;
            justify-content: space-between;

            border-bottom: 1px solid var(--border);
        }

        .address-modal-header h2 {
            margin: 0;

            display: flex;
            align-items: center;

            gap: 8px;

            color: var(--navy);

            font-size: 15px;
        }

        .address-modal-header h2 i {
            color: var(--orange);
        }

        .address-modal-body {
            padding: 18px;
        }

        .address-form-group {
            margin-bottom: 12px;
        }

        .address-form-group label {
            display: block;

            margin-bottom: 5px;

            color: var(--navy);

            font-size: 9px;
            font-weight: 700;
        }

        .address-form-group label span {
            color: var(--muted);

            font-weight: 400;
        }

        .address-form-group input,
        .address-form-group select {
            width: 100%;
            height: 37px;

            border: 1px solid var(--border);

            border-radius: 7px;

            padding: 0 10px;

            outline: none;

            background: #ffffff;

            color: var(--navy);

            font-size: 10px;
        }

        .address-form-group input:focus,
        .address-form-group select:focus {
            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252, 191, 73, 0.10);
        }


        /* ============================================================
           RESPONSIVE
           ============================================================ */

        @media (max-width: 700px) {

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full {
                grid-column: auto;
            }

            .route-modal {
                max-height: 95vh;

                border-radius: 10px;
            }

            .modal-body {
                padding: 14px;
            }

            .modal-footer {
                padding: 12px 14px;
            }
        }


        @media (max-width: 900px) {

            :root {

                --sidebar-width: 70px;
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


            .stats-grid {

                grid-template-columns:
                        1fr;
            }


            .filter-area {

                grid-template-columns:
                        1fr;
            }


            .form-grid {

                grid-template-columns:
                        1fr;
            }


            .form-group.full {

                grid-column:
                        auto;
            }


            .page-heading {

                align-items:
                        flex-start;

                flex-direction:
                        column;
            }


            .page-heading .btn {

                width:
                        100%;
            }


            .footer {

                flex-direction:
                        column;

                gap: 5px;
            }


            /* ============================================================
   TOAST MESSAGES
   ============================================================ */

            .success-toast,
            .error-toast {
                position: fixed;

                top: 82px;
                right: 25px;

                min-width: 320px;
                max-width: 460px;

                padding: 14px 16px;

                display: flex;
                align-items: center;

                gap: 11px;

                border-radius: 9px;

                font-size: 11px;
                font-weight: 600;

                box-shadow:
                        0 8px 25px rgba(0, 0, 0, 0.15);

                z-index: 99999;

                animation:
                        toastSlideIn 0.35s ease forwards;
            }

            /* SUCCESS */

            .success-toast {
                background: #EAF8EF;
                border: 1px solid #B7E4C7;
                color: #1E7A3E;
            }

            .success-toast > i:first-child {
                color: #28A745;
                font-size: 16px;
                flex-shrink: 0;
            }

            /* ERROR */

            .error-toast {
                background: #FFF0F0;
                border: 1px solid #F3B7B7;
                color: #B42318;
            }

            .error-toast > i:first-child {
                color: #D62828;
                font-size: 16px;
                flex-shrink: 0;
            }

            /* MESSAGE */

            .success-toast span,
            .error-toast span {
                flex: 1;
                line-height: 1.5;
            }

            /* CLOSE BUTTON */

            .toast-close {
                width: 25px;
                height: 25px;

                border: none;
                background: transparent;

                display: flex;
                align-items: center;
                justify-content: center;

                color: inherit;

                cursor: pointer;

                border-radius: 5px;

                flex-shrink: 0;

                transition: .2s ease;
            }

            .toast-close:hover {
                background: rgba(0, 0, 0, 0.07);
            }

            /* ENTER ANIMATION */

            @keyframes toastSlideIn {

                from {
                    opacity: 0;
                    transform: translateX(35px);
                }

                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            /* EXIT ANIMATION */

            .toast-hide {
                animation:
                        toastSlideOut 0.3s ease forwards;
            }

            @keyframes toastSlideOut {

                from {
                    opacity: 1;
                    transform: translateX(0);
                }

                to {
                    opacity: 0;
                    transform: translateX(35px);
                }
            }

            /* MOBILE */

            @media (max-width: 650px) {

                .success-toast,
                .error-toast {
                    top: 75px;
                    left: 12px;
                    right: 12px;

                    min-width: 0;
                    max-width: none;

                    width: auto;
                }
            }

        }
        /* ============================================================
   GLOBALTRADE ADMIN SIDEBAR
   SAME DESIGN AS SHIPMENT.JSP / ALERTS.JSP
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

            overflow-y: auto;

            box-shadow:
                    2px 0 10px rgba(0, 0, 0, 0.08);
        }


        /* ============================================================
           BRAND
           ============================================================ */

        .brand {

            height: 75px;

            display: flex;

            align-items: center;

            padding: 0 18px;

            gap: 10px;

            border-bottom:
                    1px solid rgba(255,255,255,.08);

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

            color: rgba(255,255,255,.65);

            font-size: 9px;

            margin-top: 3px;
        }


        /* ============================================================
           NAVIGATION
           ============================================================ */

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

            color: rgba(255,255,255,.75);

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


        /* ============================================================
           SIDEBAR SCROLLBAR
           ============================================================ */

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


        /* ============================================================
           BADGE
           ============================================================ */

        .badge {

            margin-left: auto;

            min-width: 18px;

            height: 18px;

            padding: 0 5px;

            border-radius: 10px;

            background:
                    var(--red);

            color: white;

            font-size: 8px;

            display: flex;

            align-items: center;

            justify-content: center;

            font-weight: 700;
        }


        /* ============================================================
           ADMIN PROFILE
           ============================================================ */

        .profile-mini {

            padding: 12px;

            border-top:
                    1px solid rgba(255,255,255,.08);

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

        /* ============================================================
   RESPONSIVE ADMIN LAYOUT
   SAME AS SHIPMENT / ALERTS
   ============================================================ */

        @media (max-width: 900px) {

            :root {

                --sidebar-width: 70px;
            }


            .brand {

                justify-content: center;

                padding: 0;
            }


            .brand-copy,
            .nav-item span,
            .nav-section,
            .nav-item .chevron,
            .badge,
            .profile-copy {

                display: none;
            }


            .nav-item {

                justify-content: center;

                padding: 0;
            }


            .profile-mini {

                justify-content: center;

                padding: 9px;
            }


            .main {

                margin-left:
                        var(--sidebar-width);
            }


            .search {

                width: 210px;
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

                gap: 10px;
            }


            .search {

                display: none;
            }


            .top-user > span {

                display: none;
            }


            .top-user > i {

                display: none;
            }
        }



        /* ============================================================
           ROUTE ACTIONS
           ============================================================ */

        .route-actions {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        .route-actions form {
            margin: 0;
            padding: 0;
        }

        .route-action-btn {
            width: 28px;
            height: 28px;
            border: 1px solid var(--border);
            border-radius: 6px;
            background: white;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 9px;
            transition: .2s ease;
        }

        .route-action-btn.edit {
            color: var(--blue);
        }

        .route-action-btn.delete {
            color: var(--red);
        }

        .route-action-btn.optimize {
            color: var(--orange);
        }

        .route-action-btn:hover {
            color: white;
            transform: translateY(-1px);
        }

        .route-action-btn.edit:hover {
            background: var(--blue);
            border-color: var(--blue);
        }

        .route-action-btn.delete:hover {
            background: var(--red);
            border-color: var(--red);
        }

        .route-action-btn.optimize:hover {
            background: var(--orange);
            border-color: var(--orange);
        }

        /* ============================================================
           ADD ADDRESS MODAL
           Same visual language as shipment.jsp
           ============================================================ */

        .selection-footer {
            min-height: 54px;
            padding: 10px 16px;
            border-top: 1px solid rgba(0,48,73,.06);
            display: flex;
            align-items: center;
            justify-content: flex-end;
            background: #FFFDF7;
        }

        .selection-add-button {
            height: 30px;
            padding: 0 10px;
            border: 1px solid var(--orange);
            border-radius: 6px;
            background: #FFF9E8;
            color: var(--orange);
            font-size: 8px;
            font-weight: 700;
            cursor: pointer;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .selection-add-button:hover {
            background: var(--orange);
            color: white;
        }

        .address-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,.45);
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
            z-index: 12000;
        }

        .address-overlay.show {
            display: flex;
        }

        .address-modal {
            width: min(520px, 100%);
            max-height: 90vh;
            overflow-y: auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 20px 50px rgba(0,0,0,.20);
        }

        .address-modal-header {
            min-height: 58px;
            padding: 0 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border);
        }

        .address-modal-header h2 {
            color: var(--navy);
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .address-modal-header h2 i {
            color: var(--orange);
        }

        .address-modal-body {
            padding: 18px;
        }

        .address-form-group {
            margin-bottom: 12px;
        }

        .address-form-group label {
            display: block;
            margin-bottom: 5px;
            color: var(--navy);
            font-size: 9px;
            font-weight: 700;
        }

        .address-form-group label span {
            color: var(--muted);
            font-weight: 400;
        }

        .address-form-group input,
        .address-form-group select {
            width: 100%;
            height: 37px;
            border: 1px solid var(--border);
            border-radius: 7px;
            padding: 0 10px;
            outline: none;
            background: white;
            color: var(--navy);
            font-size: 10px;
        }

        .address-form-group input:focus,
        .address-form-group select:focus {
            border-color: var(--yellow);
            box-shadow: 0 0 0 3px rgba(252,191,73,.10);
        }

        @media (max-width: 900px) {
            .route-actions {
                flex-wrap: wrap;
            }
        }

    </style>

</head>


<body>

<!-- ============================================================
     TOAST MESSAGES
     ============================================================ -->

<%
    if (successMessage != null && !successMessage.trim().isEmpty()) {
%>

<div class="success-toast"
     id="successToast"
     role="alert">

    <i class="fa-solid fa-circle-check"></i>

    <span>
        <%= html(successMessage) %>
    </span>

    <button type="button"
            class="toast-close"
            onclick="closeToast('successToast')"
            aria-label="Close notification">

        <i class="fa-solid fa-xmark"></i>

    </button>

</div>

<%
    }

    if (errorMessage != null && !errorMessage.trim().isEmpty()) {
%>

<div class="error-toast"
     id="errorToast"
     role="alert">

    <i class="fa-solid fa-circle-exclamation"></i>

    <span>
        <%= html(errorMessage) %>
    </span>

    <button type="button"
            class="toast-close"
            onclick="closeToast('errorToast')"
            aria-label="Close notification">

        <i class="fa-solid fa-xmark"></i>

    </button>

</div>

<%
    }
%>
<!-- ============================================================
     SIDEBAR
     EXACT SAME COMPONENT USED BY SHIPMENT.JSP
     ============================================================ -->

<jsp:include page="admin-sidebar.jsp"/>


<!-- ============================================================
     MAIN
     ============================================================ -->

<main class="main">


    <!-- ========================================================
         TOPBAR
         EXACT SAME COMPONENT USED BY SHIPMENT.JSP
         ======================================================== -->

    <jsp:include page="admin-topbar.jsp"/>


    <!-- ========================================================
         CONTENT
         ======================================================== -->

    <section class="content">


        <!-- ====================================================
             PAGE HEADING
             ==================================================== -->

        <div class="page-heading">

            <div>

                <h1>
                    Route Optimization
                </h1>

                <p>
                    Calculate, monitor and manage optimized
                    shipment routes.
                </p>

            </div>


            <button
                    class="btn btn-primary"
                    type="button"
                    id="openRouteButton"
                    onclick="openCreateRouteModal()">

                <i class="fa-solid fa-route"></i>
                Optimize Route
            </button>



        </div>


        <!-- ====================================================
             STATISTICS
             ==================================================== -->

        <div class="stats-grid">


            <!-- TOTAL ROUTES -->

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-route"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Total Optimized Routes
                    </span>

                    <span class="stat-value">
                        <%= totalRoutes %>
                    </span>

                </div>

            </div>


            <!-- AVERAGE SCORE -->

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-chart-line"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Average Optimization Score
                    </span>

                    <span class="stat-value">

                        <%= String.format("%.1f", averageScore) %>

                        <span class="stat-unit">
                            %
                        </span>

                    </span>

                </div>

            </div>


            <!-- AVERAGE DISTANCE -->

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-road"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Average Distance
                    </span>

                    <span class="stat-value">

                        <%= String.format("%.1f", averageDistance) %>

                        <span class="stat-unit">
                            km
                        </span>

                    </span>

                </div>

            </div>


            <!-- AVERAGE DURATION -->

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-clock"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Average Duration
                    </span>

                    <span class="stat-value">

                        <%= averageDuration %>

                        <span class="stat-unit">
                            min
                        </span>

                    </span>

                </div>

            </div>

        </div>


        <!-- ====================================================
             ROUTE TABLE CARD
             ==================================================== -->

        <div class="card">


            <!-- CARD HEADER -->

            <div class="card-header">

                <h2>
                    All Optimized Routes
                </h2>


                <div class="card-header-right">

                    <button class="btn btn-secondary"
                            type="button"
                            onclick="resetFilters()"
                            style="height:32px;padding:0 10px;">

                        <i class="fa-solid fa-rotate"></i>

                        Reset

                    </button>

                </div>

            </div>


            <!-- =================================================
                 FILTER AREA
                 ================================================= -->

            <div class="filter-area">


                <!-- SEARCH -->

                <div>

                    <input type="text"
                           class="filter-input"
                           id="routeSearch"
                           placeholder="Search shipment, origin, destination or route..."
                           onkeyup="filterRoutes()">

                </div>


                <!-- SCORE FILTER -->

                <div>

                    <select class="filter-select"
                            id="scoreFilter"
                            onchange="filterRoutes()">

                        <option value="">
                            All Scores
                        </option>

                        <option value="high">
                            High Score (80%+)
                        </option>

                        <option value="medium">
                            Medium Score (50–79%)
                        </option>

                        <option value="low">
                            Low Score (&lt;50%)
                        </option>

                    </select>

                </div>


                <!-- SEARCH -->

                <button class="btn btn-primary"
                        type="button"
                        onclick="filterRoutes()"
                        style="height:35px;">

                    <i class="fa-solid fa-magnifying-glass"></i>

                    Search

                </button>

            </div>


            <!-- =================================================
                 TABLE
                 ================================================= -->

            <div class="table-wrapper">

                <table class="route-table"
                       id="routeTable">


                    <thead>

                    <tr>

                        <th>
                            Route
                        </th>

                        <th>
                            Shipment
                        </th>

                        <th>
                            Origin
                        </th>

                        <th>
                            Destination
                        </th>

                        <th>
                            Distance
                        </th>

                        <th>
                            Duration
                        </th>

                        <th>
                            Score
                        </th>

                        <th>
                            Recommended Route
                        </th>

                        <th>
                            Calculated
                        </th>

                        <th>
                            Actions
                        </th>

                    </tr>

                    </thead>


                    <tbody id="routeTableBody">


                    <%
                        if (!routes.isEmpty()) {

                            for (RouteOptimization route : routes) {

                                Shipment shipment =
                                        route.getShipment();

                                String trackingNumber =
                                        shipment != null &&
                                                shipment.getTrackingNumber() != null
                                                ? shipment.getTrackingNumber()
                                                : "N/A";


                                String origin =
                                        addressText(route.getOriginAddress());


                                String destination =
                                        addressText(route.getDestinationAddress());


                                double score =
                                        route.getOptimizationScore() != null
                                                ? route.getOptimizationScore()
                                                .doubleValue()
                                                : 0;


                                String scoreClass;

                                if (score >= 80) {

                                    scoreClass =
                                            "score-high";

                                } else if (score >= 50) {

                                    scoreClass =
                                            "score-medium";

                                } else {

                                    scoreClass =
                                            "score-low";
                                }


                                String recommendedRoute =
                                        route.getRecommendedRoute() != null
                                                ? route.getRecommendedRoute()
                                                : "No recommendation";


                                String calculatedAt =
                                        route.getCalculatedAt() != null
                                                ? route.getCalculatedAt()
                                                .toString()
                                                : "N/A";
                    %>


                    <tr
                            data-score="<%= score %>"
                            data-score-category="<%= score >= 80 ? "high" : score >= 50 ? "medium" : "low" %>"
                    >


                        <!-- ROUTE -->

                        <td>

                            <span class="route-id">

                                ROUTE-<%= route.getId() %>

                            </span>

                        </td>


                        <!-- SHIPMENT -->

                        <td>

                            <span class="shipment-reference">

                                <%= trackingNumber %>

                            </span>

                            <span class="shipment-id">

                                Shipment ID:
                                <%= shipment != null
                                        ? shipment.getId()
                                        : "N/A" %>

                            </span>

                        </td>


                        <!-- ORIGIN -->

                        <td>

                            <div class="location">

                                <i class="fa-solid fa-location-dot"></i>

                                <span class="location-text">

                                    <%= origin %>

                                </span>

                            </div>

                        </td>


                        <!-- DESTINATION -->

                        <td>

                            <div class="location">

                                <i class="fa-solid fa-location-dot destination-icon"></i>

                                <span class="location-text">

                                    <%= destination %>

                                </span>

                            </div>

                        </td>


                        <!-- DISTANCE -->

                        <td>

                            <span class="distance-value">

                                <%= route.getEstimatedDistance() != null
                                        ? route.getEstimatedDistance()
                                        : "0" %>

                            </span>

                            <span class="distance-unit">
                                km
                            </span>

                        </td>


                        <!-- DURATION -->

                        <td>

                            <span class="duration-value">

                                <%= route.getEstimatedDuration() %>

                            </span>

                            <span class="duration-unit">
                                min
                            </span>

                        </td>


                        <!-- SCORE -->

                        <td>

                            <div class="score-wrapper">

                                <div class="score-top">

                                    <span class="score-value">

                                        <%= String.format(
                                                "%.1f",
                                                score
                                        ) %>%

                                    </span>

                                    <span class="score-label">

                                        optimized

                                    </span>

                                </div>


                                <div class="score-bar">

                                    <div class="score-fill <%= scoreClass %>"
                                         style="width:<%= Math.min(score,100) %>%;">
                                    </div>

                                </div>

                            </div>

                        </td>


                        <!-- RECOMMENDED ROUTE -->

                        <td>

                            <div class="recommended-route"
                                 title="<%= recommendedRoute.replace("\"","&quot;") %>">

                                <%= recommendedRoute %>

                            </div>

                        </td>


                        <!-- CALCULATED -->

                        <td>

                            <span class="date-main">

                                <%= calculatedAt.length() >= 10
                                        ? calculatedAt.substring(0,10)
                                        : calculatedAt %>

                            </span>

                            <span class="route-date">

                                <%= calculatedAt.length() > 10
                                        ? calculatedAt.substring(11)
                                        : "" %>

                            </span>

                        </td>

                        <!-- ACTIONS -->

                        <td>

                            <div class="route-actions">

                                <form
                                        method="post"
                                        action="${pageContext.request.contextPath}/routes"
                                        onsubmit="return confirm('Delete this route optimization?');">

                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= route.getId() %>">

                                    <button
                                            type="submit"
                                            class="route-action-btn delete"
                                            title="Delete route">

                                        <i class="fa-solid fa-trash"></i>

                                    </button>

                                </form>

                                <form
                                        method="post"
                                        action="${pageContext.request.contextPath}/routes">

                                    <input type="hidden" name="action" value="optimize">
                                    <input type="hidden" name="id" value="<%= route.getId() %>">

                                    <button
                                            type="submit"
                                            class="route-action-btn optimize"
                                            title="Recalculate route">

                                        <i class="fa-solid fa-wand-magic-sparkles"></i>

                                    </button>

                                </form>

                            </div>

                        </td>


                    </tr>


                    <%
                        }

                    } else {
                    %>


                    <tr>

                        <td colspan="10"
                            style="text-align:center;padding:45px;">

                            <div>

                                <i class="fa-solid fa-route"
                                   style="
                                   font-size:32px;
                                   color:#CBD5E1;
                                   margin-bottom:10px;
                                   ">
                                </i>

                                <div style="
                                    color:var(--navy);
                                    font-weight:700;
                                    font-size:13px;
                                    margin-bottom:5px;
                                    ">

                                    No optimized routes found

                                </div>

                                <div style="
                                    color:var(--muted);
                                    font-size:9px;
                                    ">

                                    Calculate an optimized route
                                    for a shipment to get started.

                                </div>

                            </div>

                        </td>

                    </tr>


                    <%
                        }
                    %>


                    </tbody>

                </table>


                <!-- EMPTY FILTER STATE -->

                <div class="empty-state"
                     id="emptyState">

                    <i class="fa-solid fa-route"></i>

                    <h3>
                        No routes found
                    </h3>

                    <p>
                        There are currently no routes matching
                        your search criteria.
                    </p>

                </div>

            </div>


            <!-- =================================================
                 TABLE FOOTER
                 ================================================= -->

            <div class="table-footer">

                <span class="table-info"
                      id="tableInfo">

                    Showing <%= totalRoutes %> routes

                </span>

            </div>

        </div>


        <!-- ====================================================
             FOOTER
             ==================================================== -->

        <footer class="footer">

            <span>

                © 2026 GlobalTrade Logistics System.
                All rights reserved.

            </span>


            <span>

                Administrator Portal • Version 1.0.0

            </span>

        </footer>


    </section>

</main>


<!-- ============================================================
     OPTIMIZE SHIPMENT ROUTE MODAL
     ============================================================ -->

<div class="modal-overlay"
     id="routeModal">

    <div class="route-modal">

        <!-- HEADER -->
        <div class="modal-header">

            <h2>
                <i class="fa-solid fa-route"
                   style="
                   color:var(--orange);
                   margin-right:7px;
                   ">
                </i>

                Optimize Shipment Route
            </h2>

            <button class="modal-close"
                    type="button"
                    onclick="closeRouteModal()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <!-- BODY -->
        <div class="modal-body">

            <form id="routeForm"
                  action="${pageContext.request.contextPath}/routes"
                  method="post">

                <!--
                    The backend decides whether this is a CREATE or
                    OPTIMIZE operation.

                    CREATE:
                    No optimization record exists for the shipment.

                    OPTIMIZE:
                    An optimization record already exists, so the
                    existing record is recalculated.
                -->
                <input type="hidden"
                       name="action"
                       id="routeAction"
                       value="create">

                <input type="hidden"
                       name="id"
                       id="routeId"
                       value="">

                <div class="form-grid">

                    <!-- =================================================
                         SHIPMENT
                         ================================================= -->

                    <div class="form-group full">

                        <label class="form-label">
                            Shipment
                        </label>

                        <select
                                class="form-input"
                                name="shipmentId"
                                id="selectedShipmentId"
                                required
                                onchange="handleShipmentChange()">

                            <option value="">
                                Select Shipment
                            </option>

                            <%
                                if (shipments != null &&
                                        !shipments.isEmpty()) {

                                    for (Shipment shipment : shipments) {

                                        String tracking =
                                                shipment.getTrackingNumber() != null
                                                        ? shipment.getTrackingNumber()
                                                        : "N/A";

                                        String shipmentOrigin =
                                                shipment.getOriginAddress() != null
                                                        ? addressText(
                                                        shipment.getOriginAddress()
                                                )
                                                        : "Origin not available";

                                        String shipmentDestination =
                                                shipment.getDestinationAddress() != null
                                                        ? addressText(
                                                        shipment.getDestinationAddress()
                                                )
                                                        : "Destination not available";

                                        boolean hasOrigin =
                                                shipment.getOriginAddress() != null;

                                        boolean hasDestination =
                                                shipment.getDestinationAddress() != null;
                            %>

                            <option
                                    value="<%= shipment.getId() %>"
                                    data-tracking="<%= html(tracking) %>"
                                    data-origin="<%= html(shipmentOrigin) %>"
                                    data-destination="<%= html(shipmentDestination) %>"
                                    data-has-origin="<%= hasOrigin %>"
                                    data-has-destination="<%= hasDestination %>">

                                <%= tracking %>
                                — Shipment ID: <%= shipment.getId() %>

                            </option>

                            <%
                                    }
                                }
                            %>

                        </select>

                        <div
                                class="selected-info"
                                id="routeShipmentSelectedInfo"
                                style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Shipment selected

                        </div>

                    </div>


                    <!-- =================================================
                         ORIGIN
                         Automatically loaded from Shipment
                         ================================================= -->

                    <div class="form-group">

                        <label class="form-label">
                            Origin
                        </label>

                        <div
                                class="selector-display placeholder"
                                id="routeOriginDisplay"
                                style="
                                    min-height:37px;
                                    height:auto;
                                    padding:9px 10px;
                                    white-space:normal;
                                    cursor:default;
                                ">

                            Select a shipment first

                        </div>

                        <div
                                class="selected-info"
                                id="routeOriginSelectedInfo"
                                style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Origin loaded from shipment

                        </div>

                    </div>


                    <!-- =================================================
                         DESTINATION
                         Automatically loaded from Shipment
                         ================================================= -->

                    <div class="form-group">

                        <label class="form-label">
                            Destination
                        </label>

                        <div
                                class="selector-display placeholder"
                                id="routeDestinationDisplay"
                                style="
                                    min-height:37px;
                                    height:auto;
                                    padding:9px 10px;
                                    white-space:normal;
                                    cursor:default;
                                ">

                            Select a shipment first

                        </div>

                        <div
                                class="selected-info"
                                id="routeDestinationSelectedInfo"
                                style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Destination loaded from shipment

                        </div>

                    </div>


                    <!-- =================================================
                         INFORMATION
                         ================================================= -->

                    <div class="form-group full">

                        <div class="info-box">

                            <i class="fa-solid fa-circle-info"></i>

                            Select a shipment to automatically load its
                            origin and destination. The route optimization
                            is calculated automatically by the server.

                        </div>

                    </div>


                    <!-- =================================================
                         EXISTING ROUTE INFORMATION
                         ================================================= -->

                    <div
                            class="form-group full"
                            id="existingRouteInfo"
                            style="display:none;">

                        <div class="info-box">

                            <i class="fa-solid fa-rotate"></i>

                            An optimization record already exists for this
                            shipment. Clicking Optimize Route will recalculate
                            the existing optimization.

                        </div>

                    </div>


                    <!-- =================================================
                         WARNING
                         ================================================= -->

                    <div
                            class="form-group full"
                            id="shipmentAddressWarning"
                            style="display:none;">

                        <div
                                class="info-box"
                                style="
                                    background:#FEF2F2;
                                    color:#B91C1C;
                                    border-color:#FECACA;
                                ">

                            <i class="fa-solid fa-triangle-exclamation"></i>

                            This shipment does not have both origin and
                            destination addresses. Route optimization cannot
                            be calculated.

                        </div>

                    </div>

                </div>


                <!-- FOOTER -->
                <div class="modal-footer">

                    <button type="button"
                            class="btn btn-secondary"
                            onclick="closeRouteModal()">

                        Cancel

                    </button>


                    <button type="submit"
                            class="btn btn-primary"
                            id="routeSubmitButton"
                            disabled>

                        <i class="fa-solid fa-wand-magic-sparkles"></i>

                        <span id="routeSubmitText">
                            Optimize Route
                        </span>

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>


<!-- ============================================================
     NO ROUTE / DELETE CONFIRMATION
     ============================================================ -->

<div class="modal-overlay"
     id="deleteRouteModal">

    <div class="route-modal"
         style="max-width:420px;">

        <div class="modal-header">

            <h2>
                <i class="fa-solid fa-trash"
                   style="
                   color:var(--red);
                   margin-right:7px;
                   ">
                </i>

                Delete Route Optimization
            </h2>

            <button class="modal-close"
                    type="button"
                    onclick="closeDeleteRouteModal()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <div class="modal-body">

            <p style="
                color:var(--navy);
                font-size:11px;
                line-height:1.6;
                margin:0;
            ">

                Are you sure you want to delete this route optimization
                record? The shipment itself will not be deleted.

            </p>

            <form
                    method="post"
                    action="${pageContext.request.contextPath}/routes"
                    style="margin-top:18px;">

                <input type="hidden"
                       name="action"
                       value="delete">

                <input type="hidden"
                       name="id"
                       id="deleteRouteId"
                       value="">

                <div class="modal-footer"
                     style="padding-left:0;padding-right:0;">

                    <button
                            type="button"
                            class="btn btn-secondary"
                            onclick="closeDeleteRouteModal()">

                        Cancel

                    </button>

                    <button
                            type="submit"
                            class="btn btn-primary"
                            style="
                                background:var(--red);
                                border-color:var(--red);
                            ">

                        <i class="fa-solid fa-trash"></i>

                        Delete Route

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>


<!-- ============================================================
     OPTIMIZE ALL CONFIRMATION
     ============================================================ -->

<div class="modal-overlay"
     id="optimizeAllModal">

    <div class="route-modal"
         style="max-width:420px;">

        <div class="modal-header">

            <h2>

                <i class="fa-solid fa-wand-magic-sparkles"
                   style="
                   color:var(--orange);
                   margin-right:7px;
                   ">
                </i>

                Optimize All Routes

            </h2>

            <button class="modal-close"
                    type="button"
                    onclick="closeOptimizeAllModal()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <div class="modal-body">

            <p style="
                color:var(--navy);
                font-size:11px;
                line-height:1.6;
                margin:0;
            ">

                Recalculate all existing route optimization records using
                their current shipment addresses?

            </p>

            <form
                    method="post"
                    action="${pageContext.request.contextPath}/routes"
                    style="margin-top:18px;">

                <input type="hidden"
                       name="action"
                       value="optimizeall">

                <div class="modal-footer"
                     style="padding-left:0;padding-right:0;">

                    <button
                            type="button"
                            class="btn btn-secondary"
                            onclick="closeOptimizeAllModal()">

                        Cancel

                    </button>

                    <button
                            type="submit"
                            class="btn btn-primary">

                        <i class="fa-solid fa-wand-magic-sparkles"></i>

                        Optimize All

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>


<script>

    (function () {

        "use strict";


        /* ============================================================
           ROUTE DATA

           Maps each shipment ID to its existing optimization record.
           This allows the UI to decide whether the selected shipment
           should CREATE a new optimization or OPTIMIZE an existing one.
           ============================================================ */

        const existingRoutes = {

            <%
                if (routes != null && !routes.isEmpty()) {

                    boolean firstRoute = true;

                    for (RouteOptimization route : routes) {

                        Shipment routeShipment =
                                route.getShipment();

                        if (routeShipment != null &&
                                routeShipment.getId() != null) {

                            if (!firstRoute) {
            %>
            ,
            <%
                            }

                            firstRoute = false;
            %>

            "<%= routeShipment.getId() %>": "<%= route.getId() %>"

        <%
                    }
                }
            }
        %>

    };


        /* ============================================================
           DOM HELPER
           ============================================================ */

        function getElement(id) {

            return document.getElementById(id);

        }


        /* ============================================================
           GENERIC MODAL
           ============================================================ */

        function showModal(id) {

            const modal =
                getElement(id);

            if (!modal) {

                console.error(
                    "[ROUTES] Modal not found:",
                    id
                );

                return;
            }

            modal.classList.add("show");

            modal.style.display =
                "flex";

            document.body.classList.add(
                "modal-open"
            );

        }


        function hideModal(id) {

            const modal =
                getElement(id);

            if (!modal) {

                return;
            }

            modal.classList.remove("show");

            modal.style.display =
                "none";

            document.body.classList.remove(
                "modal-open"
            );

        }


        /* ============================================================
           TOAST
           ============================================================ */

        /* ============================================================
    TOAST MANAGEMENT
    ============================================================ */

        window.closeToast = function (id) {

            const toast = getElement(id);

            if (!toast) {
                return;
            }

            /*
             * Prevent multiple close operations.
             */
            if (toast.classList.contains("toast-hide")) {
                return;
            }

            /*
             * Play exit animation.
             */
            toast.classList.add("toast-hide");

            /*
             * Remove it completely after animation.
             */
            setTimeout(function () {

                if (toast) {
                    toast.remove();
                }

            }, 300);
        };

        /* ============================================================
   AUTOMATIC TOAST DISMISSAL
   ============================================================ */

        function initializeToasts() {

            const successToast =
                getElement("successToast");

            const errorToast =
                getElement("errorToast");


            /*
             * Success message
             */
            if (successToast) {

                setTimeout(function () {

                    closeToast("successToast");

                }, 4000);
            }


            /*
             * Error message
             */
            if (errorToast) {

                setTimeout(function () {

                    closeToast("errorToast");

                }, 6000);
            }
        }


        /* ============================================================
           OPEN OPTIMIZE SHIPMENT MODAL
           ============================================================ */

        window.openCreateRouteModal = function () {

            const form =
                getElement("routeForm");

            if (form) {

                form.reset();

            }


            const action =
                getElement("routeAction");

            const routeId =
                getElement("routeId");

            if (action) {

                action.value =
                    "create";

            }

            if (routeId) {

                routeId.value =
                    "";

            }


            resetShipmentRouteFields();

            showModal("routeModal");

        };


        /* ============================================================
           HANDLE SHIPMENT SELECTION
           ============================================================ */

        window.handleShipmentChange = function () {

            const shipmentSelect =
                getElement(
                    "selectedShipmentId"
                );

            const originDisplay =
                getElement(
                    "routeOriginDisplay"
                );

            const destinationDisplay =
                getElement(
                    "routeDestinationDisplay"
                );

            const shipmentInfo =
                getElement(
                    "routeShipmentSelectedInfo"
                );

            const originInfo =
                getElement(
                    "routeOriginSelectedInfo"
                );

            const destinationInfo =
                getElement(
                    "routeDestinationSelectedInfo"
                );

            const existingInfo =
                getElement(
                    "existingRouteInfo"
                );

            const warning =
                getElement(
                    "shipmentAddressWarning"
                );

            const submitButton =
                getElement(
                    "routeSubmitButton"
                );

            const submitText =
                getElement(
                    "routeSubmitText"
                );

            const action =
                getElement(
                    "routeAction"
                );

            const routeId =
                getElement(
                    "routeId"
                );


            if (!shipmentSelect) {

                return;

            }


            const selectedOption =
                shipmentSelect.options[
                    shipmentSelect.selectedIndex
                    ];


            /* --------------------------------------------------------
               RESET
               -------------------------------------------------------- */

            if (!selectedOption ||
                !shipmentSelect.value) {

                resetShipmentRouteFields();

                return;

            }


            const origin =
                selectedOption.dataset.origin ||
                "Origin not available";

            const destination =
                selectedOption.dataset.destination ||
                "Destination not available";

            const hasOrigin =
                selectedOption.dataset.hasOrigin === "true";

            const hasDestination =
                selectedOption.dataset.hasDestination === "true";


            /* --------------------------------------------------------
               SHIPMENT SELECTED
               -------------------------------------------------------- */

            if (shipmentInfo) {

                shipmentInfo.style.display =
                    "flex";

            }


            /* --------------------------------------------------------
               ORIGIN
               -------------------------------------------------------- */

            if (originDisplay) {

                originDisplay.textContent =
                    origin;

                originDisplay.classList.remove(
                    "placeholder"
                );

                originDisplay.classList.add(
                    "selected"
                );

            }


            if (originInfo) {

                originInfo.style.display =
                    hasOrigin
                        ? "flex"
                        : "none";

            }


            /* --------------------------------------------------------
               DESTINATION
               -------------------------------------------------------- */

            if (destinationDisplay) {

                destinationDisplay.textContent =
                    destination;

                destinationDisplay.classList.remove(
                    "placeholder"
                );

                destinationDisplay.classList.add(
                    "selected"
                );

            }


            if (destinationInfo) {

                destinationInfo.style.display =
                    hasDestination
                        ? "flex"
                        : "none";

            }


            /* --------------------------------------------------------
               ADDRESS VALIDATION
               -------------------------------------------------------- */

            const validAddresses =
                hasOrigin &&
                hasDestination;


            if (warning) {

                warning.style.display =
                    validAddresses
                        ? "none"
                        : "block";

            }


            /* --------------------------------------------------------
               EXISTING ROUTE

               If a route already exists for this shipment, submit
               "optimize" with the existing route ID.

               Otherwise submit "create" with the shipment ID.
               -------------------------------------------------------- */

            const existingRouteId =
                existingRoutes[
                    String(shipmentSelect.value)
                    ];


            if (existingRouteId) {

                if (action) {

                    action.value =
                        "optimize";

                }

                if (routeId) {

                    routeId.value =
                        existingRouteId;

                }

                if (existingInfo) {

                    existingInfo.style.display =
                        "block";

                }

                if (submitText) {

                    submitText.textContent =
                        "Recalculate Route";

                }

            } else {

                if (action) {

                    action.value =
                        "create";

                }

                if (routeId) {

                    routeId.value =
                        "";

                }

                if (existingInfo) {

                    existingInfo.style.display =
                        "none";

                }

                if (submitText) {

                    submitText.textContent =
                        "Optimize Route";

                }

            }


            /* --------------------------------------------------------
               SUBMIT BUTTON
               -------------------------------------------------------- */

            if (submitButton) {

                submitButton.disabled =
                    !validAddresses;

            }

        };


        /* ============================================================
           RESET SHIPMENT FIELDS
           ============================================================ */

        function resetShipmentRouteFields() {

            const shipmentInfo =
                getElement(
                    "routeShipmentSelectedInfo"
                );

            const originDisplay =
                getElement(
                    "routeOriginDisplay"
                );

            const destinationDisplay =
                getElement(
                    "routeDestinationDisplay"
                );

            const originInfo =
                getElement(
                    "routeOriginSelectedInfo"
                );

            const destinationInfo =
                getElement(
                    "routeDestinationSelectedInfo"
                );

            const existingInfo =
                getElement(
                    "existingRouteInfo"
                );

            const warning =
                getElement(
                    "shipmentAddressWarning"
                );

            const submitButton =
                getElement(
                    "routeSubmitButton"
                );

            const submitText =
                getElement(
                    "routeSubmitText"
                );

            const action =
                getElement(
                    "routeAction"
                );

            const routeId =
                getElement(
                    "routeId"
                );


            if (shipmentInfo) {

                shipmentInfo.style.display =
                    "none";

            }


            if (originDisplay) {

                originDisplay.textContent =
                    "Select a shipment first";

                originDisplay.classList.add(
                    "placeholder"
                );

                originDisplay.classList.remove(
                    "selected"
                );

            }


            if (destinationDisplay) {

                destinationDisplay.textContent =
                    "Select a shipment first";

                destinationDisplay.classList.add(
                    "placeholder"
                );

                destinationDisplay.classList.remove(
                    "selected"
                );

            }


            if (originInfo) {

                originInfo.style.display =
                    "none";

            }


            if (destinationInfo) {

                destinationInfo.style.display =
                    "none";

            }


            if (existingInfo) {

                existingInfo.style.display =
                    "none";

            }


            if (warning) {

                warning.style.display =
                    "none";

            }


            if (submitButton) {

                submitButton.disabled =
                    true;

            }


            if (submitText) {

                submitText.textContent =
                    "Optimize Route";

            }


            if (action) {

                action.value =
                    "create";

            }


            if (routeId) {

                routeId.value =
                    "";

            }

        }


        /* ============================================================
           CLOSE ROUTE MODAL
           ============================================================ */

        window.closeRouteModal = function () {

            hideModal("routeModal");

        };


        /* ============================================================
           DELETE
           ============================================================ */

        window.openDeleteRouteModal = function (routeId) {

            const field =
                getElement(
                    "deleteRouteId"
                );

            if (field) {

                field.value =
                    routeId || "";

            }

            showModal(
                "deleteRouteModal"
            );

        };


        window.closeDeleteRouteModal = function () {

            hideModal(
                "deleteRouteModal"
            );

        };


        /* ============================================================
           OPTIMIZE ALL
           ============================================================ */

        window.openOptimizeAllModal = function () {

            showModal(
                "optimizeAllModal"
            );

        };


        window.closeOptimizeAllModal = function () {

            hideModal(
                "optimizeAllModal"
            );

        };


        /* ============================================================
           ROUTE SEARCH
           ============================================================ */

        window.filterRoutes = function () {

            const searchInput =
                getElement(
                    "routeSearch"
                );

            const scoreFilter =
                getElement(
                    "scoreFilter"
                );

            const rows =
                document.querySelectorAll(
                    "#routeTableBody tr"
                );

            if (!rows.length) {

                updateRouteCounts(0);

                return;

            }


            const searchValue =
                searchInput
                    ? searchInput.value
                        .toLowerCase()
                        .trim()
                    : "";

            const scoreValue =
                scoreFilter
                    ? scoreFilter.value
                    : "";


            let visible =
                0;


            rows.forEach(function (row) {

                const text =
                    row.innerText
                        .toLowerCase();


                const scoreCategory =
                    row.dataset.scoreCategory ||
                    "";


                const matchesSearch =
                    searchValue === "" ||
                    text.includes(
                        searchValue
                    );


                const matchesScore =
                    scoreValue === "" ||
                    scoreCategory ===
                    scoreValue;


                if (
                    matchesSearch &&
                    matchesScore
                ) {

                    row.style.display =
                        "";

                    visible++;

                } else {

                    row.style.display =
                        "none";

                }

            });


            updateRouteCounts(
                visible
            );

        };


        /* ============================================================
           UPDATE COUNTS
           ============================================================ */

        function updateRouteCounts(
            visible
        ) {

            const count =
                getElement(
                    "routeVisibleCount"
                );

            if (count) {

                count.textContent =
                    visible;

            }


            const tableInfo =
                getElement(
                    "tableInfo"
                );

            if (tableInfo) {

                tableInfo.textContent =
                    "Showing " +
                    visible +
                    " route" +
                    (
                        visible === 1
                            ? ""
                            : "s"
                    );

            }


            const emptyState =
                getElement(
                    "emptyState"
                );

            if (emptyState) {

                emptyState.style.display =
                    visible === 0
                        ? "block"
                        : "none";

            }

        }


        /* ============================================================
           RESET FILTERS
           ============================================================ */

        window.resetFilters = function () {

            const searchInput =
                getElement(
                    "routeSearch"
                );

            const scoreFilter =
                getElement(
                    "scoreFilter"
                );


            if (searchInput) {

                searchInput.value =
                    "";

            }


            if (scoreFilter) {

                scoreFilter.value =
                    "";

            }


            filterRoutes();

        };


        /* ============================================================
           FORM SUBMISSION VALIDATION
           ============================================================ */

        const routeForm =
            getElement(
                "routeForm"
            );


        if (routeForm) {

            routeForm.addEventListener(
                "submit",
                function (event) {

                    const shipmentSelect =
                        getElement(
                            "selectedShipmentId"
                        );

                    const action =
                        getElement(
                            "routeAction"
                        );

                    const routeId =
                        getElement(
                            "routeId"
                        );


                    if (!shipmentSelect ||
                        !shipmentSelect.value) {

                        event.preventDefault();

                        alert(
                            "Please select a shipment."
                        );

                        return;

                    }


                    if (!action) {

                        event.preventDefault();

                        alert(
                            "Unable to determine the route operation."
                        );

                        return;

                    }


                    if (
                        action.value ===
                        "optimize" &&
                        (
                            !routeId ||
                            !routeId.value
                        )
                    ) {

                        event.preventDefault();

                        alert(
                            "The existing route could not be identified."
                        );

                    }

                }
            );

        }


        /* ============================================================
           OVERLAY CLICK
           ============================================================ */

        document.addEventListener(
            "click",
            function (event) {

                if (
                    event.target.classList &&
                    event.target.classList.contains(
                        "modal-overlay"
                    )
                ) {

                    event.target.classList.remove(
                        "show"
                    );

                    event.target.style.display =
                        "none";

                    document.body.classList.remove(
                        "modal-open"
                    );

                }

            }
        );


        /* ============================================================
           ESCAPE
           ============================================================ */

        document.addEventListener(
            "keydown",
            function (event) {

                if (
                    event.key !==
                    "Escape"
                ) {

                    return;

                }


                document
                    .querySelectorAll(
                        ".modal-overlay.show"
                    )
                    .forEach(
                        function (modal) {

                            modal.classList.remove(
                                "show"
                            );

                            modal.style.display =
                                "none";

                        }
                    );


                document.body.classList.remove(
                    "modal-open"
                );

            }
        );


        /* ============================================================
           INITIALIZE
           ============================================================ */

        document.addEventListener(
            "DOMContentLoaded",
            function () {

                const rows =
                    document.querySelectorAll(
                        "#routeTableBody tr"
                    );

                let visible =
                    0;

                rows.forEach(function (row) {

                    if (
                        row.querySelector(
                            "td"
                        )
                    ) {

                        visible++;

                    }

                });


                updateRouteCounts(
                    visible
                );

            }
        );


    })();
    /* ============================================================
   INITIALIZE PAGE
   ============================================================ */

    initializeToasts();

</script>

</body>

</html>