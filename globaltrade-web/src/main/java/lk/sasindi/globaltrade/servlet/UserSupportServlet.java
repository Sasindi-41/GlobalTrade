package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.SupportTicketSessionBean;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;


@WebServlet("/support")
public class UserSupportServlet extends BaseUserServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private SupportTicketSessionBean supportTicketSessionBean;

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

        HttpSession session = request.getSession(false);

        User user = userService.findById(userId);
        request.setAttribute("user", user);
        request.setAttribute("activePage", "support");

        request.setAttribute(
                "myTickets",
                supportTicketSessionBean.getMyTickets(userId)
        );

        if (session != null) {

            Object errorMessage = session.getAttribute("errorMessage");
            Object successMessage = session.getAttribute("successMessage");

            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("errorMessage");
            }

            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
        }

        request.getRequestDispatcher(
                "/user/support.jsp"
        ).forward(request, response);
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        Integer userId = requireUser(request, response);

        if (userId == null) {
            return;
        }

        HttpSession session = request.getSession(false);

        try {

            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            String priority = request.getParameter("priority");

            supportTicketSessionBean.createTicket(
                    userId,
                    subject,
                    message,
                    priority
            );

            if (session != null) {
                session.setAttribute(
                        "successMessage",
                        "Your support ticket has been submitted. "
                                + "Our team will respond shortly."
                );
            }

        } catch (IllegalArgumentException e) {

            if (session != null) {
                session.setAttribute("errorMessage", e.getMessage());
            }

        } catch (Exception e) {

            e.printStackTrace();

            if (session != null) {
                session.setAttribute(
                        "errorMessage",
                        "Unable to submit your ticket. Please try again."
                );
            }
        }

        response.sendRedirect(
                request.getContextPath() + "/support"
        );
    }
}
