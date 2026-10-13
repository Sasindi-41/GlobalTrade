<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("activePage", "profile");
%>
<%
    /*
     * ============================================================
     * CHECK LOGGED-IN SESSION
     * ============================================================
     */

    jakarta.servlet.http.HttpSession userSession =
            request.getSession(false);

    if (userSession == null ||
            !Boolean.TRUE.equals(
                    userSession.getAttribute("authenticated")
            )) {

        response.sendRedirect(
                request.getContextPath() + "/signin"
        );

        return;
    }

    String successMessage =
            (String) userSession.getAttribute("successMessage");


    if (successMessage != null) {

        userSession.removeAttribute("successMessage");
    }
    /*
     * ============================================================
     * GET USER FROM REQUEST
     *
     * ProfileServlet loads the User from the database and
     * forwards it using:
     *
     * request.setAttribute("user", user);
     * ============================================================
     */

    lk.sasindi.globaltrade.entity.User user =
            (lk.sasindi.globaltrade.entity.User)
                    request.getAttribute("user");


    java.util.List<lk.sasindi.globaltrade.entity.City> cities =
            (java.util.List<lk.sasindi.globaltrade.entity.City>)
                    request.getAttribute("cities");


    if (user == null) {

        response.sendError(
                jakarta.servlet.http.HttpServletResponse.SC_NOT_FOUND,
                "User profile could not be loaded."
        );

        return;
    }


    /*
     * ============================================================
     * USER DATA
     * ============================================================
     */

    String username =
            user.getUsername();

    String firstName =
            user.getFirstName() != null
                    ? user.getFirstName()
                    : "";

    String lastName =
            user.getLastName() != null
                    ? user.getLastName()
                    : "";

    String email =
            user.getEmail() != null
                    ? user.getEmail()
                    : "";

    String phone =
            user.getMobile() != null
                    ? user.getMobile()
                    : "";

    String company =
            user.getCompany() != null
                    ? user.getCompany()
                    : "";

    String jobTitle =
            user.getJobTitle() != null
                    ? user.getJobTitle()
                    : "";

    String address =
            user.getAddress() != null
                    ? user.getAddress()
                    : "";

    String city = "";

    if (user.getCity() != null) {

        city =
                user.getCity().getName();
    }

    String postalCode =
            user.getPostalCode() != null
                    ? user.getPostalCode()
                    : "";


    /*
     * ============================================================
     * DISPLAY NAME
     * ============================================================
     */

    String displayName;

    if (!firstName.isEmpty() || !lastName.isEmpty()) {

        displayName =
                (firstName + " " + lastName).trim();

    } else {

        displayName = username;
    }


    /*
     * ============================================================
     * AVATAR LETTER
     * ============================================================
     */

    String avatarLetter =
            !displayName.isEmpty()
                    ? displayName.substring(0, 1).toUpperCase()
                    : "U";


    /*
     * ============================================================
     * ROLE
     * ============================================================
     */

    String role = "USER";

    if (userSession.getAttribute("role") != null) {

        role =
                String.valueOf(
                        userSession.getAttribute("role")
                );
    }


    /*
     * ============================================================
     * ACCOUNT STATUS
     * ============================================================
     */

    String accountStatus = "Active";

    if (user.getStatus() != null) {

        accountStatus =
                user.getStatus().getName();
    }



    /*
     * ============================================================
     * MEMBER SINCE
     * ============================================================
     */

    String memberSince = "Registered User";

    if (user.getCreatedAt() != null) {

        memberSince =
                user.getCreatedAt()
                        .toLocalDate()
                        .toString();
    }


    /*
     * ============================================================
     * NOTIFICATIONS
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

    <title>GlobalTrade | Profile</title>

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

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

            --border: rgba(0, 48, 73, 0.10);

            --sidebar-width: 250px;
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

            transition: .2s ease;
        }


        .support-button:hover {

            background: var(--orange);

            color: white;
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


        /* ============================================================
           PROFILE HERO
           ============================================================ */

        .profile-hero {

            background: var(--card);

            border: 1px solid var(--border);

            border-radius: 12px;

            padding: 22px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 14px;
        }


        .profile-identity {

            display: flex;

            align-items: center;

            gap: 18px;
        }


        .profile-avatar {

            width: 82px;
            height: 82px;

            border-radius: 50%;

            background: var(--orange);

            color: white;

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 30px;

            font-weight: 700;

            flex-shrink: 0;

            box-shadow:
                    0 7px 18px rgba(247,127,0,.20);
        }


        .profile-name {

            color: var(--navy);

            font-size: 22px;

            font-weight: 700;

            margin-bottom: 4px;
        }


        .profile-role {

            color: var(--muted);

            font-size: 12px;

            margin-bottom: 8px;
        }


        .profile-id {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            background: rgba(252,191,73,.18);

            color: var(--navy);

            border-radius: 5px;

            padding: 5px 8px;

            font-size: 9px;

            font-weight: 700;
        }


        .profile-actions {

            display: flex;

            gap: 9px;
        }


        /* ============================================================
           BUTTONS
           ============================================================ */

        .btn {

            height: 38px;

            padding: 0 15px;

            border-radius: 7px;

            font-size: 10px;

            font-weight: 700;

            cursor: pointer;

            border: 1px solid transparent;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            transition: .2s ease;
        }


        .btn-primary {

            background: var(--yellow);

            color: var(--navy);
        }


        .btn-primary:hover {

            background: var(--orange);

            color: white;
        }


        .btn-secondary {

            background: white;

            border-color: var(--border);

            color: var(--navy);
        }


        .btn-secondary:hover {

            border-color: var(--yellow);

            background: #FFFDF5;
        }


        .btn-danger {

            background: rgba(214,40,40,.09);

            color: var(--red);

            border-color: rgba(214,40,40,.12);
        }


        .btn-danger:hover {

            background: var(--red);

            color: white;
        }


        /* ============================================================
           PROFILE GRID
           ============================================================ */

        .profile-grid {

            display: grid;

            grid-template-columns: 1.35fr .85fr;

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

            border-bottom: 1px solid rgba(0,48,73,.06);
        }


        .card-header h2 {

            color: var(--navy);

            font-size: 14px;
        }


        .card-header p {

            color: var(--muted);

            font-size: 9px;
        }


        /* ============================================================
           INFORMATION
           ============================================================ */

        .info-content {

            padding: 17px;
        }


        .info-grid {

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 15px 20px;
        }


        .info-field {

            min-width: 0;
        }


        .info-field.full {

            grid-column: 1 / -1;
        }


        .info-label {

            display: block;

            color: var(--muted);

            font-size: 9px;

            font-weight: 600;

            margin-bottom: 6px;
        }


        .info-value {

            min-height: 38px;

            display: flex;

            align-items: center;

            padding: 0 11px;

            background: #FFFDF7;

            border: 1px solid rgba(0,48,73,.08);

            border-radius: 7px;

            color: var(--navy);

            font-size: 11px;

            font-weight: 600;

            word-break: break-word;
        }


        .info-value i {

            width: 22px;

            color: var(--orange);

            font-size: 12px;

            margin-right: 5px;
        }


        /* ============================================================
           ACCOUNT INFORMATION
           ============================================================ */

        .account-content {

            padding: 15px;
        }


        .account-row {

            display: flex;

            align-items: center;

            gap: 11px;

            padding: 12px 0;

            border-bottom: 1px solid rgba(0,48,73,.07);
        }


        .account-row:last-child {

            border-bottom: none;
        }


        .account-icon {

            width: 34px;
            height: 34px;

            border-radius: 8px;

            display: flex;

            align-items: center;
            justify-content: center;

            background: rgba(252,191,73,.20);

            color: var(--navy);

            font-size: 12px;

            flex-shrink: 0;
        }


        .account-text {

            flex: 1;
        }


        .account-label {

            display: block;

            color: var(--muted);

            font-size: 8px;

            margin-bottom: 3px;
        }


        .account-value {

            color: var(--navy);

            font-size: 10px;

            font-weight: 700;

            word-break: break-word;
        }


        .active-status {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            background: rgba(252,191,73,.25);

            color: var(--navy);

            padding: 4px 7px;

            border-radius: 5px;

            font-size: 8px;

            font-weight: 700;
        }


        .active-status::before {

            content: "";

            width: 6px;
            height: 6px;

            border-radius: 50%;

            background: #28a745;
        }


        /* ============================================================
           CONTACT
           ============================================================ */

        .contact-list {

            padding: 5px 15px 12px;
        }


        .contact-item {

            display: flex;

            align-items: center;

            gap: 11px;

            padding: 11px 0;

            border-bottom: 1px solid rgba(0,48,73,.07);
        }


        .contact-item:last-child {

            border-bottom: none;
        }


        .contact-icon {

            width: 35px;
            height: 35px;

            border-radius: 8px;

            background: rgba(0,48,73,.07);

            color: var(--navy);

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 12px;
        }


        .contact-details {

            min-width: 0;
        }


        .contact-label {

            color: var(--muted);

            font-size: 8px;

            margin-bottom: 3px;

            display: block;
        }


        .contact-value {

            color: var(--navy);

            font-size: 10px;

            font-weight: 600;

            word-break: break-word;
        }


        /* ============================================================
           SECURITY
           ============================================================ */

        .security-card {

            margin-bottom: 14px;
        }


        .security-content {

            padding: 15px 17px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 20px;
        }


        .security-info {

            display: flex;

            align-items: center;

            gap: 12px;
        }


        .security-icon {

            width: 42px;
            height: 42px;

            border-radius: 9px;

            background: rgba(0,48,73,.08);

            color: var(--navy);

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 15px;
        }


        .security-info h3 {

            color: var(--navy);

            font-size: 11px;

            margin-bottom: 3px;
        }


        .security-info p {

            color: var(--muted);

            font-size: 9px;
        }


        /* ============================================================
           EDIT FORM
           ============================================================ */

        .edit-form {

            padding: 17px;
        }


        .form-grid {

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 14px 18px;
        }


        .form-group.full {

            grid-column: 1 / -1;
        }


        .form-group label {

            display: block;

            color: var(--muted);

            font-size: 9px;

            font-weight: 600;

            margin-bottom: 6px;
        }


        .form-group input {

            width: 100%;

            height: 38px;

            padding: 0 11px;

            border: 1px solid var(--border);

            border-radius: 7px;

            background: #FFFDF7;

            color: var(--navy);

            font-size: 10px;

            outline: none;

            transition: .2s ease;
        }


        .form-group input:focus {

            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252,191,73,.12);
        }


        .form-actions {

            margin-top: 17px;

            display: flex;

            justify-content: flex-end;

            gap: 8px;
        }

        .form-group select {

            width: 100%;

            height: 38px;

            padding: 0 11px;

            border: 1px solid var(--border);

            border-radius: 7px;

            background: #FFFDF7;

            color: var(--navy);

            font-size: 10px;

            outline: none;

            transition: .2s ease;
        }


        .form-group select:focus {

            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252,191,73,.12);
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
           SUCCESS TOAST
           ============================================================ */

        .success-toast {

            position: fixed;

            top: 85px;
            right: 25px;

            min-width: 300px;

            padding: 14px 16px;

            background: #ffffff;

            border: 1px solid rgba(40, 167, 69, .20);

            border-left: 4px solid #28a745;

            border-radius: 9px;

            box-shadow:
                    0 8px 25px rgba(0, 0, 0, .12);

            display: flex;

            align-items: center;

            gap: 10px;

            color: var(--navy);

            font-size: 12px;

            font-weight: 600;

            z-index: 9999;

            animation:
                    toastSlideIn .3s ease;
        }


        .success-toast > i {

            color: #28a745;

            font-size: 17px;

            flex-shrink: 0;
        }


        .success-toast span {

            flex: 1;
        }


        .success-toast button {

            width: 24px;
            height: 24px;

            border: none;

            background: transparent;

            color: var(--muted);

            cursor: pointer;

            display: flex;

            align-items: center;
            justify-content: center;

            border-radius: 5px;

            font-size: 11px;

            transition: .2s ease;
        }


        .success-toast button:hover {

            background: rgba(0, 48, 73, .06);

            color: var(--navy);
        }


        @keyframes toastSlideIn {

            from {

                opacity: 0;

                transform: translateX(30px);
            }

            to {

                opacity: 1;

                transform: translateX(0);
            }
        }


        @keyframes toastSlideOut {

            from {

                opacity: 1;

                transform: translateX(0);
            }

            to {

                opacity: 0;

                transform: translateX(30px);
            }
        }
        /* ============================================================
           RESPONSIVE
           ============================================================ */

        @media (max-width: 1100px) {

            .profile-grid {

                grid-template-columns: 1fr;
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


            .main {

                margin-left: var(--sidebar-width);
            }
        }


        @media (max-width: 650px) {

            .content {

                padding: 15px 12px;
            }


            .topbar {

                padding: 0 12px;
            }


            .top-user span,
            .top-user small {

                display: none;
            }


            .profile-hero {

                flex-direction: column;

                align-items: flex-start;

                gap: 17px;
            }


            .profile-actions {

                width: 100%;
            }


            .profile-actions .btn {

                flex: 1;
            }


            .profile-avatar {

                width: 70px;
                height: 70px;

                font-size: 25px;
            }


            .profile-name {

                font-size: 19px;
            }


            .info-grid,
            .form-grid {

                grid-template-columns: 1fr;
            }


            .info-field.full,
            .form-group.full {

                grid-column: auto;
            }


            .security-content {

                align-items: flex-start;

                flex-direction: column;
            }


            .security-content .btn {

                width: 100%;
            }


            .footer {

                flex-direction: column;

                gap: 5px;
            }
        }
        .topbar-page {
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .topbar-page-title {
            color: var(--navy);
            font-size: 14px;
            font-weight: 700;
        }

        .topbar-page-subtitle {
            color: var(--muted);
            font-size: 10px;
            font-weight: 400;
        }

        @media (max-width: 650px) {

            .topbar-page-subtitle {
                display: none;
            }

            .topbar-page-title {
                font-size: 13px;
            }
        }
    </style>

</head>


<body>
<%
    if (successMessage != null) {
%>

<div class="success-toast" id="successToast">

    <i class="fa-solid fa-circle-check"></i>

    <span>
        <%= successMessage %>
    </span>

    <button type="button"
            onclick="closeSuccessToast()"
            aria-label="Close">

        <i class="fa-solid fa-xmark"></i>

    </button>

</div>

<%
    }
%>

<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<jsp:include page="user-sidebar.jsp"/>


<!-- ============================================================
     MAIN
     ============================================================ -->

<main class="main">


    <!-- TOPBAR -->

    <jsp:include page="user-topbar.jsp"/>


    <!-- ========================================================
         CONTENT
         ======================================================== -->

    <section class="content">





        <!-- ====================================================
             PROFILE HERO
             ==================================================== -->

        <div class="profile-hero">


            <div class="profile-identity">

                <div class="profile-avatar">

                    <%= avatarLetter %>

                </div>


                <div>

                    <div class="profile-name">

                        <%= displayName %>

                    </div>

                    <div class="profile-role">

                        <%= jobTitle.isEmpty() ? "Customer" : jobTitle %>

                        &nbsp;•&nbsp;

                        <%= company.isEmpty() ? "GlobalTrade Customer" : company %>

                    </div>

                    <span class="profile-id">

    <i class="fa-solid fa-user-check"></i>

    GlobalTrade Account

</span>

                </div>

            </div>


            <div class="profile-actions">

                <button class="btn btn-secondary"
                        type="button"
                        onclick="showEditForm()">

                    <i class="fa-solid fa-pen"></i>

                    Edit Profile

                </button>



            </div>

        </div>


        <!-- ====================================================
             PERSONAL + ACCOUNT INFORMATION
             ==================================================== -->

        <div class="profile-grid">


            <!-- PERSONAL INFORMATION -->

            <div class="card">

                <div class="card-header">

                    <h2>
                        Personal Information
                    </h2>

                    <i class="fa-solid fa-user"
                       style="color:var(--orange);font-size:13px;">
                    </i>

                </div>


                <div class="info-content">

                    <div class="info-grid">


                        <!-- USERNAME -->

                        <div class="info-field">

                            <span class="info-label">
                                Username
                            </span>

                            <div class="info-value">

                                <i class="fa-regular fa-user"></i>

                                <%= username %>

                            </div>

                        </div>


                        <!-- EMAIL -->

                        <div class="info-field">

                            <span class="info-label">
                                Email Address
                            </span>

                            <div class="info-value">

                                <i class="fa-regular fa-envelope"></i>

                                <%= email %>

                            </div>

                        </div>


                        <!-- FIRST NAME -->

                        <div class="info-field">

                            <span class="info-label">
                                First Name
                            </span>

                            <div class="info-value">

                                <i class="fa-regular fa-user"></i>

                                <%= firstName.isEmpty() ? "Not provided" : firstName %>

                            </div>

                        </div>


                        <!-- LAST NAME -->

                        <div class="info-field">

                            <span class="info-label">
                                Last Name
                            </span>

                            <div class="info-value">

                                <i class="fa-regular fa-user"></i>

                                <%= lastName.isEmpty() ? "Not provided" : lastName %>

                            </div>

                        </div>


                        <!-- PHONE -->

                        <div class="info-field">

                            <span class="info-label">
                                Phone Number
                            </span>

                            <div class="info-value">

                                <i class="fa-solid fa-phone"></i>

                                <%= phone.isEmpty() ? "Not provided" : phone %>

                            </div>

                        </div>


                        <!-- JOB TITLE -->

                        <div class="info-field">

                            <span class="info-label">
                                Job Title
                            </span>

                            <div class="info-value">

                                <i class="fa-solid fa-briefcase"></i>

                                <%= jobTitle.isEmpty() ? "Not provided" : jobTitle %>

                            </div>

                        </div>


                        <!-- COMPANY -->

                        <div class="info-field">

                            <span class="info-label">
                                Company
                            </span>

                            <div class="info-value">

                                <i class="fa-solid fa-building"></i>

                                <%= company.isEmpty() ? "Not provided" : company %>

                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- ACCOUNT INFORMATION -->

            <div class="card">

                <div class="card-header">

                    <h2>
                        Account Information
                    </h2>

                </div>


                <div class="account-content">




                    <!-- STATUS -->

                    <div class="account-row">

                        <div class="account-icon">

                            <i class="fa-solid fa-circle-check"></i>

                        </div>

                        <div class="account-text">

                            <span class="account-label">
                                Account Status
                            </span>

                            <span class="active-status">

                                <%= accountStatus %>

                            </span>

                        </div>

                    </div>


                    <!-- ROLE -->

                    <div class="account-row">

                        <div class="account-icon">

                            <i class="fa-solid fa-user-tag"></i>

                        </div>

                        <div class="account-text">

                            <span class="account-label">
                                Account Type
                            </span>

                            <span class="account-value">

                                <%= role %>

                            </span>

                        </div>

                    </div>


                    <!-- MEMBER SINCE -->

                    <div class="account-row">

                        <div class="account-icon">

                            <i class="fa-solid fa-calendar"></i>

                        </div>

                        <div class="account-text">

                            <span class="account-label">
                                Member Since
                            </span>

                            <span class="account-value">

                                <%= memberSince %>

                            </span>

                        </div>

                    </div>

                </div>

            </div>

        </div>


        <!-- ====================================================
             CONTACT + ADDRESS
             ==================================================== -->

        <div class="profile-grid">


            <!-- CONTACT -->

            <div class="card">

                <div class="card-header">

                    <h2>
                        Contact Information
                    </h2>

                    <i class="fa-solid fa-address-book"
                       style="color:var(--orange);font-size:13px;">
                    </i>

                </div>


                <div class="contact-list">


                    <!-- EMAIL -->

                    <div class="contact-item">

                        <div class="contact-icon">

                            <i class="fa-regular fa-envelope"></i>

                        </div>

                        <div class="contact-details">

                            <span class="contact-label">
                                Email Address
                            </span>

                            <span class="contact-value">

                                <%= email %>

                            </span>

                        </div>

                    </div>


                    <!-- PHONE -->

                    <div class="contact-item">

                        <div class="contact-icon">

                            <i class="fa-solid fa-phone"></i>

                        </div>

                        <div class="contact-details">

                            <span class="contact-label">
                                Phone Number
                            </span>

                            <span class="contact-value">

                                <%= phone.isEmpty()
                                        ? "Not provided"
                                        : phone %>

                            </span>

                        </div>

                    </div>


                    <!-- ADDRESS -->

                    <div class="contact-item">

                        <div class="contact-icon">

                            <i class="fa-solid fa-location-dot"></i>

                        </div>

                        <div class="contact-details">

                            <span class="contact-label">
                                Address
                            </span>

                            <span class="contact-value">

                                <%= address.isEmpty()
                                        ? "Not provided"
                                        : address %>

                                <%
                                    if (!city.isEmpty()) {
                                %>

                                    , <%= city %>

                                <%
                                    }

                                    if (!postalCode.isEmpty()) {
                                %>

                                    - <%= postalCode %>

                                <%
                                    }
                                %>

                            </span>

                        </div>

                    </div>

                </div>

            </div>


            <!-- =========================================================
     CUSTOMER SUPPORT
     ========================================================= -->

            <div class="card"
                 style="margin-bottom:14px;">


                <div class="card-header">

                    <h2>
                        <i class="fa-solid fa-headset"
                           style="margin-right:7px;"></i>

                        Customer Support
                    </h2>

                </div>


                <div style="padding:18px;">

                    <div style="
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:20px;
    ">

                        <div style="
            display:flex;
            align-items:center;
            gap:14px;
        ">

                            <div style="
                width:42px;
                height:42px;
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                background:#eef4ff;
                color:#0066ff;
                flex-shrink:0;
            ">

                                <i class="fa-solid fa-circle-question"></i>

                            </div>


                            <div>

                                <div style="
                    font-size:13px;
                    font-weight:700;
                    margin-bottom:5px;
                ">
                                    Need help?
                                </div>

                                <div style="
                    font-size:10px;
                    color:#64748b;
                    line-height:1.6;
                ">
                                    Contact our support team if you need
                                    assistance with shipments, invoices,
                                    documents, or your account.
                                </div>

                            </div>

                        </div>


                        <a href="${pageContext.request.contextPath}/support"
                           class="btn btn-primary"
                           style="white-space:nowrap;">

                            <i class="fa-solid fa-headset"></i>

                            Contact Support

                        </a>

                    </div>

                </div>


            </div>


        </div>


        <!-- ====================================================
             EDIT PROFILE
             ==================================================== -->

        <div class="card"
             id="editProfileCard"
             style="margin-bottom:14px;display:none;">


            <div class="card-header">

                <h2>
                    Edit Profile
                </h2>

                <button class="btn btn-secondary"
                        type="button"
                        onclick="hideEditForm()"
                        style="height:30px;padding:0 10px;">

                    <i class="fa-solid fa-xmark"></i>

                </button>

            </div>


            <form class="edit-form"
                  action="${pageContext.request.contextPath}/update-profile"
                  method="post">

                <div class="form-grid">


                    <!-- FIRST NAME -->

                    <div class="form-group">

                        <label>
                            First Name
                        </label>

                        <input type="text"
                               name="firstName"
                               value="<%= firstName %>"
                               maxlength="100"
                               required>

                    </div>


                    <!-- LAST NAME -->

                    <div class="form-group">

                        <label>
                            Last Name
                        </label>

                        <input type="text"
                               name="lastName"
                               value="<%= lastName %>"
                               maxlength="100"
                               required>

                    </div>


                    <!-- EMAIL - READ ONLY -->

                    <div class="form-group">

                        <label>
                            Email Address
                        </label>

                        <input type="email"
                               value="<%= email %>"
                               readonly
                               style="
                       background:#F1F5F9;
                       cursor:not-allowed;
                   ">

                        <small style="
                    display:block;
                    margin-top:5px;
                    color:#64748B;
                    font-size:8px;
            ">
                            Email address cannot be changed.
                        </small>

                    </div>


                    <!-- MOBILE -->

                    <div class="form-group">

                        <label>
                            Phone Number
                        </label>

                        <input type="text"
                               name="mobile"
                               value="<%= phone %>"
                               maxlength="10"
                               required>

                    </div>


                    <!-- JOB TITLE -->

                    <div class="form-group">

                        <label>
                            Job Title
                        </label>

                        <input type="text"
                               name="jobTitle"
                               value="<%= jobTitle %>"
                               maxlength="100">

                    </div>


                    <!-- COMPANY -->

                    <div class="form-group">

                        <label>
                            Company
                        </label>

                        <input type="text"
                               name="company"
                               value="<%= company %>"
                               maxlength="150">

                    </div>


                    <!-- ADDRESS -->

                    <div class="form-group full">

                        <label>
                            Address
                        </label>

                        <input type="text"
                               name="address"
                               value="<%= address %>"
                               maxlength="255">

                    </div>


                    <!-- CITY -->
                    <div class="form-group">

                        <label>
                            City
                        </label>

                        <select name="cityId">

                            <option value="">
                                Select City
                            </option>

                            <%
                                if (cities != null) {

                                    for (lk.sasindi.globaltrade.entity.City c : cities) {

                                        boolean selected =
                                                user.getCity() != null &&
                                                        user.getCity().getId().equals(c.getId());
                            %>

                            <option value="<%= c.getId() %>"
                                    <%= selected ? "selected" : "" %>>

                                <%= c.getName() %>

                            </option>

                            <%
                                    }
                                }
                            %>

                        </select>

                    </div>


                    <!-- POSTAL CODE -->

                    <div class="form-group">

                        <label>
                            Postal Code
                        </label>

                        <input type="text"
                               name="postalCode"
                               value="<%= postalCode %>"
                               maxlength="20">

                    </div>


                </div>


                <!-- BUTTONS -->

                <div class="form-actions">

                    <button type="button"
                            class="btn btn-secondary"
                            onclick="hideEditForm()">

                        Cancel

                    </button>


                    <button type="submit"
                            class="btn btn-primary">

                        <i class="fa-solid fa-check"></i>

                        Save Changes

                    </button>

                </div>

            </form>

        </div>
        <!-- =========================================================
             CHANGE PASSWORD
             ========================================================= -->

        <div class="card"
             id="changePasswordCard"
             style="margin-bottom:14px;">


            <div class="card-header">

                <h2>
                    <i class="fa-solid fa-shield-halved"
                       style="margin-right:7px;"></i>

                    Account Security
                </h2>

            </div>


            <div style="padding:18px;">

                <div class="security-content"
                     style="
             display:flex;
             justify-content:space-between;
             align-items:center;
             gap:20px;
         ">

                    <div>

                        <div style="
                font-size:13px;
                font-weight:700;
                margin-bottom:5px;
            ">
                            Password
                        </div>

                        <div style="
                font-size:10px;
                color:#64748b;
                line-height:1.6;
            ">
                            Keep your account secure by regularly updating
                            your password.
                        </div>

                    </div>


                    <button type="button"
                            class="btn btn-secondary"
                            onclick="showPasswordForm()">

                        <i class="fa-solid fa-key"></i>

                        Change Password

                    </button>

                </div>


                <!-- =====================================================
                     PASSWORD FORM
                     ===================================================== -->

                <div id="passwordForm"
                     style="display:none;margin-top:18px;">

                    <form method="post"
                          action="${pageContext.request.contextPath}/profile"
                          class="edit-form">

                        <input type="hidden"
                               name="action"
                               value="changePassword">


                        <!-- CURRENT PASSWORD -->

                        <div class="form-group full">

                            <label>
                                Current Password
                            </label>

                            <input type="password"
                                   id="currentPassword"
                                   name="currentPassword"
                                   minlength="1"
                                   autocomplete="current-password"
                                   required>

                        </div>


                        <!-- NEW PASSWORD -->

                        <div class="form-group full">

                            <label>
                                New Password
                            </label>

                            <input type="password"
                                   id="newPassword"
                                   name="newPassword"
                                   minlength="8"
                                   autocomplete="new-password"
                                   required>

                            <small style="
                    display:block;
                    margin-top:5px;
                    color:#64748b;
                    font-size:8px;
                ">
                                Password must contain at least 8 characters.
                            </small>

                        </div>


                        <!-- CONFIRM PASSWORD -->

                        <div class="form-group full">

                            <label>
                                Confirm New Password
                            </label>

                            <input type="password"
                                   id="confirmPassword"
                                   name="confirmPassword"
                                   minlength="8"
                                   autocomplete="new-password"
                                   required>

                        </div>


                        <!-- ACTIONS -->

                        <div class="form-actions">

                            <button type="submit"
                                    class="btn btn-primary">

                                <i class="fa-solid fa-key"></i>

                                Update Password

                            </button>


                            <button type="button"
                                    class="btn btn-secondary"
                                    onclick="hidePasswordForm()">

                                Cancel

                            </button>

                        </div>

                    </form>

                </div>

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

                Version 1.0.0

            </span>

        </footer>


    </section>

</main>


<!-- ============================================================
     JAVASCRIPT
     ============================================================ -->

<script>

    function showEditForm() {

        const card =
            document.getElementById("editProfileCard");

        card.style.display = "block";

        card.scrollIntoView({

            behavior: "smooth",

            block: "start"

        });

    }


    function hideEditForm() {

        const card =
            document.getElementById("editProfileCard");

        card.style.display = "none";

    }
    function closeToast() {

        const toast =
            document.getElementById("successToast");

        if (toast) {

            toast.classList.add("toast-hide");

            setTimeout(function () {

                toast.remove();

            }, 300);
        }
    }


    // Automatically hide success message after 4 seconds

    document.addEventListener("DOMContentLoaded", function () {

        const toast =
            document.getElementById("successToast");

        if (toast) {

            setTimeout(function () {

                closeToast();

            }, 4000);

        }

    });
</script>
<script>

    // =========================================================
    // SHOW PASSWORD FORM
    // =========================================================

    function showPasswordForm() {

        const form =
            document.getElementById("passwordForm");

        if (form) {

            form.style.display = "block";

            form.scrollIntoView({
                behavior: "smooth",
                block: "center"
            });

        }
    }


    // =========================================================
    // HIDE PASSWORD FORM
    // =========================================================

    function hidePasswordForm() {

        const form =
            document.getElementById("passwordForm");

        if (form) {

            form.style.display = "none";

            const passwordInputs =
                form.querySelectorAll("input[type='password']");

            passwordInputs.forEach(function(input) {
                input.value = "";
            });
        }
    }


    // =========================================================
    // PASSWORD VALIDATION
    // =========================================================

    document.addEventListener("DOMContentLoaded", function() {

        const passwordForm =
            document.querySelector(
                "#passwordForm form"
            );

        if (!passwordForm) {
            return;
        }


        passwordForm.addEventListener(
            "submit",
            function(event) {

                const currentPassword =
                    document.getElementById(
                        "currentPassword"
                    ).value;

                const newPassword =
                    document.getElementById(
                        "newPassword"
                    ).value;

                const confirmPassword =
                    document.getElementById(
                        "confirmPassword"
                    ).value;


                if (currentPassword.trim() === "") {

                    alert(
                        "Please enter your current password."
                    );

                    event.preventDefault();

                    return;
                }


                if (newPassword.length < 8) {

                    alert(
                        "New password must contain at least 8 characters."
                    );

                    event.preventDefault();

                    return;
                }


                if (newPassword !== confirmPassword) {

                    alert(
                        "New password and confirmation do not match."
                    );

                    event.preventDefault();

                    return;
                }


                if (currentPassword === newPassword) {

                    alert(
                        "New password must be different from your current password."
                    );

                    event.preventDefault();

                    return;
                }

            }
        );

    });

</script>


</body>

</html>