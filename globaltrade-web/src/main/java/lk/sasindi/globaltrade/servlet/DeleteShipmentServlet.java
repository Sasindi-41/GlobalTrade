package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.ShipmentSessionBean;

import java.io.IOException;

@WebServlet("/admin/delete-shipment")
public class DeleteShipmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @EJB
    private ShipmentSessionBean shipmentSessionBean;

    @Override
    protected void doPost(
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
                    request.getContextPath()
                            + "/signin"
            );

            return;
        }

        String role =
                (String) session.getAttribute("role");


        if (role == null ||
                !"ADMIN".equalsIgnoreCase(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access denied."
            );

            return;
        }
        Object userIdObject =
                session.getAttribute("userId");

        if (userIdObject == null) {

            session.setAttribute(
                    "errorMessage",
                    "User session could not be identified."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/shipments"
            );

            return;
        }

        Integer userId =
                ((Number) userIdObject).intValue();

        String idString =
                request.getParameter("id");


        if (idString == null ||
                idString.trim().isEmpty()) {

            session.setAttribute(
                    "errorMessage",
                    "Shipment ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/shipments"
            );

            return;
        }


        Integer id;


        try {

            id =
                    Integer.parseInt(
                            idString
                    );

        } catch (NumberFormatException e) {

            session.setAttribute(
                    "errorMessage",
                    "Invalid shipment ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/shipments"
            );

            return;
        }

        try {

            shipmentSessionBean
                    .deleteShipment(
                            id,
                            userId
                    );


            session.setAttribute(
                    "successMessage",
                    "Shipment deleted successfully."
            );


        } catch (Exception e) {

            e.printStackTrace();


            session.setAttribute(
                    "errorMessage",
                    "Unable to delete shipment: "
                            + e.getMessage()
            );
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/shipments"
        );
    }
}