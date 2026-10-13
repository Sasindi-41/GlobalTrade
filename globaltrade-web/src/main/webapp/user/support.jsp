<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sasindi.globaltrade.entity.*" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("activePage", "support");

    List<SupportTicket> myTickets = (List<SupportTicket>) request.getAttribute("myTickets");

    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GlobalTrade | Support</title>

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
                <h1>Support</h1>
                <p>Raise a ticket and our team will get back to you.</p>
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

        <div class="page-grid">

            <div class="card">

                <div class="card-header">
                    <h2>Your Tickets</h2>
                </div>

                <div class="table-wrap">

                    <% if (myTickets == null || myTickets.isEmpty()) { %>

                    <div class="empty-state">
                        <i class="fa-solid fa-headset"></i>
                        <p>You haven't raised any support tickets yet.</p>
                    </div>

                    <% } else { %>

                    <table>
                        <thead>
                        <tr>
                            <th>Ticket No.</th>
                            <th>Subject</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Raised</th>
                        </tr>
                        </thead>
                        <tbody>

                        <% for (SupportTicket ticket : myTickets) {
                            String statusClass =
                                    "status-pill status-" + ticket.getStatus().toLowerCase();
                        %>

                        <tr>
                            <td><strong><%= ticket.getTicketNumber() %></strong></td>
                            <td><%= ticket.getSubject() %></td>
                            <td><%= ticket.getPriority() %></td>
                            <td><span class="<%= statusClass %>"><%= ticket.getStatus() %></span></td>
                            <td><%= ticket.getCreatedAt().toLocalDate() %></td>
                        </tr>

                        <% } %>

                        </tbody>
                    </table>

                    <% } %>

                </div>

            </div>

            <div class="card">

                <div class="card-header">
                    <h2>Raise a Ticket</h2>
                </div>

                <form method="post"
                      action="${pageContext.request.contextPath}/support"
                      class="edit-form"
                      style="padding: 18px;">

                    <div class="form-group full">
                        <label>Subject</label>
                        <input type="text" name="subject"
                               placeholder="Briefly describe the issue" required>
                    </div>

                    <div class="form-group full">
                        <label>Priority</label>
                        <select name="priority">
                            <option value="LOW">Low</option>
                            <option value="NORMAL" selected>Normal</option>
                            <option value="HIGH">High</option>
                            <option value="URGENT">Urgent</option>
                        </select>
                    </div>

                    <div class="form-group full">
                        <label>Message</label>
                        <textarea class="textarea" name="message" required
                                  placeholder="Tell us what's going on..."></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-paper-plane"></i>
                            Submit Ticket
                        </button>
                    </div>

                </form>

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
