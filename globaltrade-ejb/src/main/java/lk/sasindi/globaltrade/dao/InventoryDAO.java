package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Inventory;

import java.util.List;

@Stateless
public class InventoryDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    public Inventory findById(Integer id) {

        if (id == null) {
            return null;
        }

        List<Inventory> result =
                em.createQuery(
                                "SELECT i " +
                                        "FROM Inventory i " +
                                        "LEFT JOIN FETCH i.vendor " +
                                        "LEFT JOIN FETCH i.warehouse " +
                                        "WHERE i.id = :id",
                                Inventory.class
                        )
                        .setParameter("id", id)
                        .getResultList();

        return result.isEmpty()
                ? null
                : result.get(0);
    }

    public List<Inventory> findAll() {

        return em.createQuery(
                "SELECT i " +
                        "FROM Inventory i " +
                        "LEFT JOIN FETCH i.vendor " +
                        "LEFT JOIN FETCH i.warehouse " +
                        "ORDER BY i.productName ASC",
                Inventory.class
        ).getResultList();
    }

    public Inventory findByProductCode(String productCode) {

        if (productCode == null ||
                productCode.trim().isEmpty()) {

            return null;
        }

        List<Inventory> results =
                em.createQuery(
                                "SELECT i " +
                                        "FROM Inventory i " +
                                        "WHERE LOWER(i.productCode) = LOWER(:productCode)",
                                Inventory.class
                        )
                        .setParameter(
                                "productCode",
                                productCode.trim()
                        )
                        .setMaxResults(1)
                        .getResultList();

        return results.isEmpty()
                ? null
                : results.get(0);
    }

    public List<String> findAllProductCodes() {

        return em.createQuery(
                "SELECT i.productCode " +
                        "FROM Inventory i " +
                        "WHERE UPPER(i.productCode) LIKE 'PRD-%'",
                String.class
        ).getResultList();
    }

    public List<Inventory> findLowStock() {

        return em.createQuery(
                "SELECT i " +
                        "FROM Inventory i " +
                        "WHERE i.quantity <= i.reorderLevel " +
                        "ORDER BY i.quantity ASC",
                Inventory.class
        ).getResultList();
    }


    public List<Inventory> findOutOfStock() {

        return em.createQuery(
                "SELECT i " +
                        "FROM Inventory i " +
                        "WHERE i.quantity = 0 " +
                        "ORDER BY i.productName",
                Inventory.class
        ).getResultList();
    }


    public List<Inventory> search(String keyword) {

        return em.createQuery(
                        "SELECT i " +
                                "FROM Inventory i " +
                                "LEFT JOIN FETCH i.vendor " +
                                "LEFT JOIN FETCH i.warehouse " +
                                "WHERE LOWER(i.productCode) LIKE :keyword " +
                                "OR LOWER(i.productName) LIKE :keyword " +
                                "ORDER BY i.productName",
                        Inventory.class
                )
                .setParameter(
                        "keyword",
                        "%" + keyword.toLowerCase() + "%"
                )
                .getResultList();
    }


    public Inventory save(Inventory inventory) {

        em.persist(inventory);
        em.flush();

        return inventory;
    }


    public Inventory update(Inventory inventory) {

        Inventory merged = em.merge(inventory);

        em.flush();

        return merged;
    }


    public void delete(Integer id) {

        Inventory inventory =
                findById(id);

        if (inventory != null) {
            em.remove(inventory);
            em.flush();
        }
    }

    public long countAll() {

        return em.createQuery(
                "SELECT COUNT(i) FROM Inventory i",
                Long.class
        ).getSingleResult();
    }


    public long countLowStock() {

        return em.createQuery(
                "SELECT COUNT(i) FROM Inventory i " +
                        "WHERE i.quantity <= i.reorderLevel",
                Long.class
        ).getSingleResult();
    }


    public long countOutOfStock() {

        return em.createQuery(
                "SELECT COUNT(i) FROM Inventory i " +
                        "WHERE i.quantity = 0",
                Long.class
        ).getSingleResult();
    }
}