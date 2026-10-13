package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.CustomDocumentSessionBean;
import lk.sasindi.globaltrade.bean.InvoiceSessionBean;
import lk.sasindi.globaltrade.bean.ShipmentSessionBean;
import lk.sasindi.globaltrade.bean.SupportTicketSessionBean;

import lk.sasindi.globaltrade.entity.CustomDocument;
import lk.sasindi.globaltrade.entity.Invoice;
import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.entity.SupportTicket;
import lk.sasindi.globaltrade.entity.User;

import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/user/dashboard")
public class UserDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private ShipmentSessionBean shipmentSessionBean;

    @EJB
    private CustomDocumentSessionBean customDocumentSessionBean;

    @EJB
    private InvoiceSessionBean invoiceSessionBean;

    @EJB
    private SupportTicketSessionBean supportTicketSessionBean;

    @EJB
    private UserService userService;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                !Boolean.TRUE.equals(
                        session.getAttribute("authenticated")
                )) {

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );

            return;
        }

        String role =
                (String) session.getAttribute("role");

        if (role == null ||
                !"USER".equalsIgnoreCase(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access denied."
            );

            return;
        }

        Object userIdObject = session.getAttribute("userId");
        Integer userId = userIdObject instanceof Number
                ? ((Number) userIdObject).intValue() : null;

        try {

            User user = userService.findById(userId);

            List<Shipment> myShipments = shipmentSessionBean.getMyShipments(userId);
            List<CustomDocument> myDocuments = customDocumentSessionBean.getMyDocuments(userId);
            List<Invoice> myInvoices = invoiceSessionBean.getMyInvoices(userId);
            List<SupportTicket> myTickets = supportTicketSessionBean.getMyTickets(userId);

            int inTransit = 0;
            int delayed = 0;
            int delivered = 0;

            for (Shipment shipment : myShipments) {

                String statusName = shipment.getShipmentStatus() != null
                        ? shipment.getShipmentStatus().getName() : "";

                String lower = statusName.toLowerCase();

                if (lower.contains("transit")) {
                    inTransit++;
                } else if (lower.contains("delay")) {
                    delayed++;
                } else if (lower.contains("deliver")) {
                    delivered++;
                }
            }

            int pendingDocuments = 0;

            for (CustomDocument document : myDocuments) {

                String statusName = document.getDocumentStatus() != null
                        ? document.getDocumentStatus().getName() : "";

                if (statusName.toLowerCase().contains("pending")) {
                    pendingDocuments++;
                }
            }

            BigDecimal totalSpent = BigDecimal.ZERO;
            int unpaidInvoices = 0;

            for (Invoice invoice : myInvoices) {

                if ("PAID".equalsIgnoreCase(invoice.getStatus())
                        && invoice.getAmount() != null) {

                    totalSpent = totalSpent.add(invoice.getAmount());

                } else {
                    unpaidInvoices++;
                }
            }

            int openTickets = 0;

            for (SupportTicket ticket : myTickets) {

                if (!"CLOSED".equalsIgnoreCase(ticket.getStatus())
                        && !"RESOLVED".equalsIgnoreCase(ticket.getStatus())) {

                    openTickets++;
                }
            }

            request.setAttribute(
                    "userName",
                    user != null && user.getFirstName() != null
                            ? user.getFirstName() : "User"
            );

            request.setAttribute("totalShipments", myShipments.size());
            request.setAttribute("inTransit", inTransit);
            request.setAttribute("delayedShipments", delayed);
            request.setAttribute("deliveredShipments", delivered);
            request.setAttribute("pendingDocuments", pendingDocuments);
            request.setAttribute(
                    "totalSpent",
                    "$" + totalSpent.setScale(2, java.math.RoundingMode.HALF_UP)
            );
            request.setAttribute("notificationCount", unpaidInvoices + openTickets);

            request.setAttribute(
                    "recentShipments",
                    myShipments.size() > 5
                            ? myShipments.subList(0, 5)
                            : myShipments
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("userName", "User");
            request.setAttribute("totalShipments", 0);
            request.setAttribute("inTransit", 0);
            request.setAttribute("delayedShipments", 0);
            request.setAttribute("deliveredShipments", 0);
            request.setAttribute("pendingDocuments", 0);
            request.setAttribute("totalSpent", "$0.00");
            request.setAttribute("notificationCount", 0);
            request.setAttribute("recentShipments", List.of());
        }

        request.getRequestDispatcher(
                "/user/dashboard.jsp"
        ).forward(
                request,
                response
        );
    }
}
