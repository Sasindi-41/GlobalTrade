package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Invoice;

import java.util.Collections;
import java.util.List;

@Stateless
public class InvoiceDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;


    public Invoice save(Invoice invoice) {
        em.persist(invoice);
        return invoice;
    }

    public Invoice update(Invoice invoice) {
        return em.merge(invoice);
    }

    public Invoice findById(Integer id) {

        if (id == null) {
            return null;
        }

        return em.find(Invoice.class, id);
    }

    public List<Invoice> findAll() {

        return em.createQuery(
                "SELECT DISTINCT i FROM Invoice i " +
                        "LEFT JOIN FETCH i.shipment " +
                        "LEFT JOIN FETCH i.user " +
                        "ORDER BY i.issueDate DESC",
                Invoice.class
        ).getResultList();
    }

    public List<Invoice> findByUser(Integer userId) {

        if (userId == null) {
            return Collections.emptyList();
        }

        return em.createQuery(
                        "SELECT DISTINCT i FROM Invoice i " +
                                "LEFT JOIN FETCH i.shipment " +
                                "WHERE i.user.id = :userId " +
                                "ORDER BY i.issueDate DESC",
                        Invoice.class
                )
                .setParameter("userId", userId)
                .getResultList();
    }

    public Invoice findByIdForUser(Integer id, Integer userId) {

        if (id == null || userId == null) {
            return null;
        }

        try {

            return em.createQuery(
                            "SELECT i FROM Invoice i " +
                                    "WHERE i.id = :id AND i.user.id = :userId",
                            Invoice.class
                    )
                    .setParameter("id", id)
                    .setParameter("userId", userId)
                    .getSingleResult();

        } catch (Exception e) {
            return null;
        }
    }

    public long getNextInvoiceSequence() {

        Long count = em.createQuery(
                "SELECT COUNT(i) FROM Invoice i",
                Long.class
        ).getSingleResult();

        return count + 1;
    }
}
