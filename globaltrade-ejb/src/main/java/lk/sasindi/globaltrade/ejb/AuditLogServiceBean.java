package lk.sasindi.globaltrade.ejb;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.bean.StockMovementSessionBean;
import lk.sasindi.globaltrade.entity.*;

import java.time.LocalDateTime;
import java.util.List;

@Stateless
public class AuditLogServiceBean {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    @EJB
    private StockMovementSessionBean stockMovementSessionBean;

    @TransactionAttribute(
            TransactionAttributeType.REQUIRED
    )
    public void createAuditLog(
            Integer userId,
            String action,
            String oldValue,
            String newValue,
            String details,
            Integer entityId,
            String entityTypeName
    ) {

        if (userId == null) {

            throw new IllegalArgumentException(
                    "Audit user ID is required."
            );
        }

        if (action == null ||
                action.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Audit action is required."
            );
        }

        if (entityId == null) {

            throw new IllegalArgumentException(
                    "Audit entity ID is required."
            );
        }

        if (entityTypeName == null ||
                entityTypeName.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Entity type is required."
            );
        }

        User user =
                em.find(
                        User.class,
                        userId
                );

        if (user == null) {

            throw new IllegalArgumentException(
                    "Audit user was not found."
            );
        }

        EntityType entityType =
                findOrCreateEntityType(
                        entityTypeName.trim()
                );

        AuditLog log =
                new AuditLog();

        log.setAction(
                action.trim().toUpperCase()
        );

        log.setOldValue(
                oldValue
        );

        log.setNewValue(
                newValue
        );

        log.setTimestamp(
                LocalDateTime.now()
        );

        log.setDetails(
                details
        );

        log.setUser(
                user
        );

        log.setEntityId(
                entityId
        );

        log.setEntityType(
                entityType
        );

        em.persist(log);

        em.flush();

        System.out.println(
                "[AUDIT] " +
                        log.getAction() +
                        " | Entity: " +
                        entityType.getName() +
                        " | ID: " +
                        entityId +
                        " | User: " +
                        user.getUsername()
        );
    }

    @TransactionAttribute(
            TransactionAttributeType.REQUIRED
    )
    public void createStockMovement(
            Integer inventoryId,
            Integer userId,
            int qty,
            int previousQty,
            int newQty,
            String reason,
            String movementType,
            String referenceType
    ) {

        stockMovementSessionBean.createStockMovement(
                inventoryId,
                userId,
                qty,
                previousQty,
                newQty,
                reason,
                movementType,
                referenceType
        );
    }

    private EntityType findOrCreateEntityType(
            String name
    ) {

        List<EntityType> results =
                em.createQuery(
                                """
                                SELECT e
                                FROM EntityType e
                                WHERE LOWER(e.name) = LOWER(:name)
                                """,
                                EntityType.class
                        )
                        .setParameter(
                                "name",
                                name
                        )
                        .setMaxResults(1)
                        .getResultList();

        if (!results.isEmpty()) {

            return results.get(0);
        }

        EntityType entityType =
                new EntityType();

        entityType.setName(
                name.toUpperCase()
        );

        em.persist(entityType);

        em.flush();

        return entityType;
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public Shipment getShipmentForAudit(
            Integer shipmentId
    ) {

        if (shipmentId == null) {
            return null;
        }

        List<Shipment> results =
                em.createQuery(
                                """
                                SELECT DISTINCT s
                                FROM Shipment s
                                LEFT JOIN FETCH s.vendor
                                LEFT JOIN FETCH s.shipmentStatus
                                LEFT JOIN FETCH s.originAddress oa
                                LEFT JOIN FETCH oa.city
                                LEFT JOIN FETCH oa.country
                                LEFT JOIN FETCH s.destinationAddress da
                                LEFT JOIN FETCH da.city
                                LEFT JOIN FETCH da.country
                                LEFT JOIN FETCH s.shipmentItems si
                                LEFT JOIN FETCH si.inventory
                                WHERE s.id = :id
                                """,
                                Shipment.class
                        )
                        .setParameter(
                                "id",
                                shipmentId
                        )
                        .setMaxResults(1)
                        .getResultList();

        return results.isEmpty()
                ? null
                : results.get(0);
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public Inventory getInventoryForAudit(
            Integer inventoryId
    ) {

        if (inventoryId == null) {
            return null;
        }

        List<Inventory> results =
                em.createQuery(
                                """
                                SELECT i
                                FROM Inventory i
                                LEFT JOIN FETCH i.vendor
                                LEFT JOIN FETCH i.warehouse
                                WHERE i.id = :id
                                """,
                                Inventory.class
                        )
                        .setParameter(
                                "id",
                                inventoryId
                        )
                        .setMaxResults(1)
                        .getResultList();

        return results.isEmpty()
                ? null
                : results.get(0);
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public Vendor getVendorForAudit(
            Integer id
    ) {

        if (id == null) {
            return null;
        }

        return em.createQuery(
                        """
                        SELECT DISTINCT v
                        FROM Vendor v
                        LEFT JOIN FETCH v.status
                        LEFT JOIN FETCH v.country
                        WHERE v.id = :id
                        """,
                        Vendor.class
                )
                .setParameter(
                        "id",
                        id
                )
                .getResultStream()
                .findFirst()
                .orElse(null);
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public CustomDocument getCustomDocumentForAudit(
            Integer id
    ) {

        if (id == null) {
            return null;
        }

        return em.createQuery(
                        """
                        SELECT d
                        FROM CustomDocument d
                        JOIN FETCH d.shipment s
                        JOIN FETCH d.documentType t
                        JOIN FETCH d.documentStatus st
                        WHERE d.id = :id
                        """,
                        CustomDocument.class
                )
                .setParameter(
                        "id",
                        id
                )
                .getResultStream()
                .findFirst()
                .orElse(null);
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public Alert getAlertForAudit(
            Integer id
    ) {

        if (id == null) {
            return null;
        }

        return em.createQuery(
                        """
                        SELECT DISTINCT a
                        FROM Alert a
                        LEFT JOIN FETCH a.shipment
                        LEFT JOIN FETCH a.vendor
                        LEFT JOIN FETCH a.inventory
                        LEFT JOIN FETCH a.alertType
                        LEFT JOIN FETCH a.severity
                        LEFT JOIN FETCH a.alertStatus
                        WHERE a.id = :id
                        """,
                        Alert.class
                )
                .setParameter(
                        "id",
                        id
                )
                .setMaxResults(1)
                .getResultStream()
                .findFirst()
                .orElse(null);
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public User getUserForAudit(
            Integer id
    ) {

        if (id == null) {
            return null;
        }

        return em.createQuery(
                        """
                        SELECT u
                        FROM User u
                        LEFT JOIN FETCH u.role
                        LEFT JOIN FETCH u.status
                        LEFT JOIN FETCH u.city
                        WHERE u.id = :id
                        """,
                        User.class
                )
                .setParameter(
                        "id",
                        id
                )
                .getResultStream()
                .findFirst()
                .orElse(null);
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<AuditLog> getAllLogs() {

        return em.createQuery(
                """
                SELECT a
                FROM AuditLog a
                JOIN FETCH a.user u
                JOIN FETCH a.entityType e
                ORDER BY a.timestamp DESC
                """,
                AuditLog.class
        ).getResultList();
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<AuditLog> searchLogs(
            String keyword
    ) {

        if (keyword == null ||
                keyword.trim().isEmpty()) {

            return getAllLogs();
        }

        String search =
                "%" +
                        keyword.trim().toLowerCase() +
                        "%";

        return em.createQuery(
                        """
                        SELECT a
                        FROM AuditLog a
                        JOIN FETCH a.user u
                        JOIN FETCH a.entityType e
                        WHERE
                            LOWER(a.action) LIKE :keyword
                            OR LOWER(a.details) LIKE :keyword
                            OR LOWER(a.oldValue) LIKE :keyword
                            OR LOWER(a.newValue) LIKE :keyword
                            OR LOWER(u.username) LIKE :keyword
                            OR LOWER(e.name) LIKE :keyword
                        ORDER BY a.timestamp DESC
                        """,
                        AuditLog.class
                )
                .setParameter(
                        "keyword",
                        search
                )
                .getResultList();
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public long getTotalCount() {

        return em.createQuery(
                """
                SELECT COUNT(a)
                FROM AuditLog a
                """,
                Long.class
        ).getSingleResult();
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public long getTodayCount() {

        LocalDateTime start =
                LocalDateTime.now()
                        .toLocalDate()
                        .atStartOfDay();

        LocalDateTime end =
                start.plusDays(1);

        return em.createQuery(
                        """
                        SELECT COUNT(a)
                        FROM AuditLog a
                        WHERE a.timestamp >= :start
                        AND a.timestamp < :end
                        """,
                        Long.class
                )
                .setParameter(
                        "start",
                        start
                )
                .setParameter(
                        "end",
                        end
                )
                .getSingleResult();
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public long getCreateCount() {

        return getActionCount(
                "CREATE"
        );
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public long getUpdateCount() {

        return getActionCount(
                "UPDATE"
        );
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public long getDeleteCount() {

        return getActionCount(
                "DELETE"
        );
    }

    private long getActionCount(
            String action
    ) {

        return em.createQuery(
                        """
                        SELECT COUNT(a)
                        FROM AuditLog a
                        WHERE UPPER(a.action) = :action
                        """,
                        Long.class
                )
                .setParameter(
                        "action",
                        action.toUpperCase()
                )
                .getSingleResult();
    }
}