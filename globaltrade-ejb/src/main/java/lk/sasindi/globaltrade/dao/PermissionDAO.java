package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Permission;

import java.util.List;

@Stateless
public class PermissionDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    public Permission save(Permission permission) {
        em.persist(permission);
        return permission;
    }

    public Permission findById(Integer id) {
        return id == null ? null : em.find(Permission.class, id);
    }

    public Permission findByName(String name) {

        List<Permission> results = em.createQuery(
                        "SELECT p FROM Permission p WHERE p.name = :name",
                        Permission.class
                )
                .setParameter("name", name)
                .getResultList();

        return results.isEmpty() ? null : results.get(0);
    }

    public List<Permission> findAll() {

        return em.createQuery(
                "SELECT p FROM Permission p ORDER BY p.name",
                Permission.class
        ).getResultList();
    }
}
