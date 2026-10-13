<%
    /*
     * ============================================================
     * GLOBALTRADE - USER TOPBAR
     * ============================================================
     *
     * User information is taken from the SESSION because the
     * topbar is included on every user page.
     *
     * SigninServlet stores:
     *      username
     *      firstName
     *      role
     *
     * in the session after successful login.
     */


    // ------------------------------------------------------------
    // GET SESSION
    // ------------------------------------------------------------

    jakarta.servlet.http.HttpSession topbarSession =
            request.getSession(false);


    // ------------------------------------------------------------
    // DEFAULT USER INFORMATION
    // ------------------------------------------------------------

    String username = "";

    String firstName = "";

    String displayName = "User";

    String role = "USER";


    // ------------------------------------------------------------
    // GET USER INFORMATION FROM SESSION
    // ------------------------------------------------------------

    if (topbarSession != null) {


        Object usernameObject =
                topbarSession.getAttribute("username");

        Object firstNameObject =
                topbarSession.getAttribute("firstName");

        Object roleObject =
                topbarSession.getAttribute("role");


        // Username

        if (usernameObject != null) {

            username =
                    String.valueOf(usernameObject);
        }


        // First name

        if (firstNameObject != null) {

            firstName =
                    String.valueOf(firstNameObject);
        }


        // Role

        if (roleObject != null) {

            role =
                    String.valueOf(roleObject);
        }
    }


    // ------------------------------------------------------------
    // BUILD DISPLAY NAME
    // ------------------------------------------------------------

    if (!firstName.trim().isEmpty()) {

        displayName =
                firstName.trim();

    } else if (!username.trim().isEmpty()) {

        displayName =
                username.trim();
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
    // NOTIFICATIONS
    // ------------------------------------------------------------

    Object notificationObject =
            request.getAttribute("notificationCount");


    if (notificationObject == null &&
            topbarSession != null) {

        notificationObject =
                topbarSession.getAttribute(
                        "notificationCount"
                );
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


<header class="topbar">


    <!-- =========================================================
         MENU
         ========================================================= -->

    <button class="menu-btn"
            type="button"
            title="Menu"
            aria-label="Open navigation menu">

        <i class="fa-solid fa-bars"></i>

    </button>


    <!-- =========================================================
         TOPBAR TITLE
         ========================================================= -->

    <div class="topbar-page">

        <span class="topbar-page-title">
            GlobalTrade
        </span>

        <span class="topbar-page-subtitle">
            Customer Portal
        </span>

    </div>


    <!-- =========================================================
         TOP ACTIONS
         ========================================================= -->

    <div class="top-actions">


        <!-- =====================================================
             NOTIFICATIONS
             ===================================================== -->

        <button class="icon-btn"
                type="button"
                title="Notifications"
                aria-label="Notifications">

            <i class="fa-regular fa-bell"></i>

            <% if (notificationCount > 0) { %>

            <span class="notification-count">
                <%= notificationCount %>
            </span>

            <% } %>

        </button>


        <!-- =====================================================
             HELP
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/support"
           class="icon-btn"
           title="Support"
           aria-label="Support">

            <i class="fa-regular fa-circle-question"></i>

        </a>


        <!-- =====================================================
             USER PROFILE
             ===================================================== -->

        <a href="${pageContext.request.contextPath}/profile"
           class="top-user"
           title="View Profile">


            <!-- USER AVATAR -->

            <div class="top-avatar">

                <%= avatarLetter %>

            </div>


            <!-- USER INFORMATION -->

            <div>

                <span>
                    <%= displayName %>
                </span>

                <small>
                    <%= role %>
                </small>

            </div>


            <!-- DROPDOWN ICON -->

            <i class="fa-solid fa-chevron-down"
               style="font-size:8px;">
            </i>

        </a>

    </div>


</header>