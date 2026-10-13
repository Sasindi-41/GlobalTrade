package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.OrderSessionBean;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;

@WebServlet("/orders")
public class UserOrdersServlet extends BaseUserServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private OrderSessionBean orderSessionBean;

    @EJB
    private UserService userService;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        Integer userId =
                requireUser(request, response);

        if (userId == null) {
            return;
        }

        HttpSession session =
                request.getSession(false);

        User user =
                userService.findById(userId);

        request.setAttribute(
                "user",
                user
        );

        request.setAttribute(
                "activePage",
                "orders"
        );

        request.setAttribute(
                "myOrders",
                orderSessionBean.getMyOrders(userId)
        );

        request.setAttribute(
                "addresses",
                orderSessionBean.getAllAddresses()
        );

        copyFlash(
                session,
                request
        );

        request.getRequestDispatcher(
                "/user/orders.jsp"
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

        Integer userId =
                requireUser(request, response);

        if (userId == null) {
            return;
        }

        HttpSession session =
                request.getSession(false);

        String action =
                request.getParameter("action");


        try {

            if ("cancel".equalsIgnoreCase(action)) {

                Integer orderId =
                        parseIntOrNull(
                                request.getParameter("orderId")
                        );


                orderSessionBean.cancelOrder(
                        orderId,
                        userId
                );


                if (session != null) {

                    session.setAttribute(
                            "successMessage",
                            "Your shipment request has been cancelled."
                    );
                }

            } else if ("create".equalsIgnoreCase(action)) {

                String productDescription =
                        request.getParameter(
                                "productDescription"
                        );


                Integer quantity =
                        parseIntOrNull(
                                request.getParameter("quantity")
                        );


                Integer originAddressId =
                        parseIntOrNull(
                                request.getParameter(
                                        "originAddressId"
                                )
                        );


                Integer destinationAddressId =
                        parseIntOrNull(
                                request.getParameter(
                                        "destinationAddressId"
                                )
                        );


                String notes =
                        request.getParameter("notes");


                orderSessionBean.createOrder(
                        userId,
                        productDescription,
                        quantity,
                        originAddressId,
                        destinationAddressId,
                        notes
                );


                if (session != null) {

                    session.setAttribute(
                            "successMessage",
                            "Your shipment request has been submitted successfully."
                    );
                }

            } else {

                throw new IllegalArgumentException(
                        "Invalid shipment request action."
                );
            }


        } catch (IllegalArgumentException | lk.sasindi.globaltrade.exception.OrderException e) {

            if (session != null) {

                session.setAttribute(
                        "errorMessage",
                        e.getMessage()
                );
            }


        } catch (Exception e) {

            e.printStackTrace();


            if (session != null) {

                session.setAttribute(
                        "errorMessage",
                        "Unable to process your shipment request. Please try again."
                );
            }
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/orders"
        );
    }

    private void copyFlash(
            HttpSession session,
            HttpServletRequest request
    ) {

        if (session == null) {
            return;
        }


        Object errorMessage =
                session.getAttribute(
                        "errorMessage"
                );


        Object successMessage =
                session.getAttribute(
                        "successMessage"
                );


        if (errorMessage != null) {

            request.setAttribute(
                    "errorMessage",
                    errorMessage
            );

            session.removeAttribute(
                    "errorMessage"
            );
        }


        if (successMessage != null) {

            request.setAttribute(
                    "successMessage",
                    successMessage
            );

            session.removeAttribute(
                    "successMessage"
            );
        }
    }
}