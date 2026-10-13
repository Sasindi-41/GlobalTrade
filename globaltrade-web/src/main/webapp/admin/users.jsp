<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="lk.sasindi.globaltrade.entity.User" %>
<%@ page import="lk.sasindi.globaltrade.entity.Role" %>
<%@ page import="lk.sasindi.globaltrade.entity.Status" %>
<%@ page import="lk.sasindi.globaltrade.entity.City" %>

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
     */

    User adminUser =
            (User) request.getAttribute("user");


    /*
     * ============================================================
     * ADMIN DISPLAY INFORMATION
     * ============================================================
     */

    String adminUsername = "Administrator";

    String adminFirstName = "";

    String adminLastName = "";


    if (adminUser != null) {

        if (adminUser.getUsername() != null) {
            adminUsername = adminUser.getUsername();
        }

        if (adminUser.getFirstName() != null) {
            adminFirstName = adminUser.getFirstName();
        }

        if (adminUser.getLastName() != null) {
            adminLastName = adminUser.getLastName();
        }
    }


    String adminDisplayName =
            (adminFirstName + " " + adminLastName).trim();


    if (adminDisplayName.isEmpty()) {
        adminDisplayName = adminUsername;
    }


    String adminAvatarLetter =
            !adminDisplayName.isEmpty()
                    ? adminDisplayName.substring(0, 1).toUpperCase()
                    : "A";


    /*
     * ============================================================
     * USER DATA
     * ============================================================
     */

    List<User> users =
            (List<User>)
                    request.getAttribute("users");

    if (users == null) {
        users = new ArrayList<>();
    }


    /*
     * ============================================================
     * ROLE DATA
     * ============================================================
     */

    List<Role> roles =
            (List<Role>)
                    request.getAttribute("roles");

    if (roles == null) {
        roles = new ArrayList<>();
    }


    /*
     * ============================================================
     * STATUS DATA
     * ============================================================
     */

    List<Status> statuses =
            (List<Status>)
                    request.getAttribute("statuses");

    if (statuses == null) {
        statuses = new ArrayList<>();
    }


    /*
     * ============================================================
     * CITY DATA
     * ============================================================
     */

    List<City> cities =
            (List<City>)
                    request.getAttribute("cities");

    if (cities == null) {
        cities = new ArrayList<>();
    }


    /*
     * ============================================================
     * STATISTICS
     * ============================================================
     */

    int totalUsers = users.size();

    int activeUsers = 0;

    int inactiveUsers = 0;

    int adminUsers = 0;

    int normalUsers = 0;


    for (User currentUser : users) {

        if (currentUser.getStatus() != null &&
                currentUser.getStatus().getName() != null) {

            String statusName =
                    currentUser.getStatus()
                            .getName()
                            .trim();

            if ("ACTIVE".equalsIgnoreCase(statusName)) {

                activeUsers++;

            } else {

                inactiveUsers++;
            }
        }


        if (currentUser.getRole() != null &&
                currentUser.getRole().getName() != null) {

            String roleName =
                    currentUser.getRole()
                            .getName()
                            .trim();

            if ("ADMIN".equalsIgnoreCase(roleName)) {

                adminUsers++;

            } else {

                normalUsers++;
            }
        }
    }


    /*
     * ============================================================
     * NOTIFICATION COUNT
     * ============================================================
     */

    int notificationCount = 0;

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        GlobalTrade | User Management
    </title>


    <!-- FONT AWESOME -->

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- ADMIN CSS -->

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/admin.css">
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

            --border: rgba(0,48,73,.10);

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

            color:
                    var(--orange);
        }


        /* ============================================================
           SEARCH
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


        /* ============================================================
           CONTENT
           ============================================================ */

        .content {

            padding:
                    20px 25px 18px;
        }


        /* ============================================================
           PAGE HEADING
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


        .btn-danger {

            background:
                    rgba(214,40,40,.08);

            border-color:
                    rgba(214,40,40,.15);

            color:
                    var(--red);
        }


        .btn-danger:hover {

            background:
                    var(--red);

            color:
                    white;
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


        .stat-icon.green {

            background:
                    rgba(40,167,69,.10);

            color:
                    var(--green);
        }


        .stat-icon.red {

            background:
                    rgba(214,40,40,.10);

            color:
                    var(--red);
        }


        .stat-icon.blue {

            background:
                    rgba(37,99,235,.10);

            color:
                    var(--blue);
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


        /* ============================================================
           CARD
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
                    1.6fr .8fr .8fr auto;

            gap: 9px;

            background:
                    #FFFDF7;
        }


        .filter-input,
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


        .filter-input:focus,
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


        .user-table {

            width: 100%;

            border-collapse: collapse;

            min-width: 1050px;
        }


        .user-table thead {

            background:
                    #FFF9E8;
        }


        .user-table th {

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


        .user-table td {

            padding:
                    12px 14px;

            color:
                    var(--navy);

            font-size: 10px;

            border-bottom:
                    1px solid rgba(0,48,73,.06);

            vertical-align: middle;
        }


        .user-table tbody tr {

            transition:
                    .15s ease;
        }


        .user-table tbody tr:hover {

            background:
                    #FFFDF5;
        }


        .user-table tbody tr:last-child td {

            border-bottom:
                    none;
        }


        /* ============================================================
           USER PROFILE CELL
           ============================================================ */

        .user-cell {

            display: flex;

            align-items: center;

            gap: 9px;

            min-width: 180px;
        }


        .user-avatar {

            width: 34px;

            height: 34px;

            border-radius: 50%;

            background:
                    var(--soft-yellow);

            color:
                    var(--orange);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 12px;

            font-weight: 700;

            flex-shrink: 0;
        }


        .user-info {

            min-width: 0;
        }


        .user-name {

            color:
                    var(--navy);

            font-size: 10px;

            font-weight: 700;

            white-space: nowrap;

            overflow: hidden;

            text-overflow: ellipsis;
        }


        .user-username {

            color:
                    var(--muted);

            font-size: 8px;

            margin-top: 3px;
        }


        /* ============================================================
           EMAIL
           ============================================================ */

        .email-text {

            color:
                    var(--navy);

            font-size: 9px;
        }


        /* ============================================================
           ROLE BADGE
           ============================================================ */

        .role-badge {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            padding:
                    5px 8px;

            border-radius: 5px;

            background:
                    rgba(252,191,73,.18);

            color:
                    #946200;

            font-size: 8px;

            font-weight: 700;

            text-transform: uppercase;
        }


        .role-badge.admin {

            background:
                    rgba(0,48,73,.10);

            color:
                    var(--navy);
        }


        /* ============================================================
           STATUS BADGE
           ============================================================ */

        .status-badge {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            padding:
                    5px 8px;

            border-radius: 5px;

            font-size: 8px;

            font-weight: 700;

            text-transform: uppercase;
        }


        .status-badge.active {

            background:
                    rgba(40,167,69,.10);

            color:
                    var(--green);
        }


        .status-badge.inactive {

            background:
                    rgba(214,40,40,.10);

            color:
                    var(--red);
        }


        .status-dot {

            width: 5px;

            height: 5px;

            border-radius: 50%;

            background:
                    currentColor;
        }


        /* ============================================================
           CITY
           ============================================================ */

        .city-cell {

            display: flex;

            align-items: center;

            gap: 6px;

            color:
                    var(--muted);

            font-size: 9px;
        }


        .city-cell i {

            color:
                    var(--orange);

            font-size: 9px;
        }


        /* ============================================================
           DATE
           ============================================================ */

        .date-main {

            color:
                    var(--navy);

            font-size: 9px;

            font-weight: 600;

            display: block;
        }


        .date-time {

            color:
                    var(--muted);

            font-size: 8px;

            margin-top: 3px;

            display: block;
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
        }


        .table-info {

            color:
                    var(--muted);

            font-size: 9px;
        }


        /* ============================================================
           MODAL
           ============================================================ */

        .modal-overlay {

            position: fixed;

            inset: 0;

            background:
                    rgba(0,48,73,.45);

            display: none;

            align-items: center;

            justify-content: center;

            padding: 20px;

            z-index: 9999;
        }


        .modal-overlay.show {

            display: flex;
        }


        .user-modal {

            width: 100%;

            max-width: 760px;

            max-height: 92vh;

            overflow-y: auto;

            background:
                    white;

            border-radius: 12px;

            box-shadow:
                    0 20px 50px
                    rgba(0,0,0,.18);
        }


        .modal-header {

            min-height: 58px;

            padding:
                    0 18px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            border-bottom:
                    1px solid var(--border);
        }


        .modal-header h2 {

            color:
                    var(--navy);

            font-size: 15px;
        }


        .modal-close {

            width: 30px;

            height: 30px;

            border: none;

            background:
                    transparent;

            color:
                    var(--muted);

            cursor: pointer;

            font-size: 15px;
        }


        .modal-close:hover {

            color:
                    var(--red);
        }


        .modal-body {

            padding:
                    18px;
        }


        /* ============================================================
           FORM
           ============================================================ */

        .form-grid {

            display: grid;

            grid-template-columns:
                    1fr 1fr;

            gap: 13px;
        }


        .form-group.full {

            grid-column:
                    1 / -1;
        }


        .form-label {

            display: block;

            color:
                    var(--muted);

            font-size: 9px;

            font-weight: 600;

            margin-bottom: 6px;
        }


        .required {

            color:
                    var(--red);
        }


        .form-input,
        .form-select {

            width: 100%;

            height: 38px;

            padding:
                    0 11px;

            border:
                    1px solid var(--border);

            border-radius: 7px;

            background:
                    #FFFDF7;

            color:
                    var(--navy);

            font-size: 10px;

            outline: none;
        }


        textarea.form-input {

            height: 75px;

            padding-top: 10px;

            resize: vertical;
        }


        .form-input:focus,
        .form-select:focus {

            border-color:
                    var(--yellow);

            box-shadow:
                    0 0 0 3px
                    rgba(252,191,73,.10);
        }


        .form-help {

            color:
                    var(--muted);

            font-size: 8px;

            margin-top: 4px;
        }


        .modal-footer {

            padding:
                    12px 18px;

            display: flex;

            justify-content: flex-end;

            gap: 8px;

            border-top:
                    1px solid var(--border);
        }


        /* ============================================================
           VIEW USER
           ============================================================ */

        .profile-summary {

            display: flex;

            align-items: center;

            gap: 13px;

            padding:
                    13px;

            border:
                    1px solid var(--border);

            background:
                    #FFFDF7;

            border-radius: 9px;

            margin-bottom: 14px;
        }


        .large-avatar {

            width: 55px;

            height: 55px;

            border-radius: 50%;

            background:
                    var(--soft-yellow);

            color:
                    var(--orange);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 19px;

            font-weight: 700;

            flex-shrink: 0;
        }


        .profile-summary-info h3 {

            color:
                    var(--navy);

            font-size: 14px;
        }


        .profile-summary-info p {

            color:
                    var(--muted);

            font-size: 9px;

            margin-top: 4px;
        }


        .details-grid {

            display: grid;

            grid-template-columns:
                    1fr 1fr;

            gap: 10px;
        }


        .detail-box {

            padding:
                    11px;

            border:
                    1px solid var(--border);

            border-radius: 8px;

            background:
                    white;
        }


        .detail-box.full {

            grid-column:
                    1 / -1;
        }


        .detail-label {

            color:
                    var(--muted);

            font-size: 8px;

            text-transform: uppercase;

            font-weight: 700;

            margin-bottom: 5px;
        }


        .detail-value {

            color:
                    var(--navy);

            font-size: 10px;

            font-weight: 600;

            word-break: break-word;
        }


        /* ============================================================
           TOAST
           ============================================================ */

        .success-toast,
        .error-toast {

            position: fixed;

            top: 85px;

            right: 25px;

            min-width: 300px;

            padding:
                    14px 16px;

            background:
                    white;

            border-radius: 9px;

            box-shadow:
                    0 8px 25px
                    rgba(0,0,0,.12);

            display: flex;

            align-items: center;

            gap: 10px;

            font-size: 12px;

            font-weight: 600;

            z-index: 10000;
        }


        .success-toast {

            border:
                    1px solid rgba(40,167,69,.20);

            border-left:
                    4px solid var(--green);
        }


        .error-toast {

            border:
                    1px solid rgba(214,40,40,.20);

            border-left:
                    4px solid var(--red);
        }


        .success-toast > i {

            color:
                    var(--green);
        }


        .error-toast > i {

            color:
                    var(--red);
        }


        .toast-close {

            margin-left: auto;

            width: 24px;

            height: 24px;

            border: none;

            background:
                    transparent;

            color:
                    var(--muted);

            cursor: pointer;
        }


        /* ============================================================
           FOOTER
           ============================================================ */

        .footer {

            margin-top:
                    14px;

            padding:
                    11px 0 2px;

            border-top:
                    1px solid var(--border);

            display: flex;

            justify-content: space-between;

            color:
                    var(--muted);

            font-size: 9px;
        }


        /* ============================================================
           SIDEBAR
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
                    rgba(0,0,0,.08);
        }


        .brand {

            height: 75px;

            display: flex;

            align-items: center;

            padding:
                    0 18px;

            gap: 10px;

            border-bottom:
                    1px solid rgba(255,255,255,.08);

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
        }


        .brand-subtitle {

            color:
                    rgba(255,255,255,.65);

            font-size: 9px;

            margin-top: 3px;
        }


        .nav {

            flex: 1;

            padding:
                    12px 10px;

            overflow-y: auto;
        }


        .nav-item {

            height: 39px;

            display: flex;

            align-items: center;

            gap: 11px;

            padding:
                    0 11px;

            margin-bottom: 3px;

            border-radius: 7px;

            color:
                    rgba(255,255,255,.75);

            font-size: 11px;

            font-weight: 500;

            transition:
                    .2s ease;

            white-space: nowrap;
        }


        .nav-item i:first-child {

            width: 17px;

            text-align: center;

            font-size: 13px;
        }


        .nav-item span {

            overflow: hidden;

            text-overflow: ellipsis;
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

            background: rgba(255,255,255,.2);

            border-radius: 5px;
        }

        .profile-mini {

            padding:
                    12px;

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


        /* ============================================================
           RESPONSIVE
           ============================================================ */

        @media (max-width: 1100px) {

            .stats-grid {

                grid-template-columns:
                        repeat(2, 1fr);
            }


            .filter-area {

                grid-template-columns:
                        1fr 1fr;
            }
        }


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
            }


            .search {

                display: none;
            }


            .top-user > span {

                display: none;
            }


            .stats-grid {

                grid-template-columns:
                        1fr;
            }


            .filter-area {

                grid-template-columns:
                        1fr;
            }


            .form-grid,
            .details-grid {

                grid-template-columns:
                        1fr;
            }


            .form-group.full,
            .detail-box.full {

                grid-column:
                        auto;
            }


            .page-heading {

                flex-direction:
                        column;

                align-items:
                        flex-start;
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


            .success-toast,
            .error-toast {

                left: 12px;

                right: 12px;

                min-width: 0;
            }
        }

    </style>
</head>


<body>


<!-- ============================================================
     TOAST MESSAGES
     ============================================================ -->

<%
    if (successMessage != null) {
%>

<div class="success-toast"
     id="successToast">

    <i class="fa-solid fa-circle-check"></i>

    <span>
        <%= successMessage %>
    </span>

    <button class="toast-close"
            type="button"
            onclick="closeToast('successToast')">

        <i class="fa-solid fa-xmark"></i>

    </button>

</div>

<%
    }

    if (errorMessage != null) {
%>

<div class="error-toast"
     id="errorToast">

    <i class="fa-solid fa-circle-exclamation"></i>

    <span>
        <%= errorMessage %>
    </span>

    <button class="toast-close"
            type="button"
            onclick="closeToast('errorToast')">

        <i class="fa-solid fa-xmark"></i>

    </button>

</div>

<%
    }
%>


<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<jsp:include page="admin-sidebar.jsp"/>


<!-- ============================================================
     MAIN
     ============================================================ -->

<main class="main">


    <!-- TOPBAR -->

    <jsp:include page="admin-topbar.jsp"/>


    <!-- CONTENT -->

    <section class="content">


        <!-- ====================================================
             PAGE HEADING
             ==================================================== -->

        <div class="page-heading">

            <div>

                <h1>
                    User Management
                </h1>

                <p>
                    Manage registered users, account status,
                    roles and user information.
                </p>

            </div>

        </div>


        <!-- ====================================================
             STATISTICS
             ==================================================== -->

        <div class="stats-grid">


            <!-- TOTAL -->

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-users"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Total Users
                    </span>

                    <span class="stat-value">
                        <%= totalUsers %>
                    </span>

                </div>

            </div>


            <!-- ACTIVE -->

            <div class="stat-card">

                <div class="stat-icon green">

                    <i class="fa-solid fa-user-check"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Active Users
                    </span>

                    <span class="stat-value">
                        <%= activeUsers %>
                    </span>

                </div>

            </div>


            <!-- INACTIVE -->

            <div class="stat-card">

                <div class="stat-icon red">

                    <i class="fa-solid fa-user-slash"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Inactive Users
                    </span>

                    <span class="stat-value">
                        <%= inactiveUsers %>
                    </span>

                </div>

            </div>


            <!-- ADMIN -->

            <div class="stat-card">

                <div class="stat-icon blue">

                    <i class="fa-solid fa-user-shield"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Administrators
                    </span>

                    <span class="stat-value">
                        <%= adminUsers %>
                    </span>

                </div>

            </div>

        </div>


        <!-- ====================================================
             USER TABLE CARD
             ==================================================== -->

        <div class="card">


            <!-- HEADER -->

            <div class="card-header">

                <h2>
                    Registered Users
                </h2>


                <div class="card-header-right">

                    <button
                            class="btn btn-secondary"
                            type="button"
                            onclick="resetFilters()"
                            style="height:32px;padding:0 10px;">

                        <i class="fa-solid fa-rotate"></i>

                        Reset

                    </button>

                </div>

            </div>


            <!-- =================================================
                 FILTERS
                 ================================================= -->

            <div class="filter-area">


                <input
                        type="text"
                        id="userSearch"
                        class="filter-input"
                        placeholder="Search username, name, email or mobile..."
                        oninput="filterUsers()">


                <select
                        id="roleFilter"
                        class="filter-select"
                        onchange="filterUsers()">

                    <option value="">
                        All Roles
                    </option>

                    <%
                        for (Role role : roles) {

                            if (role != null &&
                                    role.getName() != null) {
                    %>

                    <option value="<%= role.getName() %>">

                        <%= role.getName() %>

                    </option>

                    <%
                            }
                        }
                    %>

                </select>


                <select
                        id="statusFilter"
                        class="filter-select"
                        onchange="filterUsers()">

                    <option value="">
                        All Statuses
                    </option>

                    <%
                        for (Status status : statuses) {

                            if (status != null &&
                                    status.getName() != null) {
                    %>

                    <option value="<%= status.getName() %>">

                        <%= status.getName() %>

                    </option>

                    <%
                            }
                        }
                    %>

                </select>


                <button
                        class="btn btn-primary"
                        type="button"
                        onclick="filterUsers()"
                        style="height:35px;">

                    <i class="fa-solid fa-magnifying-glass"></i>

                    Search

                </button>

            </div>


            <!-- =================================================
                 TABLE
                 ================================================= -->

            <div class="table-wrapper">

                <table
                        class="user-table"
                        id="userTable">

                    <thead>

                    <tr>

                        <th>User</th>

                        <th>Email</th>

                        <th>Mobile</th>

                        <th>Role</th>

                        <th>Status</th>

                        <th>City</th>

                        <th>Created</th>

                        <th>Actions</th>

                    </tr>

                    </thead>


                    <tbody id="userTableBody">


                    <%
                        if (!users.isEmpty()) {

                            for (User currentUser : users) {


                                String username =
                                        currentUser.getUsername() != null
                                                ? currentUser.getUsername()
                                                : "N/A";


                                String firstName =
                                        currentUser.getFirstName() != null
                                                ? currentUser.getFirstName()
                                                : "";


                                String lastName =
                                        currentUser.getLastName() != null
                                                ? currentUser.getLastName()
                                                : "";


                                String fullName =
                                        (firstName + " " + lastName).trim();


                                if (fullName.isEmpty()) {
                                    fullName = username;
                                }


                                String email =
                                        currentUser.getEmail() != null
                                                ? currentUser.getEmail()
                                                : "N/A";


                                String mobile =
                                        currentUser.getMobile() != null
                                                ? currentUser.getMobile()
                                                : "N/A";


                                String roleName =
                                        currentUser.getRole() != null &&
                                                currentUser.getRole().getName() != null
                                                ? currentUser.getRole().getName()
                                                : "N/A";


                                String statusName =
                                        currentUser.getStatus() != null &&
                                                currentUser.getStatus().getName() != null
                                                ? currentUser.getStatus().getName()
                                                : "N/A";


                                String cityName =
                                        currentUser.getCity() != null &&
                                                currentUser.getCity().getName() != null
                                                ? currentUser.getCity().getName()
                                                : "N/A";


                                String createdAt =
                                        currentUser.getCreatedAt() != null
                                                ? currentUser.getCreatedAt().toString()
                                                : "N/A";


                                String company =
                                        currentUser.getCompany() != null
                                                ? currentUser.getCompany()
                                                : "";


                                String jobTitle =
                                        currentUser.getJobTitle() != null
                                                ? currentUser.getJobTitle()
                                                : "";


                                String address =
                                        currentUser.getAddress() != null
                                                ? currentUser.getAddress()
                                                : "";


                                String postalCode =
                                        currentUser.getPostalCode() != null
                                                ? currentUser.getPostalCode()
                                                : "";


                                String avatarLetter =
                                        !fullName.isEmpty()
                                                ? fullName.substring(0,1).toUpperCase()
                                                : "U";


                                String roleClass =
                                        "ADMIN".equalsIgnoreCase(roleName)
                                                ? "admin"
                                                : "";


                                String statusClass =
                                        "ACTIVE".equalsIgnoreCase(statusName)
                                                ? "active"
                                                : "inactive";

                    %>


                    <tr
                            class="user-row"

                            data-search="<%= (
                                    username + " " +
                                    fullName + " " +
                                    email + " " +
                                    mobile + " " +
                                    cityName
                            ).toLowerCase()
                            .replace("\"", "&quot;") %>"

                            data-role="<%= roleName.toLowerCase() %>"

                            data-status="<%= statusName.toLowerCase() %>"
                    >


                        <!-- USER -->

                        <td>

                            <div class="user-cell">

                                <div class="user-avatar">

                                    <%= avatarLetter %>

                                </div>


                                <div class="user-info">

                                    <div class="user-name">

                                        <%= fullName %>

                                    </div>

                                    <div class="user-username">

                                        @<%= username %>

                                    </div>

                                </div>

                            </div>

                        </td>


                        <!-- EMAIL -->

                        <td>

                            <span class="email-text">

                                <%= email %>

                            </span>

                        </td>


                        <!-- MOBILE -->

                        <td>

                            <%= mobile %>

                        </td>


                        <!-- ROLE -->

                        <td>

                            <span class="role-badge <%= roleClass %>">

                                <i class="fa-solid
                                    <%= "ADMIN".equalsIgnoreCase(roleName)
                                        ? "fa-shield-halved"
                                        : "fa-user" %>">
                                </i>

                                <%= roleName %>

                            </span>

                        </td>


                        <!-- STATUS -->

                        <td>

                            <span class="status-badge <%= statusClass %>">

                                <span class="status-dot"></span>

                                <%= statusName %>

                            </span>

                        </td>


                        <!-- CITY -->

                        <td>

                            <div class="city-cell">

                                <i class="fa-solid fa-location-dot"></i>

                                <%= cityName %>

                            </div>

                        </td>


                        <!-- CREATED -->

                        <td>

                            <%
                                if (!"N/A".equals(createdAt) &&
                                        createdAt.length() >= 10) {
                            %>

                            <span class="date-main">

                                <%= createdAt.substring(0,10) %>

                            </span>

                            <%
                                if (createdAt.length() > 10) {
                            %>

                            <span class="date-time">

                                <%= createdAt.substring(11) %>

                            </span>

                            <%
                                }
                            } else {
                            %>

                            <span class="date-main">

                                <%= createdAt %>

                            </span>

                            <%
                                }
                            %>

                        </td>


                        <!-- =================================================
                             ACTIONS
                             ================================================= -->

                        <td>

                            <div class="action-buttons">


                                <!-- VIEW -->

                                <button
                                        type="button"
                                        class="action-btn"
                                        title="View User"

                                        data-id="<%= currentUser.getId() %>"

                                        data-fullname="<%= fullName %>"

                                        data-username="<%= username %>"

                                        data-email="<%= email %>"

                                        data-mobile="<%= mobile %>"

                                        data-role="<%= roleName %>"

                                        data-status="<%= statusName %>"

                                        data-city="<%= cityName %>"

                                        data-company="<%= company %>"

                                        data-jobtitle="<%= jobTitle %>"

                                        data-address="<%= address %>"

                                        data-postalcode="<%= postalCode %>"

                                        data-created="<%= createdAt %>"

                                        onclick="viewUserFromButton(this)">

                                    <i class="fa-solid fa-eye"></i>

                                </button>




                                <!-- CHANGE STATUS -->

                                <button
                                        type="button"
                                        class="action-btn"
                                        title="Change Status"

                                        data-id="<%= currentUser.getId() %>"

                                        data-username="<%= username %>"

                                        data-status="<%= statusName %>"

                                        onclick="openStatusModalFromButton(this)">

                                    <i class="fa-solid fa-user-gear"></i>

                                </button>

                                <!-- CHANGE ROLE -->

                                <button
                                        type="button"
                                        class="action-btn"
                                        title="Change Role"

                                        data-id="<%= currentUser.getId() %>"

                                        data-username="<%= username %>"

                                        data-role="<%= roleName %>"

                                        onclick="openRoleModalFromButton(this)">

                                    <i class="fa-solid fa-user-tag"></i>

                                </button>


                                <!-- DELETE -->

                                <button
                                        type="button"
                                        class="action-btn delete-action"
                                        title="Delete User"

                                        data-id="<%= currentUser.getId() %>"

                                        data-username="<%= username %>"

                                        data-role="<%= roleName %>"

                                        onclick="openDeleteModalFromButton(this)">

                                    <i class="fa-solid fa-trash"></i>

                                </button>


                            </div>

                        </td>


                    </tr>


                    <%
                        }

                    } else {
                    %>


                    <tr>

                        <td
                                colspan="8"
                                style="
                                text-align:center;
                                padding:45px;
                                ">

                            <i
                                    class="fa-solid fa-users"
                                    style="
                                    font-size:32px;
                                    color:#CBD5E1;
                                    margin-bottom:10px;
                                    ">
                            </i>

                            <div
                                    style="
                                    color:var(--navy);
                                    font-weight:700;
                                    font-size:13px;
                                    margin-bottom:5px;
                                    ">

                                No users found

                            </div>

                            <div
                                    style="
                                    color:var(--muted);
                                    font-size:9px;
                                    ">

                                Registered users will appear here.

                            </div>

                        </td>

                    </tr>


                    <%
                        }
                    %>


                    </tbody>

                </table>


                <!-- EMPTY FILTER STATE -->

                <div
                        class="empty-state"
                        id="emptyState">

                    <i class="fa-solid fa-user-slash"></i>

                    <h3>
                        No users found
                    </h3>

                    <p>
                        No users match your current search or filters.
                    </p>

                </div>

            </div>


            <!-- FOOTER -->

            <div class="table-footer">

                <span
                        class="table-info"
                        id="tableInfo">

                    Showing <%= totalUsers %> users

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
     VIEW USER MODAL
     ============================================================ -->

<div
        class="modal-overlay"
        id="viewUserModal">


    <div class="user-modal">


        <div class="modal-header">

            <h2>

                <i
                        class="fa-solid fa-user"
                        style="
                        color:var(--orange);
                        margin-right:7px;
                        ">
                </i>

                User Details

            </h2>


            <button
                    class="modal-close"
                    type="button"
                    onclick="closeViewUserModal()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <div class="modal-body">


            <!-- PROFILE -->

            <div class="profile-summary">

                <div
                        class="large-avatar"
                        id="viewAvatar">

                    U

                </div>


                <div class="profile-summary-info">

                    <h3 id="viewFullName">
                        User
                    </h3>

                    <p id="viewUsername">
                        @username
                    </p>

                </div>

            </div>


            <!-- DETAILS -->

            <div class="details-grid">


                <div class="detail-box">

                    <div class="detail-label">
                        Email
                    </div>

                    <div
                            class="detail-value"
                            id="viewEmail">

                        -

                    </div>

                </div>


                <div class="detail-box">

                    <div class="detail-label">
                        Mobile
                    </div>

                    <div
                            class="detail-value"
                            id="viewMobile">

                        -

                    </div>

                </div>


                <div class="detail-box">

                    <div class="detail-label">
                        Role
                    </div>

                    <div
                            class="detail-value"
                            id="viewRole">

                        -

                    </div>

                </div>


                <div class="detail-box">

                    <div class="detail-label">
                        Status
                    </div>

                    <div
                            class="detail-value"
                            id="viewStatus">

                        -

                    </div>

                </div>


                <div class="detail-box">

                    <div class="detail-label">
                        City
                    </div>

                    <div
                            class="detail-value"
                            id="viewCity">

                        -

                    </div>

                </div>


                <div class="detail-box">

                    <div class="detail-label">
                        Company
                    </div>

                    <div
                            class="detail-value"
                            id="viewCompany">

                        -

                    </div>

                </div>


                <div class="detail-box">

                    <div class="detail-label">
                        Job Title
                    </div>

                    <div
                            class="detail-value"
                            id="viewJobTitle">

                        -

                    </div>

                </div>


                <div class="detail-box">

                    <div class="detail-label">
                        Postal Code
                    </div>

                    <div
                            class="detail-value"
                            id="viewPostalCode">

                        -

                    </div>

                </div>


                <div class="detail-box full">

                    <div class="detail-label">
                        Address
                    </div>

                    <div
                            class="detail-value"
                            id="viewAddress">

                        -

                    </div>

                </div>


                <div class="detail-box full">

                    <div class="detail-label">
                        Account Created
                    </div>

                    <div
                            class="detail-value"
                            id="viewCreated">

                        -

                    </div>

                </div>


            </div>


        </div>


        <div class="modal-footer">

            <button
                    type="button"
                    class="btn btn-secondary"
                    onclick="closeViewUserModal()">

                Close

            </button>

        </div>


    </div>

</div>


<!-- ============================================================
     CHANGE STATUS MODAL
     ============================================================ -->

<div
        class="modal-overlay"
        id="statusModal">


    <div class="user-modal"
         style="max-width:480px;">


        <div class="modal-header">

            <h2>

                <i
                        class="fa-solid fa-user-gear"
                        style="
                        color:var(--orange);
                        margin-right:7px;
                        ">
                </i>

                Change Account Status

            </h2>


            <button
                    class="modal-close"
                    type="button"
                    onclick="closeStatusModal()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <form
                action="${pageContext.request.contextPath}/UserServlet"
                method="post">


            <input
                    type="hidden"
                    name="action"
                    value="changeStatus">


            <input
                    type="hidden"
                    name="id"
                    id="statusUserId">


            <div class="modal-body">


                <div style="
                        text-align:center;
                        padding:10px 0 20px;
                ">

                    <div
                            class="large-avatar"
                            id="statusAvatar"
                            style="margin:0 auto 12px;">

                        U

                    </div>


                    <h3
                            id="statusUsername"
                            style="
                            margin:0 0 5px;
                            color:var(--navy);
                            ">

                        @username

                    </h3>


                    <p
                            id="currentStatusText"
                            style="
                            margin:0;
                            color:var(--muted);
                            ">

                        Current status: -

                    </p>

                </div>


                <div class="form-group">

                    <label class="form-label">

                        New Status
                        <span class="required">*</span>

                    </label>


                    <select
                            name="statusId"
                            id="statusSelect"
                            class="form-select"
                            required>

                        <option value="">
                            Select New Status
                        </option>


                        <%
                            for (Status status : statuses) {

                                if (status != null &&
                                        status.getId() != null &&
                                        status.getName() != null) {
                        %>

                        <option value="<%= status.getId() %>">

                            <%= status.getName() %>

                        </option>

                        <%
                                }
                            }
                        %>

                    </select>

                </div>


                <div
                        style="
                        margin-top:15px;
                        padding:12px;
                        border-radius:8px;
                        background:#F8FAFC;
                        color:var(--muted);
                        font-size:11px;
                        line-height:1.5;
                        ">

                    <i class="fa-solid fa-circle-info"
                       style="margin-right:5px;">
                    </i>

                    Changing the status controls whether this
                    account can access the system.

                </div>


            </div>


            <div class="modal-footer">

                <button
                        type="button"
                        class="btn btn-secondary"
                        onclick="closeStatusModal()">

                    Cancel

                </button>


                <button
                        type="submit"
                        class="btn btn-primary">

                    <i class="fa-solid fa-check"></i>

                    Update Status

                </button>

            </div>


        </form>

    </div>

</div>

<!-- ============================================================
     CHANGE ROLE MODAL
     ============================================================ -->

<div
        class="modal-overlay"
        id="roleModal">

    <div class="user-modal"
         style="max-width:480px;">

        <div class="modal-header">

            <h2>

                <i
                        class="fa-solid fa-user-tag"
                        style="
                        color:var(--orange);
                        margin-right:7px;
                        ">
                </i>

                Change User Role

            </h2>

            <button
                    class="modal-close"
                    type="button"
                    onclick="closeRoleModal()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <form
                action="${pageContext.request.contextPath}/UserServlet"
                method="post">

            <input
                    type="hidden"
                    name="action"
                    value="changeRole">

            <input
                    type="hidden"
                    name="id"
                    id="roleUserId">


            <div class="modal-body">

                <div style="
                        text-align:center;
                        padding:10px 0 20px;
                ">

                    <div
                            class="large-avatar"
                            id="roleAvatar"
                            style="margin:0 auto 12px;">

                        U

                    </div>


                    <h3
                            id="roleUsername"
                            style="
                            margin:0 0 5px;
                            color:var(--navy);
                            ">

                        @username

                    </h3>


                    <p
                            id="currentRoleText"
                            style="
                            margin:0;
                            color:var(--muted);
                            ">

                        Current role: -

                    </p>

                </div>


                <div class="form-group">

                    <label class="form-label">

                        New Role

                        <span class="required">*</span>

                    </label>


                    <select
                            name="roleId"
                            id="roleSelect"
                            class="form-select"
                            required>

                        <option value="">

                            Select New Role

                        </option>


                        <%
                            for (Role role : roles) {

                                if (role != null &&
                                        role.getId() != null &&
                                        role.getName() != null) {
                        %>

                        <option value="<%= role.getId() %>">

                            <%= role.getName() %>

                        </option>

                        <%
                                }
                            }
                        %>

                    </select>

                </div>


                <div
                        style="
                        margin-top:15px;
                        padding:12px;
                        border-radius:8px;
                        background:#F8FAFC;
                        color:var(--muted);
                        font-size:11px;
                        line-height:1.5;
                        ">

                    <i
                            class="fa-solid fa-circle-info"
                            style="margin-right:5px;">
                    </i>

                    Changing the role controls the permissions
                    available to this user.

                </div>

            </div>


            <div class="modal-footer">

                <button
                        type="button"
                        class="btn btn-secondary"
                        onclick="closeRoleModal()">

                    Cancel

                </button>


                <button
                        type="submit"
                        class="btn btn-primary">

                    <i class="fa-solid fa-check"></i>

                    Update Role

                </button>

            </div>

        </form>

    </div>

</div>
<!-- ============================================================
     DELETE USER MODAL
     ============================================================ -->

<div
        class="modal-overlay"
        id="deleteUserModal">


    <div class="user-modal"
         style="max-width:480px;">


        <div class="modal-header">

            <h2>

                <i
                        class="fa-solid fa-trash"
                        style="
                        color:#DC2626;
                        margin-right:7px;
                        ">
                </i>

                Delete User

            </h2>


            <button
                    class="modal-close"
                    type="button"
                    onclick="closeDeleteModal()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <form
                action="${pageContext.request.contextPath}/UserServlet"
                method="post">


            <input
                    type="hidden"
                    name="action"
                    value="delete">


            <input
                    type="hidden"
                    name="id"
                    id="deleteUserId">


            <div class="modal-body">


                <div style="
                        text-align:center;
                        padding:15px 0 20px;
                ">

                    <div
                            style="
                            width:64px;
                            height:64px;
                            margin:0 auto 15px;
                            border-radius:50%;
                            display:flex;
                            align-items:center;
                            justify-content:center;
                            background:#FEF2F2;
                            color:#DC2626;
                            font-size:25px;
                            ">

                        <i class="fa-solid fa-user-xmark"></i>

                    </div>


                    <h3
                            style="
                            margin:0 0 8px;
                            color:var(--navy);
                            ">

                        Delete User Account?

                    </h3>


                    <p
                            style="
                            margin:0;
                            color:var(--muted);
                            line-height:1.6;
                            ">

                        You are about to permanently delete

                        <strong
                                id="deleteUsername"
                                style="color:var(--navy);">
                        </strong>

                        .

                    </p>

                </div>


                <div
                        style="
                        padding:13px;
                        background:#FEF2F2;
                        border:1px solid #FECACA;
                        border-radius:8px;
                        color:#991B1B;
                        font-size:11px;
                        line-height:1.5;
                        ">

                    <i class="fa-solid fa-triangle-exclamation"
                       style="margin-right:5px;">
                    </i>

                    This action cannot be undone. Make sure the
                    user does not have important records that
                    depend on this account.

                </div>


            </div>


            <div class="modal-footer">

                <button
                        type="button"
                        class="btn btn-secondary"
                        onclick="closeDeleteModal()">

                    Cancel

                </button>


                <button
                        type="submit"
                        class="btn"
                        style="
                        background:#DC2626;
                        color:white;
                        ">

                    <i class="fa-solid fa-trash"></i>

                    Delete User

                </button>

            </div>


        </form>

    </div>

</div>

<script>

    /* ============================================================
       VIEW USER
       ============================================================ */

    function viewUserFromButton(button) {

        const fullName =
            button.dataset.fullname || "User";


        const username =
            button.dataset.username || "username";


        const avatar =
            fullName.charAt(0).toUpperCase();


        document.getElementById("viewAvatar").innerText =
            avatar;


        document.getElementById("viewFullName").innerText =
            fullName;


        document.getElementById("viewUsername").innerText =
            "@" + username;


        document.getElementById("viewEmail").innerText =
            button.dataset.email || "N/A";


        document.getElementById("viewMobile").innerText =
            button.dataset.mobile || "N/A";


        document.getElementById("viewRole").innerText =
            button.dataset.role || "N/A";


        document.getElementById("viewStatus").innerText =
            button.dataset.status || "N/A";


        document.getElementById("viewCity").innerText =
            button.dataset.city || "N/A";


        document.getElementById("viewCompany").innerText =
            button.dataset.company || "N/A";


        document.getElementById("viewJobTitle").innerText =
            button.dataset.jobtitle || "N/A";


        document.getElementById("viewAddress").innerText =
            button.dataset.address || "N/A";


        document.getElementById("viewPostalCode").innerText =
            button.dataset.postalcode || "N/A";


        document.getElementById("viewCreated").innerText =
            button.dataset.created || "N/A";


        document
            .getElementById("viewUserModal")
            .classList.add("show");
    }


    function closeViewUserModal() {

        document
            .getElementById("viewUserModal")
            .classList.remove("show");
    }


    /* ============================================================
       CHANGE STATUS
       ============================================================ */

    function openStatusModalFromButton(button) {

        const id =
            button.dataset.id || "";


        const username =
            button.dataset.username || "User";


        const currentStatus =
            button.dataset.status || "N/A";


        document.getElementById("statusUserId").value =
            id;


        document.getElementById("statusUsername").innerText =
            "@" + username;


        document.getElementById("currentStatusText").innerText =
            "Current status: " + currentStatus;


        document.getElementById("statusAvatar").innerText =
            username.charAt(0).toUpperCase();


        document.getElementById("statusSelect").value = "";


        document
            .getElementById("statusModal")
            .classList.add("show");
    }


    function closeStatusModal() {

        document
            .getElementById("statusModal")
            .classList.remove("show");
    }

    /* ============================================================
   CHANGE ROLE
   ============================================================ */

    function openRoleModalFromButton(button) {

        const id =
            button.dataset.id || "";


        const username =
            button.dataset.username || "User";


        const currentRole =
            button.dataset.role || "N/A";


        document.getElementById("roleUserId").value =
            id;


        document.getElementById("roleUsername").innerText =
            "@" + username;


        document.getElementById("currentRoleText").innerText =
            "Current role: " + currentRole;


        document.getElementById("roleAvatar").innerText =
            username.charAt(0).toUpperCase();


        document.getElementById("roleSelect").value = "";


        document
            .getElementById("roleModal")
            .classList.add("show");
    }


    function closeRoleModal() {

        document
            .getElementById("roleModal")
            .classList.remove("show");
    }

    /* ============================================================
       DELETE USER
       ============================================================ */

    function openDeleteModalFromButton(button) {

        const id =
            button.dataset.id || "";


        const username =
            button.dataset.username || "this user";


        document.getElementById("deleteUserId").value =
            id;


        document.getElementById("deleteUsername").innerText =
            "@" + username;


        document
            .getElementById("deleteUserModal")
            .classList.add("show");
    }


    function closeDeleteModal() {

        document
            .getElementById("deleteUserModal")
            .classList.remove("show");
    }


    /* ============================================================
       FILTER USERS
       ============================================================ */

    function filterUsers() {

        const search =
            document
                .getElementById("userSearch")
                .value
                .toLowerCase()
                .trim();


        const role =
            document
                .getElementById("roleFilter")
                .value
                .toLowerCase();


        const status =
            document
                .getElementById("statusFilter")
                .value
                .toLowerCase();


        const rows =
            document.querySelectorAll(
                ".user-row"
            );


        let visibleCount = 0;


        rows.forEach(function(row) {

            const rowSearch =
                row.getAttribute(
                    "data-search"
                ) || "";


            const rowRole =
                row.getAttribute(
                    "data-role"
                ) || "";


            const rowStatus =
                row.getAttribute(
                    "data-status"
                ) || "";


            const searchMatch =
                search === "" ||
                rowSearch.includes(search);


            const roleMatch =
                role === "" ||
                rowRole === role;


            const statusMatch =
                status === "" ||
                rowStatus === status;


            if (
                searchMatch &&
                roleMatch &&
                statusMatch
            ) {

                row.style.display = "";

                visibleCount++;

            } else {

                row.style.display = "none";

            }

        });


        document
            .getElementById("tableInfo")
            .innerText =
            "Showing " +
            visibleCount +
            " users";


        const emptyState =
            document.getElementById(
                "emptyState"
            );


        if (visibleCount === 0) {

            emptyState.style.display =
                "block";

        } else {

            emptyState.style.display =
                "none";
        }
    }


    /* ============================================================
       RESET FILTERS
       ============================================================ */

    function resetFilters() {

        document
            .getElementById("userSearch")
            .value = "";


        document
            .getElementById("roleFilter")
            .value = "";


        document
            .getElementById("statusFilter")
            .value = "";


        filterUsers();
    }


    /* ============================================================
       CLOSE MODALS WHEN CLICKING OUTSIDE
       ============================================================ */

    document.addEventListener(
        "DOMContentLoaded",
        function() {

            const modals = [
                "editUserModal",
                "viewUserModal",
                "statusModal",
                "roleModal",
                "deleteUserModal"
            ];


            modals.forEach(function(modalId) {

                const modal =
                    document.getElementById(
                        modalId
                    );


                if (modal) {

                    modal.addEventListener(
                        "click",
                        function(event) {

                            if (
                                event.target ===
                                this
                            ) {

                                this.classList
                                    .remove("show");

                            }

                        }
                    );

                }

            });


            filterUsers();

        }
    );


    /* ============================================================
       TOAST
       ============================================================ */

    function closeToast(id) {

        const toast =
            document.getElementById(id);


        if (toast) {

            toast.remove();

        }

    }


    /* ============================================================
       AUTO CLOSE TOAST
       ============================================================ */

    setTimeout(function() {

        closeToast("successToast");

        closeToast("errorToast");

    }, 4000);


    /* ============================================================
       ESCAPE KEY
       ============================================================ */

    document.addEventListener(
        "keydown",
        function(event) {

            if (event.key === "Escape") {

                closeViewUserModal();

                closeStatusModal();

                closeRoleModal();

                closeDeleteModal();

            }

        }
    );


</script>


</body>

</html>