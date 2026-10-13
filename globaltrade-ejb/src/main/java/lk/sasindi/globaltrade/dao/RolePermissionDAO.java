package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.RolePermission;

import java.util.Collections;
import java.util.List;

@Stateless
public class RolePermissionDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    public RolePermission save(RolePermission rolePermission) {
        em.persist(rolePermission);
        return rolePermission;
    }

    public void delete(Integer id) {

        RolePermission rolePermission = em.find(RolePermission.class, id);

        if (rolePermission != null) {
            em.remove(rolePermission);
        }
    }

    public List<RolePermission> findAll() {

        return em.createQuery(
                "SELECT rp FROM RolePermission rp " +
                        "JOIN FETCH rp.role " +
                        "JOIN FETCH rp.permission " +
                        "ORDER BY rp.role.name, rp.permission.name",
                RolePermission.class
        ).getResultList();
    }

    public List<RolePermission> findByRole(Integer roleId) {

        if (roleId == null) {
            return Collections.emptyList();
        }

        return em.createQuery(
                        "SELECT rp FROM RolePermission rp " +
                                "JOIN FETCH rp.permission " +
                                "WHERE rp.role.id = :roleId",
                        RolePermission.class
                )
                .setParameter("roleId", roleId)
                .getResultList();
    }

    public boolean existsForRoleAndPermission(
            Integer roleId,
            Integer permissionId
    ) {

        Long count = em.createQuery(
                        "SELECT COUNT(rp) FROM RolePermission rp " +
                                "WHERE rp.role.id = :roleId " +
                                "AND rp.permission.id = :permissionId",
                        Long.class
                )
                .setParameter("roleId", roleId)
                .setParameter("permissionId", permissionId)
                .getSingleResult();

        return count != null && count > 0;
    }
}
