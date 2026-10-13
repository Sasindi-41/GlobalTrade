package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.Inventory;

import java.time.LocalDateTime;

public class InventoryAuditInterceptor {

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
                "[INVENTORY-AUDIT] START | " +
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


        Integer userId =
                extractUserId(parameters);


        Inventory oldInventory = null;

        String oldValue = null;

        if (entityId != null &&
                shouldCaptureOldValue(methodName)) {

            try {

                oldInventory =
                        auditLogService
                                .getInventoryForAudit(
                                        entityId
                                );

                if (oldInventory != null) {

                    oldValue =
                            buildInventoryValue(
                                    oldInventory
                            );
                }

            } catch (Exception e) {

                System.err.println(
                        "[INVENTORY-AUDIT] " +
                                "Unable to capture old value: " +
                                e.getMessage()
                );
            }
        }


        try {

            Object result =
                    context.proceed();

            if (entityId == null &&
                    result instanceof Inventory inventory) {

                entityId =
                        inventory.getId();
            }

            if (shouldPersistAudit(methodName)) {

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
                            "INVENTORY"
                    );
                }
            }

            if (shouldCreateStockMovement(methodName)) {

                createStockMovement(
                        methodName,
                        oldInventory,
                        result,
                        entityId,
                        userId
                );
            }


            System.out.println(
                    "[INVENTORY-AUDIT] SUCCESS | " +
                            className +
                            "." +
                            methodName
            );


            return result;


        } catch (Exception e) {

            System.err.println(
                    "[INVENTORY-AUDIT] FAILURE | " +
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


    private void createStockMovement(
            String methodName,
            Inventory oldInventory,
            Object result,
            Integer entityId,
            Integer userId
    ) {

        if (entityId == null ||
                userId == null) {

            System.err.println(
                    "[STOCK-HISTORY] " +
                            "Cannot create stock movement: " +
                            "inventory ID or user ID is missing."
            );

            return;
        }


        if (!(result instanceof Inventory newInventory)) {

            return;
        }


        int previousQty;

        int newQty;

        if (oldInventory != null) {

            previousQty =
                    oldInventory.getQuantity();

        } else {

            previousQty =
                    newInventory.getQuantity();
        }


        newQty =
                newInventory.getQuantity();

        int quantityDifference =
                newQty - previousQty;

        if (quantityDifference == 0) {

            return;
        }


        int movementQty =
                Math.abs(quantityDifference);


        String movementType;

        String reason;


        if (quantityDifference > 0) {

            movementType =
                    "ADD";

            reason =
                    buildStockReason(
                            methodName,
                            "Stock increased."
                    );

        } else {

            movementType =
                    "REMOVE";

            reason =
                    buildStockReason(
                            methodName,
                            "Stock decreased."
                    );
        }

        auditLogService.createStockMovement(
                entityId,
                userId,
                movementQty,
                previousQty,
                newQty,
                reason,
                movementType,
                "INVENTORY"
        );


        System.out.println(
                "[STOCK-HISTORY] CREATED | " +
                        "Inventory: " +
                        entityId +
                        " | Type: " +
                        movementType +
                        " | Previous: " +
                        previousQty +
                        " | Qty: " +
                        movementQty +
                        " | New: " +
                        newQty
        );
    }

    private String buildStockReason(
            String methodName,
            String defaultReason
    ) {

        return switch (methodName) {

            case "addStock" ->
                    "Stock manually added.";

            case "removeStock" ->
                    "Stock manually removed.";

            case "updateQuantity" ->
                    "Inventory quantity adjusted.";

            case "updateInventory" ->
                    "Inventory quantity changed during update.";

            default ->
                    defaultReason;
        };
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

            case "createInventory" ->
                    "CREATE";

            case "updateInventory" ->
                    "UPDATE";

            case "deleteInventory" ->
                    "DELETE";

            case "addStock" ->
                    "ADD_STOCK";

            case "removeStock" ->
                    "REMOVE_STOCK";

            case "updateQuantity" ->
                    "UPDATE_QUANTITY";

            default ->
                    methodName.toUpperCase();
        };
    }

    private boolean shouldPersistAudit(
            String methodName
    ) {

        return
                "createInventory".equals(methodName)
                        ||
                        "updateInventory".equals(methodName)
                        ||
                        "deleteInventory".equals(methodName)
                        ||
                        "addStock".equals(methodName)
                        ||
                        "removeStock".equals(methodName)
                        ||
                        "updateQuantity".equals(methodName);
    }

    private boolean shouldCreateStockMovement(
            String methodName
    ) {

        return
                "addStock".equals(methodName)
                        ||
                        "removeStock".equals(methodName)
                        ||
                        "updateQuantity".equals(methodName)
                        ||
                        "updateInventory".equals(methodName);
    }

    private boolean shouldCaptureOldValue(
            String methodName
    ) {

        return
                "updateInventory".equals(methodName)
                        ||
                        "deleteInventory".equals(methodName)
                        ||
                        "addStock".equals(methodName)
                        ||
                        "removeStock".equals(methodName)
                        ||
                        "updateQuantity".equals(methodName);
    }

    private String buildNewValue(
            Object result
    ) {

        if (!(result instanceof Inventory inventory)) {

            return null;
        }


        return buildInventoryValue(
                inventory
        );
    }

    private String buildInventoryValue(
            Inventory inventory
    ) {

        if (inventory == null) {
            return null;
        }


        String vendorName =
                inventory.getVendor() != null
                        ? String.valueOf(
                        inventory.getVendor().getId()
                )
                        : "N/A";


        String warehouseName =
                inventory.getWarehouse() != null
                        ? String.valueOf(
                        inventory.getWarehouse().getId()
                )
                        : "N/A";


        return
                "Inventory ID: " +
                        inventory.getId() +

                        ", Product Code: " +
                        inventory.getProductCode() +

                        ", Product Name: " +
                        inventory.getProductName() +

                        ", Quantity: " +
                        inventory.getQuantity() +

                        ", Reorder Level: " +
                        inventory.getReorderLevel() +

                        ", Vendor: " +
                        vendorName +

                        ", Warehouse: " +
                        warehouseName;
    }

    private String buildDetails(
            String methodName
    ) {

        return switch (methodName) {

            case "createInventory" ->
                    "Inventory record created.";

            case "updateInventory" ->
                    "Inventory record updated.";

            case "deleteInventory" ->
                    "Inventory record deleted.";

            case "addStock" ->
                    "Inventory stock increased.";

            case "removeStock" ->
                    "Inventory stock decreased.";

            case "updateQuantity" ->
                    "Inventory quantity updated.";

            default ->
                    "Inventory operation: " +
                            methodName;
        };
    }
}