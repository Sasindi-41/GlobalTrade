<%
    /*
     * ============================================================
     * GLOBALTRADE - USER SIDEBAR
     * ============================================================
     *
     * This file is included by user pages such as:
     *
     *   user-dashboard.jsp
     *   profile.jsp
     *   shipments.jsp
     *   orders.jsp
     *
     * Expected values:
     *
     *   activePage -> request attribute
     *   user       -> request attribute OR session attribute
     *
     * The values are read safely so the sidebar does not cause
     * JSP compilation/runtime problems when an individual servlet
     * does not provide every attribute.
     */


    // ------------------------------------------------------------
    // ACTIVE PAGE
    // ------------------------------------------------------------

    String activePage =
            (String) request.getAttribute("activePage");

    if (activePage == null) {

        activePage = "";
    }


    // ------------------------------------------------------------
    // USER OBJECT
    // ------------------------------------------------------------

    Object userObject =
            request.getAttribute("user");

    if (userObject == null) {

        userObject =
                session.getAttribute("user");
    }


    // ------------------------------------------------------------
    // USER DISPLAY INFORMATION
    // ------------------------------------------------------------

    String username = "";

    String firstName = "";

    String lastName = "";

    String displayName = "User";


    if (userObject
            instanceof lk.sasindi.globaltrade.entity.User) {

        lk.sasindi.globaltrade.entity.User user =
                (lk.sasindi.globaltrade.entity.User) userObject;


        if (user.getUsername() != null) {

            username =
                    user.getUsername();
        }


        if (user.getFirstName() != null) {

            firstName =
                    user.getFirstName();
        }


        if (user.getLastName() != null) {

            lastName =
                    user.getLastName();
        }
    }


    // ------------------------------------------------------------
    // BUILD DISPLAY NAME
    // ------------------------------------------------------------

    if (!firstName.isEmpty() ||
            !lastName.isEmpty()) {

        displayName =
                (firstName + " " + lastName).trim();

    } else if (!username.isEmpty()) {

        displayName =
                username;
    }


    // ------------------------------------------------------------
    // AVATAR LETTER
    // ------------------------------------------------------------

    String avatarLetter =
            !displayName.isEmpty()
                    ? displayName
                    .substring(0, 1)
                    .toUpperCase()
                    : "U";


    // ------------------------------------------------------------
    // ROLE
    // ------------------------------------------------------------

    String role = "USER";


    Object roleObject =
            session.getAttribute("role");

    if (roleObject != null) {

        role =
                String.valueOf(roleObject);
    }


    // ------------------------------------------------------------
    // ACTIVE ALERTS / NOTIFICATIONS
    // ------------------------------------------------------------

    Object notificationObject =
            request.getAttribute("notificationCount");

    if (notificationObject == null) {

        notificationObject =
                session.getAttribute("notificationCount");
    }


    int notificationCount = 0;


    if (notificationObject != null) {

        try {

            notificationCount =
                    Integer.parseInt(
                            String.valueOf(
                                    notificationObject
                            )
                    );

        } catch (NumberFormatException ignored) {

            notificationCount = 0;
        }
    }
%>


<aside class="sidebar">


    <!-- =========================================================
         BRAND
         ========================================================= -->

    <div class="brand">

        <div class="brand-logo">

            <i class="fa-solid fa-globe"></i>

        </div>


        <div class="brand-copy">

            <div class="brand-title">
                GlobalTrade
            </div>

            <div class="brand-subtitle">
                Logistics System
            </div>

        </div>

    </div>


    <!-- =========================================================
         NAVIGATION
         ========================================================= -->

    <nav class="nav">


        <!-- =====================================================
             DASHBOARD
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/user/dashboard"
           class="nav-item <%= "dashboard".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-house"></i>

            <span>
                Dashboard
            </span>

        </a>


        <!-- =====================================================
             MY SHIPMENTS
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/user-shipments"
           class="nav-item <%= "shipments".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-truck-fast"></i>

            <span>
                My Shipments
            </span>

        </a>


        <!-- =====================================================
             TRACK SHIPMENT
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/track"
           class="nav-item <%= "track".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-location-dot"></i>

            <span>
                Track Shipment
            </span>

        </a>


        <!-- =====================================================
             MY ORDERS
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/orders"
           class="nav-item <%= "orders".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-box"></i>

            <span>
                My Orders
            </span>

        </a>


        <!-- =====================================================
             DOCUMENTS
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/documents"
           class="nav-item <%= "documents".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-file-lines"></i>

            <span>
                Documents
            </span>

        </a>


        <!-- =====================================================
             INVOICES
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/invoices"
           class="nav-item <%= "invoices".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-file-invoice-dollar"></i>

            <span>
                Invoices
            </span>

        </a>


        <!-- =====================================================
             PROFILE
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/profile"
           class="nav-item <%= "profile".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-user"></i>

            <span>
                Profile
            </span>

        </a>


        <!-- =====================================================
             SUPPORT
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/support"
           class="nav-item <%= "support".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-headset"></i>

            <span>
                Support
            </span>

        </a>


        <!-- =====================================================
             SETTINGS
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/logout"
           class="nav-item <%= "settings".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-gear"></i>

            <span>
                Logout
            </span>

        </a>

    </nav>


    <!-- =========================================================
         SUPPORT BOX
         ========================================================= -->

    <div class="support-box">

        <h3>
            Need Help?
        </h3>

        <p>
            Our support team is available 24/7
        </p>

        <a href="${pageContext.request.contextPath}/support"
           class="support-button"
           style="
                display:flex;
                align-items:center;
                justify-content:center;
                gap:7px;
           ">

            <i class="fa-solid fa-headset"></i>

            Contact Support

        </a>

    </div>


</aside>