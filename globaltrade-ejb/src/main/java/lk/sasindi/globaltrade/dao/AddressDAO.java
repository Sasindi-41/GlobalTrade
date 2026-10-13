package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Address;

import java.util.List;

@Stateless
public class AddressDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager entityManager;

    public Address save(Address address) {

        entityManager.persist(address);

        return address;
    }

    public Address update(Address address) {

        return entityManager.merge(address);
    }

    public void delete(Integer id) {

        Address address =
                entityManager.find(
                        Address.class,
                        id
                );

        if (address != null) {
            entityManager.remove(address);
        }
    }


    public Address findById(Integer id) {

        if (id == null) {
            return null;
        }

        return entityManager.find(
                Address.class,
                id
        );
    }


    public List<Address> findAll() {

        return entityManager.createQuery(
                "SELECT a FROM Address a " +
                        "ORDER BY a.createdAt DESC",
                Address.class
        ).getResultList();
    }

    public lk.sasindi.globaltrade.entity.Country findCountryById(
            Integer id
    ) {

        if (id == null) {
            return null;
        }

        return entityManager.find(
                lk.sasindi.globaltrade.entity.Country.class,
                id
        );
    }


    public lk.sasindi.globaltrade.entity.City findCityById(
            Integer id
    ) {

        if (id == null) {
            return null;
        }

        return entityManager.find(
                lk.sasindi.globaltrade.entity.City.class,
                id
        );
    }

    public List<lk.sasindi.globaltrade.entity.Country> findAllCountries() {

        return entityManager.createQuery(
                "SELECT c FROM Country c ORDER BY c.name",
                lk.sasindi.globaltrade.entity.Country.class
        ).getResultList();
    }


    public List<lk.sasindi.globaltrade.entity.City> findCitiesByCountry(
            Integer countryId
    ) {

        if (countryId == null) {
            return java.util.Collections.emptyList();
        }

        return entityManager.createQuery(
                        "SELECT c FROM City c " +
                                "WHERE c.country.id = :countryId " +
                                "ORDER BY c.name",
                        lk.sasindi.globaltrade.entity.City.class
                )
                .setParameter("countryId", countryId)
                .getResultList();
    }
}