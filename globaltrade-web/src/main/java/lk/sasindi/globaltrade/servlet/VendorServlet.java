package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lk.sasindi.globaltrade.entity.Country;
import lk.sasindi.globaltrade.entity.Status;
import lk.sasindi.globaltrade.entity.Vendor;
import lk.sasindi.globaltrade.service.VendorService;
import lk.sasindi.globaltrade.bean.AccessControlSessionBean;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import jakarta.servlet.http.HttpSession;

@WebServlet("/vendors")
public class VendorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private VendorService vendorService;

    @EJB
    private AccessControlSessionBean accessControlSessionBean;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            request.setAttribute("activePage", "vendors");

            loadReferenceData(request);

            request.setAttribute(
                    "nextVendorCode",
                    vendorService.generateNextVendorCode()
            );

            List<Vendor> vendors = vendorService.findAll();

            request.setAttribute("vendors", vendors);

            request.getRequestDispatcher(
                    "/admin/vendor.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    buildErrorMessage(e)
            );

            request.setAttribute(
                    "vendors",
                    Collections.emptyList()
            );

            request.setAttribute(
                    "nextVendorCode",
                    "VEN-001"
            );

            loadReferenceDataSafely(request);

            request.getRequestDispatcher(
                    "/admin/vendor.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = trim(request.getParameter("action"));

        HttpSession authSession = request.getSession(false);

        Object sessionUserIdObject =
                authSession != null
                        ? authSession.getAttribute("userId")
                        : null;

        Integer sessionUserId =
                sessionUserIdObject instanceof Number
                        ? ((Number) sessionUserIdObject).intValue()
                        : null;

        if (!accessControlSessionBean.hasPermission(
                sessionUserId,
                "MANAGE_VENDORS"
        )) {

            request.setAttribute(
                    "error",
                    "You do not have permission to manage vendors."
            );

            showVendorPage(request, response);

            return;
        }

        try {

            if ("create".equalsIgnoreCase(action)) {

                createVendor(request);

            } else if ("update".equalsIgnoreCase(action)) {

                updateVendor(request);

            } else if ("delete".equalsIgnoreCase(action)) {

                deleteVendor(request);

            } else {

                throw new IllegalArgumentException(
                        "Invalid vendor action."
                );
            }

            String message;

            if ("create".equalsIgnoreCase(action)) {
                message = "Vendor created successfully.";
            } else if ("update".equalsIgnoreCase(action)) {
                message = "Vendor updated successfully.";
            } else {
                message = "Vendor deleted successfully.";
            }

            request.getSession().setAttribute(
                    "vendorSuccess",
                    message
            );

            response.sendRedirect(
                    request.getContextPath() + "/vendors"
            );

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            showVendorPage(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    buildErrorMessage(e)
            );

            showVendorPage(request, response);
        }
    }

    private void createVendor(
            HttpServletRequest request
    ) {

        Integer userId =
                getLoggedInUserId(request);

        String vendorCode =
                trim(request.getParameter("vendorCode"));

        String companyName =
                required(request, "companyName", "Company name");

        String contactName =
                required(request, "contactName", "Contact name");

        String email =
                required(request, "email", "Email");

        String phone =
                required(request, "phone", "Phone");

        BigDecimal performanceScore =
                parseScore(
                        request.getParameter("performanceScore")
                );

        Integer countryId =
                parseRequiredInteger(
                        request.getParameter("countryId"),
                        "Country"
                );

        Integer statusId =
                parseRequiredInteger(
                        request.getParameter("statusId"),
                        "Status"
                );

        vendorService.createVendor(



                vendorCode,
                companyName,
                contactName,
                email,
                phone,
                performanceScore,
                statusId,
                countryId,
                userId
        );
    }

    private void updateVendor(
            HttpServletRequest request
    ) {

        Integer userId =
                getLoggedInUserId(request);

        Integer id =
                parseRequiredInteger(
                        request.getParameter("id"),
                        "Vendor ID"
                );

        String companyName =
                required(request, "companyName", "Company name");

        String contactName =
                required(request, "contactName", "Contact name");

        String email =
                required(request, "email", "Email");

        String phone =
                required(request, "phone", "Phone");

        BigDecimal performanceScore =
                parseScore(
                        request.getParameter("performanceScore")
                );

        Integer countryId =
                parseRequiredInteger(
                        request.getParameter("countryId"),
                        "Country"
                );

        Integer statusId =
                parseRequiredInteger(
                        request.getParameter("statusId"),
                        "Status"
                );

        vendorService.updateVendor(
                id,
                companyName,
                contactName,
                email,
                phone,
                performanceScore,
                statusId,
                countryId,
                userId
        );
    }

    private void deleteVendor(
            HttpServletRequest request
    ) {
        Integer userId =
                getLoggedInUserId(request);

        Integer id =
                parseRequiredInteger(
                        request.getParameter("id"),
                        "Vendor ID"
                );

        vendorService.deleteVendor(
                id,
                userId
        );
    }

    private void showVendorPage(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            request.setAttribute("activePage", "vendors");

            loadReferenceData(request);

            request.setAttribute(
                    "nextVendorCode",
                    vendorService.generateNextVendorCode()
            );

            List<Vendor> vendors =
                    vendorService.findAll();

            request.setAttribute("vendors", vendors);

            request.getRequestDispatcher(
                    "/admin/vendor.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    buildErrorMessage(e)
            );

            request.setAttribute(
                    "vendors",
                    Collections.emptyList()
            );

            request.setAttribute(
                    "nextVendorCode",
                    "VEN-001"
            );

            loadReferenceDataSafely(request);

            request.getRequestDispatcher(
                    "/admin/vendor.jsp"
            ).forward(request, response);
        }
    }

    private void loadReferenceData(
            HttpServletRequest request
    ) {

        request.setAttribute(
                "statuses",
                vendorService.findAllStatuses()
        );

        request.setAttribute(
                "countries",
                vendorService.findAllCountries()
        );

        consumeSuccessMessage(request);
    }

    private void loadReferenceDataSafely(
            HttpServletRequest request
    ) {

        try {
            request.setAttribute(
                    "statuses",
                    vendorService.findAllStatuses()
            );
        } catch (Exception ignored) {
            request.setAttribute(
                    "statuses",
                    Collections.emptyList()
            );
        }

        try {
            request.setAttribute(
                    "countries",
                    vendorService.findAllCountries()
            );
        } catch (Exception ignored) {
            request.setAttribute(
                    "countries",
                    Collections.emptyList()
            );
        }

        consumeSuccessMessage(request);
    }

    private void consumeSuccessMessage(
            HttpServletRequest request
    ) {

        Object message =
                request.getSession().getAttribute(
                        "vendorSuccess"
                );

        if (message != null) {

            request.setAttribute(
                    "success",
                    message.toString()
            );

            request.getSession().removeAttribute(
                    "vendorSuccess"
            );
        }
    }

    private String required(
            HttpServletRequest request,
            String parameter,
            String fieldName
    ) {

        String value =
                trim(request.getParameter(parameter));

        if (value == null || value.isEmpty()) {

            throw new IllegalArgumentException(
                    fieldName + " is required."
            );
        }

        return value;
    }

    private Integer parseRequiredInteger(
            String value,
            String fieldName
    ) {

        if (value == null || value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    fieldName + " is required."
            );
        }

        try {

            return Integer.valueOf(value.trim());

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid " + fieldName + "."
            );
        }
    }

    private BigDecimal parseScore(
            String value
    ) {

        if (value == null || value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Performance score is required."
            );
        }

        try {

            BigDecimal score =
                    new BigDecimal(value.trim());

            if (score.compareTo(BigDecimal.ZERO) < 0 ||
                    score.compareTo(new BigDecimal("100")) > 0) {

                throw new IllegalArgumentException(
                        "Performance score must be between 0 and 100."
                );
            }

            return score;

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid performance score."
            );
        }
    }

    private String trim(String value) {

        return value == null
                ? null
                : value.trim();
    }

    private String buildErrorMessage(
            Throwable throwable
    ) {

        Throwable current = throwable;

        while (current != null) {

            if (current instanceof IllegalArgumentException &&
                    current.getMessage() != null) {

                return current.getMessage();
            }

            current = current.getCause();
        }

        return "Unable to complete the vendor operation. Please try again.";
    }
    private Integer getLoggedInUserId(
            HttpServletRequest request
    ) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            throw new IllegalArgumentException(
                    "User session has expired. Please log in again."
            );
        }

        Object userIdObject =
                session.getAttribute("userId");

        if (userIdObject == null) {
            throw new IllegalArgumentException(
                    "Unable to identify the logged-in user."
            );
        }

        if (userIdObject instanceof Integer) {
            return (Integer) userIdObject;
        }

        try {
            return Integer.valueOf(
                    userIdObject.toString()
            );
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Invalid logged-in user ID."
            );
        }
    }
}
