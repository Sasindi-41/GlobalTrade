package lk.sasindi.globaltrade.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.City;

import java.util.Collections;
import java.util.List;

@Stateless
public class CityDAO {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager entityManager;

    public List<City> findAll() {

        return entityManager.createQuery(
                "SELECT c FROM City c " +
                        "ORDER BY c.name ASC",
                City.class
        ).getResultList();
    }


    public City findById(Integer id) {

        if (id == null) {
            return null;
        }

        return entityManager.find(
                City.class,
                id
        );
    }

    public List<City> findByCountryId(Integer countryId) {

        if (countryId == null) {
            return Collections.emptyList();
        }

        return entityManager.createQuery(
                        "SELECT c FROM City c " +
                                "WHERE c.country.id = :countryId " +
                                "ORDER BY c.name ASC",
                        City.class
                )
                .setParameter("countryId", countryId)
                .getResultList();
    }
}