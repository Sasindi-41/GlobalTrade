<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%


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

    String sessionRole =
            String.valueOf(
                    adminSession.getAttribute("role")
            );

    if (!"ADMIN".equalsIgnoreCase(sessionRole)) {

        response.sendRedirect(
                request.getContextPath() + "/user/dashboard"
        );

        return;
    }


    String successMessage =
            (String) adminSession.getAttribute("successMessage");

    if (successMessage != null) {

        adminSession.removeAttribute("successMessage");
    }


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



    String displayName;

    if (!firstName.isEmpty() || !lastName.isEmpty()) {

        displayName =
                (firstName + " " + lastName).trim();

    } else {

        displayName = username;
    }


    String avatarLetter =
            !displayName.isEmpty()
                    ? displayName.substring(0, 1).toUpperCase()
                    : "A";


    String accountStatus = "Active";

    if (user.getStatus() != null) {

        accountStatus =
                user.getStatus().getName();
    }


    String memberSince = "Administrator";

    if (user.getCreatedAt() != null) {

        memberSince =
                user.getCreatedAt()
                        .toLocalDate()
                        .toString();
    }


    int notificationCount = 0;

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>GlobalTrade | Admin Profile</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
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

            --border: rgba(0, 48, 73, 0.10);

            --sidebar-width: 250px;

            --soft-yellow: #FFF3CD;
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
        input {
            font-family: inherit;
        }

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

            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
        }

        .brand {

            height: 75px;

            display: flex;

            align-items: center;

            padding: 0 18px;

            gap: 10px;

            border-bottom: 1px solid rgba(255,255,255,.08);

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

            background: rgba(255,255,255,.08);

            color: white;
        }


        .nav-item.active {

            background: var(--orange);

            color: white;

            font-weight: 600;
        }

        .badge {

            margin-left: auto;

            min-width: 18px;
            height: 18px;

            padding: 0 5px;

            border-radius: 10px;

            background: var(--red);

            color: white;

            font-size: 8px;

            display: flex;

            align-items: center;
            justify-content: center;

            font-weight: 700;
        }

        .profile-mini {

            padding: 12px;

            border-top: 1px solid rgba(255,255,255,.08);

            display: flex;

            align-items: center;

            gap: 10px;

            background: rgba(0,0,0,.08);

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

            color: rgba(255,255,255,.65);

            font-size: 9px;
        }


        .profile-link:hover {

            color: white;
        }


        .profile-link.active {

            color: var(--yellow);
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

        .main {

            margin-left: var(--sidebar-width);

            min-height: 100vh;
        }

        .topbar {

            height: 65px;

            display: flex;

            align-items: center;

            padding: 0 22px;

            background: var(--card-bg);

            border-bottom: 1px solid var(--border);

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

            flex-shrink: 0;
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

            background: var(--card-bg);

            border: 1px solid #F8E4A9;

            border-radius: 7px;

            color: var(--muted);

            transition: .2s ease;
        }


        .search:focus-within {

            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252,191,73,.12);
        }


        .search i {

            font-size: 13px;

            color: var(--muted);

            flex-shrink: 0;
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

            line-height: 1;
        }

        .top-user {

            display: flex;

            align-items: center;

            gap: 8px;

            color: var(--navy);
            margin-left: 5px;
            font-size: 12px;

            font-weight: 600;

            white-space: nowrap;
        }


        .top-user:hover {

            color: var(--orange);
        }


        .top-user > span {

            display: block;
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

            flex-shrink: 0;
        }

        .content {

            padding: 20px 25px 18px;
        }

        .page-heading {

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


        .profile-hero .profile-name {

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


        .admin-badge {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            background: rgba(214,40,40,.09);

            color: var(--red);

            border: 1px solid rgba(214,40,40,.12);

            border-radius: 5px;

            padding: 5px 8px;

            font-size: 9px;

            font-weight: 700;
        }


        .profile-actions {

            display: flex;

            gap: 9px;
        }

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

        .info-content {

            padding: 17px;
        }


        .info-grid {

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 15px 20px;
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

        .success-toast {

            position: fixed;

            top: 85px;

            right: 25px;

            min-width: 300px;

            padding: 14px 16px;

            background: #ffffff;

            border: 1px solid rgba(40,167,69,.20);

            border-left: 4px solid #28a745;

            border-radius: 9px;

            box-shadow:
                    0 8px 25px rgba(0,0,0,.12);

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

        .footer {

            margin-top: 14px;

            padding: 11px 0 2px;

            border-top: 1px solid var(--border);

            display: flex;

            justify-content: space-between;

            color: var(--muted);

            font-size: 9px;
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

                margin-left: var(--sidebar-width);
            }


            .search {

                width: 210px;
            }


            .profile-grid {

                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 650px) {

            .content {

                padding: 15px 12px;
            }


            .topbar {

                padding: 0 12px;

                gap: 10px;
            }


            .search {

                display: none;
            }


            .top-actions {

                gap: 12px;
            }


            .top-user > span {

                display: none;
            }


            .top-user {

                gap: 5px;
            }


            .top-user > i {

                display: none;
            }


            .top-avatar {

                width: 34px;
                height: 34px;

                font-size: 13px;
            }


            .page-heading {

                gap: 8px;
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


            .profile-hero .profile-name {

                font-size: 19px;
            }


            .info-grid {

                grid-template-columns: 1fr;
            }


            .info-field.full {

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


            .success-toast {

                top: 80px;

                left: 12px;
                right: 12px;

                min-width: 0;

                width: auto;
            }
        }

    </style>

</head>


<body>


<%
   

    if (successMessage != null) {
%>

<div class="success-toast"
     id="successToast">

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

<jsp:include page="admin-sidebar.jsp"/>

<main class="main">

    <jsp:include page="admin-topbar.jsp"/>

    <section class="content">

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

                        <%= jobTitle.isEmpty()
                                ? "System Administrator"
                                : jobTitle %>

                        &nbsp;•&nbsp;

                        <%= company.isEmpty()
                                ? "GlobalTrade"
                                : company %>

                    </div>


                    <span class="admin-badge">

                        <i class="fa-solid fa-user-shield"></i>

                        ADMINISTRATOR

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


                <a href="${pageContext.request.contextPath}/admin/settings"
                   class="btn btn-primary">

                    <i class="fa-solid fa-gear"></i>

                    Settings

                </a>

            </div>

        </div>

        <div class="profile-grid">

            <div class="card">

                <div class="card-header">

                    <h2>
                        Personal Information
                    </h2>

                    <i class="fa-solid fa-user-shield"
                       style="color:var(--orange);font-size:13px;">
                    </i>

                </div>


                <div class="info-content">

                    <div class="info-grid">

                        <div class="info-field">

                            <span class="info-label">
                                Username
                            </span>

                            <div class="info-value">

                                <i class="fa-regular fa-user"></i>

                                <%= username %>

                            </div>

                        </div>

                        <div class="info-field">

                            <span class="info-label">
                                Email Address
                            </span>

                            <div class="info-value">

                                <i class="fa-regular fa-envelope"></i>

                                <%= email %>

                            </div>

                        </div>

                        <div class="info-field">

                            <span class="info-label">
                                First Name
                            </span>

                            <div class="info-value">

                                <i class="fa-regular fa-user"></i>

                                <%= firstName.isEmpty()
                                        ? "Not provided"
                                        : firstName %>

                            </div>

                        </div>

                        <div class="info-field">

                            <span class="info-label">
                                Last Name
                            </span>

                            <div class="info-value">

                                <i class="fa-regular fa-user"></i>

                                <%= lastName.isEmpty()
                                        ? "Not provided"
                                        : lastName %>

                            </div>

                        </div>

                        <div class="info-field">

                            <span class="info-label">
                                Phone Number
                            </span>

                            <div class="info-value">

                                <i class="fa-solid fa-phone"></i>

                                <%= phone.isEmpty()
                                        ? "Not provided"
                                        : phone %>

                            </div>

                        </div>

                        <div class="info-field">

                            <span class="info-label">
                                Job Title
                            </span>

                            <div class="info-value">

                                <i class="fa-solid fa-briefcase"></i>

                                <%= jobTitle.isEmpty()
                                        ? "Not provided"
                                        : jobTitle %>

                            </div>

                        </div>

                        <div class="info-field">

                            <span class="info-label">
                                Company
                            </span>

                            <div class="info-value">

                                <i class="fa-solid fa-building"></i>

                                <%= company.isEmpty()
                                        ? "Not provided"
                                        : company %>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

            <div class="card">

                <div class="card-header">

                    <h2>
                        Administrator Account
                    </h2>

                    <i class="fa-solid fa-shield-halved"
                       style="color:var(--orange);font-size:13px;">
                    </i>

                </div>


                <div class="account-content">

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


                    <div class="account-row">

                        <div class="account-icon">

                            <i class="fa-solid fa-user-shield"></i>

                        </div>

                        <div class="account-text">

                            <span class="account-label">
                                Access Level
                            </span>

                            <span class="account-value">
                                ADMIN
                            </span>

                        </div>

                    </div>

                    <div class="account-row">

                        <div class="account-icon">

                            <i class="fa-solid fa-calendar"></i>

                        </div>

                        <div class="account-text">

                            <span class="account-label">
                                Administrator Since
                            </span>

                            <span class="account-value">

                                <%= memberSince %>

                            </span>

                        </div>

                    </div>


                </div>

            </div>

        </div>

        <div class="card"
             style="margin-bottom:14px;">

            <div class="card-header">

                <h2>
                    Security
                </h2>

                <i class="fa-solid fa-shield-halved"
                   style="color:var(--orange);font-size:13px;">
                </i>

            </div>


            <div class="security-content">


                <div class="security-info">

                    <div class="security-icon">

                        <i class="fa-solid fa-lock"></i>

                    </div>


                    <div>

                        <h3>
                            Administrator Password
                        </h3>

                        <p>
                            Your administrator credentials are protected.
                        </p>

                    </div>

                </div>


                <a href="${pageContext.request.contextPath}/admin/change-password"
                   class="btn btn-secondary">

                    <i class="fa-solid fa-key"></i>

                    Change Password

                </a>

            </div>

        </div>

        <div class="card"
             id="editProfileCard"
             style="margin-bottom:14px;display:none;">

            <div class="card-header">

                <h2>
                    Edit Administrator Profile
                </h2>

                <button class="btn btn-secondary"
                        type="button"
                        onclick="hideEditForm()"
                        style="height:30px;padding:0 10px;">

                    <i class="fa-solid fa-xmark"></i>

                </button>

            </div>


            <form action="${pageContext.request.contextPath}/admin/update-profile"
                  method="post">


                <div style="
            padding:17px;
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:14px 18px;
        ">


                    <div>

                        <label style="
                    display:block;
                    color:var(--muted);
                    font-size:9px;
                    font-weight:600;
                    margin-bottom:6px;
                ">

                            First Name

                        </label>

                        <input type="text"
                               name="firstName"
                               value="<%= firstName %>"
                               maxlength="100"
                               required
                               style="
                           width:100%;
                           height:38px;
                           padding:0 11px;
                           border:1px solid var(--border);
                           border-radius:7px;
                           background:#FFFDF7;
                           color:var(--navy);
                           font-size:10px;
                           outline:none;
                       ">

                    </div>

                    <div>

                        <label style="
                    display:block;
                    color:var(--muted);
                    font-size:9px;
                    font-weight:600;
                    margin-bottom:6px;
                ">

                            Last Name

                        </label>

                        <input type="text"
                               name="lastName"
                               value="<%= lastName %>"
                               maxlength="45"
                               required
                               style="
                           width:100%;
                           height:38px;
                           padding:0 11px;
                           border:1px solid var(--border);
                           border-radius:7px;
                           background:#FFFDF7;
                           color:var(--navy);
                           font-size:10px;
                           outline:none;
                       ">

                    </div>

                    <div>

                        <label style="
                    display:block;
                    color:var(--muted);
                    font-size:9px;
                    font-weight:600;
                    margin-bottom:6px;
                ">

                            Email Address

                        </label>

                        <input type="email"
                               value="<%= email %>"
                               readonly
                               style="
                           width:100%;
                           height:38px;
                           padding:0 11px;
                           border:1px solid var(--border);
                           border-radius:7px;
                           background:#F1F5F9;
                           color:var(--muted);
                           font-size:10px;
                           outline:none;
                       ">

                    </div>

                    <div>

                        <label style="
                    display:block;
                    color:var(--muted);
                    font-size:9px;
                    font-weight:600;
                    margin-bottom:6px;
                ">

                            Phone Number

                        </label>

                        <input type="text"
                               name="mobile"
                               value="<%= phone %>"
                               maxlength="10"
                               pattern="[0-9]{10}"
                               required
                               style="
                           width:100%;
                           height:38px;
                           padding:0 11px;
                           border:1px solid var(--border);
                           border-radius:7px;
                           background:#FFFDF7;
                           color:var(--navy);
                           font-size:10px;
                           outline:none;
                       ">

                    </div>

                    <div>

                        <label style="
                    display:block;
                    color:var(--muted);
                    font-size:9px;
                    font-weight:600;
                    margin-bottom:6px;
                ">

                            Job Title

                        </label>

                        <input type="text"
                               name="jobTitle"
                               value="<%= jobTitle %>"
                               maxlength="100"
                               style="
                           width:100%;
                           height:38px;
                           padding:0 11px;
                           border:1px solid var(--border);
                           border-radius:7px;
                           background:#FFFDF7;
                           color:var(--navy);
                           font-size:10px;
                           outline:none;
                       ">

                    </div>

                    <div>

                        <label style="
                    display:block;
                    color:var(--muted);
                    font-size:9px;
                    font-weight:600;
                    margin-bottom:6px;
                ">

                            Company

                        </label>

                        <input type="text"
                               name="company"
                               value="<%= company %>"
                               maxlength="150"
                               style="
                           width:100%;
                           height:38px;
                           padding:0 11px;
                           border:1px solid var(--border);
                           border-radius:7px;
                           background:#FFFDF7;
                           color:var(--navy);
                           font-size:10px;
                           outline:none;
                       ">

                    </div>


                </div>

                <div style="
            padding:0 17px 17px;
            display:flex;
            justify-content:flex-end;
            gap:8px;
        ">

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


    function closeSuccessToast() {

        const toast =
            document.getElementById("successToast");

        if (toast) {

            toast.style.animation =
                "toastSlideOut .3s ease forwards";

            setTimeout(function () {

                toast.remove();

            }, 300);
        }
    }


    const successToast =
        document.getElementById("successToast");

    if (successToast) {

        setTimeout(function () {

            closeSuccessToast();

        }, 4000);

    }

</script>


</body>

</html>