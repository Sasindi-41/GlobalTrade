package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lk.sasindi.globaltrade.bean.ShipmentSessionBean;
import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;

@WebServlet("/track")
public class TrackShipmentServlet extends BaseUserServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private ShipmentSessionBean shipmentSessionBean;

    @EJB
    private UserService userService;


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        Integer userId = requireUser(request, response);

        if (userId == null) {
            return;
        }

        User user = userService.findById(userId);
        request.setAttribute("user", user);
        request.setAttribute("activePage", "track");

        String trackingNumber =
                request.getParameter("trackingNumber");

        if (trackingNumber != null && !trackingNumber.trim().isEmpty()) {

            Shipment shipment =
                    shipmentSessionBean.trackMyShipment(
                            trackingNumber.trim(),
                            userId
                    );

            request.setAttribute("searchedTrackingNumber", trackingNumber.trim());

            if (shipment == null) {

                request.setAttribute(
                        "trackErrorMessage",
                        "No shipment matching that tracking number was "
                                + "found on your account."
                );

            } else {

                request.setAttribute("shipment", shipment);
            }
        }

        request.getRequestDispatcher(
                "/user/track.jsp"
        ).forward(request, response);
    }
}
