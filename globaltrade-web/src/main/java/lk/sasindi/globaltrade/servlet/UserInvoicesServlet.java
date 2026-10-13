package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.InvoiceSessionBean;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;

@WebServlet("/invoices")
public class UserInvoicesServlet extends BaseUserServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private InvoiceSessionBean invoiceSessionBean;

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
        request.setAttribute("activePage", "invoices");

        request.setAttribute(
                "myInvoices",
                invoiceSessionBean.getMyInvoices(userId)
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
                "/user/invoices.jsp"
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

            Integer invoiceId =
                    parseIntOrNull(request.getParameter("invoiceId"));

            invoiceSessionBean.markAsPaid(invoiceId, userId);

            if (session != null) {
                session.setAttribute(
                        "successMessage",
                        "Payment recorded. Thank you."
                );
            }

        } catch (IllegalArgumentException | lk.sasindi.globaltrade.exception.InvoiceException e) {

            if (session != null) {
                session.setAttribute("errorMessage", e.getMessage());
            }

        } catch (Exception e) {

            e.printStackTrace();

            if (session != null) {
                session.setAttribute(
                        "errorMessage",
                        "Unable to process payment. Please try again."
                );
            }
        }

        response.sendRedirect(
                request.getContextPath() + "/invoices"
        );
    }
}
