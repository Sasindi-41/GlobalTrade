package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.ShipmentSessionBean;
import lk.sasindi.globaltrade.entity.Inventory;
import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.entity.ShipmentStatus;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.entity.Vendor;
import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/admin/create-shipment")
public class CreateShipmentServlet extends HttpServlet {

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

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );
            return;
        }

        int userId =
                ((Number) userIdObject).intValue();

        User user =
                userService.findById(userId);

        if (user == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Administrator profile could not be loaded."
            );
            return;
        }

        request.setAttribute(
                "user",
                user
        );

        List<Vendor> vendors =
                shipmentSessionBean.getAllVendors();

        request.setAttribute(
                "vendors",
                vendors
        );

        List<ShipmentStatus> shipmentStatuses =
                shipmentSessionBean.getAllShipmentStatuses();

        request.setAttribute(
                "shipmentStatuses",
                shipmentStatuses
        );

        List<Inventory> inventoryItems =
                shipmentSessionBean.getAllInventory();

        request.setAttribute(
                "inventoryItems",
                inventoryItems
        );

        request.setAttribute(
                "addresses",
                shipmentSessionBean.getAllAddresses()
        );

        request.getRequestDispatcher(
                "/admin/create-shipment.jsp"
        ).forward(
                request,
                response
        );
    }

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
                    request.getContextPath() + "/signin"
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

        try {

            String originAddressIdString =
                    request.getParameter(
                            "originAddressId"
                    );

            if (originAddressIdString == null ||
                    originAddressIdString.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Origin address is required."
                );
            }

            Integer originAddressId;

            try {

                originAddressId =
                        Integer.parseInt(
                                originAddressIdString
                        );

            } catch (NumberFormatException e) {

                throw new IllegalArgumentException(
                        "Invalid origin address."
                );
            }

            String destinationAddressIdString =
                    request.getParameter(
                            "destinationAddressId"
                    );

            if (destinationAddressIdString == null ||
                    destinationAddressIdString.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Destination address is required."
                );
            }

            Integer destinationAddressId;

            try {

                destinationAddressId =
                        Integer.parseInt(
                                destinationAddressIdString
                        );

            } catch (NumberFormatException e) {

                throw new IllegalArgumentException(
                        "Invalid destination address."
                );
            }

            String expectedDeliveryString =
                    request.getParameter(
                            "expectedDelivery"
                    );

            if (expectedDeliveryString == null ||
                    expectedDeliveryString.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Expected delivery date is required."
                );
            }

            LocalDateTime expectedDelivery;

            try {

                expectedDelivery =
                        LocalDateTime.parse(
                                expectedDeliveryString
                        );

            } catch (Exception e) {

                throw new IllegalArgumentException(
                        "Invalid expected delivery date."
                );
            }

            String vendorIdString =
                    request.getParameter(
                            "vendorId"
                    );

            if (vendorIdString == null ||
                    vendorIdString.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Vendor is required."
                );
            }

            Integer vendorId;

            try {

                vendorId =
                        Integer.parseInt(
                                vendorIdString
                        );

            } catch (NumberFormatException e) {

                throw new IllegalArgumentException(
                        "Invalid vendor."
                );
            }

            String shipmentStatusIdString =
                    request.getParameter(
                            "shipmentStatusId"
                    );

            if (shipmentStatusIdString == null ||
                    shipmentStatusIdString.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Shipment status is required."
                );
            }

            Integer shipmentStatusId;

            try {

                shipmentStatusId =
                        Integer.parseInt(
                                shipmentStatusIdString
                        );

            } catch (NumberFormatException e) {

                throw new IllegalArgumentException(
                        "Invalid shipment status."
                );
            }

            String inventoryIdString =
                    request.getParameter(
                            "inventoryId"
                    );

            if (inventoryIdString == null ||
                    inventoryIdString.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Inventory item is required."
                );
            }

            Integer inventoryId;

            try {

                inventoryId =
                        Integer.parseInt(
                                inventoryIdString
                        );

            } catch (NumberFormatException e) {

                throw new IllegalArgumentException(
                        "Invalid inventory item."
                );
            }

            String quantityString =
                    request.getParameter(
                            "quantity"
                    );

            if (quantityString == null ||
                    quantityString.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Quantity is required."
                );
            }

            Integer quantity;

            try {

                quantity =
                        Integer.parseInt(
                                quantityString
                        );

            } catch (NumberFormatException e) {

                throw new IllegalArgumentException(
                        "Quantity must be a valid number."
                );
            }

            if (quantity <= 0) {

                throw new IllegalArgumentException(
                        "Quantity must be greater than zero."
                );
            }

            String unitValueString =
                    request.getParameter(
                            "unitValue"
                    );

            if (unitValueString == null ||
                    unitValueString.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Unit value is required."
                );
            }

            BigDecimal unitValue;

            try {

                unitValue =
                        new BigDecimal(
                                unitValueString
                        );

            } catch (NumberFormatException e) {

                throw new IllegalArgumentException(
                        "Unit value must be a valid number."
                );
            }

            if (unitValue.compareTo(
                    BigDecimal.ZERO
            ) < 0) {

                throw new IllegalArgumentException(
                        "Unit value cannot be negative."
                );
            }

            Shipment shipment =
                    shipmentSessionBean.createShipment(
                            vendorId,
                            shipmentStatusId,
                            inventoryId,
                            originAddressId,
                            destinationAddressId,
                            expectedDelivery,
                            quantity,
                            unitValue,
                            userId
                    );

            session.setAttribute(
                    "successMessage",
                    "Shipment created successfully. Tracking Number: "
                            + shipment.getTrackingNumber()
            );


        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Unable to create shipment: "
                            + getErrorMessage(e)
            );
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/shipments"
        );
    }

    private String getErrorMessage(Exception e) {

        Throwable cause = e;

        while (cause.getCause() != null) {
            cause = cause.getCause();
        }

        if (cause.getMessage() != null &&
                !cause.getMessage().trim().isEmpty()) {

            return cause.getMessage();
        }

        if (e.getMessage() != null &&
                !e.getMessage().trim().isEmpty()) {

            return e.getMessage();
        }

        return "An unexpected error occurred.";
    }
}