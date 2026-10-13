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

@WebServlet("/admin/update-shipment")
public class UpdateShipmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private ShipmentSessionBean shipmentSessionBean;

    @EJB
    private UserService userService;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                !Boolean.TRUE.equals(
                        session.getAttribute("authenticated")
                )) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED
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

        String idString =
                request.getParameter("id");


        if (idString == null ||
                idString.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Shipment ID is required."
            );

            return;
        }


        Integer id;

        try {

            id = Integer.parseInt(idString);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid shipment ID."
            );

            return;
        }

        Shipment shipment =
                shipmentSessionBean.getShipment(id);


        if (shipment == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Shipment was not found."
            );

            return;
        }

        if (shipment.getShipmentItems() == null ||
                shipment.getShipmentItems().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Shipment item was not found."
            );

            return;
        }


        var shipmentItem =
                shipment.getShipmentItems().get(0);

        response.setContentType(
                "application/json"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );


        StringBuilder json =
                new StringBuilder();


        json.append("{");


        json.append("\"id\":")
                .append(shipment.getId())
                .append(",");


        json.append("\"trackingNumber\":\"")
                .append(jsonEscape(
                        shipment.getTrackingNumber()
                ))
                .append("\",");


        json.append("\"vendorId\":")
                .append(
                        shipment.getVendor() != null
                                ? shipment.getVendor().getId()
                                : "null"
                )
                .append(",");

        json.append("\"vendorName\":\"")
                .append(jsonEscape(
                        shipment.getVendor() != null
                                ? shipment.getVendor().getCompanyName()
                                : ""
                ))
                .append("\",");

        json.append("\"originAddressId\":")
                .append(
                        shipment.getOriginAddress() != null
                                ? shipment.getOriginAddress().getId()
                                : "null"
                )
                .append(",");

        json.append("\"originAddress\":\"")
                .append(jsonEscape(
                        getAddressText(
                                shipment.getOriginAddress()
                        )
                ))
                .append("\",");

        json.append("\"destinationAddressId\":")
                .append(
                        shipment.getDestinationAddress() != null
                                ? shipment.getDestinationAddress().getId()
                                : "null"
                )
                .append(",");

        json.append("\"destinationAddress\":\"")
                .append(jsonEscape(
                        getAddressText(
                                shipment.getDestinationAddress()
                        )
                ))
                .append("\",");


        json.append("\"expectedDelivery\":\"")
                .append(
                        shipment.getExpectedDelivery() != null
                                ? shipment.getExpectedDelivery().toString()
                                : ""
                )
                .append("\",");

        json.append("\"shipmentStatusId\":")
                .append(
                        shipment.getShipmentStatus() != null
                                ? shipment.getShipmentStatus().getId()
                                : "null"
                )
                .append(",");

        json.append("\"inventoryId\":")
                .append(
                        shipmentItem.getInventory() != null
                                ? shipmentItem.getInventory().getId()
                                : "null"
                )
                .append(",");


        json.append("\"inventoryName\":\"")
                .append(jsonEscape(
                        shipmentItem.getInventory() != null
                                ? shipmentItem.getInventory().getProductName()
                                : ""
                ))
                .append("\",");

        json.append("\"quantity\":")
                .append(
                        shipmentItem.getQuantity()
                )
                .append(",");

        json.append("\"unitValue\":\"")
                .append(
                        shipmentItem.getUnitValue() != null
                                ? shipmentItem.getUnitValue().toString()
                                : ""
                )
                .append("\"");


        json.append("}");


        response.getWriter()
                .write(json.toString());
    }
    private String jsonEscape(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
    private String getAddressText(
            lk.sasindi.globaltrade.entity.Address address
    ) {

        if (address == null) {
            return "";
        }


        StringBuilder result =
                new StringBuilder();


        if (address.getLine1() != null &&
                !address.getLine1().trim().isEmpty()) {

            result.append(
                    address.getLine1()
            );
        }


        if (address.getLine2() != null &&
                !address.getLine2().trim().isEmpty()) {

            if (result.length() > 0) {
                result.append(", ");
            }

            result.append(
                    address.getLine2()
            );
        }


        if (address.getCity() != null) {

            if (result.length() > 0) {
                result.append(", ");
            }

            result.append(
                    address.getCity().getName()
            );
        }


        return result.toString();
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

            String idString =
                    request.getParameter("id");

            if (idString == null ||
                    idString.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Shipment ID is required."
                );
            }

            Integer id;

            try {

                id =
                        Integer.parseInt(
                                idString
                        );

            } catch (NumberFormatException e) {

                throw new IllegalArgumentException(
                        "Invalid shipment ID."
                );
            }

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

            String statusIdString =
                    request.getParameter(
                            "shipmentStatusId"
                    );

            if (statusIdString == null ||
                    statusIdString.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Shipment status is required."
                );
            }

            Integer shipmentStatusId;

            try {

                shipmentStatusId =
                        Integer.parseInt(
                                statusIdString
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
                    shipmentSessionBean.updateShipment(
                            id,
                            vendorId,
                            shipmentStatusId,
                            originAddressId,
                            destinationAddressId,
                            expectedDelivery,
                            inventoryId,
                            quantity,
                            unitValue,
                            userId
                    );

            session.setAttribute(
                    "successMessage",
                    "Shipment "
                            + shipment.getTrackingNumber()
                            + " updated successfully."
            );


        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Unable to update shipment: "
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