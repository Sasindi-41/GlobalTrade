package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Order;

import java.util.Collections;
import java.util.List;

@Stateless
public class OrderDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;


    public Order save(Order order) {
        em.persist(order);
        return order;
    }

    public Order update(Order order) {
        return em.merge(order);
    }

    public Order findById(Integer id) {

        if (id == null) {
            return null;
        }

        return em.find(Order.class, id);
    }

    public List<Order> findAll() {

        return em.createQuery(
                "SELECT DISTINCT o FROM Order o " +
                        "LEFT JOIN FETCH o.user " +
                        "ORDER BY o.createdAt DESC",
                Order.class
        ).getResultList();
    }

    public List<Order> findByUser(Integer userId) {

        if (userId == null) {
            return Collections.emptyList();
        }

        return em.createQuery(
                        "SELECT o FROM Order o " +
                                "WHERE o.user.id = :userId " +
                                "ORDER BY o.createdAt DESC",
                        Order.class
                )
                .setParameter("userId", userId)
                .getResultList();
    }

    public long getNextOrderSequence() {

        Long count = em.createQuery(
                "SELECT COUNT(o) FROM Order o",
                Long.class
        ).getSingleResult();

        return count + 1;
    }
}
