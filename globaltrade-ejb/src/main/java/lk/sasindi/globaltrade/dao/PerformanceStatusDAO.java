package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.PerformanceStatus;

import java.util.List;

@Stateless
public class PerformanceStatusDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    public PerformanceStatus save(
            PerformanceStatus status
    ) {

        em.persist(status);

        return status;
    }

    public PerformanceStatus findByName(
            String name
    ) {

        List<PerformanceStatus> results =
                em.createQuery(
                                "SELECT s FROM PerformanceStatus s " +
                                        "WHERE s.name = :name",
                                PerformanceStatus.class
                        )
                        .setParameter("name", name)
                        .getResultList();

        return results.isEmpty()
                ? null
                : results.get(0);
    }
}