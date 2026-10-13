<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sasindi.globaltrade.entity.*" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("activePage", "invoices");

    List<Invoice> myInvoices = (List<Invoice>) request.getAttribute("myInvoices");

    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GlobalTrade | Invoices</title>

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
                <h1>Invoices</h1>
                <p>Billing history for your shipments. Download any invoice as a PDF.</p>
            </div>
        </div>

        <% if (errorMessage != null) { %>
        <div class="flash-message flash-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <%= errorMessage %>
        </div>
        <% } %>

        <% if (successMessage != null) { %>
        <div class="flash-message flash-success">
            <i class="fa-solid fa-circle-check"></i>
            <%= successMessage %>
        </div>
        <% } %>

        <div class="card">

            <div class="card-header">
                <h2>Your Invoices</h2>
            </div>

            <div class="table-wrap">

                <% if (myInvoices == null || myInvoices.isEmpty()) { %>

                <div class="empty-state">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                    <p>You don't have any invoices yet. An invoice is generated
                        once one of your shipments is billed.</p>
                </div>

                <% } else { %>

                <table>
                    <thead>
                    <tr>
                        <th>Invoice No.</th>
                        <th>Shipment</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Due Date</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>

                    <% for (Invoice invoice : myInvoices) {
                        String statusClass =
                                "status-pill status-" + invoice.getStatus().toLowerCase();
                    %>

                    <tr>
                        <td><strong><%= invoice.getInvoiceNumber() %></strong></td>
                        <td>
                            <%= invoice.getShipment() != null
                                    ? invoice.getShipment().getTrackingNumber() : "-" %>
                        </td>
                        <td>Rs<%= invoice.getAmount() %></td>
                        <td><span class="<%= statusClass %>"><%= invoice.getStatus() %></span></td>
                        <td><%= invoice.getDueDate() %></td>
                        <td style="display:flex; gap:6px;">

                            <a href="${pageContext.request.contextPath}/invoices/download?id=<%= invoice.getId() %>"
                               class="btn btn-secondary"
                               target="_blank"
                               style="padding:6px 10px;font-size:9px;">
                                <i class="fa-solid fa-file-pdf"></i>
                                PDF
                            </a>

                            <% if ("UNPAID".equals(invoice.getStatus())
                                    || "OVERDUE".equals(invoice.getStatus())) { %>
                            <form method="post"
                                  action="${pageContext.request.contextPath}/invoices"
                                  style="display:inline;">
                                <input type="hidden" name="invoiceId" value="<%= invoice.getId() %>">
                                <button type="submit" class="btn btn-primary"
                                        style="padding:6px 10px;font-size:9px;">
                                    Mark as Paid
                                </button>
                            </form>
                            <% } %>

                        </td>
                    </tr>

                    <% } %>

                    </tbody>
                </table>

                <% } %>

            </div>

        </div>

        <footer class="footer" style="margin-top:14px;">
            <span>&copy; 2026 GlobalTrade Logistics System. All rights reserved.</span>
            <span>Version 1.0.0</span>
        </footer>

    </section>

</main>

</body>
</html>
