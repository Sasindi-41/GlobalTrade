package lk.sasindi.globaltrade.bean;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Address;
import lk.sasindi.globaltrade.entity.City;
import lk.sasindi.globaltrade.entity.Country;

import java.time.LocalDateTime;
import java.util.List;

@Stateless
public class AddressSessionBean {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    public List<Address> getAllAddresses() {

        return em.createQuery(
                "SELECT a FROM Address a " +
                        "JOIN FETCH a.country " +
                        "JOIN FETCH a.city " +
                        "ORDER BY a.id DESC",
                Address.class
        ).getResultList();
    }

    public Address saveAddress(Address address) {

        em.persist(address);

        em.flush();

        return address;
    }

    public Address createAddress(
            String line1,
            String line2,
            String postalCode,
            String contactName,
            String contactPhone,
            Integer countryId,
            Integer cityId
    ) {

        Country country =
                em.find(
                        Country.class,
                        countryId
                );

        if (country == null) {

            throw new IllegalArgumentException(
                    "Selected country was not found."
            );
        }


        City city =
                em.find(
                        City.class,
                        cityId
                );

        if (city == null) {
            throw new IllegalArgumentException(
                    "Selected city was not found."
            );
        }

        if (city.getCountry() == null ||
                !city.getCountry().getId().equals(country.getId())) {

            throw new IllegalArgumentException(
                    "Selected city does not belong to the selected country."
            );
        }

        Address address =
                new Address();

        address.setLine1(
                line1 != null
                        ? line1.trim()
                        : null
        );

        address.setLine2(
                line2 != null &&
                        !line2.trim().isEmpty()
                        ? line2.trim()
                        : null
        );

        address.setPostalCode(
                postalCode != null
                        ? postalCode.trim()
                        : null
        );

        address.setContactName(
                contactName != null
                        ? contactName.trim()
                        : null
        );

        address.setContactPhone(
                contactPhone != null
                        ? contactPhone.trim()
                        : null
        );

        address.setCreatedAt(
                LocalDateTime.now()
        );

        address.setCountry(
                country
        );

        address.setCity(
                city
        );

        em.persist(address);

        em.flush();

        return address;
    }

    public Country getCountryById(
            int id
    ) {

        return em.find(
                Country.class,
                id
        );
    }

    public City getCityById(
            int id
    ) {

        return em.find(
                City.class,
                id
        );
    }

    public List<Country> getAllCountries() {

        return em.createQuery(
                "SELECT c FROM Country c " +
                        "ORDER BY c.name",
                Country.class
        ).getResultList();
    }

    public List<City> getAllCities() {

        return em.createQuery(
                "SELECT c FROM City c " +
                        "ORDER BY c.name",
                City.class
        ).getResultList();
    }

    public List<City> getCitiesByCountry(Integer countryId) {

        if (countryId == null) {
            return java.util.Collections.emptyList();
        }

        return em.createQuery(
                        "SELECT c FROM City c " +
                                "WHERE c.country.id = :countryId " +
                                "ORDER BY c.name",
                        City.class
                )
                .setParameter("countryId", countryId)
                .getResultList();
    }
}