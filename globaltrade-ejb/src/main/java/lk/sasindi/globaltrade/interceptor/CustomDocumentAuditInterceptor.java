package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.CustomDocument;

import java.time.LocalDateTime;

public class CustomDocumentAuditInterceptor {

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
                "[CUSTOM-DOCUMENT-AUDIT] START | " +
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
                        parameters,
                        methodName
                );


        String oldValue = null;

        if (entityId != null &&
                shouldCaptureOldValue(methodName)) {

            try {

                CustomDocument oldDocument =
                        auditLogService
                                .getCustomDocumentForAudit(
                                        entityId
                                );

                if (oldDocument != null) {

                    oldValue =
                            buildDocumentValue(
                                    oldDocument
                            );
                }

            } catch (Exception e) {

                System.err.println(
                        "[CUSTOM-DOCUMENT-AUDIT] " +
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
                        result instanceof CustomDocument document) {

                    entityId =
                            document.getId();
                }


                Integer userId =
                        extractUserId(parameters);


                if (entityId != null &&
                        userId != null) {

                    String newValue =
                            buildNewValue(
                                    result,
                                    methodName
                            );


                    auditLogService.createAuditLog(
                            userId,
                            determineAction(methodName),
                            oldValue,
                            newValue,
                            buildDetails(methodName),
                            entityId,
                            "CUSTOM_DOCUMENT"
                    );
                }
            }


            System.out.println(
                    "[CUSTOM-DOCUMENT-AUDIT] SUCCESS | " +
                            className +
                            "." +
                            methodName
            );


            return result;


        } catch (Exception e) {

            System.err.println(
                    "[CUSTOM-DOCUMENT-AUDIT] FAILURE | " +
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
            Object[] parameters,
            String methodName
    ) {

        if (parameters == null ||
                parameters.length == 0) {

            return null;
        }


        if ("createDocument".equals(methodName)) {
            return null;
        }


        Object first =
                parameters[0];


        return first instanceof Integer
                ? (Integer) first
                : null;
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

            case "createDocument" ->
                    "CREATE";

            case "updateDocument" ->
                    "UPDATE";

            case "deleteDocument" ->
                    "DELETE";

            default ->
                    methodName.toUpperCase();
        };
    }

    private boolean shouldPersistAudit(
            String methodName
    ) {

        return
                "createDocument".equals(methodName)
                        ||
                        "updateDocument".equals(methodName)
                        ||
                        "deleteDocument".equals(methodName);
    }

    private boolean shouldCaptureOldValue(
            String methodName
    ) {

        return
                "updateDocument".equals(methodName)
                        ||
                        "deleteDocument".equals(methodName);
    }

    private String buildNewValue(
            Object result,
            String methodName
    ) {

        if ("deleteDocument".equals(methodName)) {
            return null;
        }


        if (!(result instanceof CustomDocument document)) {
            return null;
        }


        return buildDocumentValue(document);
    }

    private String buildDocumentValue(
            CustomDocument document
    ) {

        if (document == null) {
            return null;
        }


        String shipmentNumber =
                document.getShipment() != null
                        ? document.getShipment()
                        .getTrackingNumber()
                        : "N/A";


        String documentType =
                document.getDocumentType() != null
                        ? document.getDocumentType()
                        .getName()
                        : "N/A";


        String documentStatus =
                document.getDocumentStatus() != null
                        ? document.getDocumentStatus()
                        .getName()
                        : "N/A";


        return
                "Document ID: " +
                        document.getId() +

                        ", Document Number: " +
                        document.getDocumentNumber() +

                        ", Issue Date: " +
                        document.getIssueDate() +

                        ", Expiry Date: " +
                        document.getExpiryDate() +

                        ", Description: " +
                        document.getDescription() +

                        ", Shipment: " +
                        shipmentNumber +

                        ", Document Type: " +
                        documentType +

                        ", Document Status: " +
                        documentStatus;
    }


    private String buildDetails(
            String methodName
    ) {

        return switch (methodName) {

            case "createDocument" ->
                    "Custom document record created.";

            case "updateDocument" ->
                    "Custom document record updated.";

            case "deleteDocument" ->
                    "Custom document record deleted.";

            default ->
                    "Custom document operation: " +
                            methodName;
        };
    }
}