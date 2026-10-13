package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lk.sasindi.globaltrade.bean.InvoiceSessionBean;
import lk.sasindi.globaltrade.entity.Invoice;

import java.io.IOException;

@WebServlet("/invoices/download")
public class InvoiceDownloadServlet extends BaseUserServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private InvoiceSessionBean invoiceSessionBean;


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        Integer userId = requireUser(request, response);

        if (userId == null) {
            return;
        }

        Integer invoiceId =
                parseIntOrNull(request.getParameter("id"));

        Invoice invoice =
                invoiceSessionBean.getMyInvoice(invoiceId, userId);

        if (invoice == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Invoice was not found."
            );
            return;
        }

        try {

            byte[] pdfBytes =
                    invoiceSessionBean.generateInvoicePdf(
                            invoiceId,
                            userId
                    );

            response.setContentType("application/pdf");

            response.setHeader(
                    "Content-Disposition",
                    "inline; filename=\""
                            + invoice.getInvoiceNumber()
                            + ".pdf\""
            );

            response.setContentLength(pdfBytes.length);

            response.getOutputStream().write(pdfBytes);
            response.getOutputStream().flush();

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to generate invoice PDF."
            );
        }
    }
}
