package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.Order;

public class OrderAuditInterceptor {

    @EJB
    private AuditLogServiceBean auditLogService;

    @AroundInvoke
    public Object audit(InvocationContext context) throws Exception {

        String methodName = context.getMethod().getName();
        Object[] parameters = context.getParameters();

        try {

            Object result = context.proceed();

            if ("createOrder".equals(methodName)
                    && result instanceof Order order
                    && parameters.length > 0
                    && parameters[0] instanceof Integer userId) {

                auditLogService.createAuditLog(
                        userId,
                        "CREATE",
                        null,
                        buildOrderValue(order),
                        "Order " + order.getOrderNumber() + " was created.",
                        order.getId(),
                        "ORDER"
                );

            } else if ("cancelOrder".equals(methodName)
                    && result instanceof Order order
                    && parameters.length > 1
                    && parameters[1] instanceof Integer userId) {

                auditLogService.createAuditLog(
                        userId,
                        "UPDATE",
                        null,
                        buildOrderValue(order),
                        "Order " + order.getOrderNumber() + " was cancelled.",
                        order.getId(),
                        "ORDER"
                );
            }

            return result;

        } catch (Exception e) {

            System.err.println(
                    "[ORDER-AUDIT] FAILURE | " + methodName
                            + " | " + e.getMessage()
            );

            throw e;
        }
    }

    private String buildOrderValue(Order order) {

        return "Order ID: " + order.getId()
                + ", Order Number: " + order.getOrderNumber()
                + ", Product: " + order.getProductDescription()
                + ", Quantity: " + order.getQuantity()
                + ", Status: " + order.getStatus();
    }
}
