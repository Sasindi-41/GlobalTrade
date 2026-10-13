package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.entity.ShipmentItem;

import java.time.LocalDateTime;

public class ShipmentAuditInterceptor {

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
                "[SHIPMENT-AUDIT] START | " +
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

                Shipment oldShipment =
                        auditLogService
                                .getShipmentForAudit(
                                        entityId
                                );

                if (oldShipment != null) {

                    oldValue =
                            buildShipmentValue(
                                    oldShipment
                            );
                }

            } catch (Exception e) {

                System.err.println(
                        "[SHIPMENT-AUDIT] " +
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
                        result instanceof Shipment shipment) {

                    entityId =
                            shipment.getId();
                }

                String newValue =
                        buildNewValue(
                                result
                        );

                if (entityId != null &&
                        userId != null) {

                    auditLogService.createAuditLog(
                            userId,
                            determineAction(methodName),
                            oldValue,
                            newValue,
                            buildDetails(
                                    methodName,
                                    result
                            ),
                            entityId,
                            "SHIPMENT"
                    );
                }
            }


            System.out.println(
                    "[SHIPMENT-AUDIT] SUCCESS | " +
                            className +
                            "." +
                            methodName
            );


            return result;


        } catch (Exception e) {

            System.err.println(
                    "[SHIPMENT-AUDIT] FAILURE | " +
                            className +
                            "." +
                            methodName +
                            " | " +
                            e.getClass()
                                    .getSimpleName() +
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



        if ("updateShipment".equals(methodName) ||
                "deleteShipment".equals(methodName)) {

            Object first =
                    parameters[0];

            if (first instanceof Integer) {

                return (Integer) first;
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


        return last instanceof Integer
                ? (Integer) last
                : null;
    }

    private String determineAction(
            String methodName
    ) {

        return switch (methodName) {

            case "createShipment" ->
                    "CREATE";

            case "updateShipment" ->
                    "UPDATE";

            case "deleteShipment" ->
                    "DELETE";

            default ->
                    methodName.toUpperCase();
        };
    }

    private boolean shouldPersistAudit(
            String methodName
    ) {

        return
                "createShipment".equals(methodName)
                        ||
                        "updateShipment".equals(methodName)
                        ||
                        "deleteShipment".equals(methodName);
    }


    private boolean shouldCaptureOldValue(
            String methodName
    ) {

        return
                "updateShipment".equals(methodName)
                        ||
                        "deleteShipment".equals(methodName);
    }

    private String buildNewValue(
            Object result
    ) {

        if (!(result instanceof Shipment shipment)) {

            return null;
        }


        return buildShipmentValue(
                shipment
        );
    }

    private String buildShipmentValue(
            Shipment shipment
    ) {

        if (shipment == null) {

            return null;
        }


        String vendor =
                shipment.getVendor() != null
                        ? shipment.getVendor()
                        .getCompanyName()
                        : "N/A";


        String status =
                shipment.getShipmentStatus() != null
                        ? shipment.getShipmentStatus()
                        .getName()
                        : "N/A";


        String origin =
                buildAddressValue(
                        shipment.getOriginAddress()
                );


        String destination =
                buildAddressValue(
                        shipment.getDestinationAddress()
                );


        StringBuilder items =
                new StringBuilder();


        if (shipment.getShipmentItems() != null &&
                !shipment.getShipmentItems().isEmpty()) {

            for (ShipmentItem item :
                    shipment.getShipmentItems()) {

                if (item == null) {
                    continue;
                }


                if (items.length() > 0) {
                    items.append(" | ");
                }


                String inventoryName =
                        item.getInventory() != null
                                ? item.getInventory()
                                .getProductName()
                                : "N/A";


                items.append(
                        "Inventory: "
                ).append(
                        inventoryName
                );


                items.append(
                        ", Quantity: "
                ).append(
                        item.getQuantity()
                );


                items.append(
                        ", Unit Value: "
                ).append(
                        item.getUnitValue()
                );
            }
        }


        return
                "Shipment ID: " +
                        shipment.getId() +

                        ", Tracking Number: " +
                        shipment.getTrackingNumber() +

                        ", Vendor: " +
                        vendor +

                        ", Status: " +
                        status +

                        ", Origin: " +
                        origin +

                        ", Destination: " +
                        destination +

                        ", Expected Delivery: " +
                        shipment.getExpectedDelivery() +

                        ", Actual Delivery: " +
                        shipment.getActualDelivery() +

                        ", Items: " +
                        items;
    }

    private String buildAddressValue(
            lk.sasindi.globaltrade.entity.Address address
    ) {

        if (address == null) {

            return "N/A";
        }


        StringBuilder result =
                new StringBuilder();


        if (address.getLine1() != null &&
                !address.getLine1()
                        .trim()
                        .isEmpty()) {

            result.append(
                    address.getLine1()
            );
        }


        if (address.getLine2() != null &&
                !address.getLine2()
                        .trim()
                        .isEmpty()) {

            if (result.length() > 0) {
                result.append(", ");
            }

            result.append(
                    address.getLine2()
            );
        }


        if (address.getCity() != null) {

            if (result.length() > 0) {
                result.append(", ");
            }

            result.append(
                    address.getCity()
                            .getName()
            );
        }


        if (address.getCountry() != null) {

            if (result.length() > 0) {
                result.append(", ");
            }

            result.append(
                    address.getCountry()
                            .getName()
            );
        }


        return result.toString();
    }

    private String buildDetails(
            String methodName,
            Object result
    ) {

        if ("createShipment".equals(methodName)) {

            String trackingNumber = "";

            if (result instanceof Shipment shipment) {

                trackingNumber =
                        shipment.getTrackingNumber();
            }

            return
                    "Shipment " +
                            trackingNumber +
                            " created successfully.";
        }


        if ("updateShipment".equals(methodName)) {

            String trackingNumber = "";

            if (result instanceof Shipment shipment) {

                trackingNumber =
                        shipment.getTrackingNumber();
            }

            return
                    "Shipment " +
                            trackingNumber +
                            " updated successfully.";
        }


        if ("deleteShipment".equals(methodName)) {

            return
                    "Shipment deleted successfully.";
        }


        return
                "Shipment operation: " +
                        methodName;
    }
}