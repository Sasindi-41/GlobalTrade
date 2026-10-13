package lk.sasindi.globaltrade.bean;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import lk.sasindi.globaltrade.entity.Inventory;
import lk.sasindi.globaltrade.entity.MovementType;
import lk.sasindi.globaltrade.entity.Reference;
import lk.sasindi.globaltrade.entity.StockMovement;
import lk.sasindi.globaltrade.entity.User;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import jakarta.interceptor.Interceptors;
import lk.sasindi.globaltrade.interceptor.TransactionMonitorInterceptor;

@Stateless
@Interceptors(
        TransactionMonitorInterceptor.class
)
public class StockMovementSessionBean {



    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<StockMovement> getAllStockMovements() {

        try {

            TypedQuery<StockMovement> query =
                    em.createQuery(
                            """
                            SELECT sm
                            FROM StockMovement sm
                            LEFT JOIN FETCH sm.inventory
                            LEFT JOIN FETCH sm.user
                            LEFT JOIN FETCH sm.movementType
                            LEFT JOIN FETCH sm.reference
                            ORDER BY sm.createdAt DESC
                            """,
                            StockMovement.class
                    );

            return query.getResultList();

        } catch (Exception e) {

            e.printStackTrace();

            return Collections.emptyList();
        }
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<MovementType> getAllMovementTypes() {

        try {

            TypedQuery<MovementType> query =
                    em.createQuery(
                            """
                            SELECT mt
                            FROM MovementType mt
                            ORDER BY mt.type ASC
                            """,
                            MovementType.class
                    );

            return query.getResultList();

        } catch (Exception e) {

            e.printStackTrace();

            return Collections.emptyList();
        }
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<Reference> getAllReferences() {

        try {

            TypedQuery<Reference> query =
                    em.createQuery(
                            """
                            SELECT r
                            FROM Reference r
                            ORDER BY r.type ASC
                            """,
                            Reference.class
                    );

            return query.getResultList();

        } catch (Exception e) {

            e.printStackTrace();

            return Collections.emptyList();
        }
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public StockMovement findById(
            int id
    ) {

        return em.find(
                StockMovement.class,
                id
        );
    }

    @TransactionAttribute(
            TransactionAttributeType.REQUIRED
    )
    public StockMovement createStockMovement(
            Integer inventoryId,
            Integer userId,
            int qty,
            int previousQty,
            int newQty,
            String reason,
            String movementTypeName,
            String referenceTypeName
    ) {

        if (inventoryId == null) {

            throw new IllegalArgumentException(
                    "Inventory ID is required for stock history."
            );
        }

        if (userId == null) {

            throw new IllegalArgumentException(
                    "User ID is required for stock history."
            );
        }

        if (qty <= 0) {

            throw new IllegalArgumentException(
                    "Stock movement quantity must be greater than zero."
            );
        }

        if (previousQty < 0) {

            throw new IllegalArgumentException(
                    "Previous quantity cannot be negative."
            );
        }

        if (newQty < 0) {

            throw new IllegalArgumentException(
                    "New quantity cannot be negative."
            );
        }

        if (movementTypeName == null ||
                movementTypeName.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Movement type is required."
            );
        }

        if (referenceTypeName == null ||
                referenceTypeName.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Reference type is required."
            );
        }

        Inventory inventory =
                em.find(
                        Inventory.class,
                        inventoryId
                );

        if (inventory == null) {

            throw new IllegalArgumentException(
                    "Inventory record not found."
            );
        }

        User user =
                em.find(
                        User.class,
                        userId
                );

        if (user == null) {

            throw new IllegalArgumentException(
                    "User record not found."
            );
        }

        MovementType movementType =
                findOrCreateMovementType(
                        movementTypeName
                );

        Reference reference =
                findOrCreateReference(
                        referenceTypeName
                );

        StockMovement movement =
                new StockMovement();

        movement.setQty(qty);

        movement.setPreviousQty(
                previousQty
        );

        movement.setNewQty(
                newQty
        );

        movement.setReason(
                reason
        );

        movement.setCreatedAt(
                LocalDateTime.now()
        );

        movement.setInventory(
                inventory
        );

        movement.setUser(
                user
        );

        movement.setMovementType(
                movementType
        );

        movement.setReference(
                reference
        );

        em.persist(movement);

        em.flush();

        System.out.println(
                "[STOCK-HISTORY] " +
                        movementType.getType() +
                        " | Inventory: " +
                        inventory.getId() +
                        " | Previous: " +
                        previousQty +
                        " | Qty: " +
                        qty +
                        " | New: " +
                        newQty +
                        " | User: " +
                        user.getUsername()
        );

        return movement;
    }

    private MovementType findOrCreateMovementType(
            String type
    ) {

        String value =
                type.trim().toUpperCase();

        List<MovementType> results =
                em.createQuery(
                                """
                                SELECT mt
                                FROM MovementType mt
                                WHERE LOWER(mt.type) = LOWER(:type)
                                """,
                                MovementType.class
                        )
                        .setParameter(
                                "type",
                                value
                        )
                        .setMaxResults(1)
                        .getResultList();

        if (!results.isEmpty()) {

            return results.get(0);
        }

        MovementType movementType =
                new MovementType();

        movementType.setType(
                value
        );

        em.persist(
                movementType
        );

        em.flush();

        return movementType;
    }

    private Reference findOrCreateReference(
            String type
    ) {

        String value =
                type.trim().toUpperCase();

        List<Reference> results =
                em.createQuery(
                                """
                                SELECT r
                                FROM Reference r
                                WHERE LOWER(r.type) = LOWER(:type)
                                """,
                                Reference.class
                        )
                        .setParameter(
                                "type",
                                value
                        )
                        .setMaxResults(1)
                        .getResultList();

        if (!results.isEmpty()) {

            return results.get(0);
        }

        Reference reference =
                new Reference();

        reference.setType(
                value
        );

        em.persist(
                reference
        );

        em.flush();

        return reference;
    }
}