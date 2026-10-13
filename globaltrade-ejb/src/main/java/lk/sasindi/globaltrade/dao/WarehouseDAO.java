package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Warehouse;

import java.util.List;

@Stateless
public class WarehouseDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    public List<Warehouse> findAll() {

        return em.createQuery(
                "SELECT w FROM Warehouse w " +
                        "ORDER BY w.name ASC",
                Warehouse.class
        ).getResultList();
    }

    public Warehouse findById(Integer id) {

        if (id == null) {
            return null;
        }

        return em.find(
                Warehouse.class,
                id
        );
    }
}