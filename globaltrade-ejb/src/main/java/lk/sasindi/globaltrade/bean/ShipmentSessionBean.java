package lk.sasindi.globaltrade.bean;

import jakarta.ejb.Stateless;
import jakarta.inject.Inject;

import jakarta.interceptor.Interceptors;
import lk.sasindi.globaltrade.dao.InventoryDAO;
import lk.sasindi.globaltrade.dao.ShipmentDAO;
import lk.sasindi.globaltrade.dao.ShipmentStatusDAO;
import lk.sasindi.globaltrade.dao.VendorDAO;
import lk.sasindi.globaltrade.dao.AddressDAO;
import lk.sasindi.globaltrade.dao.UserDAO;

import lk.sasindi.globaltrade.entity.Address;
import lk.sasindi.globaltrade.entity.Inventory;
import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.entity.ShipmentItem;
import lk.sasindi.globaltrade.entity.ShipmentStatus;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.entity.Vendor;
import lk.sasindi.globaltrade.interceptor.ShipmentAuditInterceptor;
import lk.sasindi.globaltrade.interceptor.TransactionMonitorInterceptor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import lk.sasindi.globaltrade.interceptor.TransactionMonitorInterceptor;
@Stateless
@Interceptors({ ShipmentAuditInterceptor.class, TransactionMonitorInterceptor.class })
public class ShipmentSessionBean {

    @Inject
    private ShipmentDAO shipmentDAO;

    @Inject
    private VendorDAO vendorDAO;

    @Inject
    private ShipmentStatusDAO shipmentStatusDAO;

    @Inject
    private InventoryDAO inventoryDAO;

    @Inject
    private AddressDAO addressDAO;

    @Inject
    private UserDAO userDAO;


    public Shipment createShipment(
            Integer vendorId,
            Integer shipmentStatusId,
            Integer inventoryId,
            Integer originAddressId,
            Integer destinationAddressId,
            LocalDateTime expectedDelivery,
            Integer quantity,
            BigDecimal unitValue,
            Integer userId
    ) {

        if (vendorId == null) {
            throw new IllegalArgumentException(
                    "Vendor is required."
            );
        }

        if (shipmentStatusId == null) {
            throw new IllegalArgumentException(
                    "Shipment status is required."
            );
        }

        if (inventoryId == null) {
            throw new IllegalArgumentException(
                    "Inventory item is required."
            );
        }

        if (originAddressId == null) {
            throw new IllegalArgumentException(
                    "Origin address is required."
            );
        }

        if (destinationAddressId == null) {
            throw new IllegalArgumentException(
                    "Destination address is required."
            );
        }

        if (expectedDelivery == null) {
            throw new IllegalArgumentException(
                    "Expected delivery date is required."
            );
        }

        if (quantity == null ||
                quantity <= 0) {

            throw new IllegalArgumentException(
                    "Quantity must be greater than zero."
            );
        }

        if (unitValue == null ||
                unitValue.compareTo(
                        BigDecimal.ZERO
                ) < 0) {

            throw new IllegalArgumentException(
                    "Unit value cannot be negative."
            );
        }


        Vendor vendor =
                vendorDAO.findById(vendorId);

        if (vendor == null) {

            throw new IllegalArgumentException(
                    "Selected vendor was not found."
            );
        }

        ShipmentStatus shipmentStatus =
                shipmentStatusDAO.findById(
                        shipmentStatusId
                );

        if (shipmentStatus == null) {

            throw new IllegalArgumentException(
                    "Selected shipment status was not found."
            );
        }

        Inventory inventory =
                inventoryDAO.findById(
                        inventoryId
                );

        if (inventory == null) {

            throw new IllegalArgumentException(
                    "Selected inventory item was not found."
            );
        }


        Address originAddress =
                addressDAO.findById(
                        originAddressId
                );

        if (originAddress == null) {

            throw new IllegalArgumentException(
                    "Selected origin address was not found."
            );
        }


        Address destinationAddress =
                addressDAO.findById(
                        destinationAddressId
                );

        if (destinationAddress == null) {

            throw new IllegalArgumentException(
                    "Selected destination address was not found."
            );
        }


        if (inventory.getQuantity() == null ||
                inventory.getQuantity() < quantity) {

            throw new IllegalArgumentException(
                    "Insufficient inventory. Available quantity: "
                            + inventory.getQuantity()
            );
        }

        String trackingNumber =
                generateTrackingNumber();

        Shipment shipment =
                new Shipment();

        shipment.setTrackingNumber(
                trackingNumber
        );

        shipment.setOriginAddress(
                originAddress
        );

        shipment.setDestinationAddress(
                destinationAddress
        );

        shipment.setExpectedDelivery(
                expectedDelivery
        );


        shipment.setActualDelivery(
                null
        );

        LocalDateTime now =
                LocalDateTime.now();

        shipment.setCreatedAt(
                now
        );

        shipment.setUpdatedAt(
                now
        );

        shipment.setVendor(
                vendor
        );

        shipment.setShipmentStatus(
                shipmentStatus
        );


        if (userId != null) {

            User createdByUser =
                    userDAO.findById(userId);

            shipment.setCreatedByUser(
                    createdByUser
            );
        }


        ShipmentItem shipmentItem =
                new ShipmentItem();

        shipmentItem.setQuantity(
                quantity
        );

        shipmentItem.setUnitValue(
                unitValue
        );

        shipmentItem.setInventory(
                inventory
        );


        shipment.addShipmentItem(
                shipmentItem
        );


        shipmentDAO.save(
                shipment
        );


        inventory.setQuantity(
                inventory.getQuantity() - quantity
        );

        inventory.setLastUpdated(
                LocalDateTime.now()
        );

        inventoryDAO.update(
                inventory
        );


        return shipment;
    }


    public Shipment updateShipment(
            Integer id,
            Integer vendorId,
            Integer shipmentStatusId,
            Integer originAddressId,
            Integer destinationAddressId,
            LocalDateTime expectedDelivery,
            Integer inventoryId,
            Integer quantity,
            BigDecimal unitValue,
            Integer userId
    ) {

        if (id == null) {

            throw new IllegalArgumentException(
                    "Shipment ID is required."
            );
        }


        Shipment shipment =
                shipmentDAO.findById(id);

        if (shipment == null) {

            throw new IllegalArgumentException(
                    "Shipment was not found."
            );
        }


        if (vendorId == null) {

            throw new IllegalArgumentException(
                    "Vendor is required."
            );
        }

        if (shipmentStatusId == null) {

            throw new IllegalArgumentException(
                    "Shipment status is required."
            );
        }

        if (inventoryId == null) {

            throw new IllegalArgumentException(
                    "Inventory item is required."
            );
        }

        if (originAddressId == null) {

            throw new IllegalArgumentException(
                    "Origin address is required."
            );
        }

        if (destinationAddressId == null) {

            throw new IllegalArgumentException(
                    "Destination address is required."
            );
        }

        if (expectedDelivery == null) {

            throw new IllegalArgumentException(
                    "Expected delivery date is required."
            );
        }

        if (quantity == null ||
                quantity <= 0) {

            throw new IllegalArgumentException(
                    "Quantity must be greater than zero."
            );
        }

        if (unitValue == null ||
                unitValue.compareTo(
                        BigDecimal.ZERO
                ) < 0) {

            throw new IllegalArgumentException(
                    "Unit value cannot be negative."
            );
        }


        Vendor vendor =
                vendorDAO.findById(
                        vendorId
                );

        if (vendor == null) {

            throw new IllegalArgumentException(
                    "Selected vendor was not found."
            );
        }


        ShipmentStatus shipmentStatus =
                shipmentStatusDAO.findById(
                        shipmentStatusId
                );

        if (shipmentStatus == null) {

            throw new IllegalArgumentException(
                    "Selected shipment status was not found."
            );
        }


        Inventory newInventory =
                inventoryDAO.findById(
                        inventoryId
                );

        if (newInventory == null) {

            throw new IllegalArgumentException(
                    "Selected inventory item was not found."
            );
        }


        Address originAddress =
                addressDAO.findById(
                        originAddressId
                );

        if (originAddress == null) {

            throw new IllegalArgumentException(
                    "Selected origin address was not found."
            );
        }


        Address destinationAddress =
                addressDAO.findById(
                        destinationAddressId
                );

        if (destinationAddress == null) {

            throw new IllegalArgumentException(
                    "Selected destination address was not found."
            );
        }


        if (shipment.getShipmentItems() == null ||
                shipment.getShipmentItems().isEmpty()) {

            throw new IllegalArgumentException(
                    "Shipment item could not be found."
            );
        }

        ShipmentItem shipmentItem =
                shipment.getShipmentItems().get(0);


        Inventory oldInventory =
                shipmentItem.getInventory();

        int oldQuantity =
                shipmentItem.getQuantity();


        if (oldInventory != null) {

            oldInventory.setQuantity(
                    oldInventory.getQuantity()
                            + oldQuantity
            );

            oldInventory.setLastUpdated(
                    LocalDateTime.now()
            );

            inventoryDAO.update(
                    oldInventory
            );
        }


        if (newInventory.getQuantity() == null ||
                newInventory.getQuantity() < quantity) {

            throw new IllegalArgumentException(
                    "Insufficient inventory. Available quantity: "
                            + newInventory.getQuantity()
            );
        }


        shipment.setVendor(
                vendor
        );

        shipment.setShipmentStatus(
                shipmentStatus
        );

        shipment.setOriginAddress(
                originAddress
        );

        shipment.setDestinationAddress(
                destinationAddress
        );

        shipment.setExpectedDelivery(
                expectedDelivery
        );

        shipment.setUpdatedAt(
                LocalDateTime.now()
        );


        if ("Delivered".equalsIgnoreCase(
                shipmentStatus.getName()
        )) {

            if (shipment.getActualDelivery() == null) {

                shipment.setActualDelivery(
                        LocalDateTime.now()
                );
            }

        } else {

            shipment.setActualDelivery(
                    null
            );
        }


        shipmentItem.setInventory(
                newInventory
        );

        shipmentItem.setQuantity(
                quantity
        );

        shipmentItem.setUnitValue(
                unitValue
        );


        newInventory.setQuantity(
                newInventory.getQuantity()
                        - quantity
        );

        newInventory.setLastUpdated(
                LocalDateTime.now()
        );

        inventoryDAO.update(
                newInventory
        );


        return shipmentDAO.update(
                shipment
        );
    }


    private String generateTrackingNumber() {

        long nextNumber =
                shipmentDAO.getNextTrackingSequence();

        int year =
                LocalDateTime.now().getYear();

        return String.format(
                "GT-%d-%05d",
                year,
                nextNumber
        );
    }


    public void deleteShipment(
            Integer id,
            Integer userId
    ){

        if (id == null) {

            throw new IllegalArgumentException(
                    "Shipment ID is required."
            );
        }


        Shipment shipment =
                shipmentDAO.findById(id);


        if (shipment == null) {

            throw new IllegalArgumentException(
                    "Shipment was not found."
            );
        }


        if (shipment.getShipmentItems() != null &&
                !shipment.getShipmentItems().isEmpty()) {


            for (ShipmentItem shipmentItem
                    : shipment.getShipmentItems()) {


                if (shipmentItem == null) {
                    continue;
                }


                Inventory inventory =
                        shipmentItem.getInventory();


                Integer quantity =
                        shipmentItem.getQuantity();


                if (inventory != null &&
                        quantity != null &&
                        quantity > 0) {


                    Integer currentQuantity =
                            inventory.getQuantity();


                    if (currentQuantity == null) {
                        currentQuantity = 0;
                    }


                    inventory.setQuantity(
                            currentQuantity + quantity
                    );


                    inventory.setLastUpdated(
                            LocalDateTime.now()
                    );


                    inventoryDAO.update(
                            inventory
                    );
                }
            }
        }


        shipmentDAO.delete(id);
    }


    public Shipment getShipment(
            Integer id
    ) {

        return shipmentDAO.findById(
                id
        );
    }


    public List<Shipment> getAllShipments() {

        return shipmentDAO.findAll();
    }

    public Shipment getShipmentByTrackingNumber(
            String trackingNumber
    ) {

        return shipmentDAO.findByTrackingNumber(
                trackingNumber
        );
    }

    public List<Shipment> getMyShipments(
            Integer userId
    ) {

        return shipmentDAO.findByCreatedByUser(
                userId
        );
    }

    public Shipment trackMyShipment(
            String trackingNumber,
            Integer userId
    ) {

        Shipment shipment =
                shipmentDAO.findByTrackingNumber(
                        trackingNumber
                );

        if (shipment == null) {
            return null;
        }

        if (shipment.getCreatedByUser() == null ||
                userId == null ||
                !shipment.getCreatedByUser().getId().equals(userId)) {

            return null;
        }

        return shipment;
    }

    public List<Vendor> getAllVendors() {

        return vendorDAO.findAll();
    }


    public Vendor getVendor(
            Integer id
    ) {

        return vendorDAO.findById(id);
    }

    public List<ShipmentStatus> getAllShipmentStatuses() {

        return shipmentStatusDAO.findAll();
    }


    public ShipmentStatus getShipmentStatus(
            Integer id
    ) {

        return shipmentStatusDAO.findById(id);
    }

    public List<Inventory> getAllInventory() {

        return inventoryDAO.findAll();
    }


    public Inventory getInventory(
            Integer id
    ) {

        return inventoryDAO.findById(id);
    }


    public List<Address> getAllAddresses() {

        return addressDAO.findAll();
    }


    public Address getAddress(
            Integer id
    ) {

        return addressDAO.findById(id);
    }

    public int monitorShipments() {

        System.out.println(
                "[SHIPMENT-MONITOR] Checking shipments..."
        );

        List<Shipment> shipments =
                shipmentDAO.findAll();


        if (shipments == null ||
                shipments.isEmpty()) {

            System.out.println(
                    "[SHIPMENT-MONITOR] No shipments found."
            );

            return 0;
        }

        ShipmentStatus delayedStatus = null;


        for (ShipmentStatus status :
                shipmentStatusDAO.findAll()) {

            if (status != null &&
                    status.getName() != null &&
                    "Delayed".equalsIgnoreCase(
                            status.getName().trim()
                    )) {

                delayedStatus = status;

                break;
            }
        }


        if (delayedStatus == null) {

            throw new IllegalStateException(
                    "Shipment status 'Delayed' was not found."
            );
        }


        LocalDateTime now =
                LocalDateTime.now();


        int processedRecords = 0;


        for (Shipment shipment : shipments) {

            if (shipment == null) {
                continue;
            }


            LocalDateTime expectedDelivery =
                    shipment.getExpectedDelivery();


            if (expectedDelivery == null) {
                continue;
            }


            ShipmentStatus currentStatus =
                    shipment.getShipmentStatus();


            String currentStatusName =
                    currentStatus != null &&
                            currentStatus.getName() != null
                            ? currentStatus.getName().trim()
                            : "";


            if ("Delivered".equalsIgnoreCase(
                    currentStatusName
            )) {

                continue;
            }


            if ("Cancelled".equalsIgnoreCase(
                    currentStatusName
            )) {

                continue;
            }


            if (expectedDelivery.isBefore(now)) {

                if (!"Delayed".equalsIgnoreCase(
                        currentStatusName
                )) {


                    shipment.setShipmentStatus(
                            delayedStatus
                    );


                    shipment.setUpdatedAt(
                            now
                    );


                    shipmentDAO.update(
                            shipment
                    );


                    processedRecords++;


                    System.out.println(
                            "[SHIPMENT-MONITOR] "
                                    + shipment.getTrackingNumber()
                                    + " → DELAYED"
                    );
                }
            }
        }


        System.out.println(
                "[SHIPMENT-MONITOR] Completed. "
                        + "Updated: "
                        + processedRecords
        );


        return processedRecords;
    }
}