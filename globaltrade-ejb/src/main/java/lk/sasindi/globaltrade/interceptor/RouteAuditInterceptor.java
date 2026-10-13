package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.RouteOptimization;

import java.time.LocalDateTime;

public class RouteAuditInterceptor {

    @EJB
    private AuditLogServiceBean auditLogService;


    @AroundInvoke
    public Object audit(
            InvocationContext context
    ) throws Exception {

        String className =
                context.getTarget()
                        .getClass()
                        .getSimpleName();


        String methodName =
                context.getMethod()
                        .getName();


        LocalDateTime startedAt =
                LocalDateTime.now();


        System.out.println(
                "[ROUTE-AUDIT] START | " +
                        startedAt +
                        " | " +
                        className +
                        "." +
                        methodName
        );


        Object[] parameters =
                context.getParameters();


        Integer userId =
                extractUserId(parameters);


        String action =
                determineAction(methodName);


        Integer entityId =
                extractEntityId(
                        methodName,
                        parameters
                );


        try {

            Object result =
                    context.proceed();

            if (shouldPersistAudit(methodName)) {

                if (entityId == null &&
                        result instanceof RouteOptimization route) {

                    entityId =
                            route.getId();
                }


                if (entityId != null &&
                        userId != null) {

                    String newValue =
                            buildNewValue(result);


                    auditLogService.createAuditLog(
                            userId,
                            action,
                            null,
                            newValue,
                            "Route optimization operation: " +
                                    methodName,
                            entityId,
                            "ROUTE_OPTIMIZATION"
                    );
                }
            }


            System.out.println(
                    "[ROUTE-AUDIT] SUCCESS | " +
                            className +
                            "." +
                            methodName
            );


            return result;


        } catch (Exception e) {

            System.err.println(
                    "[ROUTE-AUDIT] FAILURE | " +
                            className +
                            "." +
                            methodName +
                            " | " +
                            e.getClass().getSimpleName() +
                            " | " +
                            e.getMessage()
            );


            throw e;
        }
    }

    private Integer extractUserId(
            Object[] parameters
    ) {

        if (parameters == null ||
                parameters.length == 0) {

            return null;
        }


        Object last =
                parameters[
                        parameters.length - 1
                        ];


        return last instanceof Integer
                ? (Integer) last
                : null;
    }

    private Integer extractEntityId(
            String methodName,
            Object[] parameters
    ) {

        if (parameters == null ||
                parameters.length == 0) {

            return null;
        }

        if ("optimizeRoute".equals(methodName)) {

            Object first =
                    parameters[0];


            if (first instanceof Integer) {

                return (Integer) first;
            }
        }


        return null;
    }

    private String determineAction(
            String methodName
    ) {

        return switch (methodName) {

            case "createRoute" ->
                    "CREATE";

            case "optimizeRoute" ->
                    "OPTIMIZE";

            case "deleteRoute" ->
                    "DELETE";

            case "optimizeAllRoutes" ->
                    "OPTIMIZE_ALL";

            default ->
                    methodName.toUpperCase();
        };
    }

    private boolean shouldPersistAudit(
            String methodName
    ) {

        return
                "createRoute".equals(methodName)
                        ||
                        "optimizeRoute".equals(methodName)
                        ||
                        "deleteRoute".equals(methodName);
    }

    private String buildNewValue(
            Object result
    ) {

        if (!(result instanceof RouteOptimization route)) {

            return "Route operation completed.";
        }


        return
                "Route ID: " +
                        route.getId() +

                        ", Shipment ID: " +
                        (
                                route.getShipment() != null
                                        ? route.getShipment().getId()
                                        : "N/A"
                        ) +

                        ", Origin: " +
                        route.getOrigin() +

                        ", Destination: " +
                        route.getDestination() +

                        ", Distance: " +
                        route.getEstimatedDistance() +
                        " km" +

                        ", Duration: " +
                        route.getEstimatedDuration() +
                        " min" +

                        ", Score: " +
                        route.getOptimizationScore() +

                        ", Recommended Route: " +
                        route.getRecommendedRoute();
    }
}