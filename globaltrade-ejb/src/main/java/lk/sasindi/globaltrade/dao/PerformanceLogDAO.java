package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.PerformanceLog;

import java.util.List;

@Stateless
public class PerformanceLogDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    public PerformanceLog save(PerformanceLog log) {

        em.persist(log);

        return log;
    }

    public List<PerformanceLog> findRecent(int limit) {

        return em.createQuery(
                        "SELECT p FROM PerformanceLog p " +
                                "LEFT JOIN FETCH p.performanceStatus " +
                                "ORDER BY p.createdAt DESC",
                        PerformanceLog.class
                )
                .setMaxResults(limit)
                .getResultList();
    }

    public Double findAverageExecutionTime() {

        return em.createQuery(
                "SELECT AVG(p.executionTimeMs) " +
                        "FROM PerformanceLog p",
                Double.class
        ).getSingleResult();
    }

    public Long countByStatusName(String statusName) {

        return em.createQuery(
                        "SELECT COUNT(p) " +
                                "FROM PerformanceLog p " +
                                "WHERE p.performanceStatus.name = :statusName",
                        Long.class
                )
                .setParameter("statusName", statusName)
                .getSingleResult();
    }

    public Long countAll() {

        return em.createQuery(
                "SELECT COUNT(p) " +
                        "FROM PerformanceLog p",
                Long.class
        ).getSingleResult();
    }
}