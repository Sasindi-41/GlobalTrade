package lk.sasindi.globaltrade.service;

import jakarta.ejb.Stateless;
import jakarta.inject.Inject;

import lk.sasindi.globaltrade.dao.InventoryDAO;
import lk.sasindi.globaltrade.entity.Inventory;
import lk.sasindi.globaltrade.entity.Vendor;
import lk.sasindi.globaltrade.entity.Warehouse;

import java.time.LocalDateTime;
import java.util.List;
import jakarta.interceptor.Interceptors;
import lk.sasindi.globaltrade.interceptor.InventoryAuditInterceptor;
@Stateless
@Interceptors(InventoryAuditInterceptor.class)
public class InventoryService {

    @Inject
    private InventoryDAO inventoryDAO;

    public Inventory createInventory(
            String productName,
            Integer quantity,
            Integer reorderLevel,
            Vendor vendor,
            Warehouse warehouse,
            Integer userId
    ) {

        if (productName == null ||
                productName.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Product name is required."
            );
        }

        if (quantity == null || quantity < 0) {

            throw new IllegalArgumentException(
                    "Quantity cannot be negative."
            );
        }

        if (reorderLevel == null || reorderLevel < 0) {

            throw new IllegalArgumentException(
                    "Reorder level cannot be negative."
            );
        }

        if (vendor == null) {

            throw new IllegalArgumentException(
                    "Vendor is required."
            );
        }

        if (warehouse == null) {

            throw new IllegalArgumentException(
                    "Warehouse is required."
            );
        }

        String productCode =
                generateNextProductCode();

        Inventory inventory =
                new Inventory();

        inventory.setProductCode(productCode);

        inventory.setProductName(
                productName.trim()
        );

        inventory.setQuantity(quantity);

        inventory.setReorderLevel(reorderLevel);

        inventory.setVendor(vendor);

        inventory.setWarehouse(warehouse);

        inventory.setLastUpdated(
                LocalDateTime.now()
        );


        return inventoryDAO.save(inventory);
    }

    public Inventory updateInventory(
            Integer id,
            String productName,
            Integer quantity,
            Integer reorderLevel,
            Vendor vendor,
            Warehouse warehouse,
            Integer userId
    ) {

        if (id == null) {

            throw new IllegalArgumentException(
                    "Inventory ID is required."
            );
        }


        Inventory inventory =
                inventoryDAO.findById(id);

        if (inventory == null) {

            throw new IllegalArgumentException(
                    "Inventory record not found."
            );
        }


        if (productName == null ||
                productName.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Product name is required."
            );
        }

        if (quantity == null || quantity < 0) {

            throw new IllegalArgumentException(
                    "Quantity cannot be negative."
            );
        }

        if (reorderLevel == null ||
                reorderLevel < 0) {

            throw new IllegalArgumentException(
                    "Reorder level cannot be negative."
            );
        }

        if (vendor == null) {

            throw new IllegalArgumentException(
                    "Vendor is required."
            );
        }

        if (warehouse == null) {

            throw new IllegalArgumentException(
                    "Warehouse is required."
            );
        }

        inventory.setProductName(
                productName.trim()
        );

        inventory.setQuantity(quantity);

        inventory.setReorderLevel(reorderLevel);

        inventory.setVendor(vendor);

        inventory.setWarehouse(warehouse);

        inventory.setLastUpdated(
                LocalDateTime.now()
        );


        return inventoryDAO.update(inventory);
    }

    public Inventory getInventory(
            Integer id
    ) {

        return inventoryDAO.findById(id);
    }

    public List<Inventory> getAllInventory() {

        return inventoryDAO.findAll();
    }

    public void deleteInventory(
            Integer id,
            Integer userId
    ) {

        if (id == null) {
            throw new IllegalArgumentException(
                    "Inventory ID is required."
            );
        }

        Inventory inventory =
                inventoryDAO.findById(id);

        if (inventory == null) {
            throw new IllegalArgumentException(
                    "Inventory record not found."
            );
        }

        inventoryDAO.delete(id);
    }

    public Inventory addStock(
            Integer id,
            Integer amount,
            Integer userId
    ) {

        if (id == null) {
            throw new IllegalArgumentException(
                    "Inventory ID is required."
            );
        }

        if (amount == null || amount <= 0) {
            throw new IllegalArgumentException(
                    "Stock amount must be greater than zero."
            );
        }


        Inventory inventory =
                inventoryDAO.findById(id);

        if (inventory == null) {
            throw new IllegalArgumentException(
                    "Inventory record not found."
            );
        }


        int newQuantity =
                inventory.getQuantity() + amount;

        inventory.setQuantity(newQuantity);

        inventory.setLastUpdated(
                LocalDateTime.now()
        );


        return inventoryDAO.update(inventory);
    }

    public Inventory removeStock(
            Integer id,
            Integer amount,
            Integer userId
    ) {

        if (id == null) {
            throw new IllegalArgumentException(
                    "Inventory ID is required."
            );
        }

        if (amount == null || amount <= 0) {
            throw new IllegalArgumentException(
                    "Stock amount must be greater than zero."
            );
        }


        Inventory inventory =
                inventoryDAO.findById(id);

        if (inventory == null) {
            throw new IllegalArgumentException(
                    "Inventory record not found."
            );
        }

        if (inventory.getQuantity() < amount) {

            throw new IllegalArgumentException(
                    "Insufficient stock available."
            );
        }


        int newQuantity =
                inventory.getQuantity() - amount;

        inventory.setQuantity(newQuantity);

        inventory.setLastUpdated(
                LocalDateTime.now()
        );


        return inventoryDAO.update(inventory);
    }

    public Inventory updateQuantity(
            Integer id,
            Integer quantityChange,
            Integer userId
    ) {

        if (id == null) {

            throw new IllegalArgumentException(
                    "Inventory ID is required."
            );
        }

        if (quantityChange == null ||
                quantityChange == 0) {

            throw new IllegalArgumentException(
                    "Quantity change cannot be zero."
            );
        }

        Inventory inventory =
                inventoryDAO.findById(id);

        if (inventory == null) {

            throw new IllegalArgumentException(
                    "Inventory record not found."
            );
        }

        int currentQuantity =
                inventory.getQuantity();

        int newQuantity =
                currentQuantity + quantityChange;

        if (newQuantity < 0) {

            throw new IllegalArgumentException(
                    "Inventory quantity cannot be negative."
            );
        }

        inventory.setQuantity(newQuantity);

        inventory.setLastUpdated(
                LocalDateTime.now()
        );

        return inventoryDAO.update(inventory);
    }

    public boolean isLowStock(
            Inventory inventory
    ) {

        if (inventory == null) {
            return false;
        }

        return inventory.getQuantity()
                <= inventory.getReorderLevel();
    }

    public List<Inventory> getLowStockInventory() {

        return inventoryDAO.findLowStock();
    }

    public List<Inventory> getOutOfStockInventory() {

        return inventoryDAO.findOutOfStock();
    }

    public List<Inventory> searchInventory(
            String keyword
    ) {

        if (keyword == null ||
                keyword.trim().isEmpty()) {

            return inventoryDAO.findAll();
        }

        return inventoryDAO.search(
                keyword.trim()
        );
    }

    public long getTotalInventoryCount() {

        return inventoryDAO.countAll();
    }


    public long getLowStockCount() {

        return inventoryDAO.countLowStock();
    }


    public long getOutOfStockCount() {

        return inventoryDAO.countOutOfStock();
    }

    private String generateNextProductCode() {

        List<String> codes =
                inventoryDAO.findAllProductCodes();

        int highestNumber = 0;

        for (String code : codes) {

            if (code == null) {
                continue;
            }

            String upper =
                    code.trim().toUpperCase();

            if (!upper.matches("PRD-\\d+")) {
                continue;
            }

            try {

                int number =
                        Integer.parseInt(
                                upper.substring(4)
                        );

                if (number > highestNumber) {
                    highestNumber = number;
                }

            } catch (NumberFormatException ignored) {

            }
        }

        return String.format(
                "PRD-%03d",
                highestNumber + 1
        );
    }
}