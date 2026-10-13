package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.ejb.RouteOptimizationServiceBean;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.exception.RouteOptimizationException;
import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;
import java.util.Collections;

@WebServlet("/routes")
public class RouteOptimizationServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @EJB
    private RouteOptimizationServiceBean
            routeOptimizationService;


    @EJB
    private UserService userService;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        if (!isAdmin(session)) {

            response.sendRedirect(
                    request.getContextPath() +
                            "/signin"
            );

            return;
        }


        Object userIdObject =
                session.getAttribute("userId");


        if (!(userIdObject instanceof Number)) {

            response.sendRedirect(
                    request.getContextPath() +
                            "/signin"
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


        try {

            loadPage(request);

        } catch (Exception e) {

            e.printStackTrace();


            request.setAttribute(
                    "errorMessage",
                    "Unable to load route optimization data."
            );


            request.setAttribute(
                    "routes",
                    Collections.emptyList()
            );


            request.setAttribute(
                    "shipments",
                    Collections.emptyList()
            );
        }


        request.getRequestDispatcher(
                "/admin/routes.jsp"
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


        if (!isAdmin(session)) {

            response.sendRedirect(
                    request.getContextPath() +
                            "/signin"
            );

            return;
        }


        Object userObject =
                session.getAttribute("userId");


        if (!(userObject instanceof Number)) {

            response.sendRedirect(
                    request.getContextPath() +
                            "/signin"
            );

            return;
        }


        Integer userId =
                ((Number) userObject).intValue();


        String action =
                request.getParameter("action");


        try {

            switch (
                    action == null
                            ? ""
                            : action.toLowerCase()
            ) {

                case "create", "optimize" -> {

                    Integer shipmentId =
                            parseInteger(
                                    request.getParameter(
                                            "shipmentId"
                                    ),
                                    "Shipment"
                            );


                    routeOptimizationService.createRoute(
                            shipmentId,
                            userId
                    );


                    session.setAttribute(
                            "successMessage",
                            "Route optimization calculated successfully."
                    );
                }

                case "reoptimize" -> {

                    Integer id =
                            parseInteger(
                                    request.getParameter("id"),
                                    "Route ID"
                            );


                    routeOptimizationService.optimizeRoute(
                            id,
                            userId
                    );


                    session.setAttribute(
                            "successMessage",
                            "Route recalculated successfully."
                    );
                }

                case "delete" -> {

                    Integer id =
                            parseInteger(
                                    request.getParameter("id"),
                                    "Route ID"
                            );


                    routeOptimizationService.deleteRoute(
                            id,
                            userId
                    );


                    session.setAttribute(
                            "successMessage",
                            "Route optimization deleted successfully."
                    );
                }

                case "optimizeall" -> {

                    int count =
                            routeOptimizationService
                                    .optimizeAllRoutes();


                    session.setAttribute(
                            "successMessage",
                            count +
                                    " route(s) recalculated successfully."
                    );
                }


                default -> throw
                        new RouteOptimizationException(
                                "Invalid route action."
                        );
            }


        } catch (
                RouteOptimizationException e
        ) {

            session.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );


        } catch (Exception e) {

            e.printStackTrace();


            session.setAttribute(
                    "errorMessage",
                    "Unable to process route optimization."
            );
        }


        response.sendRedirect(
                request.getContextPath() +
                        "/routes"
        );
    }

    private void loadPage(
            HttpServletRequest request
    ) {

        request.setAttribute(
                "routes",
                routeOptimizationService.getAllRoutes()
        );


        request.setAttribute(
                "shipments",
                routeOptimizationService.getAllShipments()
        );


        request.setAttribute(
                "totalRoutes",
                routeOptimizationService.getTotalCount()
        );


        request.setAttribute(
                "averageScore",
                routeOptimizationService.getAverageScore()
        );


        request.setAttribute(
                "highScoreRoutes",
                routeOptimizationService.getHighScoreCount()
        );
    }

    private boolean isAdmin(
            HttpSession session
    ) {

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
                String.valueOf(
                        session.getAttribute("role")
                );


        return "ADMIN".equalsIgnoreCase(role);
    }

    private Integer parseInteger(
            String value,
            String field
    ) throws RouteOptimizationException {

        if (value == null ||
                value.trim().isEmpty()) {

            throw new RouteOptimizationException(
                    field + " is required."
            );
        }


        try {

            return Integer.valueOf(
                    value.trim()
            );


        } catch (NumberFormatException e) {

            throw new RouteOptimizationException(
                    "Invalid " + field + "."
            );
        }
    }
}