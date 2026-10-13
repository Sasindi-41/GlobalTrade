package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.sasindi.globaltrade.entity.ShipmentStatus;

import java.util.List;

@Stateless
public class ShipmentStatusDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    public List<ShipmentStatus> findAll() {

        return em.createQuery(
                "SELECT s FROM ShipmentStatus s ORDER BY s.name ASC",
                ShipmentStatus.class
        ).getResultList();
    }

    public ShipmentStatus findById(Integer id) {

        return em.find(ShipmentStatus.class, id);
    }
}