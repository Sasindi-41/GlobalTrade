package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.service.UserService;
import lk.sasindi.globaltrade.bean.ShipmentSessionBean;

import java.io.IOException;

@WebServlet("/user-shipments")
public class UserShipmentsServlet extends BaseUserServlet {

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
                "shipments"
        );


        request.setAttribute(
                "myShipments",
                shipmentSessionBean.getMyShipments(userId)
        );

        if (session != null) {

            Object errorMessage =
                    session.getAttribute("errorMessage");

            Object successMessage =
                    session.getAttribute("successMessage");


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


        request.getRequestDispatcher(
                "/user/shipments.jsp"
        ).forward(
                request,
                response
        );


    }

}
