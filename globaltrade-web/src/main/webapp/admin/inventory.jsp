<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.sasindi.globaltrade.entity.Inventory" %>
<%@ page import="lk.sasindi.globaltrade.entity.Vendor" %>
<%@ page import="lk.sasindi.globaltrade.entity.Warehouse" %>

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


    List<Inventory> inventoryList =
            (List<Inventory>) request.getAttribute("inventoryList");

    List<Vendor> vendorList =
            (List<Vendor>) request.getAttribute("vendorList");

    List<Warehouse> warehouseList =
            (List<Warehouse>) request.getAttribute("warehouseList");

    if (inventoryList == null) {
        inventoryList = new java.util.ArrayList<>();
    }

    if (vendorList == null) {
        vendorList = new java.util.ArrayList<>();
    }

    if (warehouseList == null) {
        warehouseList = new java.util.ArrayList<>();
    }



    int totalItems = inventoryList.size();
    int lowStock = 0;
    int outOfStock = 0;
    int totalQuantity = 0;

    for (Inventory inventory : inventoryList) {

        Integer quantity = inventory.getQuantity();
        Integer reorderLevel = inventory.getReorderLevel();

        if (quantity != null) {
            totalQuantity += quantity;
        }

        if (quantity != null && quantity == 0) {
            outOfStock++;
        }
        else if (
                quantity != null &&
                        reorderLevel != null &&
                        quantity <= reorderLevel
        ) {
            lowStock++;
        }
    }



    String success =
            request.getParameter("success");

    String error =
            request.getParameter("error");

%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Inventory | GlobalTrade</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
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

            padding: 13px 16px;

            border-bottom:
                    1px solid rgba(0,48,73,.06);

            display: grid;

            grid-template-columns:
                    1.4fr .8fr .8fr auto;

            gap: 9px;

            background: #FFFDF7;
        }


        .filter-input,
        .filter-select {

            height: 35px;

            border:
                    1px solid var(--border);

            border-radius: 7px;

            background: white;

            color: var(--navy);

            font-size: 10px;

            padding: 0 10px;

            outline: none;

            width: 100%;
        }


        .filter-input:focus,
        .filter-select:focus {

            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252,191,73,.10);
        }

        .table-wrapper {

            width: 100%;

            overflow-x: auto;
        }


        .shipment-table {

            width: 100%;

            border-collapse: collapse;

            min-width: 950px;
        }


        .shipment-table thead {

            background: #FFF9E8;
        }


        .shipment-table th {

            padding: 12px 14px;

            text-align: left;

            color: var(--muted);

            font-size: 9px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: .3px;

            border-bottom:
                    1px solid var(--border);

            white-space: nowrap;
        }


        .shipment-table td {

            padding: 13px 14px;

            color: var(--navy);

            font-size: 10px;

            border-bottom:
                    1px solid rgba(0,48,73,.06);

            vertical-align: middle;
        }


        .shipment-table tbody tr {

            transition: .15s ease;
        }


        .shipment-table tbody tr:hover {

            background: #FFFDF5;
        }


        .shipment-table tbody tr:last-child td {

            border-bottom: none;
        }

        .tracking-number {

            color: var(--orange);

            font-weight: 700;

            font-size: 10px;
        }


        .shipment-id {

            display: block;

            color: var(--muted);

            font-size: 8px;

            margin-top: 3px;
        }

        .location {

            display: flex;

            align-items: center;

            gap: 7px;
        }


        .location i {

            color: var(--orange);

            font-size: 10px;
        }


        .destination-icon {

            color: var(--red) !important;
        }

        .vendor-name {

            font-weight: 700;

            color: var(--navy);

            display: block;
        }


        .vendor-code {

            color: var(--muted);

            font-size: 8px;

            margin-top: 3px;

            display: block;
        }

        .status-badge {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            padding: 5px 8px;

            border-radius: 5px;

            font-size: 8px;

            font-weight: 700;

            white-space: nowrap;
        }


        .status-badge::before {

            content: "";

            width: 6px;
            height: 6px;

            border-radius: 50%;

            flex-shrink: 0;
        }


        .status-pending {

            background: rgba(252,191,73,.20);

            color: #946200;
        }


        .status-pending::before {

            background: var(--yellow);
        }


        .status-transit {

            background: rgba(37,99,235,.10);

            color: var(--blue);
        }


        .status-transit::before {

            background: var(--blue);
        }


        .status-delivered {

            background: rgba(40,167,69,.10);

            color: var(--green);
        }


        .status-delivered::before {

            background: var(--green);
        }


        .status-cancelled {

            background: rgba(214,40,40,.10);

            color: var(--red);
        }


        .status-cancelled::before {

            background: var(--red);
        }

        .date-main {

            font-weight: 600;

            display: block;
        }


        .date-time {

            color: var(--muted);

            font-size: 8px;

            display: block;

            margin-top: 3px;
        }

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

            background: white;

            color: var(--navy);

            display: flex;

            align-items: center;
            justify-content: center;

            cursor: pointer;

            transition: .2s ease;
        }


        .action-btn:hover {

            border-color: var(--yellow);

            color: var(--orange);

            background: #FFFDF5;
        }


        .action-btn.delete:hover {

            border-color: rgba(214,40,40,.25);

            color: var(--red);

            background: rgba(214,40,40,.04);
        }

        .empty-state {

            padding: 55px 20px;

            text-align: center;

            display: none;
        }


        .empty-state i {

            font-size: 35px;

            color: #CBD5E1;

            margin-bottom: 12px;
        }


        .empty-state h3 {

            color: var(--navy);

            font-size: 14px;

            margin-bottom: 5px;
        }


        .empty-state p {

            color: var(--muted);

            font-size: 10px;
        }

        .table-footer {

            min-height: 55px;

            padding: 10px 16px;

            border-top:
                    1px solid rgba(0,48,73,.06);

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 10px;
        }


        .table-info {

            color: var(--muted);

            font-size: 9px;
        }


        .pagination {

            display: flex;

            gap: 4px;
        }


        .page-btn {

            width: 29px;
            height: 29px;

            border:
                    1px solid var(--border);

            border-radius: 6px;

            background: white;

            color: var(--navy);

            font-size: 9px;

            cursor: pointer;
        }


        .page-btn:hover {

            border-color: var(--yellow);
        }


        .page-btn.active {

            background: var(--orange);

            border-color: var(--orange);

            color: white;
        }

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

        .modal-overlay.active {
            display: flex;
        }


        .shipment-modal {

            width: 100%;

            max-width: 720px;

            max-height: 90vh;

            overflow-y: auto;

            background: white;

            border-radius: 12px;

            box-shadow:
                    0 20px 50px rgba(0,0,0,.18);
        }


        .modal-header {

            min-height: 58px;

            padding: 0 18px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            border-bottom:
                    1px solid var(--border);
        }


        .modal-header h2 {

            color: var(--navy);

            font-size: 15px;
        }


        .modal-close {

            width: 30px;
            height: 30px;

            border: none;

            background: transparent;

            color: var(--muted);

            cursor: pointer;

            font-size: 15px;
        }


        .modal-close:hover {

            color: var(--red);
        }


        .modal-body {

            padding: 18px;
        }


        .form-grid {

            display: grid;

            grid-template-columns:
                    1fr 1fr;

            gap: 14px;
        }


        .form-group.full {

            grid-column: 1 / -1;
        }


        .form-label {

            display: block;

            color: var(--muted);

            font-size: 9px;

            font-weight: 600;

            margin-bottom: 6px;
        }


        .form-input,
        .form-select {

            width: 100%;

            height: 38px;

            padding: 0 11px;

            border:
                    1px solid var(--border);

            border-radius: 7px;

            background: #FFFDF7;

            color: var(--navy);

            font-size: 10px;

            outline: none;
        }


        .form-input:focus,
        .form-select:focus {

            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252,191,73,.10);
        }


        .modal-footer {

            padding: 12px 18px;

            display: flex;

            justify-content: flex-end;

            gap: 8px;

            border-top:
                    1px solid var(--border);
        }

        .success-toast,
        .error-toast {

            position: fixed;

            top: 85px;

            right: 25px;

            min-width: 300px;

            padding: 14px 16px;

            background: white;

            border-radius: 9px;

            box-shadow:
                    0 8px 25px rgba(0,0,0,.12);

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

            color: var(--navy);
        }


        .error-toast {

            border:
                    1px solid rgba(214,40,40,.20);

            border-left:
                    4px solid var(--red);

            color: var(--navy);
        }


        .success-toast > i {

            color: var(--green);
        }


        .error-toast > i {

            color: var(--red);
        }


        .toast-close {

            margin-left: auto;

            width: 24px;
            height: 24px;

            border: none;

            background: transparent;

            color: var(--muted);

            cursor: pointer;
        }

        .footer {

            margin-top: 14px;

            padding: 11px 0 2px;

            border-top:
                    1px solid var(--border);

            display: flex;

            justify-content: space-between;

            color: var(--muted);

            font-size: 9px;
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



        .page-heading .btn { white-space: nowrap; }
        .inventory-table { width:100%; border-collapse:collapse; min-width:1100px; }
        .inventory-table th { text-align:left; padding:12px 14px; font-size:9px; text-transform:uppercase; letter-spacing:.4px; color:#64748B; font-weight:700; border-bottom:1px solid var(--border); white-space:nowrap; }
        .inventory-table td { padding:13px 14px; font-size:10px; border-bottom:1px solid rgba(0,48,73,.06); vertical-align:middle; color:#334155; }
        .inventory-table tbody tr:hover { background:#FFFDF7; }
        .product-info { display:flex; align-items:center; gap:9px; }
        .product-icon { width:34px;height:34px;border-radius:8px;background:#FFF3CD;color:var(--orange);display:flex;align-items:center;justify-content:center;flex-shrink:0; }
        .product-name { font-size:10px;font-weight:700;color:var(--navy);margin-bottom:3px; }
        .product-code { font-size:8px;color:var(--muted); }
        .quantity { font-size:12px;font-weight:800; }
        .quantity-normal { color:var(--green); }.quantity-low{color:#D97706}.quantity-out{color:var(--red)}
        .stock-badge {display:inline-flex;align-items:center;gap:5px;padding:4px 8px;border-radius:20px;font-size:8px;font-weight:700}
        .stock-good{color:var(--green);background:#EAF7EE}.stock-low{color:#D97706;background:#FFF8E7}.stock-out{color:var(--red);background:#FEF0F0}
        .action-buttons {display:flex;gap:5px}
        .action-btn {width:28px;height:28px;border:1px solid var(--border);background:white;border-radius:6px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:10px}
        .action-edit{color:var(--blue)}.action-edit:hover{background:#EEF4FF}.action-stock{color:var(--green)}.action-stock:hover{background:#EAF7EE}.action-delete{color:var(--red)}.action-delete:hover{background:#FEF0F0}
        .empty-state{text-align:center;padding:55px 20px;color:var(--muted)}.empty-state i{font-size:30px;color:#CBD5E1;margin-bottom:10px}.empty-state h3{font-size:13px;color:var(--navy);margin-bottom:4px}.empty-state p{font-size:9px}
        .selector-field{display:flex;width:100%;height:38px;border:1px solid var(--border);border-radius:7px;background:#FFFDF7;overflow:hidden}
        .selector-display{flex:1;min-width:0;border:none;outline:none;background:transparent;color:var(--navy);padding:0 11px;font-size:10px;display:flex;align-items:center;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
        .selector-display.placeholder{color:#94A3B8}
        .selector-button{width:75px;border:none;border-left:1px solid var(--border);background:#FFF9E8;color:var(--orange);font-size:9px;font-weight:700;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:5px}
        .selector-button:hover{background:var(--yellow);color:var(--navy)}
        .selection-overlay{position:fixed;inset:0;background:rgba(0,48,73,.50);display:none;align-items:center;justify-content:center;padding:20px;z-index:11000}
        .selection-overlay.show{display:flex}
        .selection-modal{width:100%;max-width:680px;max-height:85vh;background:white;border-radius:12px;overflow:hidden;box-shadow:0 20px 60px rgba(0,0,0,.22);display:flex;flex-direction:column}
        .selection-modal-header{min-height:58px;padding:0 18px;display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid var(--border)}
        .selection-modal-header h2{color:var(--navy);font-size:15px;display:flex;align-items:center;gap:8px}.selection-modal-header h2 i{color:var(--orange)}
        .selection-close{width:30px;height:30px;border:none;background:transparent;color:var(--muted);cursor:pointer;font-size:15px;border-radius:5px}.selection-close:hover{background:#FFF3CD;color:var(--red)}
        .selection-search-area{padding:12px 16px;border-bottom:1px solid rgba(0,48,73,.06);background:#FFFDF7}
        .selection-search-wrapper{position:relative}.selection-search-wrapper i{position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--muted);font-size:11px}
        .selection-search{width:100%;height:36px;border:1px solid var(--border);border-radius:7px;background:white;outline:none;padding:0 11px 0 35px;color:var(--navy);font-size:10px}.selection-search:focus{border-color:var(--yellow);box-shadow:0 0 0 3px rgba(252,191,73,.10)}
        .selection-content{overflow-y:auto;padding:8px 12px;min-height:150px}.selection-item{width:100%;min-height:64px;padding:10px 8px;border-bottom:1px solid rgba(0,48,73,.06);display:flex;align-items:center;justify-content:space-between;gap:12px}.selection-item:hover{background:#FFFDF7}.selection-item-info{min-width:0;flex:1}.selection-item-title{display:block;color:var(--navy);font-size:10px;font-weight:700;margin-bottom:4px}.selection-item-subtitle{display:block;color:var(--muted);font-size:8px;line-height:1.5}.selection-item-button{height:30px;padding:0 11px;border:1px solid #F8E4A9;border-radius:6px;background:#FFF9E8;color:var(--orange);font-size:8px;font-weight:700;cursor:pointer}.selection-item-button:hover{background:var(--orange);border-color:var(--orange);color:white}.selection-empty{padding:45px 20px;text-align:center;color:var(--muted)}.selection-empty i{font-size:28px;color:#CBD5E1;margin-bottom:10px}.selection-empty h3{color:var(--navy);font-size:12px;margin-bottom:4px}.selection-empty p{font-size:9px}
        .modal-overlay{background:rgba(0,48,73,.45)}

        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 48, 73, 0.45);
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
            z-index: 9999;
        }

        .modal-overlay.active {
            display: flex;
        }

        .inventory-modal {
            width: 100%;
            max-width: 650px;
            max-height: 90vh;
            overflow-y: auto;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
        }

        .modal-header {
            min-height: 58px;
            padding: 0 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border);
            background: #ffffff;
        }

        .modal-header-content {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal-header-icon {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            background: #FFF3CD;
            color: var(--orange);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .modal-header h2 {
            margin: 0;
            color: var(--navy);
            font-size: 15px;
            font-weight: 700;
        }

        .modal-header p {
            margin: 3px 0 0;
            color: var(--muted);
            font-size: 9px;
        }

        .close-modal {
            width: 30px;
            height: 30px;
            border: none;
            background: transparent;
            color: #64748B;
            cursor: pointer;
            font-size: 15px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .close-modal:hover {
            background: #FEF0F0;
            color: #DC3545;
        }

        .modal-body {
            padding: 18px;
            background: #ffffff;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .form-group {
            min-width: 0;
        }

        .form-group label {
            display: block;
            color: var(--muted);
            font-size: 9px;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .form-control {
            width: 100%;
            height: 38px;
            padding: 0 11px;
            border: 1px solid var(--border);
            border-radius: 7px;
            background: #FFFDF7;
            color: var(--navy);
            font-size: 10px;
            outline: none;
        }

        .form-control:focus {
            border-color: var(--yellow);
            box-shadow: 0 0 0 3px rgba(252, 191, 73, .10);
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
        }

        .selector-button:hover {
            background: var(--yellow);
            color: var(--navy);
        }

        .selected-info {
            margin-top: 4px;
            align-items: center;
            gap: 4px;
            color: var(--green);
            font-size: 8px;
        }

        .modal-footer {
            padding: 12px 18px;
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            border-top: 1px solid var(--border);
            background: #ffffff;
        }

        .btn-save,
        .btn-delete,
        .btn-secondary {
            height: 34px;
            padding: 0 13px;
            border-radius: 7px;
            font-size: 9px;
            cursor: pointer;
        }
        .modal-header{min-height:58px;padding:0 18px}.modal-header h2{font-size:15px;color:var(--navy)}.modal-header p{font-size:9px;color:var(--muted);margin-top:3px}.modal-header-icon{width:36px;height:36px;border-radius:8px}.modal-body{padding:18px}.form-grid{gap:14px}.form-group label{color:var(--muted);font-size:9px;margin-bottom:0}.form-control{height:38px;padding:0 11px;border-radius:7px;font-size:10px;background:#FFFDF7}.modal-footer{padding:12px 18px}.btn-save,.btn-delete,.btn-secondary{height:34px;padding:0 13px;border-radius:7px;font-size:9px}
        .stats-grid{grid-template-columns:repeat(4,1fr)}.stat-card{padding:15px 16px}.stat-icon{width:36px;height:36px;font-size:14px}.stat-label{font-size:8px}.stat-value{font-size:20px}

        .inventory-panel{background:#fff;border:1px solid var(--border);border-radius:10px;box-shadow:0 5px 20px rgba(0,0,0,.05);overflow:hidden}
        .panel-header{padding:15px 16px;display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid var(--border)}
        .panel-header h2{font-size:13px;color:var(--navy);font-weight:700}.panel-header p{font-size:8px;color:var(--muted);margin-top:3px}
        .search-area{display:flex;align-items:center;gap:8px}.search-box{position:relative}.search-box i{position:absolute;left:11px;top:50%;transform:translateY(-50%);color:#94A3B8;font-size:10px}.search-box input{width:220px;height:34px;padding:0 10px 0 31px;border:1px solid var(--border);border-radius:7px;outline:none;font-size:9px;background:#fff}.search-box input:focus{border-color:var(--yellow);box-shadow:0 0 0 3px rgba(252,191,73,.10)}
        .filter-select{height:34px;padding:0 10px;border:1px solid var(--border);border-radius:7px;background:#fff;outline:none;font-size:9px;color:var(--navy)}
        .table-wrapper{overflow-x:auto}
        .stat-content h4{color:var(--muted);font-size:8px;font-weight:600;margin-bottom:6px;text-transform:uppercase;letter-spacing:.3px}.stat-content .number{font-size:21px;font-weight:800;color:var(--navy)}
        .alert{padding:10px 13px;border-radius:7px;margin-bottom:14px;display:flex;align-items:center;gap:8px;font-size:9px;font-weight:600}.alert-success{background:#EAF7EE;color:var(--green)}.alert-error{background:#FEF0F0;color:var(--red)}
        @media(max-width:1100px){.stats-grid{grid-template-columns:repeat(2,1fr)}}@media(max-width:900px){.main{margin-left:70px}}@media(max-width:650px){.main{margin-left:0}.content{padding:15px 12px}.stats-grid{grid-template-columns:1fr}.form-grid{grid-template-columns:1fr}.form-group.full{grid-column:auto}.page-heading{align-items:flex-start;flex-direction:column}.page-heading .btn{width:100%}}
        .actions {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            flex-wrap: nowrap;
        }

        .action-btn {
            width: 30px;
            height: 30px;

            border: 1px solid var(--border);

            border-radius: 6px;

            background: white;

            display: inline-flex;
            align-items: center;
            justify-content: center;

            cursor: pointer;

            font-size: 10px;

            transition: .2s ease;

            flex-shrink: 0;
        }

        .action-btn:hover {
            transform: translateY(-1px);
        }

        .action-edit {
            color: var(--blue);
        }

        .action-edit:hover {
            background: #EEF4FF;
            border-color: rgba(37,99,235,.25);
        }

        .action-stock {
            color: var(--green);
        }

        .action-stock:hover {
            background: #EAF7EE;
            border-color: rgba(40,167,69,.25);
        }

        .action-delete {
            color: var(--red);
        }

        .action-delete:hover {
            background: #FEF0F0;
            border-color: rgba(214,40,40,.25);
        }
        .stock-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 18px;
        }

        .stock-option {
            border: 1px solid var(--border);
            border-radius: 9px;
            padding: 14px;
            background: white;
            cursor: pointer;
            transition: .2s ease;

            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .stock-option i {
            font-size: 18px;
            margin-bottom: 3px;
        }

        .stock-option strong {
            font-size: 10px;
        }

        .stock-option span {
            font-size: 8px;
            color: var(--muted);
        }



        .stock-option.add {
            color: var(--green);
        }

        .stock-option.add:hover {
            background: #F4FBF6;
            border-color: rgba(40,167,69,.30);
        }

        .stock-option.add.active {
            background: #EAF7EE;
            border: 2px solid var(--green);
        }


        .stock-option.remove {
            color: var(--red);
        }

        .stock-option.remove:hover {
            background: #FEF5F5;
            border-color: rgba(214,40,40,.30);
        }

        .stock-option.remove.active {
            background: #FEF0F0;
            border: 2px solid var(--red);
        }
        body.modal-open {
            overflow: hidden;
        }
        .field-error {
            color: #dc2626;
            font-size: 11px;
            margin-top: 6px;
            display: none;
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
                <h1>Inventory Management</h1>
                <p>Manage products, stock levels, vendors and warehouses.</p>
            </div>

            <button class="btn btn-primary" type="button" onclick="openCreateModal()">
                <i class="fa-solid fa-plus"></i>
                Add Inventory
            </button>
        </div>


        <% if ("created".equals(success)) { %>

        <div class="success-toast" id="successToast">

            <i class="fa-solid fa-circle-check"></i>

            <span>Inventory item created successfully.</span>

            <button
                    type="button"
                    class="toast-close"
                    onclick="closeToast('successToast')">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <% } else if ("updated".equals(success)) { %>

        <div class="success-toast" id="successToast">

            <i class="fa-solid fa-circle-check"></i>

            <span>Inventory item updated successfully.</span>

            <button
                    type="button"
                    class="toast-close"
                    onclick="closeToast('successToast')">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <% } else if ("deleted".equals(success)) { %>

        <div class="success-toast" id="successToast">

            <i class="fa-solid fa-circle-check"></i>

            <span>Inventory item deleted successfully.</span>

            <button
                    type="button"
                    class="toast-close"
                    onclick="closeToast('successToast')">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <% } else if ("quantity".equals(success)) { %>

        <div class="success-toast" id="successToast">

            <i class="fa-solid fa-circle-check"></i>

            <span>Stock quantity updated successfully.</span>

            <button
                    type="button"
                    class="toast-close"
                    onclick="closeToast('successToast')">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <% } %>


        <% if (error != null && !error.trim().isEmpty()) { %>

        <div class="error-toast" id="errorToast">

            <i class="fa-solid fa-circle-exclamation"></i>

            <span><%= error %></span>

            <button
                    type="button"
                    class="toast-close"
                    onclick="closeToast('errorToast')">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <% } %>

        <div class="stats-grid">

            <div class="stat-card">

                <div class="stat-content">

                    <h4>Total Products</h4>

                    <div class="number">
                        <%= totalItems %>
                    </div>

                </div>

                <div class="stat-icon stat-orange">

                    <i class="fa-solid fa-box"></i>

                </div>

            </div>

            <div class="stat-card">

                <div class="stat-content">

                    <h4>Total Stock Units</h4>

                    <div class="number">
                        <%= totalQuantity %>
                    </div>

                </div>

                <div class="stat-icon stat-blue">

                    <i class="fa-solid fa-cubes"></i>

                </div>

            </div>

            <div class="stat-card">

                <div class="stat-content">

                    <h4>Low Stock</h4>

                    <div class="number">
                        <%= lowStock %>
                    </div>

                </div>

                <div class="stat-icon stat-yellow">

                    <i class="fa-solid fa-triangle-exclamation"></i>

                </div>

            </div>

            <div class="stat-card">

                <div class="stat-content">

                    <h4>Out of Stock</h4>

                    <div class="number">
                        <%= outOfStock %>
                    </div>

                </div>

                <div class="stat-icon stat-red">

                    <i class="fa-solid fa-circle-xmark"></i>

                </div>

            </div>

        </div>

        <div class="inventory-panel">

            <div class="panel-header">

                <div>

                    <h2>Inventory Records</h2>

                    <p>
                        Manage products across your warehouses
                    </p>

                </div>


                <div class="search-area">

                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input
                                type="text"
                                id="inventorySearch"
                                placeholder="Search product..."
                                onkeyup="filterInventory()">

                    </div>


                    <select
                            class="filter-select"
                            id="stockFilter"
                            onchange="filterInventory()">

                        <option value="all">
                            All Stock
                        </option>

                        <option value="good">
                            In Stock
                        </option>

                        <option value="low">
                            Low Stock
                        </option>

                        <option value="out">
                            Out of Stock
                        </option>

                    </select>

                </div>

            </div>

            <div class="table-wrapper">

                <table class="inventory-table" id="inventoryTable">

                    <thead>

                    <tr>

                        <th>Product</th>

                        <th>Vendor</th>

                        <th>Warehouse</th>

                        <th>Quantity</th>

                        <th>Reorder Level</th>

                        <th>Status</th>

                        <th>Last Updated</th>

                        <th>Actions</th>

                    </tr>

                    </thead>


                    <tbody>


                    <% if (inventoryList.isEmpty()) { %>

                    <tr>

                        <td colspan="8">

                            <div class="empty-state">

                                <i class="fa-solid fa-box-open"></i>

                                <h3>No inventory records</h3>

                                <p>
                                    Add your first inventory item to get started.
                                </p>

                            </div>

                        </td>

                    </tr>

                    <% } else { %>


                    <% for (Inventory inventory : inventoryList) {

                        Integer quantity =
                                inventory.getQuantity();

                        Integer reorderLevel =
                                inventory.getReorderLevel();

                        boolean isOut =
                                quantity != null &&
                                        quantity == 0;

                        boolean isLow =
                                !isOut &&
                                        quantity != null &&
                                        reorderLevel != null &&
                                        quantity <= reorderLevel;

                        String stockType =
                                isOut ? "out" :
                                        isLow ? "low" :
                                                "good";

                        String quantityClass =
                                isOut ? "quantity-out" :
                                        isLow ? "quantity-low" :
                                                "quantity-normal";

                        String statusText =
                                isOut ? "Out of Stock" :
                                        isLow ? "Low Stock" :
                                                "In Stock";

                        String statusIcon =
                                isOut ? "fa-circle-xmark" :
                                        isLow ? "fa-triangle-exclamation" :
                                                "fa-circle-check";

                    %>


                    <tr
                            data-product="
                            <%= inventory.getProductName() == null
                                    ? ""
                                    : inventory.getProductName().toLowerCase() %>"
                            data-code="
                            <%= inventory.getProductCode() == null
                                    ? ""
                                    : inventory.getProductCode().toLowerCase() %>"
                            data-status="<%= stockType %>"
                    >

                        <td>

                            <div class="product-info">

                                <div class="product-icon">

                                    <i class="fa-solid fa-box"></i>

                                </div>

                                <div>

                                    <div class="product-name">

                                        <%= inventory.getProductName() == null
                                                ? "-"
                                                : inventory.getProductName() %>

                                    </div>

                                    <div class="product-code">

                                        <%= inventory.getProductCode() == null
                                                ? "-"
                                                : inventory.getProductCode() %>

                                    </div>

                                </div>

                            </div>

                        </td>

                        <td>

                            <%
                                if (inventory.getVendor() != null) {
                            %>

                            <%= inventory.getVendor().getCompanyName() %>

                            <%
                            } else {
                            %>

                            <span style="color:#aaa;">
                                    —
                                </span>

                            <%
                                }
                            %>

                        </td>

                        <td>

                            <%
                                if (inventory.getWarehouse() != null) {
                            %>

                            <div style="font-weight:600;">
                                <%= inventory.getWarehouse().getName() %>
                            </div>

                            <div style="
                                    font-size:10px;
                                    color:#999;
                                    margin-top:3px;
                                ">

                                <%= inventory.getWarehouse().getCode() %>

                            </div>

                            <%
                            } else {
                            %>

                            <span style="color:#aaa;">
                                    —
                                </span>

                            <%
                                }
                            %>

                        </td>

                        <td>

                            <span class="quantity <%= quantityClass %>">

                                <%= quantity == null
                                        ? 0
                                        : quantity %>

                            </span>

                        </td>

                        <td>

                            <span style="font-weight:600;">

                                <%= reorderLevel == null
                                        ? 0
                                        : reorderLevel %>

                            </span>

                        </td>

                        <td>

                            <span
                                    class="stock-badge
                                    <%= isOut
                                            ? "stock-out"
                                            : isLow
                                            ? "stock-low"
                                            : "stock-good" %>"
                            >

                                <i class="fa-solid <%= statusIcon %>"></i>

                                <%= statusText %>

                            </span>

                        </td>

                        <td>

                            <%
                                if (inventory.getLastUpdated() != null) {
                            %>

                            <span style="
                                    font-size:11px;
                                    color:#777;
                                ">

                                    <%= inventory.getLastUpdated()
                                            .toString()
                                            .replace("T", " ") %>

                                </span>

                            <%
                            } else {
                            %>

                            <span style="color:#aaa;">
                                    —
                                </span>

                            <%
                                }
                            %>

                        </td>

                        <td>

                            <div class="actions">

                                <button
                                        type="button"
                                        class="action-btn action-edit"
                                        title="Edit"
                                        onclick="openEditModal(
                                            <%= inventory.getId() %>,
                                            <%= jsString(inventory.getProductCode()) %>,
                                            <%= jsString(inventory.getProductName()) %>,
                                            <%= inventory.getQuantity() == null ? 0 : inventory.getQuantity() %>,
                                            <%= inventory.getReorderLevel() == null ? 0 : inventory.getReorderLevel() %>,

                                            <%= inventory.getVendor() == null
                    ? "null"
                    : inventory.getVendor().getId() %>,

                                            <%= inventory.getVendor() == null
                    ? "null"
                    : jsString(inventory.getVendor().getCompanyName()) %>,

                                            <%= inventory.getVendor() == null
                    ? "null"
                    : jsString(inventory.getVendor().getVendorCode()) %>,

                                            <%= inventory.getWarehouse() == null
                    ? "null"
                    : inventory.getWarehouse().getId() %>,

                                            <%= inventory.getWarehouse() == null
                    ? "null"
                    : jsString(inventory.getWarehouse().getName()) %>,

                                            <%= inventory.getWarehouse() == null
                    ? "null"
                    : jsString(inventory.getWarehouse().getCode()) %>
                                                )">

                                    <i class="fa-solid fa-pen"></i>

                                </button>

                                <button
                                        type="button"
                                        class="action-btn action-stock"
                                        title="Update Stock"
                                        onclick="openStockModal(
                                            <%= inventory.getId() %>,
                                                '<%= jsEscape(inventory.getProductName()) %>',
                                            <%= quantity == null ? 0 : quantity %>
                                                )">

                                    <i class="fa-solid fa-arrows-rotate"></i>

                                </button>

                                <button
                                        type="button"
                                        class="action-btn action-delete"
                                        title="Delete"
                                        onclick='openDeleteModal(
                                            <%= inventory.getId() %>,
                                            <%= jsString(inventory.getProductName()) %>
                                                )'>

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

        <footer class="footer">
            <span>© 2026 GlobalTrade Logistics System. All rights reserved.</span>
            <span>Administrator Portal • Version 1.0.0</span>
        </footer>

    </section>
</main>


<div
        class="modal-overlay"
        id="createModal"
        onclick="closeModalOutside(event, 'createModal')"
>

    <div class="inventory-modal">


        <div class="modal-header">

            <div class="modal-header-content">

                <div class="modal-header-icon">

                    <i class="fa-solid fa-box"></i>

                </div>

                <div>

                    <h2>Add Inventory</h2>

                    <p>
                        Create a new inventory record
                    </p>

                </div>

            </div>


            <button
                    type="button"
                    class="close-modal"
                    onclick="closeModal('createModal')">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <form
                method="post"
                action="<%= request.getContextPath() %>/inventory"
                onsubmit="return validateCreateInventory();"
        >

            <input
                    type="hidden"
                    name="action"
                    value="create"
            >


            <div class="modal-body">

                <div class="form-grid">



                    <div class="form-group">

                        <label>
                            Product Code
                            <span class="required">*</span>
                        </label>

                        <input
                                type="text"
                                id="createProductCode"
                                class="form-control generated-code"
                                value="Generated automatically"
                                readonly
                        >

                    </div>

                    <div class="form-group">

                        <label>
                            Product Name
                            <span class="required">*</span>
                        </label>

                        <input
                                type="text"
                                name="productName"
                                class="form-control"
                                placeholder="Product name"
                                maxlength="150"
                                required
                        >

                    </div>

                    <div class="form-group">

                        <label>
                            Initial Quantity
                            <span class="required">*</span>
                        </label>

                        <input
                                type="number"
                                name="quantity"
                                class="form-control"
                                min="0"
                                placeholder="0"
                                required
                        >

                    </div>

                    <div class="form-group">

                        <label>
                            Reorder Level
                            <span class="required">*</span>
                        </label>

                        <input
                                type="number"
                                name="reorderLevel"
                                class="form-control"
                                min="0"
                                placeholder="e.g. 20"
                                required
                        >

                    </div>

                    <div class="form-group">

                        <label>
                            Vendor
                            <span class="required">*</span>
                        </label>

                        <div class="selector-field">

                            <div
                                    class="selector-display placeholder"
                                    id="vendorDisplay">

                                Select Vendor

                            </div>

                            <button
                                    type="button"
                                    class="selector-button"
                                    onclick="openSelector('vendor','create')">

                                <i class="fa-solid fa-building"></i>
                                Select

                            </button>

                        </div>

                        <input
                                type="hidden"
                                name="vendorId"
                                id="vendorId"
                        >

                        <div
                                class="field-error"
                                id="vendorError"
                                style="display:none;">

                            Please select a vendor.

                        </div>

                    </div>
                    <div class="form-group">

                        <label>
                            Warehouse
                            <span class="required">*</span>
                        </label>

                        <div class="selector-field">

                            <div
                                    class="selector-display placeholder"
                                    id="warehouseDisplay">

                                Select Warehouse

                            </div>

                            <button
                                    type="button"
                                    class="selector-button"
                                    onclick="openSelector('warehouse','create')">

                                <i class="fa-solid fa-warehouse"></i>
                                Select

                            </button>

                        </div>

                        <input
                                type="hidden"
                                name="warehouseId"
                                id="warehouseId"
                        >

                        <div
                                class="field-error"
                                id="warehouseError"
                                style="display:none;">

                            Please select a warehouse.

                        </div>

                    </div>


                </div>

            </div>


            <div class="modal-footer">

                <button
                        type="button"
                        class="btn-secondary"
                        onclick="closeModal('createModal')">

                    Cancel

                </button>


                <button
                        type="submit"
                        class="btn-save"
                >

                    <i class="fa-solid fa-check"></i>

                    Create Inventory

                </button>

            </div>

        </form>

    </div>

</div>

<div
        class="modal-overlay"
        id="editModal"
        onclick="closeModalOutside(event, 'editModal')"
>

    <div class="inventory-modal">


        <div class="modal-header">

            <div class="modal-header-content">

                <div class="modal-header-icon">

                    <i class="fa-solid fa-pen"></i>

                </div>

                <div>

                    <h2>Edit Inventory</h2>

                    <p>
                        Update inventory information
                    </p>

                </div>

            </div>


            <button
                    type="button"
                    class="close-modal"
                    onclick="closeModal('editModal')">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <form
                method="post"
                action="<%= request.getContextPath() %>/inventory"
                onsubmit="return validateEditInventory();"
        >

            <input
                    type="hidden"
                    name="action"
                    value="update"
            >

            <input
                    type="hidden"
                    name="id"
                    id="editId"
            >


            <div class="modal-body">

                <div class="form-grid">


                    <div class="form-group">

                        <label>
                            Product Code
                            <span class="required">*</span>
                        </label>

                        <input
                                type="text"
                                id="editProductCode"
                                class="form-control generated-code"
                                readonly
                        >

                    </div>


                    <div class="form-group">

                        <label>
                            Product Name
                            <span class="required">*</span>
                        </label>

                        <input
                                type="text"
                                name="productName"
                                id="editProductName"
                                class="form-control"
                                maxlength="150"
                                required
                        >

                    </div>


                    <div class="form-group">

                        <label>
                            Quantity
                            <span class="required">*</span>
                        </label>

                        <input
                                type="number"
                                name="quantity"
                                id="editQuantity"
                                class="form-control"
                                min="0"
                                required
                        >

                    </div>


                    <div class="form-group">

                        <label>
                            Reorder Level
                            <span class="required">*</span>
                        </label>

                        <input
                                type="number"
                                name="reorderLevel"
                                id="editReorderLevel"
                                class="form-control"
                                min="0"
                                required
                        >

                    </div>


                    <div class="form-group">

                        <label>
                            Vendor
                            <span class="required">*</span>
                        </label>

                        <div class="selector-field">

                            <div
                                    class="selector-display placeholder"
                                    id="editVendorDisplay">

                                Select Vendor

                            </div>

                            <button
                                    type="button"
                                    class="selector-button"
                                    onclick="openSelector('vendor','edit')">

                                <i class="fa-solid fa-building"></i>
                                Select

                            </button>

                        </div>

                        <input
                                type="hidden"
                                name="vendorId"
                                id="editVendorId"
                        >

                        <div
                                class="field-error"
                                id="editVendorError"
                                style="display:none;">

                            Please select a vendor.

                        </div>

                    </div>


                    <div class="form-group">

                        <label>
                            Warehouse
                            <span class="required">*</span>
                        </label>

                        <div class="selector-field">

                            <div
                                    class="selector-display placeholder"
                                    id="editWarehouseDisplay">

                                Select Warehouse

                            </div>

                            <button
                                    type="button"
                                    class="selector-button"
                                    onclick="openSelector('warehouse','edit')">

                                <i class="fa-solid fa-warehouse"></i>
                                Select

                            </button>

                        </div>

                        <input
                                type="hidden"
                                name="warehouseId"
                                id="editWarehouseId"
                        >

                        <div
                                class="field-error"
                                id="editWarehouseError"
                                style="display:none;">

                            Please select a warehouse.

                        </div>

                    </div>


                </div>

            </div>


            <div class="modal-footer">

                <button
                        type="button"
                        class="btn-secondary"
                        onclick="closeModal('editModal')">

                    Cancel

                </button>


                <button
                        type="submit"
                        class="btn-save">

                    <i class="fa-solid fa-floppy-disk"></i>

                    Save Changes

                </button>

            </div>

        </form>

    </div>

</div>

<div
        class="modal-overlay"
        id="stockModal"
        onclick="closeModalOutside(event, 'stockModal')"
>

    <div class="inventory-modal">


        <div class="modal-header">

            <div class="modal-header-content">

                <div class="modal-header-icon">

                    <i class="fa-solid fa-arrows-rotate"></i>

                </div>

                <div>

                    <h2>Update Stock</h2>

                    <p id="stockProductName">
                        Adjust inventory quantity
                    </p>

                </div>

            </div>


            <button
                    type="button"
                    class="close-modal"
                    onclick="closeModal('stockModal')">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <form
                method="post"
                action="<%= request.getContextPath() %>/inventory"
                onsubmit="return prepareStockSubmit();"
        >

            <input
                    type="hidden"
                    name="action"
                    value="updateQuantity"
            >

            <input
                    type="hidden"
                    name="inventoryId"
                    id="stockInventoryId"
            >

            <input
                    type="hidden"
                    name="quantityChange"
                    id="stockQuantityChange"
            >


            <div class="modal-body">


                <div
                        style="
                            background:#f8f8f8;
                            padding:14px;
                            border-radius:9px;
                            margin-bottom:18px;
                            text-align:center;
                        "
                >

                    <div style="
                        color:#777;
                        font-size:11px;
                        margin-bottom:4px;
                    ">

                        Current Stock

                    </div>

                    <div
                            id="currentStock"
                            style="
                                font-size:25px;
                                font-weight:800;
                                color:#171717;
                            "
                    >
                        0
                    </div>

                </div>


                <div class="stock-options">


                    <div
                            class="stock-option add active"
                            id="addStockOption"
                            onclick="selectStockType('add')"
                    >

                        <i class="fa-solid fa-circle-plus"></i>

                        <strong>Add Stock</strong>

                        <span>
                            Increase available quantity
                        </span>

                    </div>


                    <div
                            class="stock-option remove"
                            id="removeStockOption"
                            onclick="selectStockType('remove')"
                    >

                        <i class="fa-solid fa-circle-minus"></i>

                        <strong>Remove Stock</strong>

                        <span>
                            Decrease available quantity
                        </span>

                    </div>

                </div>


                <input
                        type="hidden"
                        id="stockOperation"
                        value="add"
                >


                <div class="form-group">

                    <label>

                        Quantity

                        <span class="required">*</span>

                    </label>

                    <input
                            type="number"
                            id="stockAmount"
                            class="form-control"
                            min="1"
                            placeholder="Enter quantity"
                            required
                    >

                </div>


            </div>


            <div class="modal-footer">

                <button
                        type="button"
                        class="btn-secondary"
                        onclick="closeModal('stockModal')">

                    Cancel

                </button>


                <button
                        type="submit"
                        class="btn-save">

                    <i class="fa-solid fa-check"></i>

                    Update Stock

                </button>

            </div>

        </form>

    </div>

</div>

<div
        class="modal-overlay"
        id="deleteModal"
        onclick="closeModalOutside(event, 'deleteModal')"
>

    <div
            class="inventory-modal"
            style="max-width:430px;"
    >


        <div class="modal-header">

            <div class="modal-header-content">

                <div class="modal-header-icon"
                     style="
                       background: #fef2f2;
                        color:var(--red);
                     ">

                    <i class="fa-solid fa-trash"></i>

                </div>

                <div>

                    <h2>Delete Inventory</h2>

                    <p>
                        Confirm inventory deletion
                    </p>

                </div>

            </div>


            <button
                    type="button"
                    class="close-modal"
                    onclick="closeModal('deleteModal')">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <form
                method="post"
                action="<%= request.getContextPath() %>/inventory"
        >

            <input
                    type="hidden"
                    name="action"
                    value="delete"
            >

            <input
                    type="hidden"
                    name="id"
                    id="deleteId"
            >


            <div class="modal-body">

                <div class="delete-content">

                    <div class="delete-icon">

                        <i class="fa-solid fa-trash-can"></i>

                    </div>

                    <h3>
                        Delete this inventory item?
                    </h3>

                    <p>

                        You are about to delete

                        <strong id="deleteProductName">
                            this product
                        </strong>.

                        This action cannot be undone.

                    </p>

                </div>

            </div>


            <div class="modal-footer">

                <button
                        type="button"
                        class="btn-secondary"
                        onclick="closeModal('deleteModal')">

                    Cancel

                </button>


                <button
                        type="submit"
                        class="btn-delete">

                    <i class="fa-solid fa-trash"></i>

                    Delete

                </button>

            </div>

        </form>

    </div>

</div>

<div class="selection-overlay" id="selectionOverlay" onclick="closeSelectorOutside(event)">
    <div class="selection-modal">
        <div class="selection-modal-header">
            <h2 id="selectionTitle"><i class="fa-solid fa-list"></i> Select</h2>
            <button type="button" class="selection-close" onclick="closeSelector()">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <div class="selection-search-area">
            <div class="selection-search-wrapper">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="selectionSearch" class="selection-search"
                       placeholder="Search..." onkeyup="searchSelection()">
            </div>
        </div>

        <div class="selection-content" id="selectionContent"></div>

        <div class="selection-empty" id="selectionEmpty" style="display:none;">
            <i class="fa-solid fa-magnifying-glass"></i>
            <h3>No results found</h3>
            <p>Try another search term.</p>
        </div>
    </div>
</div>

<script>

    function openCreateModal() {

        const modal =
            document.getElementById(
                "createModal"
            );


        const form =
            modal.querySelector("form");


        if (form) {
            form.reset();
        }

        document.getElementById(
            "vendorId"
        ).value = "";


        setSelectorDisplay(
            "vendor",
            "create",
            "",
            "Select Vendor"
        );


        clearSelectorError(
            "vendor",
            "create"
        );

        document.getElementById(
            "warehouseId"
        ).value = "";


        setSelectorDisplay(
            "warehouse",
            "create",
            "",
            "Select Warehouse"
        );


        clearSelectorError(
            "warehouse",
            "create"
        );

        document.getElementById(
            "createProductCode"
        ).value =
            "Generated automatically";

        modal.classList.add(
            "active"
        );

        document.body.classList.add(
            "modal-open"
        );
    }

    function openEditModal(
        id,
        productCode,
        productName,
        quantity,
        reorderLevel,
        vendorId,
        vendorName,
        vendorCode,
        warehouseId,
        warehouseName,
        warehouseCode
    ) {

        console.log("Opening edit modal for inventory:", id);

        document.getElementById("editId").value =
            id || "";

        document.getElementById("editProductCode").value =
            productCode || "";

        document.getElementById("editProductName").value =
            productName || "";

        document.getElementById("editQuantity").value =
            quantity == null ? 0 : quantity;

        document.getElementById("editReorderLevel").value =
            reorderLevel == null ? 0 : reorderLevel;

        document.getElementById("editVendorId").value =
            vendorId || "";

        if (vendorId != null) {

            setSelectorDisplay(
                "vendor",
                "edit",
                vendorId,
                (vendorName || "Unknown Vendor") +
                (
                    vendorCode
                        ? " • " + vendorCode
                        : ""
                )
            );

        } else {

            setSelectorDisplay(
                "vendor",
                "edit",
                "",
                "Select Vendor"
            );
        }

        document.getElementById("editWarehouseId").value =
            warehouseId || "";

        if (warehouseId != null) {

            setSelectorDisplay(
                "warehouse",
                "edit",
                warehouseId,
                (warehouseName || "Unknown Warehouse") +
                (
                    warehouseCode
                        ? " • " + warehouseCode
                        : ""
                )
            );

        } else {

            setSelectorDisplay(
                "warehouse",
                "edit",
                "",
                "Select Warehouse"
            );
        }

        document
            .getElementById("editModal")
            .classList.add("active");

        document.body.classList.add("modal-open");
    }

    function openStockModal(id, productName, currentQuantity) {
        document.getElementById("stockInventoryId").value = id;
        document.getElementById("stockProductName").textContent = productName || "Adjust inventory quantity";
        document.getElementById("currentStock").textContent = currentQuantity;
        document.getElementById("stockAmount").value = "";
        document.getElementById("stockOperation").value = "add";
        selectStockType("add");
        document.getElementById("stockModal").classList.add("active");
    }

    function selectStockType(type) {
        document.getElementById("stockOperation").value = type;
        document.getElementById("addStockOption").classList.toggle("active", type === "add");
        document.getElementById("removeStockOption").classList.toggle("active", type === "remove");
    }

    function prepareStockSubmit() {

        const amount =
            parseInt(
                document.getElementById("stockAmount").value,
                10
            );

        if (isNaN(amount) || amount <= 0) {

            alert(
                "Please enter a quantity greater than zero."
            );

            return false;
        }


        const operation =
            document.getElementById("stockOperation").value;


        document.getElementById(
            "stockQuantityChange"
        ).value =
            operation === "remove"
                ? -amount
                : amount;


        return true;
    }

    function openDeleteModal(
        id,
        productName
    ) {

        document.getElementById(
            "deleteId"
        ).value = id;

        document.getElementById(
            "deleteProductName"
        ).textContent =
            productName || "this product";

        document
            .getElementById("deleteModal")
            .classList.add("active");

        document.body.classList.add("modal-open");
    }

    function closeModal(id) {

        const modal =
            document.getElementById(id);

        if (modal) {
            modal.classList.remove("active");
        }

        document.body.classList.remove("modal-open");
    }

    function closeModalOutside(
        event,
        modalId
    ) {

        if (
            event.target.id === modalId
        ) {
            closeModal(modalId);
        }
    }

    document.addEventListener("keydown", function(event) {
        if (event.key === "Escape") {
            document.querySelectorAll(".modal-overlay.active").forEach(m => m.classList.remove("active"));
            closeSelector();
        }
    });

    const vendors = [
        <% for (Vendor vendor : vendorList) { %>
        {
            id: "<%= vendor.getId() %>",
            name: "<%= jsEscape(vendor.getCompanyName()) %>",
            code: "<%= jsEscape(vendor.getVendorCode()) %>"
        }<%= vendorList.indexOf(vendor) < vendorList.size()-1 ? "," : "" %>
        <% } %>
    ];

    const warehouses = [
        <% for (Warehouse warehouse : warehouseList) { %>
        {
            id: "<%= warehouse.getId() %>",
            name: "<%= jsEscape(warehouse.getName()) %>",
            code: "<%= jsEscape(warehouse.getCode()) %>"
        }<%= warehouseList.indexOf(warehouse) < warehouseList.size()-1 ? "," : "" %>
        <% } %>
    ];

    let selectorType = "";
    let selectorMode = "create";

    function openSelector(type, mode) {
        selectorType = type;
        selectorMode = mode || "create";

        const title = document.getElementById("selectionTitle");
        const search = document.getElementById("selectionSearch");

        title.innerHTML = type === "vendor"
            ? '<i class="fa-solid fa-building"></i> Select Vendor'
            : '<i class="fa-solid fa-warehouse"></i> Select Warehouse';

        search.value = "";
        renderSelectionItems();

        document.getElementById("selectionOverlay").classList.add("show");
        setTimeout(() => search.focus(), 50);
    }

    function renderSelectionItems() {
        const list = selectorType === "vendor" ? vendors : warehouses;
        const query = document.getElementById("selectionSearch").value.toLowerCase().trim();
        const content = document.getElementById("selectionContent");
        const empty = document.getElementById("selectionEmpty");

        const filtered = list.filter(item =>
            (item.name || "").toLowerCase().includes(query) ||
            (item.code || "").toLowerCase().includes(query)
        );

        content.innerHTML = "";

        filtered.forEach(item => {
            const row = document.createElement("div");
            row.className = "selection-item";
            row.innerHTML =
                '<div class="selection-item-info">' +
                '<span class="selection-item-title">' + escapeHtml(item.name || "-") + '</span>' +
                '<span class="selection-item-subtitle">' +
                (item.code ? escapeHtml(item.code) : "ID: " + escapeHtml(String(item.id))) +
                '</span>' +
                '</div>' +
                '<button type="button" class="selection-item-button" onclick="chooseSelection(\'' +
                escapeHtml(String(item.id)) +
                '\')">' +
                '<i class="fa-solid fa-check"></i> Select</button>';
            content.appendChild(row);
        });

        empty.style.display = filtered.length ? "none" : "block";
    }

    function searchSelection() {
        renderSelectionItems();
    }

    function chooseSelection(id) {

        const list =
            selectorType === "vendor"
                ? vendors
                : warehouses;


        const item =
            list.find(
                x => String(x.id) === String(id)
            );


        if (!item) {
            console.error(
                "Selected item not found:",
                id
            );
            return;
        }


        const displayText =
            item.name +
            (
                item.code
                    ? " • " + item.code
                    : ""
            );

        if (selectorType === "vendor") {

            const hiddenFieldId =
                selectorMode === "edit"
                    ? "editVendorId"
                    : "vendorId";


            document.getElementById(
                hiddenFieldId
            ).value = item.id;


            setSelectorDisplay(
                "vendor",
                selectorMode,
                item.id,
                displayText
            );
        }

        else {

            const hiddenFieldId =
                selectorMode === "edit"
                    ? "editWarehouseId"
                    : "warehouseId";


            document.getElementById(
                hiddenFieldId
            ).value = item.id;


            setSelectorDisplay(
                "warehouse",
                selectorMode,
                item.id,
                displayText
            );
        }

        closeSelector();
    }

    function setSelectorDisplay(type, mode, id, text) {

        let displayId;
        let infoId;

        if (mode === "edit") {

            if (type === "vendor") {
                displayId = "editVendorDisplay";
                infoId = "editVendorSelectedInfo";
            } else {
                displayId = "editWarehouseDisplay";
                infoId = "editWarehouseSelectedInfo";
            }

        } else {

            if (type === "vendor") {
                displayId = "vendorDisplay";
                infoId = "vendorSelectedInfo";
            } else {
                displayId = "warehouseDisplay";
                infoId = "warehouseSelectedInfo";
            }
        }

        const display =
            document.getElementById(displayId);

        const info =
            document.getElementById(infoId);


        if (!display) {
            console.error(
                "Selector display element not found:",
                displayId
            );
            return;
        }

        if (id) {

            display.textContent = text;

            display.classList.remove("placeholder");

            if (info) {
                info.style.display = "flex";
            }

        } else {

            display.textContent =
                type === "vendor"
                    ? "Select Vendor"
                    : "Select Warehouse";

            display.classList.add("placeholder");

            if (info) {
                info.style.display = "none";
            }
        }
    }
    function showSelectorError(
        type,
        mode
    ) {

        const prefix =
            mode === "edit"
                ? "edit"
                : "";

        const errorId =
            prefix +
            (
                type.charAt(0).toUpperCase() +
                type.slice(1)
            ) +
            "Error";


        const error =
            document.getElementById(errorId);


        if (error) {

            error.style.display =
                "block";
        }
    }
    function clearSelectorError(
        type,
        mode
    ) {

        const prefix =
            mode === "edit"
                ? "edit"
                : "";

        const errorId =
            prefix +
            (
                type.charAt(0).toUpperCase() +
                type.slice(1)
            ) +
            "Error";


        const error =
            document.getElementById(errorId);


        if (error) {

            error.style.display =
                "none";
        }
    }

    function closeSelector() {
        document.getElementById("selectionOverlay").classList.remove("show");
    }

    function closeSelectorOutside(event) {
        if (event.target.id === "selectionOverlay") closeSelector();
    }

    function escapeHtml(value) {
        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    function closeToast(id) {

        const toast =
            document.getElementById(id);

        if (!toast) {
            return;
        }

        toast.style.opacity = "0";

        toast.style.transform =
            "translateX(20px)";

        setTimeout(
            function () {
                toast.remove();
            },
            300
        );
    }


    setTimeout(
        function () {

            const toast =
                document.getElementById("successToast");

            if (toast) {
                closeToast("successToast");
            }

            const error =
                document.getElementById("errorToast");

            if (error) {
                closeToast("errorToast");
            }

        },
        4500
    );

    function filterInventory() {

        const search =
            document
                .getElementById("inventorySearch")
                .value
                .toLowerCase()
                .trim();


        const status =
            document
                .getElementById("stockFilter")
                .value;


        const rows =
            document
                .querySelectorAll(
                    "#inventoryTable tbody tr[data-status]"
                );


        rows.forEach(
            function(row) {

                const product =
                    row.dataset.product || "";

                const code =
                    row.dataset.code || "";

                const rowStatus =
                    row.dataset.status || "";


                const matchesSearch =
                    product.includes(search) ||
                    code.includes(search);


                const matchesStatus =
                    status === "all" ||
                    rowStatus === status;


                if (
                    matchesSearch &&
                    matchesStatus
                ) {

                    row.style.display = "";

                } else {

                    row.style.display = "none";
                }

            }
        );
    }

    setTimeout(
        function() {

            const alerts =
                document.querySelectorAll(
                    ".alert"
                );

            alerts.forEach(
                function(alert) {

                    alert.style.transition =
                        "opacity .4s";

                    alert.style.opacity =
                        "0";

                    setTimeout(
                        function() {

                            alert.remove();

                        },
                        400
                    );

                }
            );

        },
        4500
    );

    function validateCreateInventory() {

        let valid = true;

        const vendorId =
            document.getElementById(
                "vendorId"
            ).value;


        if (!vendorId) {

            showSelectorError(
                "vendor",
                "create"
            );

            valid = false;

        } else {

            clearSelectorError(
                "vendor",
                "create"
            );
        }

        const warehouseId =
            document.getElementById(
                "warehouseId"
            ).value;


        if (!warehouseId) {

            showSelectorError(
                "warehouse",
                "create"
            );

            valid = false;

        } else {

            clearSelectorError(
                "warehouse",
                "create"
            );
        }


        return valid;
    }
    function validateEditInventory() {

        let valid = true;

        const vendorId =
            document.getElementById(
                "editVendorId"
            ).value;


        if (!vendorId) {

            showSelectorError(
                "vendor",
                "edit"
            );

            valid = false;

        } else {

            clearSelectorError(
                "vendor",
                "edit"
            );
        }

        const warehouseId =
            document.getElementById(
                "editWarehouseId"
            ).value;


        if (!warehouseId) {

            showSelectorError(
                "warehouse",
                "edit"
            );

            valid = false;

        } else {

            clearSelectorError(
                "warehouse",
                "edit"
            );
        }


        return valid;
    }

</script>


</body>

</html>


<%!

    private String jsEscape(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("<", "\\u003C")
                .replace(">", "\\u003E")
                .replace("&", "\\u0026");
    }


    private String jsString(String value) {

        if (value == null) {
            return "''";
        }

        return "'"
                + jsEscape(value)
                + "'";
    }

%>