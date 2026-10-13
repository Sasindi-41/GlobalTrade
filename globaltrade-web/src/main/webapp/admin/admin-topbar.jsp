<%

    jakarta.servlet.http.HttpSession topbarSession =
            request.getSession(false);

    String displayName =
            "Administrator";

    String avatarLetter =
            "A";

    String role =
            "ADMIN";

    if (topbarSession != null) {

        Object firstNameObject =
                topbarSession.getAttribute("firstName");


        if (firstNameObject != null &&
                !String.valueOf(firstNameObject)
                        .trim()
                        .isEmpty()) {

            displayName =
                    String.valueOf(firstNameObject)
                            .trim();
        }

        Object roleObject =
                topbarSession.getAttribute("role");


        if (roleObject != null &&
                !String.valueOf(roleObject)
                        .trim()
                        .isEmpty()) {

            role =
                    String.valueOf(roleObject)
                            .trim()
                            .toUpperCase();
        }

        if (displayName != null &&
                !displayName.trim().isEmpty()) {

            avatarLetter =
                    displayName
                            .trim()
                            .substring(0, 1)
                            .toUpperCase();
        }
    }

    Object activeAlertsObject =
            request.getAttribute("activeAlerts");


    if (activeAlertsObject == null &&
            topbarSession != null) {

        activeAlertsObject =
                topbarSession.getAttribute("activeAlerts");
    }


    int activeAlerts = 0;


    if (activeAlertsObject != null) {

        try {

            activeAlerts =
                    Integer.parseInt(
                            String.valueOf(
                                    activeAlertsObject
                            )
                    );

        } catch (NumberFormatException ignored) {

            activeAlerts = 0;
        }
    }
%>


<header class="topbar">

    <button class="menu-btn"
            type="button"
            title="Menu"
            aria-label="Open navigation menu">

        <i class="fa-solid fa-bars"></i>

    </button>

    <div class="search">

        <i class="fa-solid fa-magnifying-glass"></i>

        <input
                type="text"
                placeholder="Search anything..."
        >

    </div>

    <div class="top-actions">

        <button class="icon-btn"
                type="button"
                title="Notifications"
                aria-label="Notifications">

            <i class="fa-regular fa-bell"></i>

            <% if (activeAlerts > 0) { %>

            <span class="notification-count">

                <%= activeAlerts %>

            </span>

            <% } %>

        </button>

        <button class="icon-btn"
                type="button"
                title="Messages"
                aria-label="Messages">

            <i class="fa-regular fa-envelope"></i>

        </button>

        <a href="${pageContext.request.contextPath}/admin/profile"
           class="top-user"
           title="View Profile">


            <div class="top-avatar">

                <%= avatarLetter %>

            </div>

            <div class="top-user-info">

                <span>
                    <%= displayName %>
                </span>
<br>
                <small>
                    <%= role %>
                </small>

            </div>

            <i class="fa-solid fa-chevron-down top-user-chevron">
            </i>

        </a>

    </div>

</header>