package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Country;
import lk.sasindi.globaltrade.entity.Status;
import lk.sasindi.globaltrade.entity.Vendor;

import java.util.List;

@Stateless
public class VendorDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    public List<Vendor> findAll() {

        return em.createQuery(
                "SELECT DISTINCT v " +
                        "FROM Vendor v " +
                        "LEFT JOIN FETCH v.status " +
                        "LEFT JOIN FETCH v.country " +
                        "ORDER BY v.companyName ASC",
                Vendor.class
        ).getResultList();
    }

    public Vendor findById(Integer id) {

        if (id == null) {
            return null;
        }

        List<Vendor> result =
                em.createQuery(
                                "SELECT DISTINCT v " +
                                        "FROM Vendor v " +
                                        "LEFT JOIN FETCH v.status " +
                                        "LEFT JOIN FETCH v.country " +
                                        "WHERE v.id = :id",
                                Vendor.class
                        )
                        .setParameter("id", id)
                        .getResultList();

        return result.isEmpty()
                ? null
                : result.get(0);
    }

    public List<String> findAllVendorCodes() {

        return em.createQuery(
                "SELECT v.vendorCode " +
                        "FROM Vendor v " +
                        "WHERE UPPER(v.vendorCode) LIKE 'VEN-%'",
                String.class
        ).getResultList();
    }

    public List<Status> findAllStatuses() {

        return em.createQuery(
                "SELECT s FROM Status s ORDER BY s.name ASC",
                Status.class
        ).getResultList();
    }

    public List<Country> findAllCountries() {

        return em.createQuery(
                "SELECT c FROM Country c ORDER BY c.name ASC",
                Country.class
        ).getResultList();
    }

    public Status findStatusById(Integer id) {

        return id == null
                ? null
                : em.find(Status.class, id);
    }

    public Country findCountryById(Integer id) {

        return id == null
                ? null
                : em.find(Country.class, id);
    }

    public Vendor findByVendorCode(String vendorCode) {

        if (vendorCode == null || vendorCode.trim().isEmpty()) {
            return null;
        }

        List<Vendor> result =
                em.createQuery(
                                "SELECT v " +
                                        "FROM Vendor v " +
                                        "WHERE LOWER(v.vendorCode) = LOWER(:vendorCode)",
                                Vendor.class
                        )
                        .setParameter("vendorCode", vendorCode.trim())
                        .setMaxResults(1)
                        .getResultList();

        return result.isEmpty()
                ? null
                : result.get(0);
    }

    public Vendor save(Vendor vendor) {

        em.persist(vendor);
        em.flush();

        return vendor;
    }

    public Vendor update(Vendor vendor) {

        Vendor merged = em.merge(vendor);
        em.flush();

        return merged;
    }

    public void delete(Integer id) {

        Vendor vendor = em.find(Vendor.class, id);

        if (vendor != null) {
            em.remove(vendor);
            em.flush();
        }
    }
}
