<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sasindi.globaltrade.entity.*" %>
<%
    request.setAttribute("activePage", "track");

    Shipment shipment = (Shipment) request.getAttribute("shipment");
    String searchedTrackingNumber = (String) request.getAttribute("searchedTrackingNumber");
    String trackErrorMessage = (String) request.getAttribute("trackErrorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GlobalTrade | Track Shipment</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/user/assets/user-style.css">

</head>
<body>

<jsp:include page="user-sidebar.jsp"/>

<main class="main">

    <jsp:include page="user-topbar.jsp"/>

    <section class="content">

        <div class="page-heading">
            <div>
                <h1>Track Shipment</h1>
                <p>Enter a tracking number to see the latest status of one of your shipments.</p>
            </div>
        </div>

        <div class="card">

            <div style="padding: 18px;">

                <form method="get"
                      action="${pageContext.request.contextPath}/track"
                      style="display:flex; gap:10px;">

                    <input type="text"
                           name="trackingNumber"
                           placeholder="e.g. GT-2026-00128"
                           value="<%= searchedTrackingNumber != null ? searchedTrackingNumber : "" %>"
                           style="flex:1; padding:11px; border:1px solid var(--border); border-radius:7px; font-size:11px; outline:none;"
                           required>

                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        Track
                    </button>

                </form>

            </div>

        </div>

        <% if (trackErrorMessage != null) { %>
        <div class="flash-message flash-error" style="margin-top:14px;">
            <i class="fa-solid fa-circle-exclamation"></i>
            <%= trackErrorMessage %>
        </div>
        <% } %>

        <% if (shipment != null) {

            String statusName =
                    shipment.getShipmentStatus() != null
                            ? shipment.getShipmentStatus().getName()
                            : "-";

            String origin =
                    shipment.getOriginAddress() != null
                            ? shipment.getOriginAddress().getLine1()
                            + (shipment.getOriginAddress().getCity() != null
                            ? ", " + shipment.getOriginAddress().getCity().getName() : "")
                            : "-";

            String destination =
                    shipment.getDestinationAddress() != null
                            ? shipment.getDestinationAddress().getLine1()
                            + (shipment.getDestinationAddress().getCity() != null
                            ? ", " + shipment.getDestinationAddress().getCity().getName() : "")
                            : "-";
        %>

        <div class="card" style="margin-top:14px;">

            <div class="card-header">
                <h2><%= shipment.getTrackingNumber() %></h2>
                <span class="status-pill status-<%= statusName.toLowerCase().replace(" ", "-") %>">
                    <%= statusName %>
                </span>
            </div>

            <div style="padding: 18px;">

                <ul class="status-list">

                    <li>
                        <span class="status-dot" style="background: var(--orange);"></span>
                        Origin
                        <span class="status-value"><%= origin %></span>
                    </li>

                    <li>
                        <span class="status-dot" style="background: var(--yellow);"></span>
                        Destination
                        <span class="status-value"><%= destination %></span>
                    </li>

                    <li>
                        <span class="status-dot" style="background: var(--navy);"></span>
                        Carrier
                        <span class="status-value">
                            <%= shipment.getVendor() != null
                                    ? shipment.getVendor().getCompanyName() : "-" %>
                        </span>
                    </li>

                    <li>
                        <span class="status-dot" style="background: #2E7D32;"></span>
                        Expected delivery
                        <span class="status-value">
                            <%= shipment.getExpectedDelivery() != null
                                    ? shipment.getExpectedDelivery().toLocalDate() : "-" %>
                        </span>
                    </li>

                    <% if (shipment.getActualDelivery() != null) { %>
                    <li>
                        <span class="status-dot" style="background: #2E7D32;"></span>
                        Delivered on
                        <span class="status-value">
                            <%= shipment.getActualDelivery().toLocalDate() %>
                        </span>
                    </li>
                    <% } %>

                </ul>

                <div style="margin-top: 10px;">
                    <a href="${pageContext.request.contextPath}/documents"
                       class="btn btn-secondary">
                        <i class="fa-solid fa-file-lines"></i>
                        View related documents
                    </a>
                </div>

            </div>

        </div>

        <% } %>

        <footer class="footer" style="margin-top:14px;">
            <span>&copy; 2026 GlobalTrade Logistics System. All rights reserved.</span>
            <span>Version 1.0.0</span>
        </footer>

    </section>

</main>

</body>
</html>
