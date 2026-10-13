<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="lk.sasindi.globaltrade.entity.Vendor" %>
<%@ page import="lk.sasindi.globaltrade.entity.Status" %>
<%@ page import="lk.sasindi.globaltrade.entity.Country" %>

<%
    jakarta.servlet.http.HttpSession adminSession = request.getSession(false);

    if (adminSession == null ||
            !Boolean.TRUE.equals(adminSession.getAttribute("authenticated"))) {

        response.sendRedirect(
                request.getContextPath() + "/signin"
        );

        return;
    }

    List<Vendor> vendors = (List<Vendor>) request.getAttribute("vendors");
    List<Status> statuses = (List<Status>) request.getAttribute("statuses");
    List<Country> countries = (List<Country>) request.getAttribute("countries");

    String nextVendorCode =
            (String) request.getAttribute("nextVendorCode");

    if (nextVendorCode == null || nextVendorCode.isBlank()) {
        nextVendorCode = "VEN-001";
    }

    if (vendors == null) vendors = Collections.emptyList();
    if (statuses == null) statuses = Collections.emptyList();
    if (countries == null) countries = Collections.emptyList();

    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");

    long activeCount = vendors.stream()
            .filter(v -> v.getStatus() != null &&
                    "Active".equalsIgnoreCase(v.getStatus().getName()))
            .count();

    long inactiveCount = vendors.stream()
            .filter(v -> v.getStatus() != null &&
                    "Active".equalsIgnoreCase(v.getStatus().getName()) == false)
            .count();

    java.math.BigDecimal averageScore = java.math.BigDecimal.ZERO;
    java.util.List<java.math.BigDecimal> scores = vendors.stream()
            .map(Vendor::getPerformanceScore)
            .filter(java.util.Objects::nonNull)
            .toList();

    if (!scores.isEmpty()) {
        java.math.BigDecimal total = scores.stream()
                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);
        averageScore = total.divide(
                java.math.BigDecimal.valueOf(scores.size()),
                2,
                java.math.RoundingMode.HALF_UP
        );
    }

    String adminName =
            String.valueOf(
                    adminSession.getAttribute("firstName")
            );

    if (adminName == null || "null".equalsIgnoreCase(adminName)
            || adminName.isBlank()) {
        adminName = "Administrator";
    }

    String initial =
            adminName.substring(0, 1).toUpperCase();
%>


<%!
    private String js(Object value) {
        if (value == null) {
            return "";
        }

        return value.toString()
                .replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\"", "\\\"")
                .replace("\r", " ")
                .replace("\n", " ");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vendors | GlobalTrade</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        :root {
            --navy: #003049;
            --navy-2: #00415f;
            --navy-3: #00506f;

            --yellow: #fcbf49;
            --yellow-light: #fff7df;

            --orange: #f77f00;
            --orange-light: #fff1df;

            --blue: #0066ff;
            --blue-light: #eef5ff;

            --green: #198754;
            --green-light: #eaf8f0;

            --red: #dc3545;
            --red-light: #fef2f2;

            --text: #16324a;
            --muted: #718096;
            --border: #e3e9ef;
            --bg: #f4f7f9;
            --white: #ffffff;

            --sidebar-width: 270px;
            --topbar-height: 70px;
        }

        * {
            box-sizing: border-box;
        }

        html,
        body {
            margin: 0;
            padding: 0;
            min-height: 100%;
            font-family: "Segoe UI", Arial, sans-serif;
            background: var(--bg);
            color: var(--text);
            font-size: 12px;
        }

        body {
            overflow-x: hidden;
        }

        button,
        input,
        select {
            font-family: inherit;
        }

        button {
            border: 0;
        }

        /* =====================================================
           SIDEBAR
           ===================================================== */

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            width: var(--sidebar-width);
            background: var(--navy);
            color: #fff;
            z-index: 1000;
            overflow-y: auto;
            overflow-x: hidden;
        }

        .sidebar-brand {
            height: 82px;
            padding: 0 22px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(255,255,255,.08);
        }

        .brand-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: var(--yellow);
            color: var(--navy);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 17px;
            flex-shrink: 0;
        }

        .brand-title {
            font-size: 15px;
            font-weight: 700;
            line-height: 1.1;
        }

        .brand-subtitle {
            margin-top: 3px;
            font-size: 9px;
            color: rgba(255,255,255,.48);
            letter-spacing: .2px;
        }

        .sidebar-nav {
            padding: 15px 10px;
        }

        .nav-section {
            margin: 13px 11px 7px;
            color: rgba(255,255,255,.35);
            font-size: 8px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 700;
        }

        .nav-item {
            min-height: 39px;
            padding: 0 13px;
            margin: 3px 0;
            border-radius: 7px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: rgba(255,255,255,.63);
            text-decoration: none;
            font-size: 10px;
            font-weight: 600;
            transition: .18s ease;
        }

        .nav-item i {
            width: 17px;
            text-align: center;
            font-size: 13px;
        }

        .nav-item:hover {
            color: #fff;
            background: rgba(255,255,255,.07);
        }

        .nav-item.active {
            color: #fff;
            background: rgba(252,191,73,.17);
            box-shadow: inset 3px 0 0 var(--yellow);
        }

        .nav-item.active i {
            color: var(--yellow);
        }

        .nav-chevron {
            margin-left: auto;
            font-size: 8px;
        }

        .sidebar-profile {
            position: sticky;
            bottom: 0;
            margin-top: 14px;
            padding: 13px;
            background: rgba(0,0,0,.12);
            border-top: 1px solid rgba(255,255,255,.07);
        }

        .profile-box {
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .profile-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: var(--yellow);
            color: var(--navy);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 12px;
        }

        .profile-name {
            color: #fff;
            font-size: 10px;
            font-weight: 700;
        }

        .profile-role {
            margin-top: 2px;
            color: rgba(255,255,255,.45);
            font-size: 8px;
        }

        /* =====================================================
           TOPBAR
           ===================================================== */

        .main {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
        }

        .topbar {
            height: var(--topbar-height);
            background: #fff;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            padding: 0 26px;
            gap: 17px;
        }

        .menu-toggle {
            width: 28px;
            height: 28px;
            background: transparent;
            color: var(--navy);
            cursor: pointer;
            font-size: 17px;
        }

        .global-search {
            width: 305px;
            height: 38px;
            border: 1px solid var(--border);
            background: #fafcfd;
            border-radius: 7px;
            display: flex;
            align-items: center;
            padding: 0 12px;
            color: #90a0ae;
        }

        .global-search i {
            margin-right: 9px;
            font-size: 12px;
        }

        .global-search input {
            border: 0;
            outline: 0;
            background: transparent;
            width: 100%;
            color: var(--text);
            font-size: 10px;
        }

        .topbar-spacer {
            flex: 1;
        }

        .top-icon {
            width: 31px;
            height: 31px;
            border-radius: 50%;
            background: transparent;
            color: var(--navy);
            cursor: pointer;
            font-size: 13px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .top-icon:hover {
            background: #f2f5f7;
        }

        .admin-menu {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-left: 5px;
        }

        .admin-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: #fff3d3;
            color: var(--orange);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }

        .admin-info {
            line-height: 1.15;
        }

        .admin-name {
            font-size: 10px;
            font-weight: 700;
            color: var(--navy);
        }

        .admin-role {
            margin-top: 3px;
            font-size: 8px;
            color: var(--muted);
        }

        .admin-chevron {
            color: var(--navy);
            margin-left: 3px;
            font-size: 9px;
        }

        /* =====================================================
           CONTENT
           ===================================================== */

        .content {
            padding: 25px 26px 18px;
        }

        .page-heading {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 19px;
        }

        .page-heading h1 {
            margin: 0;
            color: var(--navy);
            font-size: 22px;
            line-height: 1.2;
            font-weight: 700;
        }

        .page-heading p {
            margin: 5px 0 0;
            color: var(--muted);
            font-size: 10px;
        }

        .primary-btn {
            height: 40px;
            padding: 0 17px;
            border-radius: 7px;
            background: var(--yellow);
            color: var(--navy);
            font-size: 10px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            box-shadow: 0 3px 8px rgba(252,191,73,.20);
        }

        .primary-btn:hover {
            background: #f5b63b;
        }

        /* =====================================================
           ALERTS
           ===================================================== */

        .alert {
            margin-bottom: 14px;
            padding: 11px 13px;
            border-radius: 7px;
            display: flex;
            align-items: center;
            gap: 9px;
            font-size: 10px;
        }

        .alert-success {
            background: var(--green-light);
            color: #146c43;
            border: 1px solid #ccebd9;
        }

        .alert-error {
            background: var(--red-light);
            color: #b02a37;
            border: 1px solid #f4c7cb;
        }

        /* =====================================================
           STAT CARDS
           ===================================================== */

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 15px;
        }

        .stat-card {
            min-height: 83px;
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 14px 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .stat-label {
            color: #718096;
            font-size: 8px;
            text-transform: uppercase;
            letter-spacing: .55px;
            font-weight: 700;
        }

        .stat-value {
            margin-top: 8px;
            color: var(--navy);
            font-size: 20px;
            font-weight: 700;
            line-height: 1;
        }

        .stat-icon {
            width: 39px;
            height: 39px;
            border-radius: 10px;
            background: var(--yellow-light);
            color: var(--orange);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 15px;
        }

        /* =====================================================
           TABLE CARD
           ===================================================== */

        .table-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 10px;
            overflow: hidden;
        }

        .table-header {
            min-height: 68px;
            padding: 14px 17px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            border-bottom: 1px solid var(--border);
        }

        .table-title h2 {
            margin: 0;
            color: var(--navy);
            font-size: 14px;
            font-weight: 700;
        }

        .table-title p {
            margin: 4px 0 0;
            color: var(--muted);
            font-size: 9px;
        }

        .table-tools {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .table-search {
            width: 225px;
            height: 35px;
            border: 1px solid var(--border);
            border-radius: 7px;
            display: flex;
            align-items: center;
            padding: 0 10px;
            background: #fafcfd;
        }

        .table-search i {
            color: #8b9aaa;
            margin-right: 8px;
            font-size: 10px;
        }

        .table-search input {
            width: 100%;
            border: 0;
            outline: 0;
            background: transparent;
            font-size: 9px;
            color: var(--text);
        }

        .filter-select {
            height: 35px;
            border: 1px solid var(--border);
            border-radius: 7px;
            background: #fafcfd;
            padding: 0 9px;
            color: var(--text);
            outline: none;
            font-size: 9px;
            min-width: 120px;
        }

        .table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 930px;
        }

        thead th {
            height: 39px;
            padding: 0 14px;
            background: #f8fafb;
            color: #60758a;
            border-bottom: 1px solid var(--border);
            text-align: left;
            font-size: 8px;
            text-transform: uppercase;
            letter-spacing: .45px;
            font-weight: 700;
            white-space: nowrap;
        }

        tbody td {
            padding: 12px 14px;
            border-bottom: 1px solid #edf1f4;
            color: var(--text);
            font-size: 9px;
            vertical-align: middle;
        }

        tbody tr:last-child td {
            border-bottom: 0;
        }

        tbody tr:hover {
            background: #fbfcfd;
        }

        .vendor-cell {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .vendor-icon {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            background: var(--yellow-light);
            color: var(--orange);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 13px;
        }

        .vendor-name {
            color: var(--navy);
            font-size: 10px;
            font-weight: 700;
        }

        .vendor-code {
            margin-top: 3px;
            color: var(--muted);
            font-size: 8px;
        }

        .contact-name {
            color: var(--navy);
            font-weight: 600;
            font-size: 9px;
        }

        .sub-text {
            margin-top: 3px;
            color: var(--muted);
            font-size: 8px;
        }

        .score {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 700;
            color: var(--navy);
        }

        .score-bar {
            width: 50px;
            height: 5px;
            background: #edf1f4;
            border-radius: 10px;
            overflow: hidden;
        }

        .score-fill {
            height: 100%;
            background: var(--green);
            border-radius: 10px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 8px;
            border-radius: 20px;
            font-size: 8px;
            font-weight: 700;
        }

        .status-badge.active {
            background: var(--green-light);
            color: var(--green);
        }

        .status-badge.inactive {
            background: var(--red-light);
            color: var(--red);
        }

        .status-dot {
            width: 5px;
            height: 5px;
            border-radius: 50%;
            background: currentColor;
        }

        .country-cell {
            color: var(--text);
            font-size: 9px;
        }

        .action-group {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .action-btn {
            width: 30px;
            height: 30px;
            border-radius: 7px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 10px;
        }

        .edit-btn {
            background: var(--blue-light);
            color: var(--blue);
        }

        .edit-btn:hover {
            background: #dceaff;
        }

        .delete-btn {
            background: var(--red-light);
            color: var(--red);
        }

        .delete-btn:hover {
            background: #fde0e3;
        }

        .view-btn {
            background: var(--yellow-light);
            color: var(--orange);
        }

        .view-btn:hover {
            background: #ffefc2;
        }

        .empty-state {
            padding: 55px 20px;
            text-align: center;
            color: var(--muted);
        }

        .empty-state i {
            font-size: 28px;
            color: #c5d0d9;
            margin-bottom: 10px;
        }

        .empty-state h3 {
            margin: 0;
            color: var(--navy);
            font-size: 12px;
        }

        .empty-state p {
            margin: 5px 0 0;
            font-size: 9px;
        }

        .page-footer {
            padding: 18px 2px 0;
            display: flex;
            justify-content: space-between;
            color: #81909e;
            font-size: 8px;
        }

        /* =====================================================
           MODALS
           ===================================================== */

        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 48, 73, .48);
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
            z-index: 10000;
        }

        .modal-overlay.active {
            display: flex;
        }

        .vendor-modal {
            width: 100%;
            max-width: 610px;
            max-height: 92vh;
            overflow-y: auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 24px 60px rgba(0,0,0,.22);
        }

        .modal-header {
            min-height: 62px;
            padding: 12px 17px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-heading {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal-icon {
            width: 36px;
            height: 36px;
            border-radius: 9px;
            background: var(--yellow-light);
            color: var(--orange);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-header h2 {
            margin: 0;
            color: var(--navy);
            font-size: 15px;
        }

        .modal-header p {
            margin: 3px 0 0;
            color: var(--muted);
            font-size: 8px;
        }

        .close-modal {
            width: 30px;
            height: 30px;
            border-radius: 7px;
            background: transparent;
            color: #64748b;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
        }

        .close-modal:hover {
            background: var(--red-light);
            color: var(--red);
        }

        .modal-body {
            padding: 18px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 13px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: #617487;
            font-size: 9px;
            font-weight: 700;
        }

        .form-control {
            width: 100%;
            height: 38px;
            padding: 0 10px;
            border: 1px solid var(--border);
            border-radius: 7px;
            background: #fffdf7;
            outline: none;
            color: var(--navy);
            font-size: 10px;
        }

        .form-control:focus {
            border-color: var(--yellow);
            box-shadow: 0 0 0 3px rgba(252,191,73,.12);
        }

        .modal-footer {
            padding: 12px 17px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: flex-end;
            gap: 8px;
        }

        .btn-secondary {
            height: 35px;
            padding: 0 13px;
            border-radius: 7px;
            background: #f2f5f7;
            color: #566b7c;
            font-size: 9px;
            font-weight: 700;
            cursor: pointer;
        }

        .btn-secondary:hover {
            background: #e7ecef;
        }

        .btn-save {
            height: 35px;
            padding: 0 15px;
            border-radius: 7px;
            background: var(--yellow);
            color: var(--navy);
            font-size: 9px;
            font-weight: 700;
            cursor: pointer;
        }

        .btn-save:hover {
            background: #f4b63d;
        }

        .btn-delete {
            height: 35px;
            padding: 0 15px;
            border-radius: 7px;
            background: var(--red);
            color: #fff;
            font-size: 9px;
            font-weight: 700;
            cursor: pointer;
        }

        .btn-delete:hover {
            background: #c82333;
        }

        .delete-message {
            padding: 24px 20px 8px;
            text-align: center;
        }

        .delete-icon {
            width: 46px;
            height: 46px;
            margin: 0 auto 10px;
            border-radius: 50%;
            background: var(--red-light);
            color: var(--red);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .delete-message h3 {
            margin: 0;
            color: var(--navy);
            font-size: 13px;
        }

        .delete-message p {
            margin: 7px 0 0;
            color: var(--muted);
            font-size: 9px;
            line-height: 1.5;
        }

        .field-error {
            display: none;
            margin-top: 4px;
            color: var(--red);
            font-size: 8px;
        }

        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 1050px) {
            .sidebar {
                width: 225px;
            }

            .main {
                margin-left: 225px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 760px) {
            .sidebar {
                transform: translateX(-100%);
                transition: .2s ease;
            }

            .sidebar.open {
                transform: translateX(0);
            }

            .main {
                margin-left: 0;
            }

            .content {
                padding: 18px 14px;
            }

            .page-heading {
                flex-direction: column;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .table-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .table-tools {
                width: 100%;
            }

            .table-search {
                flex: 1;
                width: auto;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full {
                grid-column: auto;
            }

            .global-search {
                width: 190px;
            }
        }

        /* =====================================================
           SHIPMENT PAGE LAYOUT COMPATIBILITY
           These rules intentionally match shipment.jsp so the
           shared admin-sidebar.jsp and admin-topbar.jsp render
           identically on the vendor page.
           ===================================================== */

        :root {
            --sidebar-width: 250px;
            --topbar-height: 65px;
            --background: #FFF9E8;
            --card: #FFFFFF;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            background: var(--background);
            color: var(--text);
            font-size: 12px;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        /* Shared sidebar */
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
            box-shadow: 2px 0 10px rgba(0,0,0,.08);
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

        .nav-item.active i {
            color: white;
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
            background: #FFF3CD;
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

        /* Shared topbar */
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
            border: 1px solid #F8E4A9;
            border-radius: 7px;
            color: var(--muted);
        }

        .search:focus-within {
            border-color: var(--yellow);
            box-shadow: 0 0 0 3px rgba(252,191,73,.12);
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
            background: #FFF3CD;
            color: var(--orange);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 700;
        }

        /* Shared content */
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
            margin: 0;
            color: var(--navy);
            font-size: 24px;
            letter-spacing: -.5px;
        }

        .page-heading p {
            margin: 4px 0 0;
            font-size: 12px;
            color: var(--muted);
        }

        /* Shared stats */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 14px;
        }

        .stat-card {
            background: var(--card);
            border: 1px solid var(--border);
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
            background: rgba(252,191,73,.20);
            color: var(--orange);
            font-size: 15px;
            flex-shrink: 0;
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

        .field-help {
            margin-top: 4px;
            color: var(--muted);
            font-size: 8px;
        }

        .form-control[readonly] {
            background: #f4f7f9;
            color: var(--navy);
            font-weight: 700;
            cursor: not-allowed;
        }

        @media (max-width: 1050px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 760px) {
            .sidebar {
                transform: translateX(-100%);
                transition: .2s ease;
            }

            .sidebar.open {
                transform: translateX(0);
            }

            .main {
                margin-left: 0;
            }

            .content {
                padding: 18px 14px;
            }

            .page-heading {
                flex-direction: column;
                align-items: flex-start;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .search {
                width: 190px;
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
                <h1>Vendor Management</h1>
                <p>Manage suppliers, vendor performance and business relationships.</p>
            </div>

            <button type="button" class="primary-btn" onclick="openCreateModal()">
                <i class="fa-solid fa-plus"></i>
                Add Vendor
            </button>
        </div>

        <% if (success != null && !success.isBlank()) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <span><%= success %></span>
        </div>
        <% } %>

        <% if (error != null && !error.isBlank()) { %>
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span><%= error %></span>
        </div>
        <% } %>

        <div class="stats-grid">

            <div class="stat-card">
                <div>
                    <div class="stat-label">Total Vendors</div>
                    <div class="stat-value"><%= vendors.size() %></div>
                </div>
                <div class="stat-icon">
                    <i class="fa-solid fa-building"></i>
                </div>
            </div>

            <div class="stat-card">
                <div>
                    <div class="stat-label">Active Vendors</div>
                    <div class="stat-value"><%= activeCount %></div>
                </div>
                <div class="stat-icon">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
            </div>

            <div class="stat-card">
                <div>
                    <div class="stat-label">Inactive Vendors</div>
                    <div class="stat-value"><%= inactiveCount %></div>
                </div>
                <div class="stat-icon">
                    <i class="fa-solid fa-circle-pause"></i>
                </div>
            </div>

            <div class="stat-card">
                <div>
                    <div class="stat-label">Average Performance</div>
                    <div class="stat-value"><%= averageScore %>%</div>
                </div>
                <div class="stat-icon">
                    <i class="fa-solid fa-chart-line"></i>
                </div>
            </div>

        </div>

        <div class="table-card">

            <div class="table-header">
                <div class="table-title">
                    <h2>Vendor Records</h2>
                    <p>Manage registered suppliers and their performance.</p>
                </div>

                <div class="table-tools">

                    <div class="table-search">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input
                                type="text"
                                id="vendorSearch"
                                placeholder="Search vendor..."
                                oninput="filterVendors()">
                    </div>

                    <select id="statusFilter"
                            class="filter-select"
                            onchange="filterVendors()">
                        <option value="">All Status</option>
                        <% for (Status status : statuses) { %>
                        <option value="<%= status.getName() %>">
                            <%= status.getName() %>
                        </option>
                        <% } %>
                    </select>

                </div>
            </div>

            <div class="table-wrap">

                <table id="vendorTable">

                    <thead>
                    <tr>
                        <th>Vendor</th>
                        <th>Contact</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Country</th>
                        <th>Performance</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                    </thead>

                    <tbody id="vendorTableBody">

                    <% if (vendors.isEmpty()) { %>

                    <tr>
                        <td colspan="9">
                            <div class="empty-state">
                                <i class="fa-solid fa-building-circle-xmark"></i>
                                <h3>No vendors found</h3>
                                <p>Add your first vendor using the Add Vendor button.</p>
                            </div>
                        </td>
                    </tr>

                    <% } else { %>

                    <% for (Vendor vendor : vendors) {

                        String statusName =
                                vendor.getStatus() != null
                                        ? vendor.getStatus().getName()
                                        : "Unknown";

                        String countryName =
                                vendor.getCountry() != null
                                        ? vendor.getCountry().getName()
                                        : "Unknown";

                        java.math.BigDecimal score =
                                vendor.getPerformanceScore() != null
                                        ? vendor.getPerformanceScore()
                                        : java.math.BigDecimal.ZERO;

                        int scoreWidth = Math.max(
                                0,
                                Math.min(100, score.intValue())
                        );

                        String created =
                                vendor.getCreatedAt() != null
                                        ? vendor.getCreatedAt()
                                        .toString()
                                        .replace("T", " ")
                                        : "-";

                        boolean isActive =
                                "Active".equalsIgnoreCase(statusName);
                    %>

                    <tr class="vendor-row"
                        data-search="<%= (
                                        vendor.getVendorCode() + " " +
                                        vendor.getCompanyName() + " " +
                                        vendor.getContactName() + " " +
                                        vendor.getEmail() + " " +
                                        vendor.getPhone() + " " +
                                        countryName
                                ).toLowerCase() %>"
                        data-status="<%= statusName.toLowerCase() %>">

                        <td>
                            <div class="vendor-cell">
                                <div class="vendor-icon">
                                    <i class="fa-solid fa-building"></i>
                                </div>

                                <div>
                                    <div class="vendor-name">
                                        <%= vendor.getCompanyName() %>
                                    </div>

                                    <div class="vendor-code">
                                        <%= vendor.getVendorCode() %>
                                    </div>
                                </div>
                            </div>
                        </td>

                        <td>
                            <div class="contact-name">
                                <%= vendor.getContactName() %>
                            </div>
                        </td>

                        <td>
                            <div class="sub-text">
                                <%= vendor.getEmail() %>
                            </div>
                        </td>

                        <td>
                            <%= vendor.getPhone() %>
                        </td>

                        <td>
                            <div class="country-cell">
                                <%= countryName %>
                            </div>
                        </td>

                        <td>
                            <div class="score">
                                <%= score %>%
                                <div class="score-bar">
                                    <div class="score-fill"
                                         style="width:<%= scoreWidth %>%"></div>
                                </div>
                            </div>
                        </td>

                        <td>
                                    <span class="status-badge <%= isActive ? "active" : "inactive" %>">
                                        <span class="status-dot"></span>
                                        <%= statusName %>
                                    </span>
                        </td>

                        <td>
                            <div class="sub-text"><%= created %></div>
                        </td>

                        <td>
                            <div class="action-group">

                                <button type="button"
                                        class="action-btn view-btn"
                                        title="View Vendor"
                                        onclick="openViewModal(
                                                '<%= vendor.getId() %>',
                                                '<%= js(vendor.getVendorCode()) %>',
                                                '<%= js(vendor.getCompanyName()) %>',
                                                '<%= js(vendor.getContactName()) %>',
                                                '<%= js(vendor.getEmail()) %>',
                                                '<%= js(vendor.getPhone()) %>',
                                                '<%= js(countryName) %>',
                                                '<%= js(statusName) %>',
                                                '<%= score %>'
                                                )">
                                    <i class="fa-solid fa-eye"></i>
                                </button>

                                <button type="button"
                                        class="action-btn edit-btn"
                                        title="Edit Vendor"
                                        onclick="openEditModal(
                                                '<%= vendor.getId() %>',
                                                '<%= js(vendor.getVendorCode()) %>',
                                                '<%= js(vendor.getCompanyName()) %>',
                                                '<%= js(vendor.getContactName()) %>',
                                                '<%= js(vendor.getEmail()) %>',
                                                '<%= js(vendor.getPhone()) %>',
                                                '<%= vendor.getCountry() != null ? vendor.getCountry().getId() : "" %>',
                                                '<%= vendor.getCountry() != null ? js(vendor.getCountry().getName()) : "" %>',
                                                '<%= vendor.getStatus() != null ? vendor.getStatus().getId() : "" %>',
                                                '<%= js(statusName) %>',
                                                '<%= score %>'
                                                )">
                                    <i class="fa-solid fa-pen"></i>
                                </button>

                                <button type="button"
                                        class="action-btn delete-btn"
                                        title="Delete Vendor"
                                        onclick="openDeleteModal(
                                                '<%= vendor.getId() %>',
                                                '<%= js(vendor.getCompanyName()) %>'
                                                )">
                                    <i class="fa-solid fa-trash"></i>
                                </button>

                            </div>
                        </td>

                    </tr>

                    <% } %>

                    <% } %>

                    </tbody>
                </table>

            </div>
        </div>

        <div class="page-footer">
            <span>© 2026 GlobalTrade Logistics System. All rights reserved.</span>
            <span>Administrator Portal • Version 1.0.0</span>
        </div>

    </section>
</main>


<!-- =========================================================
     CREATE / EDIT MODAL
     ========================================================= -->

<div class="modal-overlay" id="vendorFormModal">

    <div class="vendor-modal">

        <div class="modal-header">

            <div class="modal-heading">
                <div class="modal-icon">
                    <i class="fa-solid fa-building"></i>
                </div>

                <div>
                    <h2 id="formModalTitle">Add Vendor</h2>
                    <p id="formModalSubtitle">Create a new vendor record</p>
                </div>
            </div>

            <button type="button"
                    class="close-modal"
                    onclick="closeModal('vendorFormModal')">
                <i class="fa-solid fa-xmark"></i>
            </button>

        </div>

        <form method="post"
              action="<%= request.getContextPath() %>/vendors"
              id="vendorForm"
              onsubmit="return validateVendorForm();">

            <input type="hidden" name="action" id="formAction" value="create">
            <input type="hidden" name="id" id="vendorId">

            <div class="modal-body">

                <div class="form-grid">

                    <div class="form-group">
                        <label for="vendorCode">Vendor Code *</label>
                        <input type="text"
                               class="form-control"
                               id="vendorCode"
                               name="vendorCode"
                               maxlength="30"
                               placeholder="e.g. VEN-001"
                               readonly
                               required>
                        <div class="field-help" id="vendorCodeHelp">
                            Vendor code is generated automatically and cannot be changed.
                        </div>
                        <div class="field-error" id="vendorCodeError">
                            Vendor code is required.
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="companyName">Company Name *</label>
                        <input type="text"
                               class="form-control"
                               id="companyName"
                               name="companyName"
                               maxlength="150"
                               placeholder="Company name"
                               required>
                        <div class="field-error" id="companyNameError">
                            Company name is required.
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="contactName">Contact Name *</label>
                        <input type="text"
                               class="form-control"
                               id="contactName"
                               name="contactName"
                               maxlength="100"
                               placeholder="Primary contact"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email"
                               class="form-control"
                               id="email"
                               name="email"
                               maxlength="150"
                               placeholder="vendor@example.com"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone *</label>
                        <input type="text"
                               class="form-control"
                               id="phone"
                               name="phone"
                               maxlength="10"
                               inputmode="numeric"
                               pattern="[0-9]{10}"
                               placeholder="0771234567"
                               required>
                        <div class="field-error" id="phoneError">
                            Phone number must contain exactly 10 digits.
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="performanceScore">Performance Score *</label>
                        <input type="number"
                               class="form-control"
                               id="performanceScore"
                               name="performanceScore"
                               min="0"
                               max="100"
                               step="0.01"
                               placeholder="e.g. 85.50"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="countryId">Country *</label>
                        <select class="form-control"
                                id="countryId"
                                name="countryId"
                                required>
                            <option value="">Select Country</option>

                            <% for (Country country : countries) { %>
                            <option value="<%= country.getId() %>">
                                <%= country.getName() %>
                            </option>
                            <% } %>

                        </select>
                    </div>

                    <div class="form-group">
                        <label for="statusId">Status *</label>
                        <select class="form-control"
                                id="statusId"
                                name="statusId"
                                required>
                            <option value="">Select Status</option>

                            <% for (Status status : statuses) { %>
                            <option value="<%= status.getId() %>">
                                <%= status.getName() %>
                            </option>
                            <% } %>

                        </select>
                    </div>

                </div>

            </div>

            <div class="modal-footer">

                <button type="button"
                        class="btn-secondary"
                        onclick="closeModal('vendorFormModal')">
                    Cancel
                </button>

                <button type="submit"
                        class="btn-save"
                        id="formSubmitButton">
                    <i class="fa-solid fa-check"></i>
                    Create Vendor
                </button>

            </div>

        </form>

    </div>
</div>


<!-- =========================================================
     VIEW MODAL
     ========================================================= -->

<div class="modal-overlay" id="viewModal">

    <div class="vendor-modal">

        <div class="modal-header">

            <div class="modal-heading">
                <div class="modal-icon">
                    <i class="fa-solid fa-eye"></i>
                </div>

                <div>
                    <h2>Vendor Details</h2>
                    <p>View vendor information</p>
                </div>
            </div>

            <button type="button"
                    class="close-modal"
                    onclick="closeModal('viewModal')">
                <i class="fa-solid fa-xmark"></i>
            </button>

        </div>

        <div class="modal-body">

            <div class="form-grid">

                <div class="form-group">
                    <label>Vendor Code</label>
                    <input class="form-control" id="viewVendorCode" readonly>
                </div>

                <div class="form-group">
                    <label>Company Name</label>
                    <input class="form-control" id="viewCompanyName" readonly>
                </div>

                <div class="form-group">
                    <label>Contact Name</label>
                    <input class="form-control" id="viewContactName" readonly>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input class="form-control" id="viewEmail" readonly>
                </div>

                <div class="form-group">
                    <label>Phone</label>
                    <input class="form-control" id="viewPhone" readonly>
                </div>

                <div class="form-group">
                    <label>Country</label>
                    <input class="form-control" id="viewCountry" readonly>
                </div>

                <div class="form-group">
                    <label>Status</label>
                    <input class="form-control" id="viewStatus" readonly>
                </div>

                <div class="form-group">
                    <label>Performance Score</label>
                    <input class="form-control" id="viewScore" readonly>
                </div>

            </div>

        </div>

        <div class="modal-footer">
            <button type="button"
                    class="btn-secondary"
                    onclick="closeModal('viewModal')">
                Close
            </button>
        </div>

    </div>
</div>


<!-- =========================================================
     DELETE MODAL
     ========================================================= -->

<div class="modal-overlay" id="deleteModal">

    <div class="vendor-modal" style="max-width: 450px;">

        <div class="modal-header">

            <div class="modal-heading">
                <div class="modal-icon"
                     style="background:#fef2f2;color:#dc3545;">
                    <i class="fa-solid fa-trash"></i>
                </div>

                <div>
                    <h2>Delete Vendor</h2>
                    <p>Confirm vendor deletion</p>
                </div>
            </div>

            <button type="button"
                    class="close-modal"
                    onclick="closeModal('deleteModal')">
                <i class="fa-solid fa-xmark"></i>
            </button>

        </div>

        <form method="post"
              action="<%= request.getContextPath() %>/vendors">

            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" id="deleteVendorId">

            <div class="delete-message">

                <div class="delete-icon">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>

                <h3>Delete this vendor?</h3>

                <p>
                    You are about to delete
                    <strong id="deleteVendorName"></strong>.
                    This action cannot be undone.
                </p>

            </div>

            <div class="modal-footer">

                <button type="button"
                        class="btn-secondary"
                        onclick="closeModal('deleteModal')">
                    Cancel
                </button>

                <button type="submit"
                        class="btn-delete">
                    <i class="fa-solid fa-trash"></i>
                    Delete Vendor
                </button>

            </div>

        </form>

    </div>
</div>


<script>
    function toggleSidebar() {
        const sidebar = document.querySelector(".sidebar");
        if (sidebar) sidebar.classList.toggle("open");
    }

    function openCreateModal() {

        document.getElementById("formModalTitle").textContent = "Add Vendor";
        document.getElementById("formModalSubtitle").textContent =
            "Create a new vendor record";

        document.getElementById("formAction").value = "create";
        document.getElementById("vendorId").value = "";

        document.getElementById("vendorCode").value = "<%= js(nextVendorCode) %>";
        document.getElementById("vendorCode").readOnly = true;
        document.getElementById("companyName").value = "";
        document.getElementById("contactName").value = "";
        document.getElementById("email").value = "";
        document.getElementById("phone").value = "";
        document.getElementById("performanceScore").value = "";
        document.getElementById("countryId").value = "";
        document.getElementById("statusId").value = "";

        document.getElementById("formSubmitButton").innerHTML =
            '<i class="fa-solid fa-check"></i> Create Vendor';

        clearErrors();

        document.getElementById("vendorFormModal")
            .classList.add("active");
    }

    function openEditModal(
        id,
        vendorCode,
        companyName,
        contactName,
        email,
        phone,
        countryId,
        countryName,
        statusId,
        statusName,
        score
    ) {

        document.getElementById("formModalTitle").textContent = "Edit Vendor";
        document.getElementById("formModalSubtitle").textContent =
            "Update vendor information";

        document.getElementById("formAction").value = "update";
        document.getElementById("vendorId").value = id;

        document.getElementById("vendorCode").value = vendorCode;
        document.getElementById("vendorCode").readOnly = true;
        document.getElementById("companyName").value = companyName;
        document.getElementById("contactName").value = contactName;
        document.getElementById("email").value = email;
        document.getElementById("phone").value = phone;
        document.getElementById("performanceScore").value = score;
        document.getElementById("countryId").value = countryId;
        document.getElementById("statusId").value = statusId;

        document.getElementById("formSubmitButton").innerHTML =
            '<i class="fa-solid fa-check"></i> Save Changes';

        clearErrors();

        document.getElementById("vendorFormModal")
            .classList.add("active");
    }

    function openViewModal(
        id,
        vendorCode,
        companyName,
        contactName,
        email,
        phone,
        country,
        status,
        score
    ) {

        document.getElementById("viewVendorCode").value = vendorCode;
        document.getElementById("viewCompanyName").value = companyName;
        document.getElementById("viewContactName").value = contactName;
        document.getElementById("viewEmail").value = email;
        document.getElementById("viewPhone").value = phone;
        document.getElementById("viewCountry").value = country;
        document.getElementById("viewStatus").value = status;
        document.getElementById("viewScore").value = score + "%";

        document.getElementById("viewModal")
            .classList.add("active");
    }

    function openDeleteModal(id, companyName) {

        document.getElementById("deleteVendorId").value = id;
        document.getElementById("deleteVendorName").textContent =
            companyName;

        document.getElementById("deleteModal")
            .classList.add("active");
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove("active");
    }

    document.querySelectorAll(".modal-overlay").forEach(function(modal) {

        modal.addEventListener("click", function(event) {

            if (event.target === modal) {
                modal.classList.remove("active");
            }

        });

    });

    document.addEventListener("keydown", function(event) {

        if (event.key === "Escape") {

            document.querySelectorAll(".modal-overlay.active")
                .forEach(function(modal) {
                    modal.classList.remove("active");
                });

        }

    });

    function filterVendors() {

        const search =
            document.getElementById("vendorSearch")
                .value
                .toLowerCase()
                .trim();

        const status =
            document.getElementById("statusFilter")
                .value
                .toLowerCase();

        const rows =
            document.querySelectorAll(".vendor-row");

        rows.forEach(function(row) {

            const rowSearch =
                row.getAttribute("data-search") || "";

            const rowStatus =
                row.getAttribute("data-status") || "";

            const matchesSearch =
                search === "" || rowSearch.includes(search);

            const matchesStatus =
                status === "" || rowStatus === status;

            row.style.display =
                matchesSearch && matchesStatus
                    ? ""
                    : "none";
        });
    }

    function validateVendorForm() {

        clearErrors();

        let valid = true;

        const vendorCode =
            document.getElementById("vendorCode").value.trim();

        const companyName =
            document.getElementById("companyName").value.trim();

        const contactName =
            document.getElementById("contactName").value.trim();

        const email =
            document.getElementById("email").value.trim();

        const phone =
            document.getElementById("phone").value.trim();

        const score =
            parseFloat(
                document.getElementById("performanceScore").value
            );

        const country =
            document.getElementById("countryId").value;

        const status =
            document.getElementById("statusId").value;

        if (vendorCode === "") {
            showError("vendorCodeError");
            valid = false;
        }

        if (companyName === "") {
            showError("companyNameError");
            valid = false;
        }

        if (contactName === "") {
            valid = false;
        }

        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            valid = false;
        }

        if (!/^\d{10}$/.test(phone)) {
            showError("phoneError");
            valid = false;
        }

        if (isNaN(score) || score < 0 || score > 100) {
            alert("Performance score must be between 0 and 100.");
            valid = false;
        }

        if (country === "") {
            alert("Please select a country.");
            valid = false;
        }

        if (status === "") {
            alert("Please select a status.");
            valid = false;
        }

        return valid;
    }

    function showError(id) {
        document.getElementById(id).style.display = "block";
    }

    function clearErrors() {
        document.querySelectorAll(".field-error")
            .forEach(function(element) {
                element.style.display = "none";
            });
    }

    function js(value) {

        if (value === null || value === undefined) {
            return "";
        }

        return String(value)
            .replace(/\\/g, "\\\\")
            .replace(/'/g, "\\'")
            .replace(/"/g, "&quot;")
            .replace(/\\r?\\n/g, " ");
    }

    const phoneInput = document.getElementById("phone");

    if (phoneInput) {
        phoneInput.addEventListener("input", function () {
            this.value = this.value.replace(/\D/g, "").slice(0, 10);
        });
    }

    document.getElementById("globalSearch")
        .addEventListener("input", function() {

            const value = this.value.toLowerCase().trim();

            if (value === "") {
                document.getElementById("vendorSearch").value = "";
            } else {
                document.getElementById("vendorSearch").value = value;
            }

            filterVendors();
        });
</script>

</body>
</html>
