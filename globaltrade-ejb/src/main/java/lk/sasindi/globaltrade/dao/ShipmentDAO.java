package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Shipment;

import java.util.List;

@Stateless
public class ShipmentDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    public Shipment save(
            Shipment shipment
    ) {

        em.persist(shipment);

        return shipment;
    }

    public Shipment update(
            Shipment shipment
    ) {

        return em.merge(shipment);
    }

    public void delete(
            Integer id
    ) {

        Shipment shipment =
                em.find(
                        Shipment.class,
                        id
                );

        if (shipment != null) {

            em.remove(shipment);
        }
    }

    public Shipment findById(
            Integer id
    ) {

        if (id == null) {
            return null;
        }

        return em.find(
                Shipment.class,
                id
        );
    }

    public List<Shipment> findAll() {

        return em.createQuery(
                """
                SELECT DISTINCT s
                FROM Shipment s
                LEFT JOIN FETCH s.shipmentStatus
                """,
                Shipment.class
        ).getResultList();
    }

    public Shipment findByTrackingNumber(
            String trackingNumber
    ) {

        if (trackingNumber == null ||
                trackingNumber.trim().isEmpty()) {

            return null;
        }

        try {

            return em.createQuery(
                            "SELECT s FROM Shipment s " +
                                    "WHERE s.trackingNumber = :trackingNumber",
                            Shipment.class
                    )
                    .setParameter(
                            "trackingNumber",
                            trackingNumber.trim()
                    )
                    .getSingleResult();

        } catch (Exception e) {

            return null;
        }
    }

    public List<Shipment> findByCreatedByUser(
            Integer userId
    ) {

        if (userId == null) {
            return java.util.Collections.emptyList();
        }

        return em.createQuery(
                        "SELECT DISTINCT s FROM Shipment s " +
                                "LEFT JOIN FETCH s.shipmentStatus " +
                                "WHERE s.createdByUser.id = :userId " +
                                "ORDER BY s.createdAt DESC",
                        Shipment.class
                )
                .setParameter("userId", userId)
                .getResultList();
    }

    public long getNextTrackingSequence() {

        Long count =
                em.createQuery(
                        "SELECT COUNT(s) " +
                                "FROM Shipment s",
                        Long.class
                ).getSingleResult();

        return count + 1;
    }
}