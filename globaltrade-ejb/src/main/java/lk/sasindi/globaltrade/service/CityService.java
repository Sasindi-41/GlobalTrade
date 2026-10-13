package lk.sasindi.globaltrade.service;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;

import lk.sasindi.globaltrade.dao.CityDAO;
import lk.sasindi.globaltrade.entity.City;

import java.util.List;

@Stateless
public class CityService {

    @EJB
    private CityDAO cityDAO;


    public List<City> findAll() {

        return cityDAO.findAll();
    }


    public City findById(Integer id) {

        return cityDAO.findById(id);
    }
    public List<City> findByCountryId(Integer countryId) {

        return cityDAO.findByCountryId(countryId);
    }
}