package lk.sasindi.globaltrade.bean;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.*;
import lk.sasindi.globaltrade.exception.AlertException;
import lk.sasindi.globaltrade.interceptor.AlertAuditInterceptor;
import lk.sasindi.globaltrade.interceptor.AlertPerformanceInterceptor;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Stateless
@Interceptors({
        AlertAuditInterceptor.class,
        AlertPerformanceInterceptor.class
})
public class AlertServiceBean {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<Alert> getAllAlerts() {

        return em.createQuery(
                """
                SELECT a
                FROM Alert a
                JOIN FETCH a.shipment s
                JOIN FETCH a.vendor v
                JOIN FETCH a.inventory i
                JOIN FETCH a.alertType t
                JOIN FETCH a.severity sev
                JOIN FETCH a.alertStatus st
                ORDER BY a.createdAt DESC
                """,
                Alert.class
        ).getResultList();
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<Alert> getOpenAlerts() {

        return em.createQuery(
                """
                SELECT a
                FROM Alert a
                JOIN FETCH a.shipment
                JOIN FETCH a.vendor
                JOIN FETCH a.inventory
                JOIN FETCH a.alertType
                JOIN FETCH a.severity
                JOIN FETCH a.alertStatus st
                WHERE UPPER(st.name) = 'OPEN'
                ORDER BY a.createdAt DESC
                """,
                Alert.class
        ).getResultList();
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public long getTotalCount() {

        return em.createQuery(
                """
                SELECT COUNT(a)
                FROM Alert a
                """,
                Long.class
        ).getSingleResult();
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public long getOpenCount() {

        return em.createQuery(
                """
                SELECT COUNT(a)
                FROM Alert a
                WHERE UPPER(a.alertStatus.name) = 'OPEN'
                """,
                Long.class
        ).getSingleResult();
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public long getCriticalCount() {

        return em.createQuery(
                """
                SELECT COUNT(a)
                FROM Alert a
                WHERE UPPER(a.severity.name) = 'CRITICAL'
                """,
                Long.class
        ).getSingleResult();
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public long getResolvedCount() {

        return em.createQuery(
                """
                SELECT COUNT(a)
                FROM Alert a
                WHERE UPPER(a.alertStatus.name) = 'RESOLVED'
                """,
                Long.class
        ).getSingleResult();
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public Alert findById(Integer id)
            throws AlertException {

        if (id == null || id <= 0) {
            throw new AlertException(
                    "A valid alert ID is required."
            );
        }

        Alert alert = em.find(Alert.class, id);

        if (alert == null) {
            throw new AlertException(
                    "Alert could not be found."
            );
        }

        return alert;
    }


    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void resolveAlert(
            Integer id,
            Integer userId
    ) throws AlertException {

        if (userId == null) {
            throw new AlertException(
                    "Authenticated user is required."
            );
        }

        Alert alert = findById(id);

        String currentStatus =
                alert.getAlertStatus() != null
                        ? alert.getAlertStatus().getName()
                        : "";

        if ("RESOLVED".equalsIgnoreCase(currentStatus)) {
            throw new AlertException(
                    "This alert is already resolved."
            );
        }

        AlertStatus resolvedStatus =
                findStatus("RESOLVED");

        alert.setAlertStatus(resolvedStatus);

        alert.setResolvedAt(
                LocalDateTime.now()
        );

    }

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void reopenAlert(
            Integer id,
            Integer userId
    ) throws AlertException {

        if (userId == null) {
            throw new AlertException(
                    "Authenticated user is required."
            );
        }

        Alert alert = findById(id);

        String currentStatus =
                alert.getAlertStatus() != null
                        ? alert.getAlertStatus().getName()
                        : "";

        if ("OPEN".equalsIgnoreCase(currentStatus)) {
            throw new AlertException(
                    "This alert is already open."
            );
        }

        AlertStatus openStatus =
                findStatus("OPEN");

        alert.setAlertStatus(openStatus);

        alert.setResolvedAt(null);

    }


    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void createAlert(
            Integer userId,
            String message,
            Integer shipmentId,
            Integer vendorId,
            Integer inventoryId,
            Integer alertTypeId,
            Integer severityId,
            Integer alertStatusId
    ) throws AlertException {

        if (userId == null) {
            throw new AlertException(
                    "Authenticated user is required."
            );
        }


        if (message == null ||
                message.trim().isEmpty()) {

            throw new AlertException(
                    "Alert message is required."
            );
        }

        message = message.trim();

        if (message.length() > 500) {

            throw new AlertException(
                    "Alert message cannot exceed 500 characters."
            );
        }


        validatePositiveId(
                shipmentId,
                "Shipment"
        );

        validatePositiveId(
                vendorId,
                "Vendor"
        );

        validatePositiveId(
                inventoryId,
                "Inventory"
        );

        validatePositiveId(
                alertTypeId,
                "Alert type"
        );

        validatePositiveId(
                severityId,
                "Severity"
        );

        validatePositiveId(
                alertStatusId,
                "Alert status"
        );


        Shipment shipment =
                em.find(
                        Shipment.class,
                        shipmentId
                );

        if (shipment == null) {

            throw new AlertException(
                    "Selected shipment could not be found."
            );
        }


        Vendor vendor =
                em.find(
                        Vendor.class,
                        vendorId
                );

        if (vendor == null) {

            throw new AlertException(
                    "Selected vendor could not be found."
            );
        }


        Inventory inventory =
                em.find(
                        Inventory.class,
                        inventoryId
                );

        if (inventory == null) {

            throw new AlertException(
                    "Selected inventory item could not be found."
            );
        }


        AlertType alertType =
                em.find(
                        AlertType.class,
                        alertTypeId
                );

        if (alertType == null) {

            throw new AlertException(
                    "Selected alert type could not be found."
            );
        }


        Severity severity =
                em.find(
                        Severity.class,
                        severityId
                );

        if (severity == null) {

            throw new AlertException(
                    "Selected severity could not be found."
            );
        }


        AlertStatus alertStatus =
                em.find(
                        AlertStatus.class,
                        alertStatusId
                );

        if (alertStatus == null) {

            throw new AlertException(
                    "Selected alert status could not be found."
            );
        }


        if (shipment.getVendor() == null ||
                shipment.getVendor().getId() == null ||
                !shipment.getVendor()
                        .getId()
                        .equals(vendor.getId())) {

            throw new AlertException(
                    "The selected vendor does not belong to the selected shipment."
            );
        }


        if (inventory.getVendor() == null ||
                inventory.getVendor().getId() == null ||
                !inventory.getVendor()
                        .getId()
                        .equals(vendor.getId())) {

            throw new AlertException(
                    "The selected inventory item does not belong to the selected vendor."
            );
        }


        LocalDateTime resolvedAt = null;

        if ("RESOLVED".equalsIgnoreCase(
                alertStatus.getName()
        )) {

            resolvedAt =
                    LocalDateTime.now();
        }


        Alert alert =
                new Alert();

        alert.setMessage(message);

        alert.setCreatedAt(
                LocalDateTime.now()
        );

        alert.setResolvedAt(
                resolvedAt
        );

        alert.setShipment(
                shipment
        );

        alert.setVendor(
                vendor
        );

        alert.setInventory(
                inventory
        );

        alert.setAlertType(
                alertType
        );

        alert.setSeverity(
                severity
        );

        alert.setAlertStatus(
                alertStatus
        );

        em.persist(alert);
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void generateAutomaticAlerts()
            throws AlertException {

        LocalDateTime now =
                LocalDateTime.now();

        checkShipmentDelays(now);

        checkInventoryShortages();

        checkVendorPerformance();
    }


    private void checkShipmentDelays(
            LocalDateTime now
    ) throws AlertException {

        List<Shipment> shipments =
                em.createQuery(
                                """
                                SELECT DISTINCT s
                                FROM Shipment s
                                JOIN FETCH s.vendor
                                LEFT JOIN FETCH s.shipmentItems si
                                LEFT JOIN FETCH si.inventory
                                WHERE s.actualDelivery IS NULL
                                AND s.expectedDelivery < :now
                                """,
                                Shipment.class
                        )
                        .setParameter("now", now)
                        .getResultList();


        for (Shipment shipment : shipments) {

            if (shipment.getShipmentItems() == null ||
                    shipment.getShipmentItems().isEmpty()) {

                continue;
            }


            long hoursLate =
                    Duration.between(
                            shipment.getExpectedDelivery(),
                            now
                    ).toHours();


            String severityName =
                    hoursLate >= 24
                            ? "CRITICAL"
                            : "WARNING";


            Set<Integer> processedInventoryIds =
                    new HashSet<>();


            for (ShipmentItem item :
                    shipment.getShipmentItems()) {

                if (item == null ||
                        item.getInventory() == null) {

                    continue;
                }


                Inventory inventory =
                        item.getInventory();

                if (inventory.getId() == null) {
                    continue;
                }


                if (!processedInventoryIds.add(
                        inventory.getId()
                )) {
                    continue;
                }


                String message =
                        "Shipment " +
                                shipment.getTrackingNumber() +
                                " is delayed by approximately " +
                                hoursLate +
                                " hour(s). Expected delivery was " +
                                shipment.getExpectedDelivery() +
                                ".";


                createAutomaticAlertIfNotOpen(
                        "Shipment Delay",
                        severityName,
                        shipment,
                        shipment.getVendor(),
                        inventory,
                        message
                );
            }
        }
    }


    private void checkInventoryShortages()
            throws AlertException {

        List<Inventory> inventories =
                em.createQuery(
                                """
                                SELECT i
                                FROM Inventory i
                                JOIN FETCH i.vendor
                                WHERE i.quantity <= i.reorderLevel
                                """,
                                Inventory.class
                        )
                        .getResultList();


        for (Inventory inventory :
                inventories) {

            Shipment shipment =
                    findLatestShipmentForInventory(
                            inventory
                    );



            if (shipment == null) {
                continue;
            }


            String severityName =
                    inventory.getQuantity() <= 0
                            ? "CRITICAL"
                            : "WARNING";


            String message =
                    "Inventory shortage detected for " +
                            inventory.getProductName() +
                            " (" +
                            inventory.getProductCode() +
                            "). Current quantity: " +
                            inventory.getQuantity() +
                            ", reorder level: " +
                            inventory.getReorderLevel() +
                            ".";


            createAutomaticAlertIfNotOpen(
                    "Inventory Shortage",
                    severityName,
                    shipment,
                    inventory.getVendor(),
                    inventory,
                    message
            );
        }
    }


    private void checkVendorPerformance()
            throws AlertException {

        List<Vendor> vendors =
                em.createQuery(
                                """
                                SELECT v
                                FROM Vendor v
                                WHERE v.performanceScore < 70
                                """,
                                Vendor.class
                        )
                        .getResultList();


        for (Vendor vendor :
                vendors) {

            Shipment shipment =
                    findLatestShipmentForVendor(
                            vendor
                    );

            Inventory inventory =
                    findLatestInventoryForVendor(
                            vendor
                    );



            if (shipment == null ||
                    inventory == null) {

                continue;
            }


            double score =
                    vendor.getPerformanceScore()
                            .doubleValue();


            String severityName =
                    score < 50
                            ? "CRITICAL"
                            : "WARNING";


            String message =
                    "Vendor " +
                            vendor.getCompanyName() +
                            " has a low performance score of " +
                            score +
                            ".";


            createAutomaticAlertIfNotOpen(
                    "Vendor Performance",
                    severityName,
                    shipment,
                    vendor,
                    inventory,
                    message
            );
        }
    }

    private void createAutomaticAlertIfNotOpen(
            String alertTypeName,
            String severityName,
            Shipment shipment,
            Vendor vendor,
            Inventory inventory,
            String message
    ) throws AlertException {

        if (shipment == null ||
                vendor == null ||
                inventory == null) {

            return;
        }


        AlertType alertType =
                findAlertType(alertTypeName);

        AlertStatus openStatus =
                findStatus("OPEN");

        Severity severity =
                findSeverity(severityName);


        Long existing =
                em.createQuery(
                                """
                                SELECT COUNT(a)
                                FROM Alert a
                                WHERE a.shipment.id = :shipmentId
                                AND a.vendor.id = :vendorId
                                AND a.inventory.id = :inventoryId
                                AND a.alertType.id = :typeId
                                AND UPPER(a.alertStatus.name) = 'OPEN'
                                """,
                                Long.class
                        )
                        .setParameter(
                                "shipmentId",
                                shipment.getId()
                        )
                        .setParameter(
                                "vendorId",
                                vendor.getId()
                        )
                        .setParameter(
                                "inventoryId",
                                inventory.getId()
                        )
                        .setParameter(
                                "typeId",
                                alertType.getId()
                        )
                        .getSingleResult();


        if (existing > 0) {
            return;
        }


        Alert alert =
                new Alert();

        alert.setMessage(
                message
        );

        alert.setCreatedAt(
                LocalDateTime.now()
        );

        alert.setResolvedAt(
                null
        );

        alert.setShipment(
                shipment
        );

        alert.setVendor(
                vendor
        );

        alert.setInventory(
                inventory
        );

        alert.setAlertType(
                alertType
        );

        alert.setSeverity(
                severity
        );

        alert.setAlertStatus(
                openStatus
        );

        em.persist(alert);
    }


    private Shipment findLatestShipmentForInventory(
            Inventory inventory
    ) {

        List<Shipment> shipments =
                em.createQuery(
                                """
                                SELECT si.shipment
                                FROM ShipmentItem si
                                WHERE si.inventory.id = :inventoryId
                                ORDER BY si.shipment.createdAt DESC
                                """,
                                Shipment.class
                        )
                        .setParameter(
                                "inventoryId",
                                inventory.getId()
                        )
                        .setMaxResults(1)
                        .getResultList();


        return shipments.isEmpty()
                ? null
                : shipments.get(0);
    }


    private Shipment findLatestShipmentForVendor(
            Vendor vendor
    ) {

        List<Shipment> shipments =
                em.createQuery(
                                """
                                SELECT s
                                FROM Shipment s
                                WHERE s.vendor.id = :vendorId
                                ORDER BY s.createdAt DESC
                                """,
                                Shipment.class
                        )
                        .setParameter(
                                "vendorId",
                                vendor.getId()
                        )
                        .setMaxResults(1)
                        .getResultList();


        return shipments.isEmpty()
                ? null
                : shipments.get(0);
    }


    private Inventory findLatestInventoryForVendor(
            Vendor vendor
    ) {

        List<Inventory> inventories =
                em.createQuery(
                                """
                                SELECT i
                                FROM Inventory i
                                WHERE i.vendor.id = :vendorId
                                ORDER BY i.lastUpdated DESC
                                """,
                                Inventory.class
                        )
                        .setParameter(
                                "vendorId",
                                vendor.getId()
                        )
                        .setMaxResults(1)
                        .getResultList();


        return inventories.isEmpty()
                ? null
                : inventories.get(0);
    }

    private AlertType findAlertType(
            String name
    ) throws AlertException {

        try {

            return em.createQuery(
                            """
                            SELECT a
                            FROM AlertType a
                            WHERE UPPER(a.name) = UPPER(:name)
                            """,
                            AlertType.class
                    )
                    .setParameter(
                            "name",
                            name
                    )
                    .getSingleResult();

        } catch (NoResultException e) {

            throw new AlertException(
                    "Alert type '" +
                            name +
                            "' is not configured in the database."
            );
        }
    }


    private AlertStatus findStatus(
            String name
    ) throws AlertException {

        try {

            return em.createQuery(
                            """
                            SELECT s
                            FROM AlertStatus s
                            WHERE UPPER(s.name) = UPPER(:name)
                            """,
                            AlertStatus.class
                    )
                    .setParameter(
                            "name",
                            name
                    )
                    .getSingleResult();

        } catch (NoResultException e) {

            throw new AlertException(
                    "Alert status '" +
                            name +
                            "' is not configured in the database."
            );
        }
    }

    private Severity findSeverity(
            String name
    ) throws AlertException {

        try {

            return em.createQuery(
                            """
                            SELECT s
                            FROM Severity s
                            WHERE UPPER(s.name) = UPPER(:name)
                            """,
                            Severity.class
                    )
                    .setParameter(
                            "name",
                            name
                    )
                    .getSingleResult();

        } catch (NoResultException e) {

            throw new AlertException(
                    "Severity '" +
                            name +
                            "' is not configured in the database."
            );
        }
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<Shipment> getAllShipments() {

        return em.createQuery(
                """
                SELECT s
                FROM Shipment s
                ORDER BY s.createdAt DESC
                """,
                Shipment.class
        ).getResultList();
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<Vendor> getAllVendors() {

        return em.createQuery(
                """
                SELECT v
                FROM Vendor v
                ORDER BY v.companyName ASC
                """,
                Vendor.class
        ).getResultList();
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<Inventory> getAllInventory() {

        return em.createQuery(
                """
                SELECT i
                FROM Inventory i
                ORDER BY i.productName ASC
                """,
                Inventory.class
        ).getResultList();
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<AlertType> getAllAlertTypes() {

        return em.createQuery(
                """
                SELECT a
                FROM AlertType a
                ORDER BY a.name ASC
                """,
                AlertType.class
        ).getResultList();
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<Severity> getAllSeverities() {

        return em.createQuery(
                """
                SELECT s
                FROM Severity s
                ORDER BY s.name ASC
                """,
                Severity.class
        ).getResultList();
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<AlertStatus> getAllAlertStatuses() {

        return em.createQuery(
                """
                SELECT s
                FROM AlertStatus s
                ORDER BY s.name ASC
                """,
                AlertStatus.class
        ).getResultList();
    }

    private void validatePositiveId(
            Integer id,
            String field
    ) throws AlertException {

        if (id == null || id <= 0) {

            throw new AlertException(
                    field +
                            " selection is required."
            );
        }
    }
}