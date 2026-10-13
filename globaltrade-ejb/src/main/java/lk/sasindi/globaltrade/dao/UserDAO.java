package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.User;

import java.util.List;

@Stateless
public class UserDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager entityManager;

    public List<User> findAll() {

        return entityManager.createQuery(
                        "SELECT u FROM User u ORDER BY u.createdAt DESC",
                        User.class
                )
                .getResultList();
    }

    public List<User> search(String keyword) {

        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }

        String search = "%" + keyword.trim().toLowerCase() + "%";

        return entityManager.createQuery(
                        "SELECT u FROM User u " +
                                "WHERE LOWER(u.username) LIKE :keyword " +
                                "OR LOWER(u.firstName) LIKE :keyword " +
                                "OR LOWER(u.lastName) LIKE :keyword " +
                                "OR LOWER(u.email) LIKE :keyword " +
                                "OR LOWER(u.company) LIKE :keyword " +
                                "ORDER BY u.createdAt DESC",
                        User.class
                )
                .setParameter("keyword", search)
                .getResultList();
    }

    public User findById(Integer id) {

        if (id == null) {
            return null;
        }

        return entityManager.find(User.class, id);
    }

    public User findByUsername(String username) {

        try {

            return entityManager.createQuery(
                            "SELECT u FROM User u WHERE u.username = :username",
                            User.class
                    )
                    .setParameter("username", username)
                    .getSingleResult();

        } catch (NoResultException e) {

            return null;
        }
    }

    public User findByEmail(String email) {

        try {

            return entityManager.createQuery(
                            "SELECT u FROM User u WHERE u.email = :email",
                            User.class
                    )
                    .setParameter("email", email)
                    .getSingleResult();

        } catch (NoResultException e) {

            return null;
        }
    }

    public void save(User user) {

        entityManager.persist(user);
    }

    public User update(User user) {

        return entityManager.merge(user);
    }


    public boolean delete(Integer id) {

        if (id == null) {
            return false;
        }

        User user = entityManager.find(User.class, id);

        if (user == null) {
            return false;
        }

        entityManager.remove(user);

        return true;
    }


    public long countAll() {

        return entityManager.createQuery(
                        "SELECT COUNT(u) FROM User u",
                        Long.class
                )
                .getSingleResult();
    }


    public long countByStatus(String statusName) {

        if (statusName == null || statusName.trim().isEmpty()) {
            return 0;
        }

        return entityManager.createQuery(
                        "SELECT COUNT(u) FROM User u " +
                                "WHERE LOWER(u.status.name) = LOWER(:statusName)",
                        Long.class
                )
                .setParameter("statusName", statusName.trim())
                .getSingleResult();
    }
}