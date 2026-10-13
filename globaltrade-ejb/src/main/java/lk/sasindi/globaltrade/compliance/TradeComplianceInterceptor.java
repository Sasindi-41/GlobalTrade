package lk.sasindi.globaltrade.compliance;

import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;
import lk.sasindi.globaltrade.exception.CustomDocumentException;

import java.time.LocalDate;

@TradeCompliance
public class TradeComplianceInterceptor {

    @AroundInvoke
    public Object validate(
            InvocationContext context
    ) throws Exception {

        Object[] parameters =
                context.getParameters();

        String method =
                context.getMethod().getName();

        if ("createDocument".equals(method)) {

            validateParameterCount(
                    parameters,
                    6
            );

            validateCreateOrUpdate(
                    parameters,
                    0,
                    1,
                    2,
                    3,
                    4,
                    5
            );
        }

        else if ("updateDocument".equals(method)) {

            validateParameterCount(
                    parameters,
                    7
            );

            validateCreateOrUpdate(
                    parameters,
                    1,
                    2,
                    3,
                    4,
                    5,
                    6
            );
        }

        return context.proceed();
    }


    private void validateParameterCount(
            Object[] parameters,
            int requiredCount
    ) throws CustomDocumentException {

        if (
                parameters == null
                        ||
                        parameters.length < requiredCount
        ) {

            throw new CustomDocumentException(
                    "Invalid trade document method parameters."
            );
        }
    }


    private void validateCreateOrUpdate(
            Object[] p,
            int issueIndex,
            int expiryIndex,
            int descriptionIndex,
            int shipmentIndex,
            int typeIndex,
            int statusIndex
    ) throws CustomDocumentException {

        LocalDate issueDate =
                p[issueIndex] instanceof LocalDate
                        ? (LocalDate) p[issueIndex]
                        : null;


        LocalDate expiryDate =
                p[expiryIndex] instanceof LocalDate
                        ? (LocalDate) p[expiryIndex]
                        : null;


        String description =
                p[descriptionIndex] instanceof String
                        ? (String) p[descriptionIndex]
                        : null;


        Integer shipmentId =
                p[shipmentIndex] instanceof Integer
                        ? (Integer) p[shipmentIndex]
                        : null;


        Integer documentTypeId =
                p[typeIndex] instanceof Integer
                        ? (Integer) p[typeIndex]
                        : null;


        Integer documentStatusId =
                p[statusIndex] instanceof Integer
                        ? (Integer) p[statusIndex]
                        : null;

        if (issueDate == null) {

            throw new CustomDocumentException(
                    "Trade document issue date is required."
            );
        }

        if (
                expiryDate != null
                        &&
                        expiryDate.isBefore(issueDate)
        ) {

            throw new CustomDocumentException(
                    "Trade document expiry date cannot be before the issue date."
            );
        }

        if (
                expiryDate != null
                        &&
                        expiryDate.isBefore(LocalDate.now())
        ) {

            throw new CustomDocumentException(
                    "An expired customs document cannot be created or updated."
            );
        }

        if (
                description == null
                        ||
                        description.trim().isEmpty()
        ) {

            throw new CustomDocumentException(
                    "Trade document description is required."
            );
        }

        if (
                shipmentId == null
                        ||
                        shipmentId <= 0
        ) {

            throw new CustomDocumentException(
                    "A valid shipment is required for compliance."
            );
        }

        if (
                documentTypeId == null
                        ||
                        documentTypeId <= 0
        ) {

            throw new CustomDocumentException(
                    "A valid document type is required for compliance."
            );
        }

        if (
                documentStatusId == null
                        ||
                        documentStatusId <= 0
        ) {

            throw new CustomDocumentException(
                    "A valid document status is required for compliance."
            );
        }
    }


}
