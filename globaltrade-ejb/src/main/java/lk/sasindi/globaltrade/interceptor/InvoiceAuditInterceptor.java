package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.Invoice;


public class InvoiceAuditInterceptor {

    @EJB
    private AuditLogServiceBean auditLogService;

    @AroundInvoke
    public Object audit(InvocationContext context) throws Exception {

        String methodName = context.getMethod().getName();
        Object[] parameters = context.getParameters();

        try {

            Object result = context.proceed();

            if ("generateInvoiceForShipment".equals(methodName)
                    && result instanceof Invoice invoice
                    && parameters.length > 1
                    && parameters[1] instanceof Integer userId) {

                auditLogService.createAuditLog(
                        userId,
                        "CREATE",
                        null,
                        buildInvoiceValue(invoice),
                        "Invoice " + invoice.getInvoiceNumber() + " was generated.",
                        invoice.getId(),
                        "INVOICE"
                );

            } else if ("markAsPaid".equals(methodName)
                    && result instanceof Invoice invoice
                    && parameters.length > 1
                    && parameters[1] instanceof Integer userId) {

                auditLogService.createAuditLog(
                        userId,
                        "UPDATE",
                        null,
                        buildInvoiceValue(invoice),
                        "Invoice " + invoice.getInvoiceNumber() + " was marked as paid.",
                        invoice.getId(),
                        "INVOICE"
                );
            }

            return result;

        } catch (Exception e) {

            System.err.println(
                    "[INVOICE-AUDIT] FAILURE | " + methodName
                            + " | " + e.getMessage()
            );

            throw e;
        }
    }

    private String buildInvoiceValue(Invoice invoice) {

        return "Invoice ID: " + invoice.getId()
                + ", Invoice Number: " + invoice.getInvoiceNumber()
                + ", Amount: " + invoice.getAmount()
                + ", Status: " + invoice.getStatus();
    }
}
