package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import lk.sasindi.globaltrade.entity.JobExecutionLog;

import java.util.List;

@Stateless
public class JobExecutionLogDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;


    public JobExecutionLog save(JobExecutionLog log) {

        em.persist(log);

        return log;
    }


    public JobExecutionLog update(JobExecutionLog log) {

        return em.merge(log);
    }


    public JobExecutionLog findById(Integer id) {

        return em.find(JobExecutionLog.class, id);
    }


    public List<JobExecutionLog> findAll() {

        TypedQuery<JobExecutionLog> query =
                em.createQuery(
                        "SELECT l " +
                                "FROM JobExecutionLog l " +
                                "JOIN FETCH l.jobExecutionStatus " +
                                "ORDER BY l.startedAt DESC",
                        JobExecutionLog.class
                );

        return query.getResultList();
    }


    public List<JobExecutionLog> findByJobName(String name) {

        TypedQuery<JobExecutionLog> query =
                em.createQuery(
                        "SELECT l " +
                                "FROM JobExecutionLog l " +
                                "JOIN FETCH l.jobExecutionStatus " +
                                "WHERE l.name = :name " +
                                "ORDER BY l.startedAt DESC",
                        JobExecutionLog.class
                );

        query.setParameter("name", name);

        return query.getResultList();
    }

    public void delete(Integer id) {

        JobExecutionLog log =
                em.find(JobExecutionLog.class, id);

        if (log != null) {
            em.remove(log);
        }
    }
}