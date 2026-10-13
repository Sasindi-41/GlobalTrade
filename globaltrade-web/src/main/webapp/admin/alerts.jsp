<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="lk.sasindi.globaltrade.entity.Alert" %>

<%@ page import="java.lang.reflect.Method" %>

<%!
    private Object property(Object object, String... names) {
        if (object == null) return null;
        for (String name : names) {
            try {
                String methodName = "get" + Character.toUpperCase(name.charAt(0)) + name.substring(1);
                Method method = object.getClass().getMethod(methodName);
                Object value = method.invoke(object);
                if (value != null) return value;
            } catch (Exception ignored) { }
        }
        return null;
    }

    private String objectId(Object object) {
        Object value = property(object, "id");
        return value == null ? "" : String.valueOf(value);
    }

    private String objectName(Object object, String... names) {
        Object value = property(object, names);
        return value == null ? "" : String.valueOf(value);
    }

    private String html(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
    private String js(String value) {
        if (value == null) return "";

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", " ")
                .replace("\n", " ")
                .replace("</", "<\\/");
    }
%>

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
                request.getContextPath() +
                        "/user/dashboard"
        );

        return;
    }

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

    List<Alert> alerts =
            (List<Alert>) request.getAttribute(
                    "alerts"
            );

    Long totalAlerts =
            (Long) request.getAttribute(
                    "totalAlerts"
            );

    Long openAlerts =
            (Long) request.getAttribute(
                    "openAlerts"
            );

    Long criticalAlerts =
            (Long) request.getAttribute(
                    "criticalAlerts"
            );

    Long resolvedAlerts =
            (Long) request.getAttribute(
                    "resolvedAlerts"
            );
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>GlobalTrade | Alerts</title>



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
        .sidebar::-webkit-scrollbar,
        .nav::-webkit-scrollbar {

            width: 4px;
        }


        .sidebar::-webkit-scrollbar-thumb,
        .nav::-webkit-scrollbar-thumb {

            background: rgba(255,255,255,.2);

            border-radius: 5px;
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

            border-top:
                    1px solid rgba(255,255,255,.08);

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

        .main {

            margin-left: var(--sidebar-width);

            min-height: 100vh;
        }

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

        .content {

            padding: 20px 25px 18px;
        }

        .page-heading {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 17px;

            gap: 15px;
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

        .stats-grid {

            display: grid;

            grid-template-columns:
                    repeat(4, 1fr);

            gap: 12px;

            margin-bottom: 14px;
        }


        .stat-card {

            background: var(--card);

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

            color: var(--orange);

            font-size: 15px;

            flex-shrink: 0;
        }


        .stat-text {

            min-width: 0;
        }


        .stat-label {

            display: block;

            color: var(--muted);

            font-size: 9px;

            margin-bottom: 4px;
        }


        .stat-value {

            color: var(--navy);

            font-size: 19px;

            font-weight: 700;
        }

        .card {

            background: var(--card);

            border:
                    1px solid var(--border);

            border-radius: 11px;

            overflow: hidden;
        }


        .card-header {

            min-height: 52px;

            padding: 10px 16px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            border-bottom:
                    1px solid rgba(0,48,73,.06);

            gap: 10px;
        }


        .card-header h2 {

            color: var(--navy);

            font-size: 14px;
        }


        .card-header-right {

            display: flex;

            align-items: center;

            gap: 8px;
        }

        .filter-area {

            display: flex;

            align-items: center;

            gap: 8px;
        }


        .filter-input,
        .filter-select {

            height: 34px;

            border:
                    1px solid var(--border);

            border-radius: 7px;

            padding: 0 10px;

            outline: none;

            background: white;

            color: var(--navy);

            font-size: 10px;
        }


        .filter-input {

            width: 190px;
        }


        .filter-select {

            width: 125px;
        }


        .filter-input:focus,
        .filter-select:focus {

            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px
                    rgba(252,191,73,.10);
        }

        .table-wrapper {

            width: 100%;

            overflow-x: auto;
        }


        .alert-table {

            width: 100%;

            border-collapse: collapse;

            min-width: 1050px;
        }


        .alert-table thead {

            background: #FFFDF5;
        }


        .alert-table th {

            padding: 12px 13px;

            text-align: left;

            font-size: 9px;

            color: var(--muted);

            text-transform: uppercase;

            letter-spacing: .4px;

            font-weight: 700;

            white-space: nowrap;
        }


        .alert-table td {

            padding: 12px 13px;

            border-top:
                    1px solid
                    rgba(0,48,73,.06);

            font-size: 10px;

            color: var(--navy);

            vertical-align: middle;
        }


        .alert-table tbody tr {

            transition: .15s ease;
        }


        .alert-table tbody tr:hover {

            background: #FFFDF5;
        }

        .alert-message {

            max-width: 330px;

            line-height: 1.5;

            font-weight: 500;
        }


        .alert-id {

            font-size: 9px;

            color: var(--muted);

            font-weight: 700;
        }

        .type-badge {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            padding: 5px 8px;

            border-radius: 6px;

            background: #F1F5F9;

            color: var(--navy);

            font-size: 9px;

            font-weight: 700;

            white-space: nowrap;
        }


        .type-badge i {

            color: var(--orange);
        }

        .severity-badge {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            padding: 5px 9px;

            border-radius: 20px;

            font-size: 8px;

            font-weight: 700;

            white-space: nowrap;
        }


        .severity-warning {

            background: #FFF3CD;

            color: #946200;
        }


        .severity-critical {

            background: #FDE2E2;

            color: var(--red);
        }


        .severity-info {

            background: #E8F1FF;

            color: var(--blue);
        }

        .status-badge {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            padding: 5px 9px;

            border-radius: 20px;

            font-size: 8px;

            font-weight: 700;
        }


        .status-open {

            background: #FDE2E2;

            color: var(--red);
        }


        .status-resolved {

            background: #E7F6EC;

            color: var(--green);
        }


        .status-dot {

            width: 6px;

            height: 6px;

            border-radius: 50%;

            background: currentColor;
        }

        .vendor-name {

            font-size: 10px;

            font-weight: 700;

            color: var(--navy);
        }


        .vendor-code {

            margin-top: 3px;

            font-size: 8px;

            color: var(--muted);
        }

        .inventory-name {

            font-size: 10px;

            font-weight: 600;
        }


        .inventory-code {

            margin-top: 3px;

            font-size: 8px;

            color: var(--muted);
        }

        .tracking-number {

            font-size: 9px;

            font-weight: 700;

            color: var(--navy);
        }

        .date-main {

            font-size: 9px;

            font-weight: 600;

            white-space: nowrap;
        }


        .date-time {

            margin-top: 3px;

            font-size: 8px;

            color: var(--muted);

            white-space: nowrap;
        }

        .action-buttons {

            display: flex;

            align-items: center;

            gap: 5px;
        }


        .action-btn {

            width: 29px;

            height: 29px;

            border: none;

            border-radius: 6px;

            display: flex;

            align-items: center;

            justify-content: center;

            cursor: pointer;

            background: #F1F5F9;

            color: var(--navy);

            transition: .2s ease;
        }


        .action-btn:hover {

            background: var(--yellow);

            color: var(--navy);
        }


        .action-btn.resolve:hover {

            background: var(--green);

            color: white;
        }


        .action-btn.reopen:hover {

            background: var(--orange);

            color: white;
        }

        .empty-state {

            text-align: center;

            padding: 55px 20px;

            color: var(--muted);
        }


        .empty-state i {

            font-size: 35px;

            color: #CBD5E1;

            margin-bottom: 10px;
        }


        .empty-state h3 {

            font-size: 14px;

            color: var(--navy);

            margin-bottom: 5px;
        }


        .empty-state p {

            font-size: 10px;
        }

        .success-toast,
        .error-toast {

            position: fixed;

            top: 78px;

            right: 25px;

            z-index: 20000;

            min-width: 280px;

            max-width: 400px;

            padding: 13px 14px;

            border-radius: 8px;

            display: flex;

            align-items: center;

            gap: 9px;

            box-shadow:
                    0 12px 35px rgba(0,0,0,.15);

            font-size: 10px;

            font-weight: 600;
        }


        .success-toast {

            background: #E7F6EC;

            color: #176B35;

            border:
                    1px solid #B9E4C6;
        }


        .error-toast {

            background: #FDE2E2;

            color: #9D1C1C;

            border:
                    1px solid #F3B7B7;
        }


        .toast-close {

            margin-left: auto;

            border: none;

            background: transparent;

            cursor: pointer;

            color: inherit;

            font-size: 12px;
        }


        .alert-modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 48, 73, .45);
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
            z-index: 3000;
        }

        .alert-modal-overlay.show { display: flex; }

        .alert-modal {
            width: min(760px, 100%);
            max-height: 90vh;
            overflow-y: auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 20px 60px rgba(0,0,0,.20);
        }

        .alert-modal-header {
            min-height: 62px;
            padding: 0 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border);
        }

        .alert-modal-header h2 {
            font-size: 15px;
            color: var(--navy);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-modal-header h2 i { color: var(--orange); }

        .modal-close {
            width: 32px;
            height: 32px;
            border: none;
            border-radius: 7px;
            background: #F1F5F9;
            color: var(--muted);
            cursor: pointer;
        }

        .modal-close:hover { background: #FDE2E2; color: var(--red); }

        .alert-modal-body { padding: 18px; }

        .alert-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0,1fr));
            gap: 14px;
        }

        .alert-form-group { display: flex; flex-direction: column; gap: 6px; }
        .alert-form-group.full { grid-column: 1 / -1; }

        .alert-form-group label {
            font-size: 10px;
            font-weight: 700;
            color: var(--navy);
        }

        .alert-form-group label span { color: var(--red); }

        .alert-form-group input,
        .alert-form-group select,
        .alert-form-group textarea {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 7px;
            outline: none;
            background: white;
            color: var(--navy);
            font-size: 10px;
            padding: 9px 10px;
        }

        .alert-form-group textarea { min-height: 90px; resize: vertical; }
        .alert-form-group input:focus,
        .alert-form-group select:focus,
        .alert-form-group textarea:focus {
            border-color: var(--yellow);
            box-shadow: 0 0 0 3px rgba(252,191,73,.10);
        }

        .alert-form-help {
            font-size: 9px;
            color: var(--muted);
            line-height: 1.5;
        }

        .alert-modal-footer {
            padding: 13px 18px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: flex-end;
            gap: 8px;
        }

        @media (max-width: 760px) {
            .alert-form-grid { grid-template-columns: 1fr; }
            .alert-form-group.full { grid-column: auto; }
            .filter-area { width: 100%; flex-wrap: wrap; }
            .filter-input { width: 100%; }
        }

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


            .top-user > span {

                display: none;
            }


            .top-user > i {

                display: none;
            }


            .page-heading {

                align-items: flex-start;

                flex-direction: column;
            }


            .page-heading .btn {

                width: 100%;
            }


            .stats-grid {

                grid-template-columns: 1fr;
            }


            .filter-area {

                grid-template-columns: 1fr;
            }


            .form-grid {

                grid-template-columns: 1fr;
            }


            .form-group.full {

                grid-column: auto;
            }


            .table-footer {

                flex-direction: column;

                align-items: flex-start;
            }


            .footer {

                flex-direction: column;

                gap: 5px;
            }


            .success-toast,
            .error-toast {

                top: 80px;

                left: 12px;

                right: 12px;

                min-width: 0;
            }
        }

        .selector-field {

            display: flex;

            width: 100%;

            height: 38px;

            border: 1px solid var(--border);

            border-radius: 7px;

            background: #FFFDF7;

            overflow: hidden;
        }


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
        }


        .selector-display.placeholder {

            color: #94A3B8;
        }


        .selector-button {

            width: 75px;

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

            transition: .2s ease;

            flex-shrink: 0;
        }


        .selector-button:hover {

            background: var(--yellow);

            color: var(--navy);
        }

        .selection-overlay {

            position: fixed;

            inset: 0;

            background: rgba(0,48,73,.50);

            display: none;

            align-items: center;

            justify-content: center;

            padding: 20px;

            z-index: 11000;
        }


        .selection-overlay.show {

            display: flex;
        }


        .selection-modal {

            width: 100%;

            max-width: 680px;

            max-height: 85vh;

            background: white;

            border-radius: 12px;

            overflow: hidden;

            box-shadow:
                    0 20px 60px rgba(0,0,0,.22);

            display: flex;

            flex-direction: column;
        }


        .selection-modal-header {

            min-height: 58px;

            padding: 0 18px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            border-bottom: 1px solid var(--border);

            flex-shrink: 0;
        }


        .selection-modal-header h2 {

            color: var(--navy);

            font-size: 15px;

            display: flex;

            align-items: center;

            gap: 8px;
        }


        .selection-modal-header h2 i {

            color: var(--orange);
        }


        .selection-close {

            width: 30px;

            height: 30px;

            border: none;

            background: transparent;

            color: var(--muted);

            cursor: pointer;

            font-size: 15px;

            border-radius: 5px;
        }


        .selection-close:hover {

            background: #FFF3CD;

            color: var(--red);
        }

        .selection-search-area {

            padding: 12px 16px;

            border-bottom: 1px solid rgba(0,48,73,.06);

            background: #FFFDF7;

            flex-shrink: 0;
        }


        .selection-search {

            width: 100%;

            height: 36px;

            border: 1px solid var(--border);

            border-radius: 7px;

            background: white;

            outline: none;

            padding: 0 11px 0 35px;

            color: var(--navy);

            font-size: 10px;
        }


        .selection-search:focus {

            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252,191,73,.10);
        }


        .selection-search-wrapper {

            position: relative;
        }


        .selection-search-wrapper i {

            position: absolute;

            left: 12px;

            top: 50%;

            transform: translateY(-50%);

            color: var(--muted);

            font-size: 11px;
        }

        .selection-content {

            overflow-y: auto;

            padding: 8px 12px;

            min-height: 150px;
        }


        .selection-content::-webkit-scrollbar {

            width: 5px;
        }


        .selection-content::-webkit-scrollbar-thumb {

            background: #CBD5E1;

            border-radius: 5px;
        }

        .selection-item {

            width: 100%;

            min-height: 64px;

            padding: 10px 8px;

            border-bottom: 1px solid rgba(0,48,73,.06);

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 12px;
        }


        .selection-item:last-child {

            border-bottom: none;
        }


        .selection-item:hover {

            background: #FFFDF7;
        }


        .selection-item-info {

            min-width: 0;

            flex: 1;
        }


        .selection-item-title {

            display: block;

            color: var(--navy);

            font-size: 10px;

            font-weight: 700;

            margin-bottom: 4px;
        }


        .selection-item-subtitle {

            display: block;

            color: var(--muted);

            font-size: 8px;

            line-height: 1.5;
        }


        .selection-item-button {

            height: 30px;

            padding: 0 11px;

            border: 1px solid #F8E4A9;

            border-radius: 6px;

            background: #FFF9E8;

            color: var(--orange);

            font-size: 8px;

            font-weight: 700;

            cursor: pointer;

            white-space: nowrap;

            flex-shrink: 0;
        }


        .selection-item-button:hover {

            background: var(--orange);

            border-color: var(--orange);

            color: white;
        }

        .selection-empty {

            padding: 45px 20px;

            text-align: center;

            color: var(--muted);

            display: none;
        }


        .selection-empty i {

            font-size: 28px;

            color: #CBD5E1;

            margin-bottom: 10px;
        }


        .selection-empty h3 {

            color: var(--navy);

            font-size: 12px;

            margin-bottom: 4px;
        }


        .selection-empty p {

            font-size: 9px;
        }

        .selected-info {

            display: flex;

            align-items: center;

            gap: 6px;

            color: var(--muted);

            font-size: 8px;

            margin-top: 5px;
        }


        .selected-info i {

            color: var(--green);
        }


        @media (max-width: 650px) {

            .selection-overlay {

                padding: 10px;
            }


            .selection-modal {

                max-height: 90vh;
            }


            .selection-item {

                align-items: flex-start;
            }


            .selection-item-button {

                padding: 0 8px;
            }
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

            display: flex;

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

            box-shadow:
                    0 20px 50px rgba(0,0,0,.20);
        }


        .address-modal-header {

            min-height: 58px;

            padding: 0 18px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            border-bottom:
                    1px solid var(--border);
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

            box-shadow:
                    0 0 0 3px rgba(252,191,73,.10);
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

    <button
            class="toast-close"
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

    <button
            class="toast-close"
            type="button"
            onclick="closeToast('errorToast')">

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

        <div class="page-heading">

            <div>

                <h1>
                    Alerts & Monitoring
                </h1>

                <p>
                    Monitor automated shipment, inventory and vendor alerts.
                </p>

            </div>

            <button
                    type="button"
                    class="btn btn-primary"
                    onclick="openCreateAlertModal()">

                <i class="fa-solid fa-plus"></i>
                Add Alert

            </button>

        </div>

        <div class="stats-grid">


            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-bell"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Total Alerts
                    </span>

                    <span class="stat-value">
                        <%= totalAlerts != null ? totalAlerts : 0 %>
                    </span>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-triangle-exclamation"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Open Alerts
                    </span>

                    <span class="stat-value">
                        <%= openAlerts != null ? openAlerts : 0 %>
                    </span>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-fire"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Critical
                    </span>

                    <span class="stat-value">
                        <%= criticalAlerts != null ? criticalAlerts : 0 %>
                    </span>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-circle-check"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Resolved
                    </span>

                    <span class="stat-value">
                        <%= resolvedAlerts != null ? resolvedAlerts : 0 %>
                    </span>

                </div>

            </div>

        </div>

        <div class="card">


            <div class="card-header">

                <h2>

                    <i class="fa-solid fa-bell"></i>

                    Supply Chain Alerts

                </h2>


                <div class="filter-area">

                    <input
                            type="text"
                            id="alertSearch"
                            class="filter-input"
                            placeholder="Search alerts...">


                    <select
                            id="severityFilter"
                            class="filter-select">

                        <option value="">
                            All Severity
                        </option>

                        <option value="WARNING">
                            Warning
                        </option>

                        <option value="CRITICAL">
                            Critical
                        </option>

                        <option value="INFO">
                            Info
                        </option>

                    </select>


                    <select
                            id="statusFilter"
                            class="filter-select">

                        <option value="">
                            All Status
                        </option>

                        <option value="OPEN">
                            Open
                        </option>

                        <option value="RESOLVED">
                            Resolved
                        </option>

                    </select>

                </div>

            </div>


            <div class="table-wrapper">

                <table class="alert-table"
                       id="alertTable">

                    <thead>

                    <tr>

                        <th>
                            ID
                        </th>

                        <th>
                            Alert
                        </th>

                        <th>
                            Type
                        </th>

                        <th>
                            Severity
                        </th>

                        <th>
                            Vendor
                        </th>

                        <th>
                            Inventory
                        </th>

                        <th>
                            Shipment
                        </th>

                        <th>
                            Created
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Action
                        </th>

                    </tr>

                    </thead>


                    <tbody>

                    <%
                        if (alerts == null ||
                                alerts.isEmpty()) {
                    %>

                    <tr>

                        <td colspan="10">

                            <div class="empty-state">

                                <i class="fa-regular fa-circle-check"></i>

                                <h3>
                                    No alerts found
                                </h3>

                                <p>
                                    The supply chain is currently operating without recorded alerts.
                                </p>

                            </div>

                        </td>

                    </tr>

                    <%
                    } else {

                        for (Alert alert : alerts) {

                            String severity =
                                    alert.getSeverity() != null &&
                                            alert.getSeverity().getName() != null
                                            ? alert.getSeverity().getName()
                                            : "";

                            String status =
                                    alert.getAlertStatus() != null &&
                                            alert.getAlertStatus().getName() != null
                                            ? alert.getAlertStatus().getName()
                                            : "";

                            String type =
                                    alert.getAlertType() != null &&
                                            alert.getAlertType().getName() != null
                                            ? alert.getAlertType().getName()
                                            : "";

                            String severityClass =
                                    severity.equalsIgnoreCase("CRITICAL")
                                            ? "severity-critical"
                                            : severity.equalsIgnoreCase("WARNING")
                                            ? "severity-warning"
                                            : "severity-info";

                            String statusClass =
                                    status.equalsIgnoreCase("OPEN")
                                            ? "status-open"
                                            : "status-resolved";
                    %>

                    <tr
                            data-search="<%= (
                                    alert.getMessage() + " " +
                                    type + " " +
                                    severity + " " +
                                    status + " " +
                                    (alert.getVendor() != null
                                            ? alert.getVendor().getCompanyName()
                                            : "") + " " +
                                    (alert.getInventory() != null
                                            ? alert.getInventory().getProductName()
                                            : "") + " " +
                                    (alert.getShipment() != null
                                            ? alert.getShipment().getTrackingNumber()
                                            : "")
                            ).toLowerCase().replace("\"", "") %>"
                            data-severity="<%= severity.toUpperCase() %>"
                            data-status="<%= status.toUpperCase() %>"
                    >

                        <td>

                            <span class="alert-id">

                                #<%= alert.getId() %>

                            </span>

                        </td>


                        <td>

                            <div class="alert-message">

                                <%= alert.getMessage() %>

                            </div>

                        </td>


                        <td>

                            <span class="type-badge">

                                <i class="fa-solid fa-tag"></i>

                                <%= type %>

                            </span>

                        </td>


                        <td>

                            <span class="severity-badge <%= severityClass %>">

                                <i class="fa-solid fa-circle-exclamation"></i>

                                <%= severity %>

                            </span>

                        </td>


                        <td>

                            <div class="vendor-name">

                                <%= alert.getVendor() != null
                                        ? alert.getVendor().getCompanyName()
                                        : "-" %>

                            </div>

                            <div class="vendor-code">

                                <%= alert.getVendor() != null
                                        ? alert.getVendor().getVendorCode()
                                        : "-" %>

                            </div>

                        </td>


                        <td>

                            <div class="inventory-name">

                                <%= alert.getInventory() != null
                                        ? alert.getInventory().getProductName()
                                        : "-" %>

                            </div>

                            <div class="inventory-code">

                                <%= alert.getInventory() != null
                                        ? alert.getInventory().getProductCode()
                                        : "-" %>

                            </div>

                        </td>


                        <td>

                            <span class="tracking-number">

                                <%= alert.getShipment() != null
                                        ? alert.getShipment().getTrackingNumber()
                                        : "-" %>

                            </span>

                        </td>


                        <td>

                            <%
                                if (alert.getCreatedAt() != null) {
                            %>

                            <div class="date-main">

                                <%= alert.getCreatedAt()
                                        .toLocalDate() %>

                            </div>

                            <div class="date-time">

                                <%= alert.getCreatedAt()
                                        .toLocalTime()
                                        .withNano(0) %>

                            </div>

                            <%
                                }
                            %>

                        </td>


                        <td>

                            <span class="status-badge <%= statusClass %>">

                                <span class="status-dot"></span>

                                <%= status %>

                            </span>

                        </td>


                        <td>

                            <div class="action-buttons">

                                <%
                                    if ("OPEN".equalsIgnoreCase(status)) {
                                %>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/alerts"
                                      style="display:inline;">

                                    <input
                                            type="hidden"
                                            name="action"
                                            value="resolve">

                                    <input
                                            type="hidden"
                                            name="id"
                                            value="<%= alert.getId() %>">

                                    <button
                                            type="submit"
                                            class="action-btn resolve"
                                            title="Resolve alert">

                                        <i class="fa-solid fa-check"></i>

                                    </button>

                                </form>

                                <%
                                } else {
                                %>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/alerts"
                                      style="display:inline;">

                                    <input
                                            type="hidden"
                                            name="action"
                                            value="reopen">

                                    <input
                                            type="hidden"
                                            name="id"
                                            value="<%= alert.getId() %>">

                                    <button
                                            type="submit"
                                            class="action-btn reopen"
                                            title="Reopen alert">

                                        <i class="fa-solid fa-rotate-left"></i>

                                    </button>

                                </form>

                                <%
                                    }
                                %>

                            </div>

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

    </section>

</main>

<div class="alert-modal-overlay"
     id="createAlertModal"
     onclick="closeCreateAlertModal(event)">

    <div class="alert-modal" onclick="event.stopPropagation()">

        <div class="alert-modal-header">

            <h2>
                <i class="fa-solid fa-bell"></i>
                Create Supply Chain Alert
            </h2>

            <button type="button"
                    class="modal-close"
                    onclick="closeCreateAlertModal()">
                <i class="fa-solid fa-xmark"></i>
            </button>

        </div>

        <form method="post"
              action="${pageContext.request.contextPath}/alerts">

            <input type="hidden" name="action" value="create">

            <div class="alert-modal-body">

                <div class="alert-form-grid">

                    <div class="alert-form-group full">
                        <label for="alertMessage">Message <span>*</span></label>
                        <textarea id="alertMessage"
                                  name="message"
                                  maxlength="500"
                                  required
                                  placeholder="Enter the alert message..."></textarea>
                    </div>

                    <div class="alert-form-group">

                        <label>
                            Shipment <span>*</span>
                        </label>

                        <div class="selector-field">

                            <div class="selector-display placeholder"
                                 id="alertShipmentDisplay">

                                Select Shipment

                            </div>

                            <button type="button"
                                    class="selector-button"
                                    onclick="openAlertSelector('shipment')">

                                <i class="fa-solid fa-truck"></i>

                                Select

                            </button>

                        </div>

                        <input type="hidden"
                               name="shipments_id"
                               id="alertShipmentId"
                               required>

                        <div class="selected-info"
                             id="alertShipmentSelectedInfo"
                             style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Shipment selected

                        </div>

                    </div>

                    <div class="alert-form-group">

                        <label>
                            Vendor <span>*</span>
                        </label>

                        <div class="selector-field">

                            <div class="selector-display placeholder"
                                 id="alertVendorDisplay">

                                Select Vendor

                            </div>

                            <button type="button"
                                    class="selector-button"
                                    onclick="openAlertSelector('vendor')">

                                <i class="fa-solid fa-building"></i>

                                Select

                            </button>

                        </div>

                        <input type="hidden"
                               name="vendors_id"
                               id="alertVendorId"
                               required>

                        <div class="selected-info"
                             id="alertVendorSelectedInfo"
                             style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Vendor selected

                        </div>

                    </div>

                    <div class="alert-form-group">

                        <label>
                            Inventory <span>*</span>
                        </label>

                        <div class="selector-field">

                            <div class="selector-display placeholder"
                                 id="alertInventoryDisplay">

                                Select Inventory Item

                            </div>

                            <button type="button"
                                    class="selector-button"
                                    onclick="openAlertSelector('inventory')">

                                <i class="fa-solid fa-box"></i>

                                Select

                            </button>

                        </div>

                        <input type="hidden"
                               name="inventory_id"
                               id="alertInventoryId"
                               required>

                        <div class="selected-info"
                             id="alertInventorySelectedInfo"
                             style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Inventory item selected

                        </div>

                    </div>

                    <div class="alert-form-group">

                        <label>
                            Alert Type <span>*</span>
                        </label>

                        <div class="selector-field">

                            <div class="selector-display placeholder"
                                 id="alertTypeDisplay">

                                Select Alert Type

                            </div>

                            <button type="button"
                                    class="selector-button"
                                    onclick="openAlertSelector('type')">

                                <i class="fa-solid fa-tag"></i>

                                Select

                            </button>

                        </div>

                        <input type="hidden"
                               name="alert_type_id"
                               id="alertTypeId"
                               required>

                        <div class="selected-info"
                             id="alertTypeSelectedInfo"
                             style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Alert type selected

                        </div>

                    </div>

                    <div class="alert-form-group">

                        <label>
                            Severity <span>*</span>
                        </label>

                        <div class="selector-field">

                            <div class="selector-display placeholder"
                                 id="alertSeverityDisplay">

                                Select Severity

                            </div>

                            <button type="button"
                                    class="selector-button"
                                    onclick="openAlertSelector('severity')">

                                <i class="fa-solid fa-triangle-exclamation"></i>

                                Select

                            </button>

                        </div>

                        <input type="hidden"
                               name="severity_id"
                               id="alertSeverityId"
                               required>

                        <div class="selected-info"
                             id="alertSeveritySelectedInfo"
                             style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Severity selected

                        </div>

                    </div>
                    <div class="alert-form-group">
                        <label for="alertStatus">Status <span>*</span></label>
                        <select id="alertStatus" name="alert_status_id" required>
                            <option value="">Select status</option>
                            <%
                                List<?> statusOptions = (List<?>) request.getAttribute("alertStatuses");
                                if (statusOptions != null) {
                                    for (Object item : statusOptions) {
                                        String id = objectId(item);
                                        String label = objectName(item, "name");
                                        if (!id.isEmpty()) {
                            %>
                            <option value="<%= html(id) %>" <%= "OPEN".equalsIgnoreCase(label) ? "selected" : "" %>><%= html(label) %></option>
                            <%
                                        }
                                    }
                                }
                            %>
                        </select>
                    </div>

                </div>

                <p class="alert-form-help" style="margin-top:12px;">
                    Alerts are normally produced by automated supply-chain monitoring. This form is provided for authorized administrative/manual alert creation.
                </p>

            </div>

            <div class="alert-modal-footer">

                <button type="button"
                        class="btn btn-secondary"
                        onclick="closeCreateAlertModal()">
                    Cancel
                </button>

                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-plus"></i>
                    Create Alert
                </button>

            </div>

        </form>

    </div>

</div>

<div class="selection-overlay"
     id="alertSelectionOverlay">

    <div class="selection-modal">

        <div class="selection-modal-header">

            <h2 id="alertSelectionTitle">

                <i class="fa-solid fa-list"></i>

                Select

            </h2>

            <button type="button"
                    class="selection-close"
                    onclick="closeAlertSelector()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <div class="selection-search-area">

            <div class="selection-search-wrapper">

                <i class="fa-solid fa-magnifying-glass"></i>

                <input type="text"
                       id="alertSelectionSearch"
                       class="selection-search"
                       placeholder="Search..."
                       oninput="searchAlertSelection()">

            </div>

        </div>

        <div class="selection-content"
             id="alertSelectionContent">

        </div>


        <div class="selection-empty"
             id="alertSelectionEmpty"
             style="display:none;">

            <i class="fa-solid fa-magnifying-glass"></i>

            <h3>
                No results found
            </h3>

            <p>
                Try another search term.
            </p>

        </div>

    </div>

</div>


<script>

    const searchInput =
        document.getElementById("alertSearch");

    const severityFilter =
        document.getElementById("severityFilter");

    const statusFilter =
        document.getElementById("statusFilter");

    const tableRows =
        document.querySelectorAll(
            "#alertTable tbody tr"
        );


    function filterAlerts() {

        const search =
            searchInput.value
                .toLowerCase()
                .trim();

        const severity =
            severityFilter.value
                .toUpperCase();

        const status =
            statusFilter.value
                .toUpperCase();


        tableRows.forEach(row => {

            const rowSearch =
                row.dataset.search || "";

            const rowSeverity =
                row.dataset.severity || "";

            const rowStatus =
                row.dataset.status || "";


            const matchesSearch =
                rowSearch.includes(search);

            const matchesSeverity =
                !severity ||
                rowSeverity === severity;

            const matchesStatus =
                !status ||
                rowStatus === status;


            if (
                matchesSearch &&
                matchesSeverity &&
                matchesStatus
            ) {

                row.style.display = "";

            } else {

                row.style.display = "none";
            }

        });
    }


    searchInput.addEventListener(
        "input",
        filterAlerts
    );


    severityFilter.addEventListener(
        "change",
        filterAlerts
    );


    statusFilter.addEventListener(
        "change",
        filterAlerts
    );


    function openCreateAlertModal() {
        const modal = document.getElementById("createAlertModal");
        if (modal) modal.classList.add("show");
        document.body.style.overflow = "hidden";
    }

    function closeCreateAlertModal(event) {
        if (event && event.target && event.target.id !== "createAlertModal") return;
        const modal = document.getElementById("createAlertModal");
        if (modal) modal.classList.remove("show");
        document.body.style.overflow = "";
    }

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") closeCreateAlertModal();
    });

    function closeToast(id) {

        const element =
            document.getElementById(id);

        if (element) {

            element.style.display =
                "none";
        }
    }


    setTimeout(() => {

        const success =
            document.getElementById(
                "successToast"
            );

        const error =
            document.getElementById(
                "errorToast"
            );

        if (success) {
            success.style.display = "none";
        }

        if (error) {
            error.style.display = "none";
        }

    }, 5000);

</script>
<script>

    let currentAlertSelector = "";

    function openAlertSelector(type) {

        currentAlertSelector = type;

        const overlay =
            document.getElementById(
                "alertSelectionOverlay"
            );

        const title =
            document.getElementById(
                "alertSelectionTitle"
            );

        const search =
            document.getElementById(
                "alertSelectionSearch"
            );


        let titleText = "";
        let placeholderText = "";


        if (type === "shipment") {

            titleText =
                "Select Shipment";

            placeholderText =
                "Search by tracking number...";

        }

        else if (type === "vendor") {

            titleText =
                "Select Vendor";

            placeholderText =
                "Search by company name or vendor code...";

        }

        else if (type === "inventory") {

            titleText =
                "Select Inventory Item";

            placeholderText =
                "Search product, code or quantity...";

        }

        else if (type === "type") {

            titleText =
                "Select Alert Type";

            placeholderText =
                "Search alert type...";

        }

        else if (type === "severity") {

            titleText =
                "Select Severity";

            placeholderText =
                "Search severity...";

        }


        title.innerHTML =
            '<i class="fa-solid fa-list"></i>' +
            titleText;


        search.placeholder =
            placeholderText;

        search.value = "";


        loadAlertSelectionData();


        overlay.classList.add("show");


        document.body.style.overflow =
            "hidden";


        setTimeout(function () {

            search.focus();

        }, 100);

    }

    function closeAlertSelector() {

        const overlay =
            document.getElementById(
                "alertSelectionOverlay"
            );

        overlay.classList.remove("show");

        currentAlertSelector = "";

        document.body.style.overflow = "";

    }


    document
        .getElementById("alertSelectionOverlay")
        .addEventListener(
            "click",
            function (event) {

                if (event.target === this) {

                    closeAlertSelector();

                }

            }
        );


    function loadAlertSelectionData() {

        const content =
            document.getElementById(
                "alertSelectionContent"
            );

        const empty =
            document.getElementById(
                "alertSelectionEmpty"
            );


        content.innerHTML = "";

        empty.style.display =
            "none";


        if (currentAlertSelector === "shipment") {

            <%
                List<?> alertShipments =
                        (List<?>) request.getAttribute("shipments");

                if (alertShipments != null) {

                    for (Object item : alertShipments) {

                        String id =
                                objectId(item);

                        String tracking =
                                objectName(
                                        item,
                                        "trackingNumber"
                                );

                        if (!id.isEmpty()) {
            %>

            addAlertSelectionItem({

                type: "shipment",

                id: "<%= js(id) %>",

                title: "<%= js(
                    tracking.isEmpty()
                            ? "Shipment #" + id
                            : tracking
            ) %>",

                subtitle:
                    "Shipment ID: <%= js(id) %>"

            });

            <%
                        }
                    }
                }
            %>

        }

        else if (currentAlertSelector === "vendor") {

            <%
                List<?> alertVendors =
                        (List<?>) request.getAttribute("vendors");

                if (alertVendors != null) {

                    for (Object item : alertVendors) {

                        String id =
                                objectId(item);

                        String company =
                                objectName(
                                        item,
                                        "companyName"
                                );

                        String code =
                                objectName(
                                        item,
                                        "vendorCode"
                                );

                        if (!id.isEmpty()) {
            %>

            addAlertSelectionItem({

                type: "vendor",

                id: "<%= js(id) %>",

                title: "<%= js(
                    company.isEmpty()
                            ? "Vendor #" + id
                            : company
            ) %>",

                subtitle:
                    "<%= js(
                    code.isEmpty()
                        ? "Vendor ID: " + id
                        : "Vendor Code: " + code
                ) %>"

            });

            <%
                        }
                    }
                }
            %>

        }


        else if (currentAlertSelector === "inventory") {

            <%
                List<?> alertInventories =
                        (List<?>) request.getAttribute("inventories");

                if (alertInventories != null) {

                    for (Object item : alertInventories) {

                        String id =
                                objectId(item);

                        String product =
                                objectName(
                                        item,
                                        "productName"
                                );

                        String code =
                                objectName(
                                        item,
                                        "productCode"
                                );

                        String quantity =
                                objectName(
                                        item,
                                        "quantity"
                                );

                        if (!id.isEmpty()) {
            %>

            addAlertSelectionItem({

                type: "inventory",

                id: "<%= js(id) %>",

                title: "<%= js(
                    product.isEmpty()
                            ? "Inventory #" + id
                            : product
            ) %>",

                subtitle:
                    "<%= js(
                    "Product Code: " +
                    (code.isEmpty()
                        ? "-"
                        : code) +
                    " • Available Quantity: " +
                    (quantity.isEmpty()
                        ? "-"
                        : quantity)
                ) %>"

            });

            <%
                        }
                    }
                }
            %>

        }


        else if (currentAlertSelector === "type") {

            <%
                List<?> alertTypes =
                        (List<?>) request.getAttribute("alertTypes");

                if (alertTypes != null) {

                    for (Object item : alertTypes) {

                        String id =
                                objectId(item);

                        String name =
                                objectName(
                                        item,
                                        "name"
                                );

                        if (!id.isEmpty()) {
            %>

            addAlertSelectionItem({

                type: "type",

                id: "<%= js(id) %>",

                title: "<%= js(
                    name.isEmpty()
                            ? "Alert Type #" + id
                            : name
            ) %>",

                subtitle:
                    "Alert Type ID: <%= js(id) %>"

            });

            <%
                        }
                    }
                }
            %>

        }


        else if (currentAlertSelector === "severity") {

            <%
                List<?> alertSeverities =
                        (List<?>) request.getAttribute("severities");

                if (alertSeverities != null) {

                    for (Object item : alertSeverities) {

                        String id =
                                objectId(item);

                        String name =
                                objectName(
                                        item,
                                        "name"
                                );

                        if (!id.isEmpty()) {
            %>

            addAlertSelectionItem({

                type: "severity",

                id: "<%= js(id) %>",

                title: "<%= js(
                    name.isEmpty()
                            ? "Severity #" + id
                            : name
            ) %>",

                subtitle:
                    "Severity ID: <%= js(id) %>"

            });

            <%
                        }
                    }
                }
            %>

        }


        if (content.children.length === 0) {

            empty.style.display =
                "block";

        }

    }

    function addAlertSelectionItem(data) {

        const content =
            document.getElementById(
                "alertSelectionContent"
            );


        const item =
            document.createElement("div");

        item.className =
            "selection-item";


        const info =
            document.createElement("div");

        info.className =
            "selection-item-info";


        const title =
            document.createElement("span");

        title.className =
            "selection-item-title";

        title.textContent =
            data.title;


        const subtitle =
            document.createElement("span");

        subtitle.className =
            "selection-item-subtitle";

        subtitle.textContent =
            data.subtitle;


        info.appendChild(title);

        info.appendChild(subtitle);


        const button =
            document.createElement("button");

        button.type =
            "button";

        button.className =
            "selection-item-button";


        button.innerHTML =
            '<i class="fa-solid fa-check"></i> Select';


        button.addEventListener(
            "click",
            function () {

                selectAlertItem(
                    data.type,
                    data.id,
                    data.title
                );

            }
        );


        item.appendChild(info);

        item.appendChild(button);


        content.appendChild(item);

    }

    function selectAlertItem(
        type,
        id,
        title
    ) {


        if (type === "shipment") {

            document
                .getElementById(
                    "alertShipmentId"
                )
                .value = id;


            const display =
                document.getElementById(
                    "alertShipmentDisplay"
                );


            display.textContent =
                title;

            display.classList.remove(
                "placeholder"
            );


            document
                .getElementById(
                    "alertShipmentSelectedInfo"
                )
                .style.display = "flex";

        }


        else if (type === "vendor") {

            document
                .getElementById(
                    "alertVendorId"
                )
                .value = id;


            const display =
                document.getElementById(
                    "alertVendorDisplay"
                );


            display.textContent =
                title;

            display.classList.remove(
                "placeholder"
            );


            document
                .getElementById(
                    "alertVendorSelectedInfo"
                )
                .style.display = "flex";

        }


        else if (type === "inventory") {

            document
                .getElementById(
                    "alertInventoryId"
                )
                .value = id;


            const display =
                document.getElementById(
                    "alertInventoryDisplay"
                );


            display.textContent =
                title;

            display.classList.remove(
                "placeholder"
            );


            document
                .getElementById(
                    "alertInventorySelectedInfo"
                )
                .style.display = "flex";

        }


        else if (type === "type") {

            document
                .getElementById(
                    "alertTypeId"
                )
                .value = id;


            const display =
                document.getElementById(
                    "alertTypeDisplay"
                );


            display.textContent =
                title;

            display.classList.remove(
                "placeholder"
            );


            document
                .getElementById(
                    "alertTypeSelectedInfo"
                )
                .style.display = "flex";

        }


        else if (type === "severity") {

            document
                .getElementById(
                    "alertSeverityId"
                )
                .value = id;


            const display =
                document.getElementById(
                    "alertSeverityDisplay"
                );


            display.textContent =
                title;

            display.classList.remove(
                "placeholder"
            );


            document
                .getElementById(
                    "alertSeveritySelectedInfo"
                )
                .style.display = "flex";

        }


        closeAlertSelector();

    }

    function searchAlertSelection() {

        const search =
            document
                .getElementById(
                    "alertSelectionSearch"
                )
                .value
                .toLowerCase()
                .trim();


        const items =
            document.querySelectorAll(
                "#alertSelectionContent .selection-item"
            );


        let visibleCount = 0;


        items.forEach(
            function (item) {

                const text =
                    item.innerText
                        .toLowerCase();


                if (
                    search === "" ||
                    text.includes(search)
                ) {

                    item.style.display =
                        "";

                    visibleCount++;

                }

                else {

                    item.style.display =
                        "none";

                }

            }
        );


        const empty =
            document.getElementById(
                "alertSelectionEmpty"
            );


        if (visibleCount === 0) {

            empty.style.display =
                "block";

        }

        else {

            empty.style.display =
                "none";

        }

    }

    document.addEventListener(
        "keydown",
        function (event) {

            if (
                event.key === "Escape"
            ) {

                const overlay =
                    document.getElementById(
                        "alertSelectionOverlay"
                    );


                if (
                    overlay &&
                    overlay.classList.contains("show")
                ) {

                    closeAlertSelector();

                }

            }

        }
    );

</script>

</body>

</html>