package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.CustomDocumentSessionBean;
import lk.sasindi.globaltrade.bean.ShipmentSessionBean;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.exception.CustomDocumentException;
import lk.sasindi.globaltrade.service.UserService;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/documents")
public class UserDocumentsServlet extends BaseUserServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private CustomDocumentSessionBean customDocumentSessionBean;

    @EJB
    private ShipmentSessionBean shipmentSessionBean;

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
        request.setAttribute("activePage", "documents");

        request.setAttribute(
                "myDocuments",
                customDocumentSessionBean.getMyDocuments(userId)
        );

        request.setAttribute(
                "myShipments",
                shipmentSessionBean.getMyShipments(userId)
        );

        request.setAttribute(
                "documentTypes",
                customDocumentSessionBean.getDocumentTypes()
        );

        request.setAttribute(
                "documentStatuses",
                customDocumentSessionBean.getDocumentStatuses()
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
                "/user/documents.jsp"
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

            Integer shipmentId =
                    parseIntOrNull(request.getParameter("shipmentId"));

            boolean ownsShipment =
                    shipmentSessionBean.getMyShipments(userId)
                            .stream()
                            .anyMatch(s -> s.getId().equals(shipmentId));

            if (!ownsShipment) {
                throw new IllegalArgumentException(
                        "Please choose one of your own shipments."
                );
            }

            Integer documentTypeId =
                    parseIntOrNull(request.getParameter("documentTypeId"));

            Integer documentStatusId =
                    parseIntOrNull(request.getParameter("documentStatusId"));

            String description =
                    request.getParameter("description");

            LocalDate issueDate =
                    parseLocalDateOrNull(request.getParameter("issueDate"));

            LocalDate expiryDate =
                    parseLocalDateOrNull(request.getParameter("expiryDate"));

            customDocumentSessionBean.createDocument(
                    issueDate,
                    expiryDate,
                    description,
                    shipmentId,
                    documentTypeId,
                    documentStatusId,
                    userId
            );

            if (session != null) {
                session.setAttribute(
                        "successMessage",
                        "Document has been submitted."
                );
            }

        } catch (CustomDocumentException | IllegalArgumentException e) {

            if (session != null) {
                session.setAttribute("errorMessage", e.getMessage());
            }

        } catch (Exception e) {

            e.printStackTrace();

            if (session != null) {
                session.setAttribute(
                        "errorMessage",
                        "Unable to submit document. Please try again."
                );
            }
        }

        response.sendRedirect(
                request.getContextPath() + "/documents"
        );
    }

    private LocalDate parseLocalDateOrNull(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return LocalDate.parse(value.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
