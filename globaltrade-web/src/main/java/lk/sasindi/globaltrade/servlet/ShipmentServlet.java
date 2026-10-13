package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.sasindi.globaltrade.entity.Inventory;

import lk.sasindi.globaltrade.bean.AddressSessionBean;
import lk.sasindi.globaltrade.bean.ShipmentSessionBean;
import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.entity.ShipmentStatus;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.entity.Vendor;
import lk.sasindi.globaltrade.service.UserService;
import lk.sasindi.globaltrade.entity.Address;
import lk.sasindi.globaltrade.entity.City;
import lk.sasindi.globaltrade.entity.Country;

import java.time.LocalDateTime;

import java.io.IOException;
import java.util.List;

@WebServlet("/shipments")
public class ShipmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private ShipmentSessionBean shipmentSessionBean;

    @EJB
    private UserService userService;

    @EJB
    private AddressSessionBean addressSessionBean;

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
                shipmentSessionBean
                        .getAllShipmentStatuses();

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

        List<Address> addresses =
                addressSessionBean.getAllAddresses();

        request.setAttribute(
                "addresses",
                addresses
        );

        List<Country> countries =
                addressSessionBean.getAllCountries();

        request.setAttribute(
                "countries",
                countries
        );

        List<City> cities =
                addressSessionBean.getAllCities();

        request.setAttribute(
                "cities",
                cities
        );

        String action =
                request.getParameter("action");

        if ("search".equals(action)) {

            String trackingNumber =
                    request.getParameter(
                            "trackingNumber"
                    );

            Shipment shipment =
                    shipmentSessionBean
                            .getShipmentByTrackingNumber(
                                    trackingNumber
                            );

            request.setAttribute(
                    "shipment",
                    shipment
            );

        }

        else if ("delete".equals(action)) {

            String id =
                    request.getParameter("id");

            if (id != null &&
                    !id.trim().isEmpty()) {

                try {

                    shipmentSessionBean.deleteShipment(
                            Integer.parseInt(id),
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
                                    + getErrorMessage(e)
                    );
                }
            }

            response.sendRedirect(
                    request.getContextPath()
                            + "/shipments"
            );

            return;
        }

        else {

            List<Shipment> shipments =
                    shipmentSessionBean
                            .getAllShipments();

            request.setAttribute(
                    "shipments",
                    shipments
            );
        }

        request.getRequestDispatcher(
                "/admin/shipment.jsp"
        ).forward(
                request,
                response
        );
    }

    private String getErrorMessage(
            Exception e
    ) {

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

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED
            );

            response.getWriter().write(
                    "Session expired."
            );

            return;
        }

        String role =
                (String) session.getAttribute("role");

        if (role == null ||
                !"ADMIN".equalsIgnoreCase(role)) {

            response.setStatus(
                    HttpServletResponse.SC_FORBIDDEN
            );

            response.getWriter().write(
                    "Access denied."
            );

            return;
        }

        String action =
                request.getParameter("action");

        if ("addAddress".equals(action)) {

            try {

                String line1 =
                        request.getParameter("line1");

                String line2 =
                        request.getParameter("line2");

                String postalCode =
                        request.getParameter("postalCode");

                String contactName =
                        request.getParameter("contactName");

                String contactPhone =
                        request.getParameter("contactPhone");

                String countryIdString =
                        request.getParameter("countryId");

                String cityIdString =
                        request.getParameter("cityId");

                if (line1 == null ||
                        line1.trim().isEmpty() ||

                        postalCode == null ||
                        postalCode.trim().isEmpty() ||

                        contactName == null ||
                        contactName.trim().isEmpty() ||

                        contactPhone == null ||
                        contactPhone.trim().isEmpty() ||

                        countryIdString == null ||
                        countryIdString.trim().isEmpty() ||

                        cityIdString == null ||
                        cityIdString.trim().isEmpty()) {

                    response.setStatus(
                            HttpServletResponse.SC_BAD_REQUEST
                    );

                    response.setContentType(
                            "application/json"
                    );

                    response.getWriter().write(
                            "{\"success\":false,\"message\":\"Please fill all required fields.\"}"
                    );

                    return;
                }

                int countryId =
                        Integer.parseInt(countryIdString);

                int cityId =
                        Integer.parseInt(cityIdString);

                Country country =
                        addressSessionBean.getCountryById(
                                countryId
                        );

                if (country == null) {

                    response.setStatus(
                            HttpServletResponse.SC_BAD_REQUEST
                    );

                    response.setContentType(
                            "application/json"
                    );

                    response.getWriter().write(
                            "{\"success\":false,\"message\":\"Selected country was not found.\"}"
                    );

                    return;
                }

                City city =
                        addressSessionBean.getCityById(
                                cityId
                        );

                if (city == null) {

                    response.setStatus(
                            HttpServletResponse.SC_BAD_REQUEST
                    );

                    response.setContentType(
                            "application/json"
                    );

                    response.getWriter().write(
                            "{\"success\":false,\"message\":\"Selected city was not found.\"}"
                    );

                    return;
                }

                Address address = new Address();

                address.setLine1(
                        line1.trim()
                );

                address.setLine2(
                        line2 != null &&
                                !line2.trim().isEmpty()
                                ? line2.trim()
                                : null
                );

                address.setPostalCode(
                        postalCode.trim()
                );

                address.setContactName(
                        contactName.trim()
                );

                address.setContactPhone(
                        contactPhone.trim()
                );

                address.setCreatedAt(
                        LocalDateTime.now()
                );

                address.setCountry(
                        country
                );

                address.setCity(
                        city
                );

                Address savedAddress =
                        addressSessionBean.saveAddress(
                                address
                        );


                if (savedAddress == null) {

                    response.setStatus(
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR
                    );

                    response.setContentType(
                            "application/json"
                    );

                    response.getWriter().write(
                            "{\"success\":false,\"message\":\"Unable to save address.\"}"
                    );

                    return;
                }

                StringBuilder addressText =
                        new StringBuilder();

                addressText.append(
                        savedAddress.getLine1()
                );

                if (savedAddress.getLine2() != null &&
                        !savedAddress.getLine2()
                                .trim()
                                .isEmpty()) {

                    addressText.append(", ")
                            .append(
                                    savedAddress.getLine2()
                            );
                }

                if (savedAddress.getCity() != null) {

                    addressText.append(", ")
                            .append(
                                    savedAddress
                                            .getCity()
                                            .getName()
                            );
                }

                if (savedAddress.getCountry() != null) {

                    addressText.append(", ")
                            .append(
                                    savedAddress
                                            .getCountry()
                                            .getName()
                            );
                }

                response.setContentType(
                        "application/json"
                );

                response.setCharacterEncoding(
                        "UTF-8"
                );

                String json =
                        "{"
                                + "\"success\":true,"
                                + "\"id\":" + savedAddress.getId() + ","
                                + "\"address\":\""
                                + escapeJson(
                                addressText.toString()
                        )
                                + "\","
                                + "\"city\":\""
                                + escapeJson(
                                savedAddress
                                        .getCity()
                                        .getName()
                        )
                                + "\","
                                + "\"country\":\""
                                + escapeJson(
                                savedAddress
                                        .getCountry()
                                        .getName()
                        )
                                + "\","
                                + "\"postalCode\":\""
                                + escapeJson(
                                savedAddress
                                        .getPostalCode()
                        )
                                + "\","
                                + "\"contactName\":\""
                                + escapeJson(
                                savedAddress
                                        .getContactName()
                        )
                                + "\","
                                + "\"contactPhone\":\""
                                + escapeJson(
                                savedAddress
                                        .getContactPhone()
                        )
                                + "\""
                                + "}";

                response.getWriter().write(json);

                return;


            } catch (NumberFormatException e) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                response.setContentType(
                        "application/json"
                );

                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Invalid country or city.\"}"
                );

                return;


            } catch (Exception e) {

                e.printStackTrace();

                response.setStatus(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR
                );

                response.setContentType(
                        "application/json"
                );

                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Unable to save address.\"}"
                );

                return;
            }
        }


        response.setStatus(
                HttpServletResponse.SC_BAD_REQUEST
        );

        response.getWriter().write(
                "Invalid action."
        );
    }
    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", " ")
                .replace("\n", " ");
    }
}