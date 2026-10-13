package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import lk.sasindi.globaltrade.entity.JobExecutionStatus;

@Stateless
public class JobExecutionStatusDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;


    public JobExecutionStatus findByName(String name) {

        TypedQuery<JobExecutionStatus> query =
                em.createQuery(
                        "SELECT s " +
                                "FROM JobExecutionStatus s " +
                                "WHERE UPPER(s.name) = UPPER(:name)",
                        JobExecutionStatus.class
                );

        query.setParameter("name", name);

        return query.getResultStream()
                .findFirst()
                .orElse(null);
    }


    public JobExecutionStatus save(
            JobExecutionStatus status) {

        em.persist(status);

        return status;
    }
}