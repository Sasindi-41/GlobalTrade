package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.NoResultException;

import lk.sasindi.globaltrade.entity.Status;

import java.util.List;

@Stateless
public class StatusDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager entityManager;

    public List<Status> findAll() {

        return entityManager.createQuery(
                        "SELECT s FROM Status s ORDER BY s.name ASC",
                        Status.class
                )
                .getResultList();
    }

    public Status findById(Integer id) {

        if (id == null) {
            return null;
        }

        return entityManager.find(Status.class, id);
    }

    public Status findByName(String name) {

        if (name == null || name.trim().isEmpty()) {
            return null;
        }

        try {

            return entityManager.createQuery(
                            "SELECT s FROM Status s " +
                                    "WHERE LOWER(s.name) = LOWER(:name)",
                            Status.class
                    )
                    .setParameter("name", name.trim())
                    .getSingleResult();

        } catch (NoResultException e) {

            return null;
        }
    }
}