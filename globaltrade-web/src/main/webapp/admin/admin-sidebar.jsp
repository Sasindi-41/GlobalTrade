<%


    String activePage = (String) request.getAttribute("activePage");

    if (activePage == null) {
        activePage = "";
    }

    Object adminNameObject = request.getAttribute("adminName");

    if (adminNameObject == null) {
        adminNameObject = session.getAttribute("adminName");
    }

    String adminName = "Administrator";

    if (adminNameObject != null) {
        adminName = String.valueOf(adminNameObject);
    }

    Object activeAlertsObject = request.getAttribute("activeAlerts");

    if (activeAlertsObject == null) {
        activeAlertsObject = session.getAttribute("activeAlerts");
    }

    int activeAlerts = 0;

    if (activeAlertsObject != null) {
        try {
            activeAlerts = Integer.parseInt(
                    String.valueOf(activeAlertsObject)
            );
        } catch (NumberFormatException ignored) {
            activeAlerts = 0;
        }
    }
%>


<aside class="sidebar">

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

    <nav class="nav">

        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="nav-item <%= "dashboard".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-chart-pie"></i>

            <span>
                Dashboard
            </span>

        </a>

        <a href="${pageContext.request.contextPath}/shipments"
           class="nav-item <%= "shipments".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-truck-fast"></i>

            <span>
                Shipments
            </span>

            <i class="fa-solid fa-chevron-down chevron"></i>

        </a>

        <a href="${pageContext.request.contextPath}/inventory"
           class="nav-item <%= "inventory".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-boxes-stacked"></i>

            <span>
                Inventory
            </span>

            <i class="fa-solid fa-chevron-down chevron"></i>

        </a>

        <a href="${pageContext.request.contextPath}/vendors"
           class="nav-item <%= "vendors".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-building"></i>

            <span>
                Vendors
            </span>

            <i class="fa-solid fa-chevron-down chevron"></i>

        </a>

        <a href="${pageContext.request.contextPath}/custom-documents"
           class="nav-item <%= "customs".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-file-shield"></i>

            <span>
                Customs Documents
            </span>

            <i class="fa-solid fa-chevron-down chevron"></i>

        </a>

        <a href="${pageContext.request.contextPath}/alerts"
           class="nav-item <%= "alerts".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-triangle-exclamation"></i>

            <span>
                Alerts
            </span>

            <% if (activeAlerts > 0) { %>

            <span class="badge">
                    <%= activeAlerts %>
                </span>

            <% } %>

        </a>

        <a href="${pageContext.request.contextPath}/routes"
           class="nav-item <%= "routes".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-route"></i>

            <span>
                Route Optimization
            </span>

        </a>

        <a href="${pageContext.request.contextPath}/audit-logs"
           class="nav-item <%= "audit-logs".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-clipboard-list"></i>

            <span>
                Audit Logs
            </span>

        </a>

        <a href="${pageContext.request.contextPath}/UserServlet"
           class="nav-item <%= "users".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-users"></i>

            <span>
                Users
            </span>

            <i class="fa-solid fa-chevron-down chevron"></i>

        </a>

        <a href="${pageContext.request.contextPath}/reports"
           class="nav-item <%= "reports".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-chart-column"></i>

            <span>
                Reports
            </span>

            <i class="fa-solid fa-chevron-down chevron"></i>

        </a>

        <a href="${pageContext.request.contextPath}/timer-services"
           class="nav-item <%= "timer-services".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-gear"></i>

            <span>
               Timer Services
            </span>

        </a>

        <a href="${pageContext.request.contextPath}/performance-logs"
           class="nav-item <%= "performance-logs".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-gauge-high"></i>

            <span>
               Performance Logs
            </span>

        </a>

        <a href="${pageContext.request.contextPath}/stock-history"
           class="nav-item <%= "activity-history".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-clock-rotate-left"></i>

            <span>
                Activity History
            </span>

        </a>

        <a href="${pageContext.request.contextPath}/access-control"
           class="nav-item <%= "access-control".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-user-shield"></i>

            <span>
                Access Control
            </span>

        </a>
        <a href="${pageContext.request.contextPath}/admin/system-health"
           class="nav-item <%= "system-health".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-heart-pulse"></i>

            <span>
              System Health
            </span>

        </a>
        <a href="${pageContext.request.contextPath}/logout"
           class="nav-item <%= "logout".equals(activePage) ? "active" : "" %>">

            <i class="fa-solid fa-user-shield"></i>

            <span>
                Logout
            </span>

        </a>


    </nav>

    <div class="profile-mini">

        <div class="avatar">

            <i class="fa-solid fa-user"></i>

        </div>


        <div class="profile-copy">

            <div class="profile-name">
                <%= adminName %>
            </div>


            <a href="${pageContext.request.contextPath}/admin/profile"
               class="profile-link <%= "profile".equals(activePage) ? "active" : "" %>">

                <i class="fa-solid fa-user"></i>

                <span>
                    Profile
                </span>

            </a>

        </div>

    </div>

</aside>