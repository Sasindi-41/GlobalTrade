package lk.sasindi.globaltrade.service;

import jakarta.ejb.Stateless;
import jakarta.inject.Inject;

import lk.sasindi.globaltrade.dao.WarehouseDAO;
import lk.sasindi.globaltrade.entity.Warehouse;

import java.util.List;

@Stateless
public class WarehouseService {

    @Inject
    private WarehouseDAO warehouseDAO;

    public List<Warehouse> findAll() {

        return warehouseDAO.findAll();
    }

    public Warehouse findById(Integer id) {

        if (id == null) {
            return null;
        }

        return warehouseDAO.findById(id);
    }
}