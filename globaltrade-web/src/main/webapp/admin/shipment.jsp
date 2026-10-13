<%@ page import="java.util.List" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="lk.sasindi.globaltrade.entity.*" %>
<%!
    /*
     * ============================================================
     * GENERIC PROPERTY READER
     * ============================================================
     *
     * This allows the JSP to safely read properties from
     * Address / Inventory entities without requiring
     * getAddressId(), getInventoryId(), etc.
     */

    private Object getProperty(Object object, String... propertyNames) {

        if (object == null) {
            return null;
        }

        for (String propertyName : propertyNames) {

            try {

                String methodName =
                        "get" +
                                Character.toUpperCase(propertyName.charAt(0)) +
                                propertyName.substring(1);

                Method method =
                        object.getClass().getMethod(methodName);

                Object value =
                        method.invoke(object);

                if (value != null) {

                    return value;
                }

            } catch (Exception ignored) {
                // Try the next possible property name
            }
        }

        return null;
    }


    /*
     * ============================================================
     * ADDRESS ID
     * ============================================================
     */

    private String getAddressId(Object address) {

        Object value =
                getProperty(
                        address,
                        "id",
                        "addressId"
                );

        return value != null
                ? String.valueOf(value)
                : "";
    }


    /*
     * ============================================================
     * ADDRESS TITLE
     * ============================================================
     */

    private String getAddressTitle(Object address) {

        Object fullAddress =
                getProperty(
                        address,
                        "fullAddress",
                        "address"
                );

        if (fullAddress != null &&
                !String.valueOf(fullAddress).trim().isEmpty()) {

            return escapeJs(String.valueOf(fullAddress));
        }


        Object line1 =
                getProperty(
                        address,
                        "addressLine1",
                        "address1",
                        "line1"
                );

        Object line2 =
                getProperty(
                        address,
                        "addressLine2",
                        "address2",
                        "line2"
                );

        Object city =
                getProperty(
                        address,
                        "city",
                        "cityName"
                );


        StringBuilder result =
                new StringBuilder();


        if (line1 != null) {

            result.append(line1);
        }


        if (line2 != null &&
                !String.valueOf(line2).trim().isEmpty()) {

            if (result.length() > 0) {

                result.append(", ");
            }

            result.append(line2);
        }


        if (city != null &&
                !String.valueOf(city).trim().isEmpty()) {

            if (result.length() > 0) {

                result.append(", ");
            }

            result.append(city);
        }


        if (result.length() == 0) {

            result.append("Address #")
                    .append(getAddressId(address));
        }


        return escapeJs(result.toString());
    }


    /*
     * ============================================================
     * ADDRESS SUBTITLE
     * ============================================================
     */

    private String getAddressSubtitle(Object address) {

        Object city =
                getProperty(
                        address,
                        "city",
                        "cityName"
                );

        Object postalCode =
                getProperty(
                        address,
                        "postalCode",
                        "postal_code"
                );

        StringBuilder result =
                new StringBuilder();


        if (city != null) {

            result.append("City: ")
                    .append(city);
        }


        if (postalCode != null) {

            if (result.length() > 0) {

                result.append(" • ");
            }

            result.append("Postal Code: ")
                    .append(postalCode);
        }


        if (result.length() == 0) {

            result.append("Address ID: ")
                    .append(getAddressId(address));
        }


        return escapeJs(result.toString());
    }


    /*
     * ============================================================
     * INVENTORY ID
     * ============================================================
     */

    private String getInventoryId(Object inventory) {

        Object value =
                getProperty(
                        inventory,
                        "id",
                        "inventoryId",
                        "itemId"
                );

        return value != null
                ? String.valueOf(value)
                : "";
    }


    /*
     * ============================================================
     * INVENTORY TITLE
     * ============================================================
     */

    private String getInventoryTitle(Object inventory) {

        Object value =
                getProperty(
                        inventory,
                        "itemName",
                        "name",
                        "productName",
                        "inventoryName"
                );

        if (value != null) {

            return escapeJs(String.valueOf(value));
        }


        return "Inventory Item #" +
                getInventoryId(inventory);
    }


    /*
     * ============================================================
     * INVENTORY SUBTITLE
     * ============================================================
     */

    private String getInventorySubtitle(Object inventory) {

        Object sku =
                getProperty(
                        inventory,
                        "sku",
                        "itemCode",
                        "productCode"
                );

        Object category =
                getProperty(
                        inventory,
                        "category",
                        "categoryName"
                );

        Object quantity =
                getProperty(
                        inventory,
                        "quantity",
                        "stockQuantity",
                        "availableQuantity"
                );


        StringBuilder result =
                new StringBuilder();


        if (sku != null) {

            result.append("SKU: ")
                    .append(sku);
        }


        if (category != null) {

            if (result.length() > 0) {

                result.append(" • ");
            }

            result.append("Category: ")
                    .append(category);
        }


        if (quantity != null) {

            if (result.length() > 0) {

                result.append(" • ");
            }

            result.append("Available: ")
                    .append(quantity);
        }


        if (result.length() == 0) {

            result.append("Inventory ID: ")
                    .append(getInventoryId(inventory));
        }


        return escapeJs(result.toString());
    }


    /*
     * ============================================================
     * ESCAPE JAVASCRIPT STRING
     * ============================================================
     */

    private String escapeJs(String value) {

        if (value == null) {

            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", " ")
                .replace("\n", " ");
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
                request.getContextPath() + "/user/dashboard"
        );

        return;
    }


    /*
     * ============================================================
     * SUCCESS / ERROR MESSAGES
     * ============================================================
     */

    String successMessage =
            (String) adminSession.getAttribute("successMessage");

    if (successMessage != null) {
        adminSession.removeAttribute("successMessage");
    }

    String errorMessage =
            (String) adminSession.getAttribute("errorMessage");

    if (errorMessage != null) {
        adminSession.removeAttribute("errorMessage");
    }


    /*
     * ============================================================
     * ADMIN USER
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
                    : "A";


    /*
     * ============================================================
     * NOTIFICATIONS
     * ============================================================
     */

    int notificationCount = 0;


    /*
     * ============================================================
     * SHIPMENT DATA
     * ============================================================
     */

    List<Vendor> vendors =
            (List<Vendor>) request.getAttribute("vendors");


//    List<Address> addresses =
//            (List<Address>) request.getAttribute("addresses");


    List<Inventory> inventoryItems =
            (List<Inventory>) request.getAttribute("inventoryItems");


    List<ShipmentStatus> shipmentStatuses =
            (List<ShipmentStatus>)
                    request.getAttribute("shipmentStatuses");

    List<Shipment> shipments =
            (List<Shipment>) request.getAttribute("shipments");

    List<Country> countries =
            (List<Country>) request.getAttribute("countries");

    int totalShipments = 0;
    int pendingShipments = 0;
    int transitShipments = 0;
    int deliveredShipments = 0;

    if (shipments != null) {

        totalShipments = shipments.size();

        for (Shipment shipment : shipments) {

            if (shipment.getShipmentStatus() == null) {
                continue;
            }

            String status =
                    shipment.getShipmentStatus()
                            .getName();

            if (status == null) {
                continue;
            }

            status = status.trim();

            if ("Pending".equalsIgnoreCase(status)) {

                pendingShipments++;

            } else if ("In Transit".equalsIgnoreCase(status)) {

                transitShipments++;

            } else if ("Delivered".equalsIgnoreCase(status)) {

                deliveredShipments++;
            }
        }
    }
%>


<!DOCTYPE html>


<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>GlobalTrade | Shipments</title>


    <!-- Font Awesome -->

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


        /* ============================================================
           BADGE
           ============================================================ */

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


        /* ============================================================
           CONTENT
           ============================================================ */

        .content {

            padding: 20px 25px 18px;
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


        /* ============================================================
           STAT CARDS
           ============================================================ */

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


        /* ============================================================
           MAIN SHIPMENT CARD
           ============================================================ */

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


        /* ============================================================
           FILTERS
           ============================================================ */

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


        /* ============================================================
           TABLE
           ============================================================ */

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


        /* ============================================================
           TRACKING NUMBER
           ============================================================ */

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


        /* ============================================================
           LOCATION
           ============================================================ */

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


        /* ============================================================
           VENDOR
           ============================================================ */

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


        /* ============================================================
           STATUS
           ============================================================ */

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


        /* ============================================================
           DATE
           ============================================================ */

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


        /* ============================================================
           EMPTY STATE
           ============================================================ */

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


        /* ============================================================
           PAGINATION
           ============================================================ */

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


        /* ============================================================
           TOAST
           ============================================================ */

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


        /* ============================================================
           FOOTER
           ============================================================ */

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
        /* ============================================================
           SELECTOR FIELD
           ============================================================ */

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


        /* ============================================================
           SELECTION MODAL
           ============================================================ */

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


        /* ============================================================
           POPUP SEARCH
           ============================================================ */

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


        /* ============================================================
           POPUP CONTENT
           ============================================================ */

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


        /* ============================================================
           SELECTION ITEM
           ============================================================ */

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


        /* ============================================================
           POPUP EMPTY STATE
           ============================================================ */

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


        /* ============================================================
           SELECTED INFORMATION
           ============================================================ */

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
        /* ============================================================
   ADD ADDRESS BUTTON
   ============================================================ */

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
        /* ============================================================
   ADDRESS MODAL
   ============================================================ */

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

        /* =========================================================
   ALERT SELECTOR FIELDS
   Same visual style as Shipment selector fields
   ========================================================= */

        .selector-field {
            width: 100%;
            min-height: 46px;
            padding: 0 14px;

            display: flex;
            align-items: center;
            justify-content: space-between;

            background: #ffffff;
            border: 1px solid #d9e1e8;
            border-radius: 8px;

            color: #6b7280;
            font-size: 14px;

            cursor: pointer;

            transition:
                    border-color 0.2s ease,
                    box-shadow 0.2s ease,
                    background 0.2s ease;
        }

        .selector-field:hover {
            border-color: #0066ff;
            background: #fafcff;
        }

        .selector-field:focus,
        .selector-field.active {
            border-color: #0066ff;
            box-shadow: 0 0 0 3px rgba(0, 102, 255, 0.10);
        }

        .selector-field span {
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .selector-field span.selected {
            color: #2c3e50;
            font-weight: 500;
        }

        .selector-field i {
            color: #6b7280;
            font-size: 12px;
            flex-shrink: 0;
            margin-left: 10px;
        }


        /* =========================================================
           SELECTION POPUP OVERLAY
           ========================================================= */

        .selection-overlay {
            position: fixed;
            inset: 0;

            display: none;
            align-items: center;
            justify-content: center;

            background: rgba(15, 48, 64, 0.45);

            z-index: 9999;

            padding: 20px;
        }

        .selection-overlay.active {
            display: flex;
        }


        /* =========================================================
           SELECTION POPUP
           ========================================================= */

        .selection-modal {
            width: 100%;
            max-width: 520px;
            max-height: 80vh;

            background: #ffffff;

            border-radius: 14px;

            box-shadow:
                    0 20px 50px rgba(15, 48, 64, 0.20);

            overflow: hidden;

            animation: alertSelectorIn 0.2s ease-out;
        }

        @keyframes alertSelectorIn {

            from {
                opacity: 0;
                transform: translateY(-12px) scale(0.98);
            }

            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }


        /* =========================================================
           POPUP HEADER
           ========================================================= */

        .selection-modal-header {
            min-height: 64px;

            padding: 0 20px;

            display: flex;
            align-items: center;
            justify-content: space-between;

            border-bottom: 1px solid #e8edf2;
        }

        .selection-modal-header h3 {
            margin: 0;

            color: #2c3e50;

            font-size: 18px;
            font-weight: 600;
        }

        .selection-modal-header button {
            width: 34px;
            height: 34px;

            display: flex;
            align-items: center;
            justify-content: center;

            border: none;
            border-radius: 50%;

            background: #f1f4f7;

            color: #64748b;

            cursor: pointer;

            transition:
                    background 0.2s ease,
                    color 0.2s ease;
        }

        .selection-modal-header button:hover {
            background: #e8edf2;
            color: #2c3e50;
        }


        /* =========================================================
           POPUP LIST
           ========================================================= */

        .selection-list {
            max-height: calc(80vh - 64px);

            overflow-y: auto;

            padding: 8px;
        }


        /* =========================================================
           POPUP ITEM
           ========================================================= */

        .selection-item {
            min-height: 64px;

            padding: 12px 14px;

            display: flex;
            align-items: center;
            justify-content: space-between;

            border-radius: 9px;

            cursor: pointer;

            transition:
                    background 0.2s ease,
                    transform 0.15s ease;
        }

        .selection-item:hover {
            background: #f4f7f9;
        }

        .selection-item:active {
            transform: scale(0.99);
        }

        .selection-item > div {
            min-width: 0;
        }

        .selection-item strong {
            display: block;

            color: #2c3e50;

            font-size: 14px;
            font-weight: 600;

            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .selection-item small {
            display: block;

            margin-top: 4px;

            color: #7b8794;

            font-size: 12px;
        }

        .selection-item > i {
            color: #94a3b8;
            font-size: 12px;

            margin-left: 12px;

            flex-shrink: 0;
        }

        .selection-item:hover > i {
            color: #0066ff;
        }


        /* =========================================================
           BODY LOCK WHEN POPUP IS OPEN
           ========================================================= */

        body.modal-open {
            overflow: hidden;
        }


        /* =========================================================
           FIELD ERROR
           ========================================================= */

        .field-error {
            display: none;

            margin-top: 5px;

            color: #dc3545;

            font-size: 12px;
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

<div class="success-toast" id="successToast">

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

<div class="error-toast" id="errorToast">

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
                    Shipment Management
                </h1>

                <p>
                    Create, monitor and manage GlobalTrade shipments.
                </p>

            </div>


            <button class="btn btn-primary"
                    type="button"
                    onclick="openShipmentModal()">

                <i class="fa-solid fa-plus"></i>

                Create Shipment

            </button>

        </div>


        <!-- ====================================================
             STATISTICS
             ==================================================== -->

        <div class="stats-grid">


            <!-- TOTAL -->

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-boxes-stacked"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Total Shipments
                    </span>

                    <span class="stat-value"
                          id="totalShipments">
    <%= totalShipments %>
</span>

                </div>

            </div>


            <!-- PENDING -->

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-clock"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Pending
                    </span>

                    <span class="stat-value"
                          id="pendingShipments">
    <%= pendingShipments %>
</span>

                </div>

            </div>


            <!-- IN TRANSIT -->

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-truck-fast"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        In Transit
                    </span>

                    <span class="stat-value"
                          id="transitShipments">
    <%= transitShipments %>
</span>

                </div>

            </div>


            <!-- DELIVERED -->

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="fa-solid fa-circle-check"></i>

                </div>

                <div class="stat-text">

                    <span class="stat-label">
                        Delivered
                    </span>

                    <span class="stat-value"
                          id="deliveredShipments">
    <%= deliveredShipments %>
</span>

                </div>

            </div>

        </div>


        <!-- ====================================================
             SHIPMENT TABLE CARD
             ==================================================== -->

        <div class="card">


            <!-- CARD HEADER -->

            <div class="card-header">

                <h2>
                    All Shipments
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
                           id="shipmentSearch"
                           placeholder="Search tracking number, origin or destination..."
                           onkeyup="filterShipments()">

                </div>


                <!-- STATUS -->

                <select
                        id="statusFilter"
                        class="filter-select"
                        onchange="filterShipments()"
                >
                    <option value="">
                        All Statuses
                    </option>

                    <%
                        if (shipmentStatuses != null) {
                            for (ShipmentStatus shipmentStatus : shipmentStatuses) {
                    %>

                    <option value="<%= shipmentStatus.getName() %>">
                        <%= shipmentStatus.getName() %>
                    </option>

                    <%
                            }
                        }
                    %>

                </select>


                <!-- VENDOR -->

                <!-- ============================================================
        VENDOR
        ============================================================ -->

                <!-- VENDOR FILTER -->

                <select class="filter-select"
                        id="vendorFilter"
                        onchange="filterShipments()">

                    <option value="">
                        All Vendors
                    </option>

                    <%
                        if (vendors != null) {

                            for (Vendor vendor : vendors) {
                    %>

                    <option value="<%= vendor.getCompanyName() %>">
                        <%= vendor.getCompanyName() %>
                    </option>

                    <%
                            }
                        }
                    %>

                </select>


                <!-- SEARCH BUTTON -->

                <button class="btn btn-primary"
                        type="button"
                        onclick="filterShipments()"
                        style="height:35px;">

                    <i class="fa-solid fa-magnifying-glass"></i>

                    Search

                </button>

            </div>


            <!-- =================================================
                 TABLE
                 ================================================= -->

            <div class="table-wrapper">

                <table class="shipment-table"
                       id="shipmentTable">


                    <thead>

                    <tr>

                        <th>
                            Tracking
                        </th>

                        <th>
                            Origin
                        </th>

                        <th>
                            Destination
                        </th>

                        <th>
                            Vendor
                        </th>

                        <th>
                            Expected Delivery
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Actions
                        </th>

                    </tr>

                    </thead>


                    <tbody id="shipmentTableBody">

                    <%

                        if (shipments != null && !shipments.isEmpty()) {

                            for (Shipment shipment : shipments) {

                                // =================================================
                                // ORIGIN ADDRESS
                                // =================================================

                                String origin = "";

                                if (shipment.getOriginAddress() != null) {

                                    String line1 =
                                            shipment.getOriginAddress().getLine1();

                                    String line2 =
                                            shipment.getOriginAddress().getLine2();

                                    String city = shipment.getOriginAddress().getCity() != null
                                            ? shipment.getOriginAddress().getCity().getName()
                                            : "";

                                    origin =
                                            (line1 != null ? line1 : "")
                                                    + (line2 != null && !line2.trim().isEmpty()
                                                    ? ", " + line2
                                                    : "")
                                                    + (city != null && !city.trim().isEmpty()
                                                    ? ", " + city
                                                    : "");
                                }


                                // =================================================
                                // DESTINATION ADDRESS
                                // =================================================

                                String destination = "";

                                if (shipment.getDestinationAddress() != null) {

                                    String line1 =
                                            shipment.getDestinationAddress().getLine1();

                                    String line2 =
                                            shipment.getDestinationAddress().getLine2();

                                    String city = shipment.getDestinationAddress().getCity() != null
                                            ? shipment.getDestinationAddress().getCity().getName()
                                            : "";

                                    destination =
                                            (line1 != null ? line1 : "")
                                                    + (line2 != null && !line2.trim().isEmpty()
                                                    ? ", " + line2
                                                    : "")
                                                    + (city != null && !city.trim().isEmpty()
                                                    ? ", " + city
                                                    : "");
                                }
                    %>

                    <tr
                            data-tracking="<%= shipment.getTrackingNumber() != null
                ? shipment.getTrackingNumber()
                : "" %>"

                            data-vendor="<%= shipment.getVendor() != null
                && shipment.getVendor().getCompanyName() != null
                ? shipment.getVendor().getCompanyName()
                : "" %>"

                            data-status="<%= shipment.getShipmentStatus() != null
                && shipment.getShipmentStatus().getName() != null
                ? shipment.getShipmentStatus().getName()
                : "" %>"

                            data-origin="<%= origin %>"

                            data-destination="<%= destination %>"
                    >


                        <!-- =================================================
                             TRACKING
                             ================================================= -->

                        <td>

                            <strong>
                                <%= shipment.getTrackingNumber() != null
                                        ? shipment.getTrackingNumber()
                                        : "N/A" %>
                            </strong>

                        </td>


                        <!-- =================================================
                             ORIGIN
                             ================================================= -->

                        <td>

                            <%= !origin.isEmpty()
                                    ? origin
                                    : "N/A" %>

                        </td>


                        <!-- =================================================
                             DESTINATION
                             ================================================= -->

                        <td>

                            <%= !destination.isEmpty()
                                    ? destination
                                    : "N/A" %>

                        </td>


                        <!-- =================================================
                             VENDOR
                             ================================================= -->

                        <td>

                            <%= shipment.getVendor() != null
                                    && shipment.getVendor().getCompanyName() != null
                                    ? shipment.getVendor().getCompanyName()
                                    : "N/A" %>

                        </td>


                        <!-- =================================================
                             EXPECTED DELIVERY
                             ================================================= -->

                        <td>

                            <%= shipment.getExpectedDelivery() != null
                                    ? shipment.getExpectedDelivery()
                                    : "N/A" %>

                        </td>


                        <!-- =================================================
                             STATUS
                             ================================================= -->

                        <td>

        <span class="status-badge">

            <%= shipment.getShipmentStatus() != null
                    && shipment.getShipmentStatus().getName() != null
                    ? shipment.getShipmentStatus().getName()
                    : "N/A" %>

        </span>

                        </td>


                        <!-- =================================================
                             ACTIONS
                             ================================================= -->

                        <td>

                            <div class="action-buttons">

                                <button
                                        type="button"
                                        class="btn btn-primary"
                                        onclick="openUpdateShipmentModal(<%= shipment.getId() %>)"
                                >
                                    <i class="fa-solid fa-pen"></i>
                                    Update
                                </button>


                                <button
                                        type="button"
                                        class="btn btn-danger"
                                        onclick="deleteShipment(<%= shipment.getId() %>)"
                                >

                                    <i class="fa-solid fa-trash"></i>

                                    Delete

                                </button>

                            </div>

                        </td>

                    </tr>

                    <%
                            }
                        }
                    %>

                    </tbody>
                </table>


                <!-- =================================================
                     EMPTY STATE
                     ================================================= -->

                <div class="empty-state"
                     id="emptyState">

                    <i class="fa-solid fa-box-open"></i>

                    <h3>
                        No shipments found
                    </h3>

                    <p>
                        There are currently no shipments matching
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

                    Showing 0 shipments

                </span>


                <div class="pagination">

                    <button class="page-btn active">
                        1
                    </button>

                    <button class="page-btn">
                        2
                    </button>

                    <button class="page-btn">
                        3
                    </button>

                    <button class="page-btn">

                        <i class="fa-solid fa-chevron-right"></i>

                    </button>

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

                Administrator Portal • Version 1.0.0

            </span>

        </footer>


    </section>

</main>


<!-- ============================================================
     CREATE SHIPMENT MODAL
     ============================================================ -->

<div class="modal-overlay"
     id="shipmentModal">


    <div class="shipment-modal">


        <!-- HEADER -->

        <div class="modal-header">

            <h2>
                <i class="fa-solid fa-truck-fast"
                   style="color:var(--orange);margin-right:7px;">
                </i>

                <span id="shipmentModalTitle">
        Create New Shipment
    </span>
            </h2>


            <button class="modal-close"
                    type="button"
                    onclick="closeShipmentModal()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <!-- BODY -->

        <div class="modal-body">


            <form id="shipmentForm"
                  action="${pageContext.request.contextPath}/admin/create-shipment"
                  method="post">

                <input type="hidden"
                       name="id"
                       id="shipmentId">


                <div class="form-grid">

                    <!-- TRACKING NUMBER -->

                    <!-- TRACKING NUMBER -->
                    <div class="form-group">

                        <label class="form-label">
                            Tracking Number
                        </label>

                        <!-- CREATE MODE -->
                        <div id="trackingCreateDisplay"
                             style="
            height:38px;
            padding:0 11px;
            border:1px solid var(--border);
            border-radius:7px;
            background:#F8FAFC;
            color:var(--muted);
            font-size:10px;
            display:flex;
            align-items:center;
            gap:7px;
         ">

                            <i class="fa-solid fa-wand-magic-sparkles"
                               style="color:var(--orange);">
                            </i>

                            Automatically generated

                        </div>


                        <!-- UPDATE MODE -->
                        <div id="trackingUpdateDisplay"
                             style="
            height:38px;
            padding:0 11px;
            border:1px solid var(--border);
            border-radius:7px;
            background:#F8FAFC;
            color:#334155;
            font-size:11px;
            display:none;
            align-items:center;
            justify-content:space-between;
         ">

                            <strong id="trackingNumberDisplay">
                                -
                            </strong>

                            <span style="color:var(--muted);font-size:9px;">
            <i class="fa-solid fa-lock"></i>
            Read only
        </span>

                        </div>

                    </div>


                    <!-- VENDOR -->

                    <!-- ============================================================
      VENDOR
      ============================================================ -->

                    <div class="form-group">

                        <label class="form-label">
                            Vendor
                        </label>

                        <div class="selector-field">

                            <div class="selector-display placeholder"
                                 id="vendorDisplay">

                                Select Vendor

                            </div>

                            <button type="button"
                                    class="selector-button"
                                    onclick="openSelector('vendor')">

                                <i class="fa-solid fa-building"></i>

                                Select

                            </button>

                        </div>

                        <input type="hidden"
                               name="vendorId"
                               id="vendorId"
                               required>

                        <div class="selected-info"
                             id="vendorSelectedInfo"
                             style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Vendor selected

                        </div>

                    </div>


                    <!-- ORIGIN -->

                    <!-- ORIGIN -->

                    <div class="form-group">

                        <label class="form-label">
                            Origin
                        </label>

                        <div class="selector-field">

                            <div class="selector-display placeholder"
                                 id="originDisplay">

                                Select Origin Address

                            </div>

                            <button type="button"
                                    class="selector-button"
                                    onclick="openSelector('origin')">

                                <i class="fa-solid fa-location-dot"></i>

                                Select

                            </button>

                        </div>

                        <input type="hidden"
                               name="originAddressId"
                               id="originAddressId"
                               required>

                        <input type="hidden"
                               name="origin"
                               id="origin"
                               required>

                        <div class="selected-info"
                             id="originSelectedInfo"
                             style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Origin address selected

                        </div>

                    </div>


                    <!-- DESTINATION -->

                    <!-- DESTINATION -->

                    <div class="form-group">

                        <label class="form-label">
                            Destination
                        </label>

                        <div class="selector-field">

                            <div class="selector-display placeholder"
                                 id="destinationDisplay">

                                Select Destination Address

                            </div>

                            <button type="button"
                                    class="selector-button"
                                    onclick="openSelector('destination')">

                                <i class="fa-solid fa-location-dot"></i>

                                Select

                            </button>

                        </div>

                        <input type="hidden"
                               name="destinationAddressId"
                               id="destinationAddressId"
                               required>

                        <input type="hidden"
                               name="destination"
                               id="destination"
                               required>

                        <div class="selected-info"
                             id="destinationSelectedInfo"
                             style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Destination address selected

                        </div>

                    </div>


                    <!-- EXPECTED DELIVERY -->

                    <div class="form-group">

                        <label class="form-label">

                            Expected Delivery

                        </label>

                        <input type="datetime-local"
                               name="expectedDelivery"
                               class="form-input"
                               required>

                    </div>


                    <!-- STATUS -->

                    <div class="mb-3">

                        <label for="shipmentStatusId" class="form-label">
                            Shipment Status
                        </label>

                        <select
                                name="shipmentStatusId"
                                id="shipmentStatusId"
                                class="form-select"
                                required
                        >

                            <option value="">
                                Select Shipment Status
                            </option>

                            <%
                                if (shipmentStatuses != null) {

                                    for (ShipmentStatus shipmentStatus : shipmentStatuses) {
                            %>

                            <option value="<%= shipmentStatus.getId() %>">
                                <%= shipmentStatus.getName() %>
                            </option>

                            <%
                                    }
                                }
                            %>

                        </select>

                    </div>


                    <!-- ITEM -->

                    <!-- INVENTORY ITEM -->

                    <div class="form-group full">

                        <label class="form-label">
                            Inventory Item
                        </label>

                        <div class="selector-field">

                            <div class="selector-display placeholder"
                                 id="inventoryDisplay">

                                Select Inventory Item

                            </div>

                            <button type="button"
                                    class="selector-button"
                                    onclick="openSelector('inventory')">

                                <i class="fa-solid fa-box-open"></i>

                                Select

                            </button>

                        </div>

                        <input type="hidden"
                               name="inventoryId"
                               id="inventoryId"
                               required>

                        <div class="selected-info"
                             id="inventorySelectedInfo"
                             style="display:none;">

                            <i class="fa-solid fa-circle-check"></i>

                            Inventory item selected

                        </div>

                    </div>


                    <!-- QUANTITY -->

                    <div class="form-group">

                        <label class="form-label">

                            Quantity

                        </label>

                        <input type="number"
                               name="quantity"
                               class="form-input"
                               min="1"
                               placeholder="Quantity"
                               required>

                    </div>


                    <!-- UNIT VALUE -->

                    <div class="form-group">

                        <label class="form-label">

                            Unit Value

                        </label>

                        <input type="number"
                               name="unitValue"
                               class="form-input"
                               min="0"
                               step="0.01"
                               placeholder="0.00"
                               required>

                    </div>


                    <!-- INFORMATION -->

                    <div class="form-group full">

                        <div style="
                            padding:11px;
                            background:#FFF9E8;
                            border:1px solid #F8E4A9;
                            border-radius:7px;
                            color:var(--muted);
                            font-size:9px;
                            line-height:1.6;
                        ">

                            <i class="fa-solid fa-circle-info"
                               style="color:var(--orange);margin-right:5px;">
                            </i>

                            The shipment will be created with the
                            selected vendor, inventory item and
                            shipment status. The actual delivery
                            date will remain empty until the shipment
                            is delivered.

                        </div>

                    </div>


                </div>


                <!-- FOOTER -->

                <div class="modal-footer">

                    <button type="button"
                            class="btn btn-secondary"
                            onclick="closeShipmentModal()">

                        Cancel

                    </button>


                    <button type="submit"
                            class="btn btn-primary"
                            id="shipmentSubmitButton">

                        <i class="fa-solid fa-check"></i>

                        <span id="shipmentSubmitText">
        Create Shipment
    </span>

                    </button>

                </div>


            </form>

        </div>

    </div>

</div>

<!-- ============================================================
     SELECTOR POPUP
     ============================================================ -->
<!-- ============================================================
     SELECTOR POPUP
     ============================================================ -->

<div class="selection-overlay"
     id="selectionOverlay">

    <div class="selection-modal">

        <!-- HEADER -->
        <div class="selection-modal-header">

            <h2 id="selectionTitle">
                <i class="fa-solid fa-list"></i>
                Select
            </h2>

            <div style="
                display:flex;
                align-items:center;
                gap:7px;
            ">

                <!-- ADD ADDRESS -->
                <button
                        type="button"
                        id="addAddressButton"
                        class="selection-add-button"
                        onclick="openAddressModal()"
                        style="display:none;">

                    <i class="fa-solid fa-plus"></i>
                    Add New Address

                </button>

                <!-- CLOSE -->
                <button
                        type="button"
                        class="selection-close"
                        onclick="closeSelector()">

                    <i class="fa-solid fa-xmark"></i>

                </button>

            </div>

        </div>


        <!-- SEARCH -->
        <div class="selection-search-area">

            <div class="selection-search-wrapper">

                <i class="fa-solid fa-magnifying-glass"></i>

                <input
                        type="text"
                        id="selectionSearch"
                        class="selection-search"
                        placeholder="Search..."
                        onkeyup="searchSelection()">

            </div>

        </div>


        <!-- CONTENT -->
        <div
                class="selection-content"
                id="selectionContent">

        </div>


        <!-- EMPTY -->
        <div
                class="selection-empty"
                id="selectionEmpty"
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

<!-- ============================================================
     ADD ADDRESS MODAL
     ============================================================ -->

<div class="address-overlay"
     id="addressOverlay">

    <div class="address-modal">

        <!-- HEADER -->

        <div class="address-modal-header">

            <h2>

                <i class="fa-solid fa-location-dot"></i>

                Add New Address

            </h2>


            <button
                    type="button"
                    class="selection-close"
                    onclick="closeAddressModal()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <!-- BODY -->

        <div class="address-modal-body">

            <form id="addressForm">


                <!-- LINE 1 -->

                <div class="address-form-group">

                    <label>
                        Address Line 1
                    </label>

                    <input
                            type="text"
                            id="addressLine1"
                            name="line1"
                            maxlength="100"
                            required
                            placeholder="Enter address line 1">

                </div>


                <!-- LINE 2 -->

                <div class="address-form-group">

                    <label>
                        Address Line 2
                        <span>(Optional)</span>
                    </label>

                    <input
                            type="text"
                            id="addressLine2"
                            name="line2"
                            maxlength="100"
                            placeholder="Enter address line 2">

                </div>


                <!-- COUNTRY -->

                <div class="address-form-group">

                    <label>
                        Country
                    </label>

                    <select
                            id="addressCountry"
                            name="countryId"
                            required
                            onchange="loadAddressCities()">

                        <option value="">
                            Select Country
                        </option>

                        <%
                            if (countries != null) {

                                for (Country country
                                        : countries) {
                        %>

                        <option value="<%= country.getId() %>">
                            <%= country.getName() %>
                        </option>

                        <%
                                }
                            }
                        %>

                    </select>

                </div>


                <!-- CITY -->

                <div class="address-form-group">

                    <label>
                        City
                    </label>

                    <select
                            id="addressCity"
                            name="cityId"
                            required
                            disabled>

                        <option value="">
                            Select Country First
                        </option>

                    </select>

                </div>


                <!-- POSTAL CODE -->

                <div class="address-form-group">

                    <label>
                        Postal Code
                    </label>

                    <input
                            type="text"
                            id="addressPostalCode"
                            name="postalCode"
                            maxlength="45"
                            required
                            placeholder="Enter postal code">

                </div>


                <!-- CONTACT NAME -->

                <div class="address-form-group">

                    <label>
                        Contact Name
                    </label>

                    <input
                            type="text"
                            id="addressContactName"
                            name="contactName"
                            maxlength="100"
                            required
                            placeholder="Enter contact name">

                </div>


                <!-- CONTACT PHONE -->

                <div class="address-form-group">

                    <label>
                        Contact Phone
                    </label>

                    <input
                            type="text"
                            id="addressContactPhone"
                            name="contactPhone"
                            maxlength="45"
                            required
                            placeholder="Enter contact phone">

                </div>


                <!-- ERROR -->

                <div id="addressError"
                     style="
                        display:none;
                        margin-top:10px;
                        padding:9px;
                        border-radius:6px;
                        background:#FEF2F2;
                        color:#B91C1C;
                        font-size:9px;
                     ">
                </div>


                <!-- ACTIONS -->

                <div style="
                    display:flex;
                    justify-content:flex-end;
                    gap:8px;
                    margin-top:15px;
                ">

                    <button
                            type="button"
                            class="btn btn-secondary"
                            onclick="closeAddressModal()">

                        Cancel

                    </button>


                    <button
                            type="submit"
                            class="btn btn-primary">

                        <i class="fa-solid fa-check"></i>

                        Save Address

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>
<!-- ============================================================
     JAVASCRIPT
     ============================================================ -->

<script>


    /*
     * ============================================================
     * OPEN MODAL
     * ============================================================
     */

    // ============================================================
    // SHIPMENT MODAL MODE
    // ============================================================

    let shipmentModalMode = "create";


    // ============================================================
    // CREATE SHIPMENT
    // ============================================================

    function openShipmentModal() {

        shipmentModalMode = "create";

        const form =
            document.getElementById("shipmentForm");

        form.reset();

        document.getElementById("shipmentId").value = "";

        form.action =
            "${pageContext.request.contextPath}/admin/create-shipment";


        // TITLE

        document.getElementById(
            "shipmentModalTitle"
        ).textContent = "Create New Shipment";


        // BUTTON

        document.getElementById(
            "shipmentSubmitText"
        ).textContent = "Create Shipment";


        // TRACKING

        document.getElementById(
            "trackingCreateDisplay"
        ).style.display = "flex";

        document.getElementById(
            "trackingUpdateDisplay"
        ).style.display = "none";


        // RESET SELECTORS

        resetShipmentSelectors();


        // OPEN

        document
            .getElementById("shipmentModal")
            .classList.add("show");
    }



    // ============================================================
    // UPDATE SHIPMENT
    // ============================================================

    function openUpdateShipmentModal(shipmentId) {

        shipmentModalMode = "update";


        if (!shipmentId) {

            alert("Invalid shipment ID.");

            return;
        }


        // Show loading modal

        document
            .getElementById("shipmentModal")
            .classList.add("show");


        document.getElementById(
            "shipmentModalTitle"
        ).textContent = "Update Shipment";


        document.getElementById(
            "shipmentSubmitText"
        ).textContent = "Update Shipment";


        document.getElementById(
            "trackingCreateDisplay"
        ).style.display = "none";


        document.getElementById(
            "trackingUpdateDisplay"
        ).style.display = "flex";


        // Load shipment

        fetch(
            "${pageContext.request.contextPath}/admin/update-shipment?id="
            + encodeURIComponent(shipmentId),
            {
                method: "GET",
                headers: {
                    "Accept": "application/json"
                }
            }
        )
            .then(function(response) {

                if (!response.ok) {

                    throw new Error(
                        "Unable to load shipment."
                    );
                }

                return response.json();
            })
            .then(function(shipment) {

                populateShipmentUpdateForm(
                    shipment
                );

            })
            .catch(function(error) {

                console.error(error);

                alert(
                    "Unable to load shipment details."
                );

                closeShipmentModal();

            });
    }


    /*
     * ============================================================
     * CLOSE MODAL
     * ============================================================
     */

    function closeShipmentModal() {

        document
            .getElementById("shipmentModal")
            .classList.remove("show");
    }


    /*
     * ============================================================
     * CLOSE MODAL WHEN CLICKING OUTSIDE
     * ============================================================
     */

    document
        .getElementById("shipmentModal")
        .addEventListener(
            "click",
            function (event) {

                if (event.target === this) {

                    closeShipmentModal();
                }
            }
        );


    /*
     * ============================================================
     * SEARCH / FILTER
     * ============================================================
     */

    // ============================================================
    // SEARCH / FILTER SHIPMENTS
    // ============================================================

    /*
 * ============================================================
 * SEARCH / FILTER SHIPMENTS
 * ============================================================
 */

    function filterShipments() {

        const searchElement =
            document.getElementById("shipmentSearch");

        const statusElement =
            document.getElementById("statusFilter");

        const vendorElement =
            document.getElementById("vendorFilter");


        const search =
            searchElement
                ? searchElement.value.toLowerCase().trim()
                : "";


        const status =
            statusElement
                ? statusElement.value.toLowerCase().trim()
                : "";


        const vendor =
            vendorElement
                ? vendorElement.value.toLowerCase().trim()
                : "";


        const rows =
            document.querySelectorAll(
                "#shipmentTableBody tr"
            );


        let visibleCount = 0;


        rows.forEach(function(row) {

            /*
             * Get the values stored in the row.
             */
            const rowTracking =
                (row.dataset.tracking || "")
                    .toLowerCase();

            const rowOrigin =
                (row.dataset.origin || "")
                    .toLowerCase();

            const rowDestination =
                (row.dataset.destination || "")
                    .toLowerCase();

            const rowStatus =
                (row.dataset.status || "")
                    .toLowerCase();

            const rowVendor =
                (row.dataset.vendor || "")
                    .toLowerCase();


            /*
             * SEARCH
             */
            const matchesSearch =
                search === "" ||
                rowTracking.includes(search) ||
                rowOrigin.includes(search) ||
                rowDestination.includes(search) ||
                rowVendor.includes(search);


            /*
             * STATUS
             */
            const matchesStatus =
                status === "" ||
                rowStatus === status;


            /*
             * VENDOR
             */
            const matchesVendor =
                vendor === "" ||
                rowVendor === vendor;


            /*
             * SHOW / HIDE
             */
            if (
                matchesSearch &&
                matchesStatus &&
                matchesVendor
            ) {

                row.style.display = "";

                visibleCount++;

            } else {

                row.style.display = "none";
            }

        });


        /*
         * TABLE COUNT
         */
        const tableInfo =
            document.getElementById("tableInfo");

        if (tableInfo) {

            tableInfo.innerText =
                "Showing " +
                visibleCount +
                " shipments";
        }


        /*
         * EMPTY STATE
         */
        const emptyState =
            document.getElementById("emptyState");

        if (emptyState) {

            emptyState.style.display =
                visibleCount === 0
                    ? "block"
                    : "none";
        }
    }


    /*
     * ============================================================
     * RESET FILTERS
     * ============================================================
     */

    /*
  * ============================================================
  * RESET FILTERS
  * ============================================================
  */

    function resetFilters() {

        const searchElement =
            document.getElementById("shipmentSearch");

        const statusElement =
            document.getElementById("statusFilter");

        const vendorElement =
            document.getElementById("vendorFilter");


        /*
         * Clear search
         */
        if (searchElement) {
            searchElement.value = "";
        }


        /*
         * Reset status dropdown
         */
        if (statusElement) {
            statusElement.selectedIndex = 0;
            statusElement.value = "";
        }


        /*
         * Reset vendor dropdown
         */
        if (vendorElement) {
            vendorElement.selectedIndex = 0;
            vendorElement.value = "";
        }


        /*
         * Show all shipments again
         */
        filterShipments();
    }


    /*
     * ============================================================
     * TOAST
     * ============================================================
     */

    function closeToast(id) {

        const toast =
            document.getElementById(id);

        if (toast) {

            toast.remove();
        }
    }


    /*
     * ============================================================
     * AUTO CLOSE TOAST
     * ============================================================
     */

    setTimeout(function () {

        closeToast("successToast");

        closeToast("errorToast");

    }, 4000);


    /*
     * ============================================================
     * INITIAL TABLE STATE
     * ============================================================
     */

    document.addEventListener(
        "DOMContentLoaded",
        function () {

            filterShipments();

        }
    );
    /* ============================================================
 * SELECTOR POPUP
 * ============================================================ */

    let currentSelector = "";


    /*
     * ============================================================
     * OPEN SELECTOR
     * ============================================================
     */

    function openSelector(type) {

        currentSelector = type;


        const overlay =
            document.getElementById(
                "selectionOverlay"
            );


        const title =
            document.getElementById(
                "selectionTitle"
            );


        const search =
            document.getElementById(
                "selectionSearch"
            );


        const addAddressButton =
            document.getElementById(
                "addAddressButton"
            );


        let titleText = "";

        let placeholderText = "";


        if (type === "vendor") {

            titleText = "Select Vendor";

            placeholderText =
                "Search vendor by company name...";


            addAddressButton.style.display =
                "none";
        }


        else if (type === "origin") {

            titleText =
                "Select Origin Address";

            placeholderText =
                "Search origin address...";


            addAddressButton.style.display =
                "flex";
        }


        else if (type === "destination") {

            titleText =
                "Select Destination Address";

            placeholderText =
                "Search destination address...";


            addAddressButton.style.display =
                "flex";
        }


        else if (type === "inventory") {

            titleText =
                "Select Inventory Item";

            placeholderText =
                "Search item, SKU or category...";


            addAddressButton.style.display =
                "none";
        }


        title.innerHTML =
            '<i class="fa-solid fa-list"></i>'
            + titleText;


        search.placeholder =
            placeholderText;


        search.value = "";


        loadSelectionData();


        overlay.classList.add("show");


        setTimeout(function () {

            search.focus();

        }, 100);
    }


    /*
     * ============================================================
     * CLOSE SELECTOR
     * ============================================================
     */

    function closeSelector() {

        document
            .getElementById("selectionOverlay")
            .classList.remove("show");

        currentSelector = "";
    }


    /*
     * ============================================================
     * CLICK OUTSIDE POPUP
     * ============================================================
     */

    document
        .getElementById("selectionOverlay")
        .addEventListener(
            "click",
            function (event) {

                if (event.target === this) {

                    closeSelector();
                }

            }
        );


    /*
     * ============================================================
     * LOAD SELECTION DATA
     * ============================================================
     */

    function loadSelectionData() {

        const content =
            document.getElementById("selectionContent");

        const empty =
            document.getElementById("selectionEmpty");


        content.innerHTML = "";

        empty.style.display = "none";


        /*
         * ----------------------------------------------------------
         * VENDORS
         * ----------------------------------------------------------
         */

        if (currentSelector === "vendor") {

            <%
                if (vendors != null) {

                    for (Vendor vendor : vendors) {
            %>

            addSelectionItem({

                type: "vendor",

                id: "<%= vendor.getId() %>",

                title: "<%= vendor.getCompanyName()
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", " ")
                    .replace("\r", " ") %>",

                subtitle:
                    "Vendor ID: <%= vendor.getId() %>"

            });

            <%
                    }

                }
            %>

        }


        /*
         * ----------------------------------------------------------
         * ADDRESSES
         * ----------------------------------------------------------
         */

        else if (
            currentSelector === "origin" ||
            currentSelector === "destination"
        ) {

            <%
    List<Address> addresses =
            (List<Address>) request.getAttribute("addresses");

    if (addresses != null) {

        for (Address address : addresses) {
%>

            addSelectionItem({

                type: currentSelector,

                id: "<%= getAddressId(address) %>",

                title:
                    "<%= getAddressTitle(address) %>",

                subtitle:
                    "<%= getAddressSubtitle(address) %>"

            });

            <%
                    }

                }
            %>

        }


        /*
         * ----------------------------------------------------------
         * INVENTORY
         * ----------------------------------------------------------
         */

        else if (currentSelector === "inventory") {

            <%
     if (inventoryItems != null) {

         for (Inventory inventory : inventoryItems) {

             String inventoryName =
                     inventory.getProductName() != null
                             ? inventory.getProductName()
                             : "";

             String inventoryCode =
                     inventory.getProductCode() != null
                             ? inventory.getProductCode()
                             : "";

             String inventorySubtitle =
                     "Product Code: " + inventoryCode
                     + " • Available Quantity: "
                     + inventory.getQuantity();

             String safeInventoryName =
                     inventoryName
                             .replace("\\", "\\\\")
                             .replace("\"", "\\\"")
                             .replace("\r", " ")
                             .replace("\n", " ");

             String safeInventorySubtitle =
                     inventorySubtitle
                             .replace("\\", "\\\\")
                             .replace("\"", "\\\"")
                             .replace("\r", " ")
                             .replace("\n", " ");
 %>

            addSelectionItem({
                type: "inventory",
                id: "<%= inventory.getId() %>",
                title: "<%= safeInventoryName %>",
                subtitle: "<%= safeInventorySubtitle %>"
            });

            <%
                    }
                }
            %>

        }


        /*
         * ----------------------------------------------------------
         * CHECK EMPTY
         * ----------------------------------------------------------
         */

        if (content.children.length === 0) {

            empty.style.display = "block";
        }

    }


    /*
     * ============================================================
     * ADD POPUP ITEM
     * ============================================================
     */

    function addSelectionItem(data) {

        const content =
            document.getElementById("selectionContent");


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

                selectItem(
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


    /*
     * ============================================================
     * SELECT ITEM
     * ============================================================
     */

    function selectItem(
        type,
        id,
        title
    ) {


        if (type === "vendor") {

            document
                .getElementById("vendorId")
                .value = id;


            const display =
                document.getElementById("vendorDisplay");


            display.textContent =
                title;


            display.classList.remove(
                "placeholder"
            );


            document
                .getElementById("vendorSelectedInfo")
                .style.display = "flex";
        }


        else if (
            type === "origin"
        ) {

            document
                .getElementById("originAddressId")
                .value = id;


            document
                .getElementById("origin")
                .value = title;


            const display =
                document.getElementById(
                    "originDisplay"
                );


            display.textContent =
                title;


            display.classList.remove(
                "placeholder"
            );


            document
                .getElementById(
                    "originSelectedInfo"
                )
                .style.display = "flex";
        }


        else if (
            type === "destination"
        ) {

            document
                .getElementById(
                    "destinationAddressId"
                )
                .value = id;


            document
                .getElementById(
                    "destination"
                )
                .value = title;


            const display =
                document.getElementById(
                    "destinationDisplay"
                );


            display.textContent =
                title;


            display.classList.remove(
                "placeholder"
            );


            document
                .getElementById(
                    "destinationSelectedInfo"
                )
                .style.display = "flex";
        }


        else if (
            type === "inventory"
        ) {

            document
                .getElementById(
                    "inventoryId"
                )
                .value = id;


            const display =
                document.getElementById(
                    "inventoryDisplay"
                );


            display.textContent =
                title;


            display.classList.remove(
                "placeholder"
            );


            document
                .getElementById(
                    "inventorySelectedInfo"
                )
                .style.display = "flex";
        }


        closeSelector();
    }


    /*
     * ============================================================
     * SEARCH POPUP DATA
     * ============================================================
     */

    function searchSelection() {

        const search =
            document
                .getElementById(
                    "selectionSearch"
                )
                .value
                .toLowerCase()
                .trim();


        const items =
            document.querySelectorAll(
                "#selectionContent .selection-item"
            );


        let visibleCount = 0;


        items.forEach(function (item) {

            const text =
                item.innerText.toLowerCase();


            if (
                search === "" ||
                text.includes(search)
            ) {

                item.style.display = "";

                visibleCount++;

            } else {

                item.style.display = "none";
            }

        });


        const empty =
            document.getElementById(
                "selectionEmpty"
            );


        if (visibleCount === 0) {

            empty.style.display =
                "block";

        } else {

            empty.style.display =
                "none";
        }
    }

</script>
<script>

    function validateShipmentForm() {

        let valid = true;

        // ================================================
        // CLEAR PREVIOUS ERRORS
        // ================================================

        document.querySelectorAll(".shipment-error")
            .forEach(function (element) {

                element.remove();

            });


        document.querySelectorAll(".shipment-invalid")
            .forEach(function (element) {

                element.classList.remove(
                    "shipment-invalid"
                );

            });


        // ================================================
        // VENDOR
        // ================================================

        const vendor =
            document.getElementById("vendorId");

        if (!vendor || vendor.value === "") {

            showShipmentError(
                vendor,
                "Please select a vendor."
            );

            valid = false;
        }


        // ================================================
        // STATUS
        // ================================================

        const status =
            document.getElementById(
                "shipmentStatusId"
            );

        if (!status || status.value === "") {

            showShipmentError(
                status,
                "Please select a shipment status."
            );

            valid = false;
        }


        // ================================================
        // INVENTORY
        // ================================================

        const inventory =
            document.getElementById("inventoryId");

        if (!inventory || inventory.value === "") {

            showShipmentError(
                inventory,
                "Please select an inventory item."
            );

            valid = false;
        }


        // ================================================
        // ORIGIN
        // ================================================

        const origin =
            document.getElementById(
                "originAddressId"
            );

        if (!origin || origin.value === "") {

            showShipmentError(
                origin,
                "Please select an origin address."
            );

            valid = false;
        }


        // ================================================
        // DESTINATION
        // ================================================

        const destination =
            document.getElementById(
                "destinationAddressId"
            );

        if (!destination ||
            destination.value === "") {

            showShipmentError(
                destination,
                "Please select a destination address."
            );

            valid = false;
        }


        // ================================================
        // ORIGIN != DESTINATION
        // ================================================

        if (
            origin &&
            destination &&
            origin.value !== "" &&
            destination.value !== "" &&
            origin.value === destination.value
        ) {

            showShipmentError(
                destination,
                "Origin and destination cannot be the same."
            );

            valid = false;
        }


        // ================================================
        // EXPECTED DELIVERY
        // ================================================

        const expectedDelivery =
            document.getElementById(
                "expectedDelivery"
            );

        if (
            !expectedDelivery ||
            expectedDelivery.value === ""
        ) {

            showShipmentError(
                expectedDelivery,
                "Please select an expected delivery date."
            );

            valid = false;

        } else {

            const selectedDate =
                new Date(
                    expectedDelivery.value
                );

            const now =
                new Date();

            if (selectedDate <= now) {

                showShipmentError(
                    expectedDelivery,
                    "Expected delivery must be a future date."
                );

                valid = false;
            }
        }


        // ================================================
        // QUANTITY
        // ================================================

        const quantity =
            document.getElementById("quantity");

        if (
            !quantity ||
            quantity.value.trim() === ""
        ) {

            showShipmentError(
                quantity,
                "Quantity is required."
            );

            valid = false;

        } else if (
            isNaN(quantity.value) ||
            parseInt(quantity.value) <= 0
        ) {

            showShipmentError(
                quantity,
                "Quantity must be greater than zero."
            );

            valid = false;
        }


        // ================================================
        // UNIT VALUE
        // ================================================

        const unitValue =
            document.getElementById("unitValue");

        if (
            !unitValue ||
            unitValue.value.trim() === ""
        ) {

            showShipmentError(
                unitValue,
                "Unit value is required."
            );

            valid = false;

        } else if (
            isNaN(unitValue.value) ||
            parseFloat(unitValue.value) < 0
        ) {

            showShipmentError(
                unitValue,
                "Unit value cannot be negative."
            );

            valid = false;
        }


        // ================================================
        // STOP SUBMISSION
        // ================================================

        if (!valid) {

            const firstError =
                document.querySelector(
                    ".shipment-invalid"
                );

            if (firstError) {

                firstError.focus();

                firstError.scrollIntoView({
                    behavior: "smooth",
                    block: "center"
                });
            }

            return false;
        }


        return true;
    }


    // ====================================================
    // SHOW ERROR
    // ====================================================

    function showShipmentError(
        field,
        message
    ) {

        if (!field) {
            return;
        }


        field.classList.add(
            "shipment-invalid"
        );


        const error =
            document.createElement("div");

        error.className =
            "shipment-error";

        error.innerHTML =
            '<i class="fa-solid fa-circle-exclamation"></i> '
            + message;


        field.parentNode.appendChild(
            error
        );
    }
    // ============================================================
    // POPULATE UPDATE FORM
    // ============================================================

    function populateShipmentUpdateForm(shipment) {

        // ---------------------------------------------------------
        // SHIPMENT ID
        // ---------------------------------------------------------

        document.getElementById(
            "shipmentId"
        ).value = shipment.id;


        // ---------------------------------------------------------
        // TRACKING NUMBER
        // ---------------------------------------------------------

        document.getElementById(
            "trackingNumberDisplay"
        ).textContent =
            shipment.trackingNumber || "-";


        // ---------------------------------------------------------
        // VENDOR
        // ---------------------------------------------------------

        document.getElementById(
            "vendorId"
        ).value =
            shipment.vendorId || "";


        document.getElementById(
            "vendorDisplay"
        ).textContent =
            shipment.vendorName || "Select Vendor";


        document.getElementById(
            "vendorDisplay"
        ).classList.remove("placeholder");


        document.getElementById(
            "vendorSelectedInfo"
        ).style.display = "flex";


        // ---------------------------------------------------------
        // ORIGIN
        // ---------------------------------------------------------

        document.getElementById(
            "originAddressId"
        ).value =
            shipment.originAddressId || "";


        document.getElementById(
            "origin"
        ).value =
            shipment.originAddress || "";


        document.getElementById(
            "originDisplay"
        ).textContent =
            shipment.originAddress || "Select Origin Address";


        document.getElementById(
            "originDisplay"
        ).classList.remove("placeholder");


        document.getElementById(
            "originSelectedInfo"
        ).style.display = "flex";


        // ---------------------------------------------------------
        // DESTINATION
        // ---------------------------------------------------------

        document.getElementById(
            "destinationAddressId"
        ).value =
            shipment.destinationAddressId || "";


        document.getElementById(
            "destination"
        ).value =
            shipment.destinationAddress || "";


        document.getElementById(
            "destinationDisplay"
        ).textContent =
            shipment.destinationAddress ||
            "Select Destination Address";


        document.getElementById(
            "destinationDisplay"
        ).classList.remove("placeholder");


        document.getElementById(
            "destinationSelectedInfo"
        ).style.display = "flex";


        // ---------------------------------------------------------
        // EXPECTED DELIVERY
        // ---------------------------------------------------------

        document.querySelector(
            '[name="expectedDelivery"]'
        ).value =
            shipment.expectedDelivery
                ? shipment.expectedDelivery.substring(0, 16)
                : "";


        // ---------------------------------------------------------
        // STATUS
        // ---------------------------------------------------------

        document.getElementById(
            "shipmentStatusId"
        ).value =
            shipment.shipmentStatusId || "";


        // ---------------------------------------------------------
        // INVENTORY
        // ---------------------------------------------------------

        document.getElementById(
            "inventoryId"
        ).value =
            shipment.inventoryId || "";


        document.getElementById(
            "inventoryDisplay"
        ).textContent =
            shipment.inventoryName ||
            "Select Inventory Item";


        document.getElementById(
            "inventoryDisplay"
        ).classList.remove("placeholder");


        document.getElementById(
            "inventorySelectedInfo"
        ).style.display = "flex";


        // ---------------------------------------------------------
        // QUANTITY
        // ---------------------------------------------------------

        document.querySelector(
            '[name="quantity"]'
        ).value =
            shipment.quantity || "";


        // ---------------------------------------------------------
        // UNIT VALUE
        // ---------------------------------------------------------

        document.querySelector(
            '[name="unitValue"]'
        ).value =
            shipment.unitValue || "";
    }
    // ============================================================
    // RESET SHIPMENT SELECTORS
    // ============================================================

    function resetShipmentSelectors() {

        // Vendor

        document.getElementById(
            "vendorId"
        ).value = "";

        document.getElementById(
            "vendorDisplay"
        ).textContent = "Select Vendor";

        document.getElementById(
            "vendorDisplay"
        ).classList.add("placeholder");

        document.getElementById(
            "vendorSelectedInfo"
        ).style.display = "none";


        // Origin

        document.getElementById(
            "originAddressId"
        ).value = "";

        document.getElementById(
            "origin"
        ).value = "";

        document.getElementById(
            "originDisplay"
        ).textContent =
            "Select Origin Address";

        document.getElementById(
            "originDisplay"
        ).classList.add("placeholder");

        document.getElementById(
            "originSelectedInfo"
        ).style.display = "none";


        // Destination

        document.getElementById(
            "destinationAddressId"
        ).value = "";

        document.getElementById(
            "destination"
        ).value = "";

        document.getElementById(
            "destinationDisplay"
        ).textContent =
            "Select Destination Address";

        document.getElementById(
            "destinationDisplay"
        ).classList.add("placeholder");

        document.getElementById(
            "destinationSelectedInfo"
        ).style.display = "none";


        // Inventory

        document.getElementById(
            "inventoryId"
        ).value = "";

        document.getElementById(
            "inventoryDisplay"
        ).textContent =
            "Select Inventory Item";

        document.getElementById(
            "inventoryDisplay"
        ).classList.add("placeholder");

        document.getElementById(
            "inventorySelectedInfo"
        ).style.display = "none";
    }
    // ============================================================
    // FORM SUBMISSION
    // ============================================================

    document
        .getElementById("shipmentForm")
        .addEventListener(
            "submit",
            function () {

                if (shipmentModalMode === "update") {

                    this.action =
                        "${pageContext.request.contextPath}/admin/update-shipment";

                } else {

                    this.action =
                        "${pageContext.request.contextPath}/admin/create-shipment";
                }

            }
        );
    // ============================================================
    // DELETE SHIPMENT
    // ============================================================

    function deleteShipment(shipmentId) {

        if (!shipmentId) {

            alert("Invalid shipment ID.");

            return;
        }


        const confirmed =
            confirm(
                "Are you sure you want to delete this shipment?\n\n"
                + "The shipment will be permanently removed "
                + "and its inventory quantity will be restored."
            );


        if (!confirmed) {
            return;
        }


        const form =
            document.createElement("form");


        form.method = "POST";

        form.action =
            "${pageContext.request.contextPath}/admin/delete-shipment";


        const idInput =
            document.createElement("input");

        idInput.type = "hidden";

        idInput.name = "id";

        idInput.value = shipmentId;


        form.appendChild(idInput);


        document.body.appendChild(form);

        form.submit();
    }
    // ============================================================
    // OPEN ADDRESS MODAL
    // ============================================================

    function openAddressModal() {

        if (
            currentSelector !== "origin" &&
            currentSelector !== "destination"
        ) {

            return;
        }


        document
            .getElementById("addressForm")
            .reset();


        const city =
            document.getElementById(
                "addressCity"
            );


        city.innerHTML =
            '<option value="">'
            + 'Select Country First'
            + '</option>';


        city.disabled = true;


        document
            .getElementById("addressError")
            .style.display = "none";


        document
            .getElementById("addressOverlay")
            .classList.add("show");
    }
    // ============================================================
    // CLOSE ADDRESS MODAL
    // ============================================================

    function closeAddressModal() {

        const overlay =
            document.getElementById("addressOverlay");

        if (overlay) {

            overlay.classList.remove("show");

        }

    }
    // ============================================================
    // LOAD CITIES
    // ============================================================

    function loadAddressCities() {

        const countryId =
            document.getElementById(
                "addressCountry"
            ).value;


        const citySelect =
            document.getElementById(
                "addressCity"
            );


        citySelect.innerHTML =
            '<option value="">'
            + 'Loading cities...'
            + '</option>';


        citySelect.disabled = true;


        if (!countryId) {

            citySelect.innerHTML =
                '<option value="">'
                + 'Select Country First'
                + '</option>';

            return;
        }


        fetch(
            "${pageContext.request.contextPath}"
            + "/admin/address?action=cities"
            + "&countryId="
            + encodeURIComponent(countryId)
        )
            .then(function(response) {

                if (!response.ok) {

                    throw new Error(
                        "Unable to load cities."
                    );
                }

                return response.json();
            })
            .then(function(cities) {

                citySelect.innerHTML =
                    '<option value="">'
                    + 'Select City'
                    + '</option>';


                cities.forEach(function(city) {

                    const option =
                        document.createElement(
                            "option"
                        );


                    option.value =
                        city.id;


                    option.textContent =
                        city.name;


                    citySelect.appendChild(
                        option
                    );
                });


                if (cities.length === 0) {

                    citySelect.disabled = true;

                    citySelect.innerHTML =
                        '<option value="">'
                        + 'No cities available'
                        + '</option>';

                    return;
                }

                citySelect.disabled = false;

            })
            .catch(function(error) {

                console.error(error);


                citySelect.innerHTML =
                    '<option value="">'
                    + 'Unable to load cities'
                    + '</option>';
            });
    }
    // ============================================================
    // SAVE ADDRESS
    // ============================================================
    // ============================================================
    // SAVE ADDRESS
    // ============================================================

    document
        .getElementById("addressForm")
        .addEventListener("submit", function (e) {

            e.preventDefault();

            const form = this;

            const errorBox =
                document.getElementById("addressError");

            // -----------------------------------------------------
            // CLEAR PREVIOUS ERROR
            // -----------------------------------------------------

            if (errorBox) {
                errorBox.style.display = "none";
                errorBox.textContent = "";
            }


            // -----------------------------------------------------
            // GET VALUES DIRECTLY FROM INPUTS
            // -----------------------------------------------------

            const line1 =
                document.getElementById("addressLine1").value.trim();

            const line2 =
                document.getElementById("addressLine2").value.trim();

            const countryId =
                document.getElementById("addressCountry").value.trim();

            const cityId =
                document.getElementById("addressCity").value.trim();

            const postalCode =
                document.getElementById("addressPostalCode").value.trim();

            const contactName =
                document.getElementById("addressContactName").value.trim();

            const contactPhone =
                document.getElementById("addressContactPhone").value.trim();


            // -----------------------------------------------------
            // DEBUG
            // -----------------------------------------------------

            console.log("========== ADDRESS DATA ==========");
            console.log("line1:", line1);
            console.log("line2:", line2);
            console.log("countryId:", countryId);
            console.log("cityId:", cityId);
            console.log("postalCode:", postalCode);
            console.log("contactName:", contactName);
            console.log("contactPhone:", contactPhone);
            console.log("==================================");


            // -----------------------------------------------------
            // VALIDATION
            // -----------------------------------------------------

            if (!line1) {

                showAddressError(
                    "Please enter Address Line 1."
                );

                return;
            }


            if (!countryId) {

                showAddressError(
                    "Please select a country."
                );

                return;
            }


            if (!cityId) {

                showAddressError(
                    "Please select a city."
                );

                return;
            }


            if (!postalCode) {

                showAddressError(
                    "Please enter the postal code."
                );

                return;
            }


            if (!contactName) {

                showAddressError(
                    "Please enter the contact name."
                );

                return;
            }


            if (!contactPhone) {

                showAddressError(
                    "Please enter the contact phone."
                );

                return;
            }


            // -----------------------------------------------------
            // CREATE FORM DATA MANUALLY
            // -----------------------------------------------------

            const formData = new URLSearchParams();

            formData.append("line1", line1);
            formData.append("line2", line2);
            formData.append("postalCode", postalCode);
            formData.append("contactName", contactName);
            formData.append("contactPhone", contactPhone);
            formData.append("countryId", countryId);
            formData.append("cityId", cityId);


            // -----------------------------------------------------
            // SEND TO ADDRESS SERVLET
            // -----------------------------------------------------

            fetch(
                "${pageContext.request.contextPath}/admin/address",
                {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                    },
                    body: formData.toString()
                }
            )
                .then(function (response) {

                    return response.json();

                })
                .then(function (result) {

                    console.log(
                        "ADDRESS SERVER RESPONSE:",
                        result
                    );


                    // -------------------------------------------------
                    // SERVER ERROR
                    // -------------------------------------------------

                    if (!result.success) {

                        showAddressError(
                            result.message ||
                            "Unable to save address."
                        );

                        return;
                    }


                    // -------------------------------------------------
                    // SUCCESS
                    // -------------------------------------------------

                    console.log(
                        "Address saved successfully."
                    );


                    // Close address popup
                    closeAddressModal();


                    // Reset form
                    form.reset();


                    // Reset city
                    const citySelect =
                        document.getElementById(
                            "addressCity"
                        );

                    citySelect.innerHTML =
                        '<option value="">Select Country First</option>';

                    citySelect.disabled = true;


                    // -------------------------------------------------
                    // RELOAD ADDRESSES
                    // -------------------------------------------------

                    if (
                        typeof loadAddresses === "function"
                    ) {

                        loadAddresses();

                    }


                    // -------------------------------------------------
                    // ALSO REFRESH CURRENT SELECTOR
                    // -------------------------------------------------

                    if (
                        typeof loadSelectionData === "function"
                    ) {

                        loadSelectionData();

                    }

                })
                .catch(function (error) {

                    console.error(
                        "ADDRESS SAVE ERROR:",
                        error
                    );

                    showAddressError(
                        "Unable to save address. Please try again."
                    );

                });


            // -----------------------------------------------------
            // ERROR FUNCTION
            // -----------------------------------------------------

            function showAddressError(message) {

                if (errorBox) {

                    errorBox.textContent =
                        message;

                    errorBox.style.display =
                        "block";
                }

                console.error(
                    "ADDRESS VALIDATION:",
                    message
                );
            }

        });

</script>

</body>

</html>