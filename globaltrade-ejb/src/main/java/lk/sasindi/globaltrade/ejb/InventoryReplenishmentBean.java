package lk.sasindi.globaltrade.ejb;

import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.LockTimeoutException;
import jakarta.persistence.PessimisticLockException;
import jakarta.transaction.Status;
import jakarta.transaction.UserTransaction;

import lk.sasindi.globaltrade.entity.Inventory;
import lk.sasindi.globaltrade.exception.InventoryConcurrencyException;
import lk.sasindi.globaltrade.exception.ReplenishmentException;

import java.time.LocalDateTime;
import java.util.List;


@Stateless
@TransactionManagement(
        TransactionManagementType.BEAN
)
public class InventoryReplenishmentBean {


    @PersistenceContext(
            unitName = "GlobalTradePU"
    )
    private EntityManager em;

    @Resource
    private UserTransaction userTransaction;

    public int replenishLowStock()
            throws ReplenishmentException {

        List<Integer> ids =
                em.createQuery(
                                "SELECT i.id " +
                                        "FROM Inventory i " +
                                        "WHERE i.quantity <= i.reorderLevel " +
                                        "ORDER BY i.quantity ASC",
                                Integer.class
                        )
                        .getResultList();


        int successful = 0;


        for (Integer id : ids) {

            try {

                if (replenishSingle(id)) {
                    successful++;
                }

            } catch (
                    InventoryConcurrencyException e
            ) {

                System.err.println(
                        "[REPLENISHMENT] " +
                                "Concurrency conflict for inventory " +
                                id +
                                ": " +
                                e.getMessage()
                );

            } catch (ReplenishmentException e) {

                System.err.println(
                        "[REPLENISHMENT] " +
                                "Inventory " +
                                id +
                                " failed: " +
                                e.getMessage()
                );
            }
        }


        return successful;
    }

    private boolean replenishSingle(
            Integer inventoryId
    )
            throws ReplenishmentException,
            InventoryConcurrencyException {


        if (inventoryId == null) {

            throw new ReplenishmentException(
                    "Inventory ID cannot be null."
            );
        }


        boolean transactionStarted = false;


        try {

            userTransaction.begin();

            transactionStarted = true;


            try {

                em.setProperty(
                        "jakarta.persistence.lock.timeout",
                        5000
                );

            } catch (Exception ignored) {

            }

            Inventory inventory =
                    em.find(
                            Inventory.class,
                            inventoryId,
                            LockModeType.PESSIMISTIC_WRITE
                    );


            if (inventory == null) {

                safeRollback();

                return false;
            }

            int current =
                    inventory.getQuantity() == null
                            ? 0
                            : inventory.getQuantity();


            int reorderLevel =
                    inventory.getReorderLevel() == null
                            ? 0
                            : inventory.getReorderLevel();


            if (current > reorderLevel) {

                userTransaction.commit();

                return false;
            }

            int target =
                    Math.max(
                            reorderLevel * 2,
                            10
                    );


            int quantityToAdd =
                    Math.max(
                            target - current,
                            0
                    );


            if (quantityToAdd <= 0) {

                userTransaction.commit();

                return false;
            }

            inventory.setQuantity(
                    current + quantityToAdd
            );


            inventory.setLastUpdated(
                    LocalDateTime.now()
            );


            em.merge(inventory);

            em.flush();

            userTransaction.commit();

            transactionStarted = false;


            System.out.println(
                    "[REPLENISHMENT] Inventory " +
                            inventoryId +
                            " replenished by " +
                            quantityToAdd +
                            " unit(s)."
            );


            return true;


        } catch (
                PessimisticLockException |
                LockTimeoutException e
        ) {

            if (transactionStarted) {
                safeRollback();
            }


            throw new InventoryConcurrencyException(
                    "Unable to acquire inventory lock for " +
                            inventoryId +
                            ". Another transaction may be " +
                            "updating the same inventory record.",
                    e
            );


        } catch (Exception e) {

            if (transactionStarted) {
                safeRollback();
            }


            throw new ReplenishmentException(
                    "Inventory replenishment transaction failed " +
                            "for inventory " +
                            inventoryId,
                    e
            );
        }
    }

    private void safeRollback() {

        try {

            int status =
                    userTransaction.getStatus();


            if (status == Status.STATUS_ACTIVE ||
                    status == Status.STATUS_MARKED_ROLLBACK) {

                userTransaction.rollback();
            }

        } catch (Exception rollbackException) {

            System.err.println(
                    "[TRANSACTION-RECOVERY] " +
                            "Rollback failed: " +
                            rollbackException.getMessage()
            );
        }
    }


}

