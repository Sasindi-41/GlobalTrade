package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.SupportTicket;

public class SupportTicketAuditInterceptor {

    @EJB
    private AuditLogServiceBean auditLogService;

    @AroundInvoke
    public Object audit(InvocationContext context) throws Exception {

        String methodName = context.getMethod().getName();
        Object[] parameters = context.getParameters();

        try {

            Object result = context.proceed();

            if ("createTicket".equals(methodName)
                    && result instanceof SupportTicket ticket
                    && parameters.length > 0
                    && parameters[0] instanceof Integer userId) {

                auditLogService.createAuditLog(
                        userId,
                        "CREATE",
                        null,
                        buildTicketValue(ticket),
                        "Support ticket " + ticket.getTicketNumber() + " was raised.",
                        ticket.getId(),
                        "SUPPORT_TICKET"
                );
            }

            return result;

        } catch (Exception e) {

            System.err.println(
                    "[SUPPORT-AUDIT] FAILURE | " + methodName
                            + " | " + e.getMessage()
            );

            throw e;
        }
    }

    private String buildTicketValue(SupportTicket ticket) {

        return "Ticket ID: " + ticket.getId()
                + ", Ticket Number: " + ticket.getTicketNumber()
                + ", Subject: " + ticket.getSubject()
                + ", Priority: " + ticket.getPriority()
                + ", Status: " + ticket.getStatus();
    }
}
