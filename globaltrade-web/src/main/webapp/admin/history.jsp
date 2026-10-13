<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>

<%@ page import="lk.sasindi.globaltrade.entity.StockMovement" %>
<%@ page import="lk.sasindi.globaltrade.entity.MovementType" %>
<%@ page import="lk.sasindi.globaltrade.entity.Reference" %>

<%

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

    List<StockMovement> stockMovements =
            (List<StockMovement>) request.getAttribute("stockMovements");

    List<MovementType> movementTypes =
            (List<MovementType>) request.getAttribute("movementTypes");

    List<Reference> references =
            (List<Reference>) request.getAttribute("references");


    if (stockMovements == null) {
        stockMovements = Collections.emptyList();
    }

    if (movementTypes == null) {
        movementTypes = Collections.emptyList();
    }

    if (references == null) {
        references = Collections.emptyList();
    }

    String error =
            (String) request.getAttribute("error");

    String success =
            (String) request.getAttribute("success");

    long totalMovements =
            stockMovements.size();

    long stockInCount =
            stockMovements.stream()
                    .filter(m ->
                            m.getMovementType() != null &&
                                    m.getMovementType().getType() != null &&
                                    (
                                            "IN".equalsIgnoreCase(
                                                    m.getMovementType().getType()
                                            )
                                                    ||
                                                    "STOCK IN".equalsIgnoreCase(
                                                            m.getMovementType().getType()
                                                    )
                                                    ||
                                                    "RECEIVED".equalsIgnoreCase(
                                                            m.getMovementType().getType()
                                                    )
                                    )
                    )
                    .count();


    long stockOutCount =
            stockMovements.stream()
                    .filter(m ->
                            m.getMovementType() != null &&
                                    m.getMovementType().getType() != null &&
                                    (
                                            "OUT".equalsIgnoreCase(
                                                    m.getMovementType().getType()
                                            )
                                                    ||
                                                    "STOCK OUT".equalsIgnoreCase(
                                                            m.getMovementType().getType()
                                                    )
                                                    ||
                                                    "ISSUED".equalsIgnoreCase(
                                                            m.getMovementType().getType()
                                                    )
                                    )
                    )
                    .count();


    long adjustmentCount =
            stockMovements.stream()
                    .filter(m ->
                            m.getMovementType() != null &&
                                    m.getMovementType().getType() != null &&
                                    (
                                            m.getMovementType()
                                                    .getType()
                                                    .toLowerCase()
                                                    .contains("adjust")
                                                    ||
                                                    m.getMovementType()
                                                            .getType()
                                                            .toLowerCase()
                                                            .contains("return")
                                    )
                    )
                    .count();

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

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Stock History | GlobalTrade</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;500;600;700&display=swap"
          rel="stylesheet">

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

            --purple: #7950f2;
            --purple-light: #f1edff;

            --text: #16324a;
            --muted: #718096;

            --border: #e3e9ef;

            --background: #FFF9E8;
            --card: #FFFFFF;

            --white: #ffffff;

            --sidebar-width: 250px;
            --topbar-height: 65px;
        }

        * {
            box-sizing: border-box;
        }


        html {
            scroll-behavior: smooth;
        }


        body {

            margin: 0;
            padding: 0;

            min-height: 100%;

            font-family:
                    "Segoe UI",
                    Arial,
                    sans-serif;

            background: var(--background);

            color: var(--text);

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
            border: 0;
        }

        .main {

            margin-left: var(--sidebar-width);

            min-height: 100vh;
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

        .stats-grid {

            display: grid;

            grid-template-columns:
                    repeat(4, 1fr);

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

            min-height: 74px;
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


        .stat-card.stock-in .stat-icon {

            background: var(--green-light);

            color: var(--green);
        }


        .stat-card.stock-out .stat-icon {

            background: var(--red-light);

            color: var(--red);
        }


        .stat-card.adjustment .stat-icon {

            background: var(--purple-light);

            color: var(--purple);
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

        .table-card {

            background: var(--card);

            border: 1px solid var(--border);

            border-radius: 11px;

            overflow: hidden;
        }

        .table-header {

            min-height: 70px;

            padding: 14px 17px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            border-bottom:
                    1px solid var(--border);
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

            flex-wrap: wrap;
        }


        .table-search {

            width: 225px;

            height: 35px;

            border:
                    1px solid var(--border);

            border-radius: 7px;

            display: flex;

            align-items: center;

            padding: 0 10px;

            background: #fafcfd;
        }


        .table-search:focus-within {

            border-color:
                    var(--yellow);

            box-shadow:
                    0 0 0 3px
                    rgba(252,191,73,.12);
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


        .table-search input::placeholder {

            color: #94A3B8;
        }


        .filter-select {

            height: 35px;

            border:
                    1px solid var(--border);

            border-radius: 7px;

            background: #fafcfd;

            padding: 0 9px;

            color: var(--text);

            outline: none;

            font-size: 9px;

            min-width: 125px;

            cursor: pointer;
        }


        .filter-select:focus {

            border-color:
                    var(--yellow);

            box-shadow:
                    0 0 0 3px
                    rgba(252,191,73,.12);
        }

        .table-wrap {

            width: 100%;

            overflow-x: auto;
        }


        table {

            width: 100%;

            border-collapse: collapse;

            min-width: 1100px;
        }


        thead th {

            height: 39px;

            padding: 0 14px;

            background: #f8fafb;

            color: #60758a;

            border-bottom:
                    1px solid var(--border);

            text-align: left;

            font-size: 8px;

            text-transform: uppercase;

            letter-spacing: .45px;

            font-weight: 700;

            white-space: nowrap;
        }


        tbody td {

            padding: 11px 14px;

            border-bottom:
                    1px solid #edf1f4;

            color: var(--text);

            font-size: 9px;

            vertical-align: middle;
        }


        tbody tr:last-child td {

            border-bottom: 0;
        }


        tbody tr:hover {

            background: #fffdf5;
        }


        .movement-id {

            color: var(--muted);

            font-size: 8px;

            font-weight: 600;
        }


        .movement-number {

            color: var(--navy);

            font-size: 9px;

            font-weight: 700;
        }

        .inventory-cell {

            display: flex;

            align-items: center;

            gap: 9px;
        }


        .inventory-icon {

            width: 34px;

            height: 34px;

            border-radius: 8px;

            background:
                    var(--yellow-light);

            color: var(--orange);

            display: flex;

            align-items: center;

            justify-content: center;

            flex-shrink: 0;

            font-size: 12px;
        }


        .inventory-name {

            color: var(--navy);

            font-size: 10px;

            font-weight: 700;

            white-space: nowrap;
        }


        .inventory-code {

            margin-top: 3px;

            color: var(--muted);

            font-size: 8px;
        }

        .quantity {

            font-size: 10px;

            font-weight: 700;
        }


        .quantity.increase {

            color: var(--green);
        }


        .quantity.decrease {

            color: var(--red);
        }


        .quantity.neutral {

            color: var(--navy);
        }


        .quantity-change {

            display: inline-flex;

            align-items: center;

            gap: 5px;
        }


        .quantity-arrow {

            font-size: 8px;
        }

        .stock-level {

            display: flex;

            align-items: center;

            gap: 7px;
        }


        .stock-number {

            color: var(--navy);

            font-size: 9px;

            font-weight: 700;

            min-width: 25px;
        }


        .stock-arrow {

            color: #9aa8b5;

            font-size: 8px;
        }

        .movement-badge {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            padding: 5px 8px;

            border-radius: 20px;

            font-size: 8px;

            font-weight: 700;

            white-space: nowrap;
        }


        .movement-badge.in {

            background:
                    var(--green-light);

            color: var(--green);
        }


        .movement-badge.out {

            background:
                    var(--red-light);

            color: var(--red);
        }


        .movement-badge.adjustment {

            background:
                    var(--purple-light);

            color: var(--purple);
        }


        .movement-badge.other {

            background:
                    var(--yellow-light);

            color: var(--orange);
        }


        .movement-dot {

            width: 5px;

            height: 5px;

            border-radius: 50%;

            background: currentColor;
        }

        .reference-badge {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            padding: 5px 8px;

            border-radius: 6px;

            background: #f4f7f9;

            color: #566b7c;

            font-size: 8px;

            font-weight: 600;

            white-space: nowrap;
        }


        .reference-badge i {

            color: var(--orange);

            font-size: 8px;
        }

        .user-cell {

            display: flex;

            align-items: center;

            gap: 7px;
        }


        .user-avatar {

            width: 28px;

            height: 28px;

            border-radius: 50%;

            background: #FFF3CD;

            color: var(--orange);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 9px;

            font-weight: 700;

            flex-shrink: 0;
        }


        .user-name {

            color: var(--navy);

            font-size: 9px;

            font-weight: 600;

            white-space: nowrap;
        }

        .date-cell {

            color: var(--text);

            font-size: 9px;

            white-space: nowrap;
        }


        .date-cell .date {

            font-weight: 600;
        }


        .date-cell .time {

            margin-top: 3px;

            color: var(--muted);

            font-size: 8px;
        }

        .reason-cell {

            max-width: 180px;

            color: var(--muted);

            font-size: 8px;

            line-height: 1.45;
        }


        .reason-empty {

            color: #a8b4be;

            font-style: italic;
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

            transition: .18s ease;
        }


        .view-btn {

            background:
                    var(--yellow-light);

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

        .modal-overlay {

            position: fixed;

            inset: 0;

            background:
                    rgba(0,48,73,.48);

            display: none;

            align-items: center;

            justify-content: center;

            padding: 20px;

            z-index: 10000;
        }


        .modal-overlay.active {

            display: flex;
        }


        .history-modal {

            width: 100%;

            max-width: 620px;

            max-height: 90vh;

            overflow-y: auto;

            background: #fff;

            border-radius: 12px;

            box-shadow:
                    0 24px 60px
                    rgba(0,0,0,.22);
        }


        .modal-header {

            min-height: 62px;

            padding: 12px 17px;

            border-bottom:
                    1px solid var(--border);

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

            background:
                    var(--yellow-light);

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

            background:
                    var(--red-light);

            color: var(--red);
        }


        .modal-body {

            padding: 18px;
        }

        .detail-grid {

            display: grid;

            grid-template-columns:
                    1fr 1fr;

            gap: 13px;
        }


        .detail-group {

            min-width: 0;
        }


        .detail-group.full {

            grid-column: 1 / -1;
        }


        .detail-label {

            display: block;

            margin-bottom: 6px;

            color: #617487;

            font-size: 9px;

            font-weight: 700;
        }


        .detail-value {

            width: 100%;

            min-height: 38px;

            padding: 10px;

            border:
                    1px solid var(--border);

            border-radius: 7px;

            background: #fffdf7;

            color: var(--navy);

            font-size: 10px;

            display: flex;

            align-items: center;

        }


        .detail-value.reason {

            display: block;

            line-height: 1.5;

            min-height: 60px;
        }


        .modal-footer {

            padding: 12px 17px;

            border-top:
                    1px solid var(--border);

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

        @media (max-width: 1100px) {

            .stats-grid {

                grid-template-columns:
                        repeat(2, 1fr);
            }

            .table-tools {

                justify-content: flex-end;
            }
        }


        @media (max-width: 760px) {

            .sidebar {

                transform:
                        translateX(-100%);

                transition: .2s ease;
            }


            .sidebar.open {

                transform:
                        translateX(0);
            }


            .main {

                margin-left: 0;
            }


            .content {

                padding:
                        18px 14px;
            }


            .page-heading {

                flex-direction: column;

                align-items:
                        flex-start;
            }


            .stats-grid {

                grid-template-columns:
                        1fr;
            }


            .table-header {

                align-items:
                        flex-start;

                flex-direction:
                        column;
            }


            .table-tools {

                width: 100%;

                justify-content:
                        stretch;
            }


            .table-search {

                flex: 1;

                width: auto;
            }


            .filter-select {

                min-width: 115px;
            }


            .detail-grid {

                grid-template-columns:
                        1fr;
            }


            .detail-group.full {

                grid-column:
                        auto;
            }
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
    </style>

</head>


<body>

<jsp:include page="admin-sidebar.jsp"/>


<main class="main">

    <jsp:include page="admin-topbar.jsp"/>


    <section class="content">

        <div class="page-heading">

            <div>

                <h1>Stock History</h1>

                <p>
                    Track inventory quantity changes, movement types,
                    references and responsible users.
                </p>

            </div>

        </div>

        <% if (success != null &&
                !success.isBlank()) { %>

        <div class="alert alert-success">

            <i class="fa-solid fa-circle-check"></i>

            <span>
                <%= success %>
            </span>

        </div>

        <% } %>


        <% if (error != null &&
                !error.isBlank()) { %>

        <div class="alert alert-error">

            <i class="fa-solid fa-circle-exclamation"></i>

            <span>
                <%= error %>
            </span>

        </div>

        <% } %>

        <div class="stats-grid">

            <div class="stat-card">

                <div>

                    <div class="stat-label">
                        Total Movements
                    </div>

                    <div class="stat-value">
                        <%= totalMovements %>
                    </div>

                </div>

                <div class="stat-icon">

                    <i class="fa-solid fa-clock-rotate-left"></i>

                </div>

            </div>

            <div class="stat-card stock-in">

                <div>

                    <div class="stat-label">
                        Stock In
                    </div>

                    <div class="stat-value">
                        <%= stockInCount %>
                    </div>

                </div>

                <div class="stat-icon">

                    <i class="fa-solid fa-arrow-down"></i>

                </div>

            </div>

            <div class="stat-card stock-out">

                <div>

                    <div class="stat-label">
                        Stock Out
                    </div>

                    <div class="stat-value">
                        <%= stockOutCount %>
                    </div>

                </div>

                <div class="stat-icon">

                    <i class="fa-solid fa-arrow-up"></i>

                </div>

            </div>

            <div class="stat-card adjustment">

                <div>

                    <div class="stat-label">
                        Adjustments / Returns
                    </div>

                    <div class="stat-value">
                        <%= adjustmentCount %>
                    </div>

                </div>

                <div class="stat-icon">

                    <i class="fa-solid fa-sliders"></i>

                </div>

            </div>


        </div>

        <div class="table-card">

            <div class="table-header">


                <div class="table-title">

                    <h2>
                        Inventory Movement Records
                    </h2>

                    <p>
                        Complete history of stock quantity changes.
                    </p>

                </div>


                <div class="table-tools">

                    <div class="table-search">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input
                                type="text"
                                id="historySearch"
                                placeholder="Search inventory, user, reference..."
                                oninput="filterHistory()">

                    </div>

                    <select
                            id="movementTypeFilter"
                            class="filter-select"
                            onchange="filterHistory()">

                        <option value="">
                            All Movement Types
                        </option>

                        <% for (MovementType movementType :
                                movementTypes) { %>

                        <option
                                value="<%= js(movementType.getType()) %>">

                            <%= movementType.getType() %>

                        </option>

                        <% } %>

                    </select>

                    <select
                            id="referenceFilter"
                            class="filter-select"
                            onchange="filterHistory()">

                        <option value="">
                            All References
                        </option>

                        <% for (Reference reference :
                                references) { %>

                        <option
                                value="<%= js(reference.getType()) %>">

                            <%= reference.getType() %>

                        </option>

                        <% } %>

                    </select>


                </div>

            </div>

            <div class="table-wrap">


                <table id="historyTable">


                    <thead>

                    <tr>

                        <th>
                            ID
                        </th>

                        <th>
                            Inventory
                        </th>

                        <th>
                            Movement
                        </th>

                        <th>
                            Quantity
                        </th>

                        <th>
                            Stock Level
                        </th>

                        <th>
                            Reference
                        </th>

                        <th>
                            User
                        </th>

                        <th>
                            Reason
                        </th>

                        <th>
                            Date & Time
                        </th>

                        <th>
                            Action
                        </th>

                    </tr>

                    </thead>


                    <tbody id="historyTableBody">


                    <% if (stockMovements.isEmpty()) { %>


                    <tr>

                        <td colspan="10">

                            <div class="empty-state">

                                <i class="fa-solid fa-clock-rotate-left"></i>

                                <h3>
                                    No stock history found
                                </h3>

                                <p>
                                    Inventory movement records will
                                    appear here when stock changes occur.
                                </p>

                            </div>

                        </td>

                    </tr>


                    <% } else { %>


                    <% for (StockMovement movement :
                            stockMovements) {

                        String productName =
                                movement.getInventory() != null &&
                                        movement.getInventory().getProductName() != null
                                        ? movement.getInventory().getProductName()
                                        : "Unknown Product";


                        String productCode =
                                movement.getInventory() != null &&
                                        movement.getInventory().getProductCode() != null
                                        ? movement.getInventory().getProductCode()
                                        : "-";

                        String movementType =
                                movement.getMovementType() != null &&
                                        movement.getMovementType().getType() != null
                                        ? movement.getMovementType().getType()
                                        : "Unknown";


                        String movementTypeLower =
                                movementType.toLowerCase();


                        boolean isIn =
                                movementTypeLower.contains("in") ||
                                        movementTypeLower.contains("receive") ||
                                        movementTypeLower.contains("add");


                        boolean isOut =
                                movementTypeLower.contains("out") ||
                                        movementTypeLower.contains("issue") ||
                                        movementTypeLower.contains("remove") ||
                                        movementTypeLower.contains("dispatch");


                        boolean isAdjustment =
                                movementTypeLower.contains("adjust") ||
                                        movementTypeLower.contains("return");


                        String movementClass =
                                isIn
                                        ? "in"
                                        : isOut
                                        ? "out"
                                        : isAdjustment
                                        ? "adjustment"
                                        : "other";


                        String movementIcon =
                                isIn
                                        ? "fa-arrow-down"
                                        : isOut
                                        ? "fa-arrow-up"
                                        : isAdjustment
                                        ? "fa-sliders"
                                        : "fa-right-left";


                        int qty =
                                movement.getQty();


                        int previousQty =
                                movement.getPreviousQty();


                        int newQty =
                                movement.getNewQty();


                        String quantityClass =
                                newQty > previousQty
                                        ? "increase"
                                        : newQty < previousQty
                                        ? "decrease"
                                        : "neutral";


                        String quantityIcon =
                                newQty > previousQty
                                        ? "fa-plus"
                                        : newQty < previousQty
                                        ? "fa-minus"
                                        : "fa-equals";


                        String referenceType =
                                movement.getReference() != null &&
                                        movement.getReference().getType() != null
                                        ? movement.getReference().getType()
                                        : "Unknown";


                        String userName = "System";


                        if (movement.getUser() != null) {

                            String firstName =
                                    movement.getUser().getFirstName();

                            String lastName =
                                    movement.getUser().getLastName();

                            String username =
                                    movement.getUser().getUsername();


                            if (firstName != null &&
                                    !firstName.isBlank()) {

                                userName =
                                        firstName +
                                                (
                                                        lastName != null &&
                                                                !lastName.isBlank()
                                                                ? " " + lastName
                                                                : ""
                                                );

                            } else if (username != null &&
                                    !username.isBlank()) {

                                userName = username;
                            }
                        }


                        String userInitial =
                                userName.substring(0, 1)
                                        .toUpperCase();


                        String created =
                                movement.getCreatedAt() != null
                                        ? movement.getCreatedAt()
                                        .toString()
                                        .replace("T", " ")
                                        : "-";


                        String datePart = created;

                        String timePart = "";


                        if (created.contains(" ")) {

                            int spaceIndex =
                                    created.indexOf(" ");

                            datePart =
                                    created.substring(
                                            0,
                                            spaceIndex
                                    );

                            timePart =
                                    created.substring(
                                            spaceIndex + 1
                                    );
                        }

                        String reason =
                                movement.getReason() != null &&
                                        !movement.getReason().isBlank()
                                        ? movement.getReason()
                                        : "";


                    %>


                    <tr class="history-row"


                        data-search="<%= js(
                                productName + " " +
                                productCode + " " +
                                movementType + " " +
                                referenceType + " " +
                                userName + " " +
                                reason
                        ).toLowerCase() %>"


                        data-movement-type="<%= js(
                                movementType
                        ).toLowerCase() %>"


                        data-reference="<%= js(
                                referenceType
                        ).toLowerCase() %>">

                        <td>

                            <div class="movement-id">
                                #<%= movement.getId() %>
                            </div>

                        </td>

                        <td>

                            <div class="inventory-cell">

                                <div class="inventory-icon">

                                    <i class="fa-solid fa-boxes-stacked"></i>

                                </div>


                                <div>

                                    <div class="inventory-name">

                                        <%= productName %>

                                    </div>

                                    <div class="inventory-code">

                                        <%= productCode %>

                                    </div>

                                </div>

                            </div>

                        </td>

                        <td>

                            <span class="movement-badge <%= movementClass %>">

                                <span class="movement-dot"></span>

                                <i class="fa-solid <%= movementIcon %>"></i>

                                <%= movementType %>

                            </span>

                        </td>

                        <td>

                            <div class="quantity-change">

                                <span class="quantity <%= quantityClass %>">

                                    <%= qty %>

                                </span>

                                <i class="fa-solid <%= quantityIcon %>
                                          quantity-arrow"></i>

                            </div>

                        </td>

                        <td>

                            <div class="stock-level">

                                <span class="stock-number">
                                    <%= previousQty %>
                                </span>

                                <i class="fa-solid fa-arrow-right
                                          stock-arrow"></i>

                                <span class="stock-number">
                                    <%= newQty %>
                                </span>

                            </div>

                        </td>

                        <td>

                            <span class="reference-badge">

                                <i class="fa-solid fa-link"></i>

                                <%= referenceType %>

                            </span>

                        </td>

                        <td>

                            <div class="user-cell">

                                <div class="user-avatar">

                                    <%= userInitial %>

                                </div>

                                <div class="user-name">

                                    <%= userName %>

                                </div>

                            </div>

                        </td>

                        <td>

                            <% if (reason.isBlank()) { %>

                            <div class="reason-cell reason-empty">
                                No reason provided
                            </div>

                            <% } else { %>

                            <div class="reason-cell"
                                 title="<%= js(reason) %>">

                                <%= reason %>

                            </div>

                            <% } %>

                        </td>

                        <td>

                            <div class="date-cell">

                                <div class="date">
                                    <%= datePart %>
                                </div>

                                <% if (!timePart.isBlank()) { %>

                                <div class="time">
                                    <%= timePart %>
                                </div>

                                <% } %>

                            </div>

                        </td>

                        <td>

                            <div class="action-group">

                                <button
                                        type="button"
                                        class="action-btn view-btn"
                                        title="View Movement"
                                        onclick="openHistoryModal(
                                                '<%= movement.getId() %>',
                                                '<%= js(productName) %>',
                                                '<%= js(productCode) %>',
                                                '<%= js(movementType) %>',
                                                '<%= qty %>',
                                                '<%= previousQty %>',
                                                '<%= newQty %>',
                                                '<%= js(referenceType) %>',
                                                '<%= js(userName) %>',
                                                '<%= js(reason) %>',
                                                '<%= js(created) %>'
                                                )">

                                    <i class="fa-solid fa-eye"></i>

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

            <span>
                © 2026 GlobalTrade Logistics System.
                All rights reserved.
            </span>

            <span>
                Administrator Portal • Version 1.0.0
            </span>

        </div>


    </section>

</main>


<div class="modal-overlay"
     id="historyViewModal">


    <div class="history-modal">

        <div class="modal-header">


            <div class="modal-heading">


                <div class="modal-icon">

                    <i class="fa-solid fa-clock-rotate-left"></i>

                </div>


                <div>

                    <h2>
                        Movement Details
                    </h2>

                    <p>
                        View inventory movement information
                    </p>

                </div>


            </div>


            <button
                    type="button"
                    class="close-modal"
                    onclick="closeHistoryModal()">

                <i class="fa-solid fa-xmark"></i>

            </button>


        </div>


        <div class="modal-body">


            <div class="detail-grid">

                <div class="detail-group">

                    <span class="detail-label">
                        Movement ID
                    </span>

                    <div class="detail-value"
                         id="viewMovementId">
                    </div>

                </div>

                <div class="detail-group">

                    <span class="detail-label">
                        Movement Type
                    </span>

                    <div class="detail-value"
                         id="viewMovementType">
                    </div>

                </div>

                <div class="detail-group">

                    <span class="detail-label">
                        Product
                    </span>

                    <div class="detail-value"
                         id="viewProductName">
                    </div>

                </div>

                <div class="detail-group">

                    <span class="detail-label">
                        Product Code
                    </span>

                    <div class="detail-value"
                         id="viewProductCode">
                    </div>

                </div>

                <div class="detail-group">

                    <span class="detail-label">
                        Movement Quantity
                    </span>

                    <div class="detail-value"
                         id="viewQuantity">
                    </div>

                </div>

                <div class="detail-group">

                    <span class="detail-label">
                        Previous Quantity
                    </span>

                    <div class="detail-value"
                         id="viewPreviousQty">
                    </div>

                </div>

                <div class="detail-group">

                    <span class="detail-label">
                        New Quantity
                    </span>

                    <div class="detail-value"
                         id="viewNewQty">
                    </div>

                </div>

                <div class="detail-group">

                    <span class="detail-label">
                        Reference
                    </span>

                    <div class="detail-value"
                         id="viewReference">
                    </div>

                </div>

                <div class="detail-group">

                    <span class="detail-label">
                        Performed By
                    </span>

                    <div class="detail-value"
                         id="viewUser">
                    </div>

                </div>

                <div class="detail-group">

                    <span class="detail-label">
                        Created At
                    </span>

                    <div class="detail-value"
                         id="viewCreatedAt">
                    </div>

                </div>

                <div class="detail-group full">

                    <span class="detail-label">
                        Reason
                    </span>

                    <div class="detail-value reason"
                         id="viewReason">
                    </div>

                </div>


            </div>


        </div>

        <div class="modal-footer">

            <button
                    type="button"
                    class="btn-secondary"
                    onclick="closeHistoryModal()">

                Close

            </button>

        </div>


    </div>

</div>



<script>

    function toggleSidebar() {

        const sidebar =
            document.querySelector(".sidebar");

        if (sidebar) {

            sidebar.classList.toggle("open");
        }
    }

    function filterHistory() {


        const searchInput =
            document.getElementById(
                "historySearch"
            );


        const movementTypeInput =
            document.getElementById(
                "movementTypeFilter"
            );


        const referenceInput =
            document.getElementById(
                "referenceFilter"
            );


        const search =
            searchInput.value
                .toLowerCase()
                .trim();


        const movementType =
            movementTypeInput.value
                .toLowerCase()
                .trim();


        const reference =
            referenceInput.value
                .toLowerCase()
                .trim();


        const rows =
            document.querySelectorAll(
                ".history-row"
            );


        rows.forEach(function(row) {


            const rowSearch =
                row.getAttribute(
                    "data-search"
                ) || "";


            const rowMovementType =
                row.getAttribute(
                    "data-movement-type"
                ) || "";


            const rowReference =
                row.getAttribute(
                    "data-reference"
                ) || "";


            const matchesSearch =
                search === "" ||
                rowSearch.includes(search);


            const matchesMovementType =
                movementType === "" ||
                rowMovementType === movementType;


            const matchesReference =
                reference === "" ||
                rowReference === reference;


            row.style.display =
                matchesSearch &&
                matchesMovementType &&
                matchesReference
                    ? ""
                    : "none";

        });

    }


    const globalSearch =
        document.getElementById(
            "globalSearch"
        );


    if (globalSearch) {


        globalSearch.addEventListener(
            "input",
            function () {


                const value =
                    this.value
                        .toLowerCase()
                        .trim();


                const historySearch =
                    document.getElementById(
                        "historySearch"
                    );


                if (historySearch) {

                    historySearch.value =
                        value;
                }


                filterHistory();

            }
        );

    }

    function openHistoryModal(
        id,
        productName,
        productCode,
        movementType,
        quantity,
        previousQty,
        newQty,
        reference,
        user,
        reason,
        createdAt
    ) {


        document.getElementById(
            "viewMovementId"
        ).textContent =
            "#" + id;


        document.getElementById(
            "viewProductName"
        ).textContent =
            productName;


        document.getElementById(
            "viewProductCode"
        ).textContent =
            productCode;


        document.getElementById(
            "viewMovementType"
        ).textContent =
            movementType;


        document.getElementById(
            "viewQuantity"
        ).textContent =
            quantity;


        document.getElementById(
            "viewPreviousQty"
        ).textContent =
            previousQty;


        document.getElementById(
            "viewNewQty"
        ).textContent =
            newQty;


        document.getElementById(
            "viewReference"
        ).textContent =
            reference;


        document.getElementById(
            "viewUser"
        ).textContent =
            user;


        document.getElementById(
            "viewReason"
        ).textContent =
            reason === ""
                ? "No reason provided"
                : reason;


        document.getElementById(
            "viewCreatedAt"
        ).textContent =
            createdAt;


        document.getElementById(
            "historyViewModal"
        ).classList.add("active");

    }


    function closeHistoryModal() {

        document.getElementById(
            "historyViewModal"
        ).classList.remove("active");
    }

    const historyModal =
        document.getElementById(
            "historyViewModal"
        );


    if (historyModal) {


        historyModal.addEventListener(
            "click",
            function (event) {


                if (event.target === historyModal) {

                    closeHistoryModal();
                }

            }
        );

    }

    document.addEventListener(
        "keydown",
        function (event) {


            if (event.key === "Escape") {

                const modal =
                    document.getElementById(
                        "historyViewModal"
                    );


                if (modal &&
                    modal.classList.contains(
                        "active"
                    )) {

                    closeHistoryModal();
                }

            }

        }
    );


</script>


</body>

</html>

