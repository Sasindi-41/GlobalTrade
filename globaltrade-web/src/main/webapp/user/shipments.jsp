<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sasindi.globaltrade.entity.*" %>
<%@ page import="java.util.List" %>

<%
    /*
     * ============================================================
     * PAGE SETUP
     * ============================================================
     */


    request.setAttribute("activePage", "shipments");

    List<Shipment> myShipments =
    (List<Shipment>) request.getAttribute("myShipments");

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

    <title>GlobalTrade | My Shipments</title>


    <!-- =========================================================
         FONT AWESOME
         ========================================================= -->

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- =========================================================
         USER STYLE
         ========================================================= -->

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/user/assets/user-style.css">


</head>

<body>

<!-- =============================================================
     SIDEBAR
     ============================================================= -->

<jsp:include page="user-sidebar.jsp"/>

<main class="main">


    <!-- =========================================================
         TOP BAR
         ========================================================= -->

    <jsp:include page="user-topbar.jsp"/>


    <section class="content">


        <!-- =====================================================
             PAGE HEADING
             ===================================================== -->

        <div class="page-heading">

            <div>

                <h1>My Shipments</h1>

                <p>
                    Track and monitor shipments that have been created
                    from your orders.
                </p>

            </div>

        </div>


        <!-- =====================================================
             ERROR MESSAGE
             ===================================================== -->

        <% if (errorMessage != null &&
            !errorMessage.trim().isEmpty()) { %>

        <div class="flash-message flash-error">

            <i class="fa-solid fa-circle-exclamation"></i>

            <%= errorMessage %>

        </div>

        <% } %>


        <!-- =====================================================
             SUCCESS MESSAGE
             ===================================================== -->

        <% if (successMessage != null &&
            !successMessage.trim().isEmpty()) { %>

        <div class="flash-message flash-success">

            <i class="fa-solid fa-circle-check"></i>

            <%= successMessage %>

        </div>

        <% } %>


        <!-- =====================================================
             MAIN GRID
             ===================================================== -->

        <div class="page-grid">


            <!-- =================================================
                 MY SHIPMENTS
                 ================================================= -->

            <div class="card">


                <div class="card-header">

                    <h2>

                        <i class="fa-solid fa-truck-fast"></i>

                        Your Shipments

                    </h2>

                </div>


                <div class="table-wrap">


                    <% if (myShipments == null ||
                        myShipments.isEmpty()) { %>


                    <!-- =========================================
                         EMPTY STATE
                         ========================================= -->

                    <div class="empty-state">

                        <i class="fa-solid fa-box-open"></i>

                        <p>
                            You don't have any shipments yet.
                        </p>

                        <small>
                            Once a shipment is created for one of your
                            orders, its tracking information will appear here.
                        </small>

                    </div>


                    <% } else { %>


                    <!-- =========================================
                         SHIPMENT TABLE
                         ========================================= -->

                    <table>

                        <thead>

                        <tr>

                            <th>
                                Tracking No.
                            </th>

                            <th>
                                Item
                            </th>

                            <th>
                                Quantity
                            </th>

                            <th>
                                Route
                            </th>

                            <th>
                                Status
                            </th>

                            <th>
                                Est. Delivery
                            </th>

                        </tr>

                        </thead>


                        <tbody>


                        <% for (Shipment shipment : myShipments) {


                            String itemName = "-";

                            Integer quantity = null;


                            /*
                             * ---------------------------------
                             * SHIPMENT ITEM
                             * ---------------------------------
                             */

                            if (shipment.getShipmentItems() != null &&
                            !shipment.getShipmentItems().isEmpty()) {

                            ShipmentItem firstItem =
                            shipment.getShipmentItems().get(0);


                            if (firstItem != null) {

                            if (firstItem.getInventory() != null) {

                            itemName =
                            firstItem
                            .getInventory()
                            .getProductName();
                            }


                            quantity =
                            firstItem.getQuantity();
                            }
                            }


                            /*
                             * ---------------------------------
                             * ORIGIN
                             * ---------------------------------
                             */

                            String origin = "-";


                            if (shipment.getOriginAddress() != null) {

                            Address originAddress =
                            shipment.getOriginAddress();


                            if (originAddress.getCity() != null) {

                            origin =
                            originAddress
                            .getCity()
                            .getName();

                            } else if (originAddress.getLine1() != null) {

                            origin =
                            originAddress.getLine1();
                            }
                            }


                            /*
                             * ---------------------------------
                             * DESTINATION
                             * ---------------------------------
                             */

                            String destination = "-";


                            if (shipment.getDestinationAddress() != null) {

                            Address destinationAddress =
                            shipment.getDestinationAddress();


                            if (destinationAddress.getCity() != null) {

                            destination =
                            destinationAddress
                            .getCity()
                            .getName();

                            } else if (destinationAddress.getLine1() != null) {

                            destination =
                            destinationAddress.getLine1();
                            }
                            }


                            /*
                             * ---------------------------------
                             * STATUS
                             * ---------------------------------
                             */

                            String statusName = "Pending";


                            if (shipment.getShipmentStatus() != null &&
                            shipment.getShipmentStatus().getName() != null) {

                            statusName =
                            shipment
                            .getShipmentStatus()
                            .getName();
                            }


                            String statusClass =
                            "status-pill status-" +
                            statusName
                            .toLowerCase()
                            .replace(" ", "-");


                            /*
                             * ---------------------------------
                             * EXPECTED DELIVERY
                             * ---------------------------------
                             */

                            String expectedDelivery = "-";


                            if (shipment.getExpectedDelivery() != null) {

                            expectedDelivery =
                            shipment
                            .getExpectedDelivery()
                            .toLocalDate()
                            .toString();
                            }

                        %>


                        <tr>


                            <!-- TRACKING -->

                            <td>

                                <strong>
                                    <%= shipment.getTrackingNumber() %>
                                </strong>

                            </td>


                            <!-- ITEM -->

                            <td>

                                <%= itemName %>

                            </td>


                            <!-- QUANTITY -->

                            <td>

                                <%= quantity != null
                                    ? quantity
                                    : "-" %>

                            </td>


                            <!-- ROUTE -->

                            <td>

                            <span>
                                <%= origin %>
                            </span>

                                <i class="fa-solid fa-arrow-right"
                                   style="margin: 0 6px;">
                                </i>

                                <span>
                                <%= destination %>
                            </span>

                            </td>


                            <!-- STATUS -->

                            <td>

                            <span class="<%= statusClass %>">

                                <%= statusName %>

                            </span>

                            </td>


                            <!-- DELIVERY -->

                            <td>

                                <%= expectedDelivery %>

                            </td>


                        </tr>


                        <% } %>


                        </tbody>

                    </table>


                    <% } %>


                </div>


            </div>


        </div>


        <!-- =====================================================
             SHIPMENT INFORMATION
             ===================================================== -->

        <div class="card"
             style="margin-top: 20px;">


            <div class="card-header">

                <h2>

                    <i class="fa-solid fa-circle-info"></i>

                    How Shipment Requests Work

                </h2>

            </div>


            <div style="padding: 18px;">


                <!-- STEP 1 -->

                <div style="
                display: flex;
                gap: 15px;
                align-items: flex-start;
                margin-bottom: 14px;
            ">

                    <i class="fa-solid fa-1"></i>

                    <div>

                        <strong>
                            Place an order
                        </strong>

                        <p style="margin: 4px 0 0;">

                            Select the products you need and place your
                            order from the Orders page.

                        </p>

                    </div>

                </div>


                <!-- STEP 2 -->

                <div style="
                display: flex;
                gap: 15px;
                align-items: flex-start;
                margin-bottom: 14px;
            ">

                    <i class="fa-solid fa-2"></i>

                    <div>

                        <strong>
                            Request shipment from your order
                        </strong>

                        <p style="margin: 4px 0 0;">

                            Once your order is ready, use the shipment
                            request option from the Orders page.

                        </p>

                    </div>

                </div>


                <!-- STEP 3 -->

                <div style="
                display: flex;
                gap: 15px;
                align-items: flex-start;
                margin-bottom: 14px;
            ">

                    <i class="fa-solid fa-3"></i>

                    <div>

                        <strong>
                            Logistics team processes the shipment
                        </strong>

                        <p style="margin: 4px 0 0;">

                            The logistics team reviews the request,
                            assigns the appropriate carrier and creates
                            the shipment.

                        </p>

                    </div>

                </div>


                <!-- STEP 4 -->

                <div style="
                display: flex;
                gap: 15px;
                align-items: flex-start;
            ">

                    <i class="fa-solid fa-4"></i>

                    <div>

                        <strong>
                            Track your shipment
                        </strong>

                        <p style="margin: 4px 0 0;">

                            After the shipment is created, the tracking
                            number, status, route and estimated delivery
                            date will appear on this page.

                        </p>

                    </div>

                </div>


            </div>

        </div>


        <!-- =====================================================
             FOOTER
             ===================================================== -->

        <footer class="footer">

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
