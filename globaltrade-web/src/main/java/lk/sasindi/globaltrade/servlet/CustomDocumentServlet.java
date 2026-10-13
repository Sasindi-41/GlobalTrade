package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lk.sasindi.globaltrade.bean.CustomDocumentSessionBean;
import lk.sasindi.globaltrade.exception.CustomDocumentException;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

import lk.sasindi.globaltrade.entity.CustomDocument;
import lk.sasindi.globaltrade.entity.DocumentStatus;
import lk.sasindi.globaltrade.entity.DocumentType;
import lk.sasindi.globaltrade.entity.Shipment;
import jakarta.servlet.http.HttpSession;
@WebServlet("/custom-documents")
public class CustomDocumentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private CustomDocumentSessionBean customDocumentBean;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            loadPageData(request);

            request.getRequestDispatcher(
                    "/admin/custom-document.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "customDocumentList",
                    java.util.Collections.emptyList()
            );
            request.setAttribute(
                    "shipmentList",
                    java.util.Collections.emptyList()
            );
            request.setAttribute(
                    "documentTypeList",
                    java.util.Collections.emptyList()
            );
            request.setAttribute(
                    "documentStatusList",
                    java.util.Collections.emptyList()
            );

            request.setAttribute(
                    "errorMessage",
                    "Unable to load customs documents."
            );

            request.getRequestDispatcher(
                    "/admin/custom-document.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String action =
                request.getParameter("action");

        HttpSession session =
                request.getSession(false);

        Integer userId = null;

        if (session != null) {

            Object sessionUserId =
                    session.getAttribute("userId");

            if (sessionUserId instanceof Integer) {
                userId = (Integer) sessionUserId;
            }
        }

        try {

            if ("create".equalsIgnoreCase(action)) {

                customDocumentBean.createDocument(

                        parseDate(
                                request.getParameter("issueDate"),
                                "Issue date is required."
                        ),

                        parseOptionalDate(
                                request.getParameter("expiryDate")
                        ),

                        requiredText(
                                request.getParameter("description"),
                                "Document description is required."
                        ),

                        parseRequiredId(
                                request.getParameter("shipmentId"),
                                "Shipment is required."
                        ),

                        parseRequiredId(
                                request.getParameter("documentTypeId"),
                                "Document type is required."
                        ),

                        parseRequiredId(
                                request.getParameter("documentStatusId"),
                                "Document status is required."
                        ),

                        userId
                );


                redirect(
                        response,
                        request,
                        "created",
                        null
                );

                return;
            }

            if ("update".equalsIgnoreCase(action)) {

                customDocumentBean.updateDocument(

                        parseRequiredId(
                                request.getParameter("id"),
                                "Document ID is required."
                        ),

                        parseDate(
                                request.getParameter("issueDate"),
                                "Issue date is required."
                        ),

                        parseOptionalDate(
                                request.getParameter("expiryDate")
                        ),

                        requiredText(
                                request.getParameter("description"),
                                "Document description is required."
                        ),

                        parseRequiredId(
                                request.getParameter("shipmentId"),
                                "Shipment is required."
                        ),

                        parseRequiredId(
                                request.getParameter("documentTypeId"),
                                "Document type is required."
                        ),

                        parseRequiredId(
                                request.getParameter("documentStatusId"),
                                "Document status is required."
                        ),

                        userId
                );


                redirect(
                        response,
                        request,
                        "updated",
                        null
                );

                return;
            }

            if ("delete".equalsIgnoreCase(action)) {

                customDocumentBean.deleteDocument(
                        parseRequiredId(
                                request.getParameter("id"),
                                "Document ID is required."
                        ),
                        userId
                );


                redirect(
                        response,
                        request,
                        "deleted",
                        null
                );

                return;
            }


            redirect(
                    response,
                    request,
                    null,
                    "Invalid action."
            );


        } catch (CustomDocumentException e) {

            e.printStackTrace();

            redirect(
                    response,
                    request,
                    null,
                    e.getMessage()
            );


        } catch (IllegalArgumentException e) {

            e.printStackTrace();

            redirect(
                    response,
                    request,
                    null,
                    e.getMessage()
            );


        } catch (Exception e) {

            e.printStackTrace();

            redirect(
                    response,
                    request,
                    null,
                    "A system error occurred while processing the document."
            );
        }
    }

    private void loadPageData(HttpServletRequest request) {

        List<CustomDocument> documents =
                customDocumentBean.getAllDocuments();

        long totalExpiryDocuments =
                customDocumentBean
                        .getTotalExpiryDocumentCount();

        long expirySoonDocuments =
                customDocumentBean
                        .getExpirySoonDocumentCount();

        request.setAttribute(
                "totalExpiryDocuments",
                totalExpiryDocuments
        );

        request.setAttribute(
                "expirySoonDocuments",
                expirySoonDocuments
        );

        List<Shipment> shipments =
                customDocumentBean.getShipments();

        List<DocumentType> documentTypes =
                customDocumentBean.getDocumentTypes();

        List<DocumentStatus> documentStatuses =
                customDocumentBean.getDocumentStatuses();

        request.setAttribute(
                "customDocumentList",
                documents
        );

        request.setAttribute(
                "shipmentList",
                shipments
        );

        request.setAttribute(
                "documentTypeList",
                documentTypes
        );

        request.setAttribute(
                "documentStatusList",
                documentStatuses
        );
    }

    private Integer parseRequiredId(
            String value,
            String message
    ) {

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(message);
        }

        try {
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(message);
        }
    }

    private LocalDate parseDate(
            String value,
            String message
    ) {

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(message);
        }

        try {
            return LocalDate.parse(value.trim());
        } catch (Exception e) {
            throw new IllegalArgumentException(
                    "Invalid date value."
            );
        }
    }

    private LocalDate parseOptionalDate(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return LocalDate.parse(value.trim());
        } catch (Exception e) {
            throw new IllegalArgumentException(
                    "Invalid expiry date."
            );
        }
    }

    private String requiredText(
            String value,
            String message
    ) {

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(message);
        }

        return value.trim();
    }

    private void redirect(
            HttpServletResponse response,
            HttpServletRequest request,
            String success,
            String error
    ) throws IOException {

        StringBuilder url = new StringBuilder();

        url.append(
                request.getContextPath()
        ).append(
                "/custom-documents"
        );

        if (success != null) {
            url.append(
                    "?success="
            ).append(
                    URLEncoder.encode(
                            success,
                            StandardCharsets.UTF_8
                    )
            );
        } else if (error != null) {
            url.append(
                    "?error="
            ).append(
                    URLEncoder.encode(
                            error,
                            StandardCharsets.UTF_8
                    )
            );
        }

        response.sendRedirect(url.toString());
    }
}
