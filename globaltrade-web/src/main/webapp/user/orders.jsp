<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sasindi.globaltrade.entity.Order" %>
<%@ page import="lk.sasindi.globaltrade.entity.Address" %>
<%@ page import="java.util.List" %>

<%
    request.setAttribute("activePage", "orders");

    List<Order> myOrders =
            (List<Order>) request.getAttribute("myOrders");

    List<Address> addresses =
            (List<Address>) request.getAttribute("addresses");

    String errorMessage =
            (String) request.getAttribute("errorMessage");

    String successMessage =
            (String) request.getAttribute("successMessage");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>GlobalTrade | Shipment Requests</title>

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

        <!-- =====================================================
             PAGE HEADING
        ====================================================== -->

        <div class="page-heading">

            <div>

                <h1>Shipment Requests</h1>

                <p>
                    Submit a shipment request and track its approval
                    before it becomes an active shipment.
                </p>

            </div>

        </div>


        <!-- =====================================================
             FLASH MESSAGES
        ====================================================== -->

        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>

        <div class="flash-message flash-error">

            <i class="fa-solid fa-circle-exclamation"></i>

            <%= errorMessage %>

        </div>

        <% } %>


        <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>

        <div class="flash-message flash-success">

            <i class="fa-solid fa-circle-check"></i>

            <%= successMessage %>

        </div>

        <% } %>


        <!-- =====================================================
             INFORMATION CARD
        ====================================================== -->

        <div class="card"
             style="margin-bottom:18px;">

            <div class="card-header">

                <h2>

                    <i class="fa-solid fa-circle-info"></i>

                    How Shipment Requests Work

                </h2>

            </div>


            <div style="padding:18px;">

                <div style="
                    display:grid;
                    grid-template-columns:repeat(auto-fit,minmax(180px,1fr));
                    gap:14px;
                ">

                    <!-- STEP 1 -->

                    <div style="
                        padding:15px;
                        border-radius:10px;
                        background:rgba(0,102,255,0.06);
                    ">

                        <div style="
                            font-size:20px;
                            margin-bottom:8px;
                        ">

                            <i class="fa-solid fa-file-circle-plus"></i>

                        </div>

                        <strong>1. Submit Request</strong>

                        <p style="
                            margin:7px 0 0;
                            font-size:12px;
                            opacity:.75;
                        ">

                            Tell us what you need to ship and provide
                            the origin and destination.

                        </p>

                    </div>


                    <!-- STEP 2 -->

                    <div style="
                        padding:15px;
                        border-radius:10px;
                        background:rgba(0,102,255,0.06);
                    ">

                        <div style="
                            font-size:20px;
                            margin-bottom:8px;
                        ">

                            <i class="fa-solid fa-user-check"></i>

                        </div>

                        <strong>2. Staff Review</strong>

                        <p style="
                            margin:7px 0 0;
                            font-size:12px;
                            opacity:.75;
                        ">

                            Our logistics team reviews your request
                            and prepares the shipment.

                        </p>

                    </div>


                    <!-- STEP 3 -->

                    <div style="
                        padding:15px;
                        border-radius:10px;
                        background:rgba(0,102,255,0.06);
                    ">

                        <div style="
                            font-size:20px;
                            margin-bottom:8px;
                        ">

                            <i class="fa-solid fa-truck-fast"></i>

                        </div>

                        <strong>3. Shipment Created</strong>

                        <p style="
                            margin:7px 0 0;
                            font-size:12px;
                            opacity:.75;
                        ">

                            Once approved, your request becomes
                            an operational shipment.

                        </p>

                    </div>


                    <!-- STEP 4 -->

                    <div style="
                        padding:15px;
                        border-radius:10px;
                        background:rgba(0,102,255,0.06);
                    ">

                        <div style="
                            font-size:20px;
                            margin-bottom:8px;
                        ">

                            <i class="fa-solid fa-location-dot"></i>

                        </div>

                        <strong>4. Track Shipment</strong>

                        <p style="
                            margin:7px 0 0;
                            font-size:12px;
                            opacity:.75;
                        ">

                            After conversion, use the shipment tracking
                            number to follow your delivery.

                        </p>

                    </div>

                </div>

            </div>

        </div>


        <!-- =====================================================
             MAIN GRID
        ====================================================== -->

        <div class="page-grid">


            <!-- =================================================
                 REQUEST HISTORY
            ================================================== -->

            <div class="card">

                <div class="card-header">

                    <h2>

                        <i class="fa-solid fa-clock-rotate-left"></i>

                        My Shipment Requests

                    </h2>

                </div>


                <div class="table-wrap">

                    <% if (myOrders == null || myOrders.isEmpty()) { %>

                    <div class="empty-state">

                        <i class="fa-solid fa-box-open"></i>

                        <p>
                            You haven't submitted any shipment
                            requests yet.
                        </p>

                    </div>

                    <% } else { %>


                    <table>

                        <thead>

                        <tr>

                            <th>Request No.</th>

                            <th>Shipment Details</th>

                            <th>Route</th>

                            <th>Qty</th>

                            <th>Status</th>

                            <th>Submitted</th>

                            <th>Shipment</th>

                            <th></th>

                        </tr>

                        </thead>


                        <tbody>

                        <% for (Order order : myOrders) {

                            if (order == null) {
                                continue;
                            }

                            String status = order.getStatus();

                            if (status == null || status.trim().isEmpty()) {
                                status = "PENDING";
                            }

                            status = status.trim();

                            String statusClass =
                                    "status-pill status-"
                                            + status.toLowerCase()
                                            .replace(" ", "-");


                            String originText = "-";

                            if (order.getOriginAddress() != null) {

                                Address origin =
                                        order.getOriginAddress();

                                if (origin.getLine1() != null) {

                                    originText = origin.getLine1();

                                }

                                if (origin.getCity() != null &&
                                        origin.getCity().getName() != null) {

                                    originText +=
                                            ", "
                                                    + origin.getCity().getName();
                                }
                            }


                            String destinationText = "-";

                            if (order.getDestinationAddress() != null) {

                                Address destination =
                                        order.getDestinationAddress();

                                if (destination.getLine1() != null) {

                                    destinationText =
                                            destination.getLine1();

                                }

                                if (destination.getCity() != null &&
                                        destination.getCity().getName() != null) {

                                    destinationText +=
                                            ", "
                                                    + destination.getCity().getName();
                                }
                            }


                            boolean hasShipment =
                                    order.getShipment() != null;


                            String shipmentTracking = null;

                            if (hasShipment &&
                                    order.getShipment().getTrackingNumber() != null) {

                                shipmentTracking =
                                        order.getShipment().getTrackingNumber();
                            }

                        %>


                        <tr>

                            <!-- REQUEST NUMBER -->

                            <td>

                                <strong>
                                    <%= order.getOrderNumber() %>
                                </strong>

                            </td>


                            <!-- SHIPMENT DETAILS -->

                            <td>

                                <div style="font-weight:600;">

                                    <%= order.getProductDescription() %>

                                </div>


                                <% if (order.getNotes() != null &&
                                        !order.getNotes().trim().isEmpty()) { %>

                                <div style="
                                    font-size:10px;
                                    opacity:.65;
                                    margin-top:4px;
                                ">

                                    <i class="fa-regular fa-note-sticky"></i>

                                    <%= order.getNotes() %>

                                </div>

                                <% } %>

                            </td>


                            <!-- ROUTE -->

                            <td>

                                <div style="font-size:11px;">

                                    <i class="fa-solid fa-location-dot"></i>

                                    <%= originText %>

                                </div>


                                <div style="
                                    margin:4px 0;
                                    opacity:.45;
                                ">

                                    <i class="fa-solid fa-arrow-down"></i>

                                </div>


                                <div style="font-size:11px;">

                                    <i class="fa-solid fa-location-dot"></i>

                                    <%= destinationText %>

                                </div>

                            </td>


                            <!-- QUANTITY -->

                            <td>

                                <%= order.getQuantity() %>

                            </td>


                            <!-- STATUS -->

                            <td>

                                <span class="<%= statusClass %>">

                                    <%= status %>

                                </span>

                            </td>


                            <!-- SUBMITTED DATE -->

                            <td>

                                <% if (order.getCreatedAt() != null) { %>

                                <%= order.getCreatedAt().toLocalDate() %>

                                <% } else { %>

                                -

                                <% } %>

                            </td>


                            <!-- LINKED SHIPMENT -->

                            <td>

                                <% if (shipmentTracking != null &&
                                        !shipmentTracking.trim().isEmpty()) { %>

                                <div style="
                                    white-space:nowrap;
                                    font-size:11px;
                                ">

                                    <i class="fa-solid fa-truck-fast"></i>

                                    <strong>
                                        <%= shipmentTracking %>
                                    </strong>

                                </div>

                                <% } else if ("CONVERTED".equalsIgnoreCase(status)) { %>

                                <span style="
                                    font-size:10px;
                                    opacity:.65;
                                ">

                                    Processing

                                </span>

                                <% } else { %>

                                <span style="
                                    font-size:10px;
                                    opacity:.45;
                                ">

                                    Not created

                                </span>

                                <% } %>

                            </td>


                            <!-- ACTIONS -->

                            <td>

                                <% if ("PENDING".equalsIgnoreCase(status)) { %>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/orders"
                                      style="display:inline;"
                                      onsubmit="return confirm('Are you sure you want to cancel this shipment request?');">

                                    <input type="hidden"
                                           name="action"
                                           value="cancel">

                                    <input type="hidden"
                                           name="orderId"
                                           value="<%= order.getId() %>">

                                    <button type="submit"
                                            class="btn btn-danger"
                                            style="
                                                padding:6px 10px;
                                                font-size:9px;
                                            ">

                                        <i class="fa-solid fa-xmark"></i>

                                        Cancel

                                    </button>

                                </form>


                                <% } else if (hasShipment) { %>

                                <a href="${pageContext.request.contextPath}/user-shipments"
                                   class="btn btn-primary"
                                   style="
                                       padding:6px 10px;
                                       font-size:9px;
                                       text-decoration:none;
                                   ">

                                    <i class="fa-solid fa-truck"></i>

                                    View

                                </a>

                                <% } %>

                            </td>

                        </tr>


                        <% } %>

                        </tbody>

                    </table>


                    <% } %>

                </div>

            </div>


            <!-- =================================================
                 REQUEST FORM
            ================================================== -->

            <div class="card">

                <div class="card-header">

                    <h2>

                        <i class="fa-solid fa-plus"></i>

                        Request a Shipment

                    </h2>

                </div>


                <div style="
                    padding:15px 18px 0;
                    font-size:11px;
                    opacity:.7;
                ">

                    You don't need to select a vendor or inventory item.
                    Our logistics team will handle those details after
                    reviewing your request.

                </div>


                <form method="post"
                      action="${pageContext.request.contextPath}/orders"
                      class="edit-form"
                      style="padding:18px;">

                    <input type="hidden"
                           name="action"
                           value="create">


                    <!-- PRODUCT DESCRIPTION -->

                    <div class="form-group full">

                        <label>
                            What are you shipping?
                        </label>

                        <input type="text"
                               name="productDescription"
                               placeholder="e.g. 200 boxes of ceramic tiles"
                               maxlength="500"
                               required>

                    </div>


                    <!-- QUANTITY -->

                    <div class="form-group full">

                        <label>
                            Quantity
                        </label>

                        <input type="number"
                               name="quantity"
                               min="1"
                               required>

                    </div>


                    <!-- ORIGIN -->

                    <div class="form-group">

                        <label>
                            Origin Address
                        </label>

                        <select name="originAddressId"
                                required>

                            <option value="">
                                Select origin
                            </option>

                            <% if (addresses != null) {

                                for (Address address : addresses) {

                                    if (address == null) {
                                        continue;
                                    }

                                    String addressText =
                                            address.getLine1() != null
                                                    ? address.getLine1()
                                                    : "";

                                    if (address.getCity() != null &&
                                            address.getCity().getName() != null) {

                                        addressText +=
                                                ", "
                                                        + address.getCity().getName();
                                    }

                            %>

                            <option value="<%= address.getId() %>">
                                <%= addressText %>
                            </option>

                            <%
                                    }
                                } %>

                        </select>

                    </div>


                    <!-- DESTINATION -->

                    <div class="form-group">

                        <label>
                            Destination Address
                        </label>

                        <select name="destinationAddressId"
                                required>

                            <option value="">
                                Select destination
                            </option>

                            <% if (addresses != null) {

                                for (Address address : addresses) {

                                    if (address == null) {
                                        continue;
                                    }

                                    String addressText =
                                            address.getLine1() != null
                                                    ? address.getLine1()
                                                    : "";

                                    if (address.getCity() != null &&
                                            address.getCity().getName() != null) {

                                        addressText +=
                                                ", "
                                                        + address.getCity().getName();
                                    }

                            %>

                            <option value="<%= address.getId() %>">
                                <%= addressText %>
                            </option>

                            <%
                                    }
                                } %>

                        </select>

                    </div>


                    <!-- NOTES -->

                    <div class="form-group full">

                        <label>

                            Notes

                            <span style="opacity:.55;">
                                (optional)
                            </span>

                        </label>

                        <textarea class="textarea"
                                  name="notes"
                                  maxlength="500"
                                  placeholder="Anything our logistics team should know?"></textarea>

                    </div>


                    <!-- SUBMIT -->

                    <div class="form-actions">

                        <button type="submit"
                                class="btn btn-primary">

                            <i class="fa-solid fa-paper-plane"></i>

                            Submit Shipment Request

                        </button>

                    </div>

                </form>

            </div>


        </div>


        <!-- =====================================================
             FOOTER
        ====================================================== -->

        <footer class="footer"
                style="margin-top:14px;">

            <span>

                &copy; 2026 GlobalTrade Logistics System.
                All rights reserved.

            </span>

            <span>

                Version 1.0.0

            </span>

        </footer>


    </section>

</main>

</body>

</html>

