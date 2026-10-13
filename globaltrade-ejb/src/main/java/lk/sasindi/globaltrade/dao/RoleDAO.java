package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.NoResultException;

import lk.sasindi.globaltrade.entity.Role;

import java.util.List;

@Stateless
public class RoleDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager entityManager;

    public List<Role> findAll() {

        return entityManager.createQuery(
                        "SELECT r FROM Role r ORDER BY r.name ASC",
                        Role.class
                )
                .getResultList();
    }

    public Role findById(Integer id) {

        if (id == null) {
            return null;
        }

        return entityManager.find(Role.class, id);
    }

    public Role findByName(String name) {

        if (name == null || name.trim().isEmpty()) {
            return null;
        }

        try {

            return entityManager.createQuery(
                            "SELECT r FROM Role r " +
                                    "WHERE LOWER(r.name) = LOWER(:name)",
                            Role.class
                    )
                    .setParameter("name", name.trim())
                    .getSingleResult();

        } catch (NoResultException e) {

            return null;
        }
    }
}