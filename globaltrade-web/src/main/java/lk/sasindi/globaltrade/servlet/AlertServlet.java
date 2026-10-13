package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.AlertServiceBean;
import lk.sasindi.globaltrade.exception.AlertException;

import java.io.IOException;

@WebServlet("/alerts")
public class AlertServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private AlertServiceBean alertServiceBean;

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
                    request.getContextPath() +
                            "/signin"
            );

            return;
        }

        String role =
                String.valueOf(
                        session.getAttribute("role")
                );


        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() +
                            "/user/dashboard"
            );

            return;
        }

        try {

            loadPage(request);

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Unable to load alert information."
            );
        }


        request.getRequestDispatcher(
                "/admin/alerts.jsp"
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
                    request.getContextPath() +
                            "/signin"
            );

            return;
        }

        Object userIdObject =
                session.getAttribute("userId");

        if (userIdObject == null) {

            session.setAttribute(
                    "errorMessage",
                    "Authenticated user could not be identified."
            );

            redirectToAlerts(
                    request,
                    response
            );

            return;
        }

        Integer userId =
                ((Number) userIdObject).intValue();

        String role =
                String.valueOf(
                        session.getAttribute("role")
                );


        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() +
                            "/user/dashboard"
            );

            return;
        }

        String action =
                request.getParameter("action");


        if (action == null ||
                action.trim().isEmpty()) {

            session.setAttribute(
                    "errorMessage",
                    "Alert action is required."
            );

            redirectToAlerts(
                    request,
                    response
            );

            return;
        }


        try {

            if ("create".equalsIgnoreCase(action)) {

                createAlert(
                        request,
                        userId
                );

                session.setAttribute(
                        "successMessage",
                        "Alert created successfully."
                );
            }

            else if ("resolve".equalsIgnoreCase(action)) {

                Integer id =
                        parseId(
                                request.getParameter("id"),
                                "Alert"
                        );

                alertServiceBean.resolveAlert(
                        id,
                        userId
                );

                session.setAttribute(
                        "successMessage",
                        "Alert resolved successfully."
                );
            }

            else if ("reopen".equalsIgnoreCase(action)) {

                Integer id =
                        parseId(
                                request.getParameter("id"),
                                "Alert"
                        );

                alertServiceBean.reopenAlert(
                        id,
                        userId
                );

                session.setAttribute(
                        "successMessage",
                        "Alert reopened successfully."
                );
            }

            else {

                session.setAttribute(
                        "errorMessage",
                        "Invalid alert action."
                );
            }


        } catch (AlertException e) {

            session.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Unable to process the alert request."
            );
        }


        redirectToAlerts(
                request,
                response
        );
    }

    private void createAlert(
            HttpServletRequest request,
            Integer userId
    ) throws AlertException {

        String message =
                request.getParameter(
                        "message"
                );


        Integer shipmentId =
                parseId(
                        request.getParameter(
                                "shipments_id"
                        ),
                        "Shipment"
                );

        Integer vendorId =
                parseId(
                        request.getParameter(
                                "vendors_id"
                        ),
                        "Vendor"
                );

        Integer inventoryId =
                parseId(
                        request.getParameter(
                                "inventory_id"
                        ),
                        "Inventory"
                );

        Integer alertTypeId =
                parseId(
                        request.getParameter(
                                "alert_type_id"
                        ),
                        "Alert type"
                );

        Integer severityId =
                parseId(
                        request.getParameter(
                                "severity_id"
                        ),
                        "Severity"
                );

        Integer alertStatusId =
                parseId(
                        request.getParameter(
                                "alert_status_id"
                        ),
                        "Alert status"
                );

        alertServiceBean.createAlert(
                userId,
                message,
                shipmentId,
                vendorId,
                inventoryId,
                alertTypeId,
                severityId,
                alertStatusId
        );
    }

    private void loadPage(
            HttpServletRequest request
    ) {

        request.setAttribute(
                "alerts",
                alertServiceBean.getAllAlerts()
        );

        request.setAttribute(
                "totalAlerts",
                alertServiceBean.getTotalCount()
        );

        request.setAttribute(
                "openAlerts",
                alertServiceBean.getOpenCount()
        );

        request.setAttribute(
                "criticalAlerts",
                alertServiceBean.getCriticalCount()
        );

        request.setAttribute(
                "resolvedAlerts",
                alertServiceBean.getResolvedCount()
        );

        request.setAttribute(
                "shipments",
                alertServiceBean.getAllShipments()
        );

        request.setAttribute(
                "vendors",
                alertServiceBean.getAllVendors()
        );

        request.setAttribute(
                "inventories",
                alertServiceBean.getAllInventory()
        );

        request.setAttribute(
                "alertTypes",
                alertServiceBean.getAllAlertTypes()
        );

        request.setAttribute(
                "severities",
                alertServiceBean.getAllSeverities()
        );

        request.setAttribute(
                "alertStatuses",
                alertServiceBean.getAllAlertStatuses()
        );
    }

    private Integer parseId(
            String value,
            String field
    ) throws AlertException {

        if (value == null ||
                value.trim().isEmpty()) {

            throw new AlertException(
                    field +
                            " selection is required."
            );
        }


        try {

            Integer id =
                    Integer.valueOf(
                            value.trim()
                    );


            if (id <= 0) {

                throw new AlertException(
                        "Invalid " +
                                field.toLowerCase() +
                                " ID."
                );
            }


            return id;

        } catch (NumberFormatException e) {

            throw new AlertException(
                    "Invalid " +
                            field.toLowerCase() +
                            " ID."
            );
        }
    }

    private void redirectToAlerts(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath() +
                        "/alerts"
        );
    }
}