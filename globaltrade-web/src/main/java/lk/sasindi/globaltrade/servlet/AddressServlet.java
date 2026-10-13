package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.AddressSessionBean;
import lk.sasindi.globaltrade.entity.Address;
import lk.sasindi.globaltrade.entity.City;
import lk.sasindi.globaltrade.entity.Country;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/address")
public class AddressServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @EJB
    private AddressSessionBean addressSessionBean;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        if (!isAdmin(request)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access denied."
            );

            return;
        }


        String action =
                request.getParameter("action");

        if ("countries".equalsIgnoreCase(action)) {

            sendCountries(
                    response
            );

            return;
        }

        if ("cities".equalsIgnoreCase(action)) {

            sendCities(
                    request,
                    response
            );

            return;
        }

        if ("addresses".equalsIgnoreCase(action)) {

            sendAddresses(
                    response
            );

            return;
        }


        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid action."
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        if (!isAdmin(request)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access denied."
            );

            return;
        }


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

            if (line1 == null || line1.trim().isEmpty() ||
                    postalCode == null || postalCode.trim().isEmpty() ||
                    contactName == null || contactName.trim().isEmpty() ||
                    contactPhone == null || contactPhone.trim().isEmpty() ||
                    countryIdString == null || countryIdString.trim().isEmpty() ||
                    cityIdString == null || cityIdString.trim().isEmpty()) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                response.setContentType(
                        "application/json"
                );

                response.setCharacterEncoding(
                        "UTF-8"
                );

                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Please fill all required address fields.\"}"
                );

                return;
            }

            Integer countryId;
            Integer cityId;

            try {

                countryId =
                        Integer.parseInt(
                                countryIdString.trim()
                        );

                cityId =
                        Integer.parseInt(
                                cityIdString.trim()
                        );

            } catch (NumberFormatException e) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                response.setContentType(
                        "application/json"
                );

                response.setCharacterEncoding(
                        "UTF-8"
                );

                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Invalid country or city selected.\"}"
                );

                return;
            }


            Address address =
                    addressSessionBean.createAddress(
                            line1,
                            line2,
                            postalCode,
                            contactName,
                            contactPhone,
                            countryId,
                            cityId
                    );


            response.setContentType(
                    "application/json"
            );

            response.setCharacterEncoding(
                    "UTF-8"
            );


            String title =
                    buildAddressTitle(
                            address
                    );


            String subtitle =
                    "Contact: "
                            + address.getContactName()
                            + " • Phone: "
                            + address.getContactPhone()
                            + " • Postal Code: "
                            + address.getPostalCode();


            String json =
                    "{"
                            + "\"success\":true,"
                            + "\"id\":" + address.getId() + ","
                            + "\"title\":\""
                            + escapeJson(title)
                            + "\","
                            + "\"subtitle\":\""
                            + escapeJson(subtitle)
                            + "\""
                            + "}";


            response.getWriter()
                    .write(json);


        } catch (Exception e) {

            e.printStackTrace();


            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST
            );


            response.setContentType(
                    "application/json"
            );


            response.getWriter()
                    .write(
                            "{"
                                    + "\"success\":false,"
                                    + "\"message\":\""
                                    + escapeJson(
                                    getErrorMessage(e)
                            )
                                    + "\""
                                    + "}"
                    );
        }
    }

    private void sendCountries(
            HttpServletResponse response
    ) throws IOException {

        List<Country> countries =
                addressSessionBean.getAllCountries();


        StringBuilder json =
                new StringBuilder("[");


        for (int i = 0;
             i < countries.size();
             i++) {

            Country country =
                    countries.get(i);


            if (i > 0) {
                json.append(",");
            }


            json.append("{")
                    .append("\"id\":")
                    .append(country.getId())
                    .append(",")
                    .append("\"name\":\"")
                    .append(
                            escapeJson(
                                    country.getName()
                            )
                    )
                    .append("\"")
                    .append("}");
        }


        json.append("]");


        writeJson(
                response,
                json.toString()
        );
    }

    private void sendCities(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String countryIdString =
                request.getParameter(
                        "countryId"
                );


        if (countryIdString == null ||
                countryIdString.trim().isEmpty()) {

            writeJson(
                    response,
                    "[]"
            );

            return;
        }


        Integer countryId;

        try {

            countryId =
                    Integer.parseInt(
                            countryIdString.trim()
                    );

        } catch (NumberFormatException e) {

            writeJson(
                    response,
                    "[]"
            );

            return;
        }


        List<City> cities =
                addressSessionBean.getCitiesByCountry(
                        countryId
                );


        StringBuilder json =
                new StringBuilder("[");


        for (int i = 0;
             i < cities.size();
             i++) {

            City city =
                    cities.get(i);


            if (i > 0) {
                json.append(",");
            }


            json.append("{")
                    .append("\"id\":")
                    .append(city.getId())
                    .append(",")
                    .append("\"name\":\"")
                    .append(
                            escapeJson(
                                    city.getName()
                            )
                    )
                    .append("\"")
                    .append("}");
        }


        json.append("]");


        writeJson(
                response,
                json.toString()
        );
    }

    private void sendAddresses(
            HttpServletResponse response
    ) throws IOException {

        List<Address> addresses =
                addressSessionBean
                        .getAllAddresses();


        StringBuilder json =
                new StringBuilder("[");


        for (int i = 0;
             i < addresses.size();
             i++) {

            Address address =
                    addresses.get(i);


            if (i > 0) {
                json.append(",");
            }


            json.append("{")
                    .append("\"id\":")
                    .append(address.getId())
                    .append(",")
                    .append("\"title\":\"")
                    .append(
                            escapeJson(
                                    buildAddressTitle(
                                            address
                                    )
                            )
                    )
                    .append("\",")
                    .append("\"subtitle\":\"")
                    .append(
                            escapeJson(
                                    "Contact: "
                                            + address.getContactName()
                                            + " • Phone: "
                                            + address.getContactPhone()
                            )
                    )
                    .append("\"")
                    .append("}");
        }


        json.append("]");


        writeJson(
                response,
                json.toString()
        );
    }

    private String buildAddressTitle(
            Address address
    ) {

        StringBuilder result =
                new StringBuilder();


        if (address.getLine1() != null) {

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


        if (address.getCity() != null &&
                address.getCity().getName() != null) {

            if (result.length() > 0) {
                result.append(", ");
            }

            result.append(
                    address.getCity().getName()
            );
        }


        if (address.getCountry() != null &&
                address.getCountry().getName() != null) {

            if (result.length() > 0) {
                result.append(", ");
            }

            result.append(
                    address.getCountry().getName()
            );
        }


        return result.toString();
    }

    private boolean isAdmin(
            HttpServletRequest request
    ) {

        HttpSession session =
                request.getSession(false);


        if (session == null) {
            return false;
        }


        if (!Boolean.TRUE.equals(
                session.getAttribute(
                        "authenticated"
                )
        )) {
            return false;
        }


        String role =
                (String) session.getAttribute(
                        "role"
                );


        return "ADMIN".equalsIgnoreCase(
                role
        );
    }

    private void writeJson(
            HttpServletResponse response,
            String json
    ) throws IOException {

        response.setContentType(
                "application/json"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );

        response.getWriter()
                .write(json);
    }


    private String escapeJson(
            String value
    ) {

        if (value == null) {
            return "";
        }


        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", " ")
                .replace("\n", " ");
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


        return "Unable to save address.";
    }
}