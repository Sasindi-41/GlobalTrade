package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.Vendor;

import java.time.LocalDateTime;

public class VendorAuditInterceptor {

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
                "[VENDOR-AUDIT] START | " +
                        startedAt +
                        " | " +
                        className +
                        "." +
                        methodName
        );


        Object[] parameters =
                context.getParameters();


        Integer entityId =
                extractEntityId(parameters);


        String oldValue = null;

        if (entityId != null &&
                shouldCaptureOldValue(methodName)) {

            try {

                Vendor oldVendor =
                        auditLogService
                                .getVendorForAudit(entityId);

                if (oldVendor != null) {

                    oldValue =
                            buildVendorValue(
                                    oldVendor
                            );
                }

            } catch (Exception e) {

                System.err.println(
                        "[VENDOR-AUDIT] " +
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
                        result instanceof Vendor vendor) {

                    entityId =
                            vendor.getId();
                }

                Integer userId =
                        extractUserId(parameters);


                if (entityId != null &&
                        userId != null) {

                    String newValue =
                            buildNewValue(
                                    result
                            );


                    auditLogService.createAuditLog(
                            userId,
                            determineAction(methodName),
                            oldValue,
                            newValue,
                            buildDetails(methodName),
                            entityId,
                            "VENDOR"
                    );
                }
            }


            System.out.println(
                    "[VENDOR-AUDIT] SUCCESS | " +
                            className +
                            "." +
                            methodName
            );


            return result;


        } catch (Exception e) {

            System.err.println(
                    "[VENDOR-AUDIT] FAILURE | " +
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
            Object[] parameters
    ) {

        if (parameters == null ||
                parameters.length == 0) {

            return null;
        }


        Object first =
                parameters[0];


        if (first instanceof Integer) {

            return (Integer) first;
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


        return last instanceof Integer
                ? (Integer) last
                : null;
    }

    private String determineAction(
            String methodName
    ) {

        return switch (methodName) {

            case "createVendor" ->
                    "CREATE";

            case "updateVendor" ->
                    "UPDATE";

            case "deleteVendor" ->
                    "DELETE";

            default ->
                    methodName.toUpperCase();
        };
    }

    private boolean shouldPersistAudit(
            String methodName
    ) {

        return
                "createVendor".equals(methodName)
                        ||
                        "updateVendor".equals(methodName)
                        ||
                        "deleteVendor".equals(methodName);
    }

    private boolean shouldCaptureOldValue(
            String methodName
    ) {

        return
                "updateVendor".equals(methodName)
                        ||
                        "deleteVendor".equals(methodName);
    }

    private String buildNewValue(
            Object result
    ) {

        if (!(result instanceof Vendor vendor)) {

            return null;
        }


        return buildVendorValue(
                vendor
        );
    }

    private String buildVendorValue(
            Vendor vendor
    ) {

        if (vendor == null) {
            return null;
        }


        String statusName =
                vendor.getStatus() != null
                        ? vendor.getStatus().getName()
                        : "N/A";


        String countryName =
                vendor.getCountry() != null
                        ? vendor.getCountry().getName()
                        : "N/A";


        return
                "Vendor ID: " +
                        vendor.getId() +

                        ", Vendor Code: " +
                        vendor.getVendorCode() +

                        ", Company Name: " +
                        vendor.getCompanyName() +

                        ", Contact Name: " +
                        vendor.getContactName() +

                        ", Email: " +
                        vendor.getEmail() +

                        ", Phone: " +
                        vendor.getPhone() +

                        ", Performance Score: " +
                        vendor.getPerformanceScore() +

                        ", Status: " +
                        statusName +

                        ", Country: " +
                        countryName;
    }

    private String buildDetails(
            String methodName
    ) {

        return switch (methodName) {

            case "createVendor" ->
                    "Vendor record created.";

            case "updateVendor" ->
                    "Vendor record updated.";

            case "deleteVendor" ->
                    "Vendor record deleted.";

            default ->
                    "Vendor operation: " +
                            methodName;
        };
    }
}