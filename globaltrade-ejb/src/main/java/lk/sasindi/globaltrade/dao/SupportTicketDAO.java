package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.SupportTicket;

import java.util.Collections;
import java.util.List;

@Stateless
public class SupportTicketDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;


    public SupportTicket save(SupportTicket ticket) {
        em.persist(ticket);
        return ticket;
    }

    public SupportTicket update(SupportTicket ticket) {
        return em.merge(ticket);
    }

    public SupportTicket findById(Integer id) {

        if (id == null) {
            return null;
        }

        return em.find(SupportTicket.class, id);
    }

    public List<SupportTicket> findByUser(Integer userId) {

        if (userId == null) {
            return Collections.emptyList();
        }

        return em.createQuery(
                        "SELECT t FROM SupportTicket t " +
                                "WHERE t.user.id = :userId " +
                                "ORDER BY t.createdAt DESC",
                        SupportTicket.class
                )
                .setParameter("userId", userId)
                .getResultList();
    }

    public long getNextTicketSequence() {

        Long count = em.createQuery(
                "SELECT COUNT(t) FROM SupportTicket t",
                Long.class
        ).getSingleResult();

        return count + 1;
    }
}
