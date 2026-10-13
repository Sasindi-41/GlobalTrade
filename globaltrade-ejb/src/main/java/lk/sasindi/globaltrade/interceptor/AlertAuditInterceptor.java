package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.Alert;

import java.time.LocalDateTime;

public class AlertAuditInterceptor {

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
                "[ALERT-AUDIT] START | " +
                        startedAt +
                        " | " +
                        className +
                        "." +
                        methodName
        );


        Object[] parameters =
                context.getParameters();


        Integer entityId =
                extractEntityId(
                        methodName,
                        parameters
                );


        Integer userId =
                extractUserId(
                        parameters
                );

        String oldValue = null;


        if (entityId != null &&
                shouldCaptureOldValue(methodName)) {

            try {

                Alert oldAlert =
                        auditLogService
                                .getAlertForAudit(
                                        entityId
                                );


                if (oldAlert != null) {

                    oldValue =
                            buildAlertValue(
                                    oldAlert
                            );
                }


            } catch (Exception e) {

                System.err.println(
                        "[ALERT-AUDIT] " +
                                "Unable to capture old value: " +
                                e.getMessage()
                );
            }
        }


        try {

            Object result =
                    context.proceed();

            if (shouldPersistAudit(methodName)) {

                if (entityId == null &&
                        result instanceof Alert alert) {

                    entityId =
                            alert.getId();
                }


                String newValue =
                        buildNewValue(
                                result,
                                entityId
                        );


                if (entityId != null &&
                        userId != null) {

                    auditLogService.createAuditLog(
                            userId,
                            determineAction(methodName),
                            oldValue,
                            newValue,
                            buildDetails(methodName),
                            entityId,
                            "ALERT"
                    );
                }


            }


            System.out.println(
                    "[ALERT-AUDIT] SUCCESS | " +
                            className +
                            "." +
                            methodName
            );


            return result;


        } catch (Exception e) {

            System.err.println(
                    "[ALERT-AUDIT] FAILURE | " +
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


    private Integer extractEntityId(
            String methodName,
            Object[] parameters
    ) {

        if (parameters == null ||
                parameters.length == 0) {

            return null;
        }


        /*
         * createAlert(...)
         *
         * Parameters:
         *
         * 0 = userId
         * 1 = message
         * 2 = shipmentId
         * 3 = vendorId
         * 4 = inventoryId
         * 5 = alertTypeId
         * 6 = severityId
         * 7 = alertStatusId
         *
         * resolveAlert(...)
         *
         * 0 = alertId
         * 1 = userId
         *
         * reopenAlert(...)
         *
         * 0 = alertId
         * 1 = userId
         */


        if ("createAlert".equals(methodName)) {

            return null;
        }


        if ("resolveAlert".equals(methodName) ||
                "reopenAlert".equals(methodName)) {

            Object first =
                    parameters[0];


            if (first instanceof Number) {

                return ((Number) first).intValue();
            }
        }


        return null;
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


        if (last instanceof Number) {

            return ((Number) last).intValue();
        }


        return null;
    }

    private String determineAction(
            String methodName
    ) {

        return switch (methodName) {

            case "createAlert" ->
                    "CREATE";

            case "resolveAlert" ->
                    "RESOLVE";

            case "reopenAlert" ->
                    "REOPEN";

            default ->
                    methodName.toUpperCase();
        };
    }

    private boolean shouldPersistAudit(
            String methodName
    ) {

        return
                "createAlert".equals(methodName)
                        ||
                        "resolveAlert".equals(methodName)
                        ||
                        "reopenAlert".equals(methodName);
    }

    private boolean shouldCaptureOldValue(
            String methodName
    ) {

        return
                "resolveAlert".equals(methodName)
                        ||
                        "reopenAlert".equals(methodName);
    }

    private String buildNewValue(
            Object result,
            Integer entityId
    ) {

        Alert alert = null;

        if (result instanceof Alert) {

            alert =
                    (Alert) result;
        }

        if (alert == null &&
                entityId != null) {

            try {

                alert =
                        auditLogService
                                .getAlertForAudit(
                                        entityId
                                );

            } catch (Exception e) {

                System.err.println(
                        "[ALERT-AUDIT] " +
                                "Unable to capture new value: " +
                                e.getMessage()
                );
            }
        }


        return buildAlertValue(
                alert
        );
    }

    private String buildAlertValue(
            Alert alert
    ) {

        if (alert == null) {

            return null;
        }


        String shipmentValue =
                alert.getShipment() != null
                        ? String.valueOf(
                        alert.getShipment().getId()
                )
                        : "N/A";


        String vendorValue =
                alert.getVendor() != null
                        ? String.valueOf(
                        alert.getVendor().getCompanyName()
                )
                        : "N/A";


        String inventoryValue =
                alert.getInventory() != null
                        ? String.valueOf(
                        alert.getInventory().getId()
                )
                        : "N/A";


        String alertTypeValue =
                alert.getAlertType() != null
                        ? alert.getAlertType().getName()
                        : "N/A";


        String severityValue =
                alert.getSeverity() != null
                        ? alert.getSeverity().getName()
                        : "N/A";


        String statusValue =
                alert.getAlertStatus() != null
                        ? alert.getAlertStatus().getName()
                        : "N/A";


        return
                "Alert ID: " +
                        alert.getId() +

                        ", Message: " +
                        alert.getMessage() +

                        ", Shipment ID: " +
                        shipmentValue +

                        ", Vendor: " +
                        vendorValue +

                        ", Inventory ID: " +
                        inventoryValue +

                        ", Alert Type: " +
                        alertTypeValue +

                        ", Severity: " +
                        severityValue +

                        ", Status: " +
                        statusValue +

                        ", Created At: " +
                        alert.getCreatedAt() +

                        ", Resolved At: " +
                        alert.getResolvedAt();
    }

    private String buildDetails(
            String methodName
    ) {

        return switch (methodName) {

            case "createAlert" ->
                    "Alert record created.";

            case "resolveAlert" ->
                    "Alert resolved.";

            case "reopenAlert" ->
                    "Alert reopened.";

            default ->
                    "Alert operation: " +
                            methodName;
        };
    }
}

