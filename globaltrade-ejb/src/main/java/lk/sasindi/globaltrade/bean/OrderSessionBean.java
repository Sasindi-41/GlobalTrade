package lk.sasindi.globaltrade.bean;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.inject.Inject;
import jakarta.interceptor.Interceptors;

import lk.sasindi.globaltrade.dao.AddressDAO;
import lk.sasindi.globaltrade.dao.OrderDAO;
import lk.sasindi.globaltrade.dao.UserDAO;

import lk.sasindi.globaltrade.entity.Address;
import lk.sasindi.globaltrade.entity.Order;
import lk.sasindi.globaltrade.entity.User;

import lk.sasindi.globaltrade.exception.OrderException;

import java.time.LocalDateTime;
import java.util.List;


@Stateless
@Interceptors(lk.sasindi.globaltrade.interceptor.OrderAuditInterceptor.class)
public class OrderSessionBean {

    @Inject
    private OrderDAO orderDAO;

    @Inject
    private AddressDAO addressDAO;

    @Inject
    private UserDAO userDAO;


    @TransactionAttribute(
            TransactionAttributeType.REQUIRED
    )
    public Order createOrder(
            Integer userId,
            String productDescription,
            Integer quantity,
            Integer originAddressId,
            Integer destinationAddressId,
            String notes
    ) throws OrderException {

        if (userId == null) {

            throw new OrderException(
                    "User is required."
            );
        }


        User user =
                userDAO.findById(userId);


        if (user == null) {

            throw new OrderException(
                    "User was not found."
            );
        }

        if (productDescription == null ||
                productDescription.trim().isEmpty()) {

            throw new OrderException(
                    "Please describe what you want to ship."
            );
        }


        if (productDescription.trim().length() > 500) {

            throw new OrderException(
                    "Shipment description cannot exceed 500 characters."
            );
        }

        if (quantity == null ||
                quantity <= 0) {

            throw new OrderException(
                    "Quantity must be greater than zero."
            );
        }

        if (originAddressId == null) {

            throw new OrderException(
                    "Origin address is required."
            );
        }


        if (destinationAddressId == null) {

            throw new OrderException(
                    "Destination address is required."
            );
        }


        if (originAddressId.equals(
                destinationAddressId
        )) {

            throw new OrderException(
                    "Origin and destination addresses cannot be the same."
            );
        }


        Address origin =
                addressDAO.findById(
                        originAddressId
                );


        Address destination =
                addressDAO.findById(
                        destinationAddressId
                );


        if (origin == null) {

            throw new OrderException(
                    "Selected origin address was not found."
            );
        }


        if (destination == null) {

            throw new OrderException(
                    "Selected destination address was not found."
            );
        }

        Order order =
                new Order();


        order.setOrderNumber(
                generateOrderNumber()
        );


        order.setUser(
                user
        );


        order.setProductDescription(
                productDescription.trim()
        );


        order.setQuantity(
                quantity
        );


        order.setOriginAddress(
                origin
        );


        order.setDestinationAddress(
                destination
        );

        order.setStatus(
                "PENDING"
        );

        if (notes != null &&
                !notes.trim().isEmpty()) {

            String cleanNotes =
                    notes.trim();


            if (cleanNotes.length() > 500) {

                throw new OrderException(
                        "Notes cannot exceed 500 characters."
                );
            }


            order.setNotes(
                    cleanNotes
            );

        } else {

            order.setNotes(
                    null
            );
        }

        LocalDateTime now =
                LocalDateTime.now();


        order.setCreatedAt(
                now
        );


        order.setUpdatedAt(
                now
        );

        return orderDAO.save(
                order
        );
    }

    @TransactionAttribute(
            TransactionAttributeType.REQUIRED
    )
    public Order cancelOrder(
            Integer orderId,
            Integer userId
    ) throws OrderException {

        if (orderId == null) {

            throw new OrderException(
                    "Shipment request ID is required."
            );
        }


        if (userId == null) {

            throw new OrderException(
                    "User is required."
            );
        }


        Order order =
                orderDAO.findById(
                        orderId
                );


        if (order == null) {

            throw new OrderException(
                    "Shipment request was not found."
            );
        }

        if (order.getUser() == null ||
                order.getUser().getId() == null ||
                !order.getUser()
                        .getId()
                        .equals(userId)) {

            throw new OrderException(
                    "You are not allowed to cancel this shipment request."
            );
        }

        if (!"PENDING".equalsIgnoreCase(
                order.getStatus()
        )) {

            throw new OrderException(
                    "Only pending shipment requests can be cancelled."
            );
        }

        order.setStatus(
                "CANCELLED"
        );


        order.setUpdatedAt(
                LocalDateTime.now()
        );


        return orderDAO.update(
                order
        );
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<Order> getMyOrders(
            Integer userId
    ) {

        return orderDAO.findByUser(
                userId
        );
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<Order> getAllOrders() {

        return orderDAO.findAll();
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<Address> getAllAddresses() {

        return addressDAO.findAll();
    }

    private String generateOrderNumber() {

        long sequence =
                orderDAO.getNextOrderSequence();


        return "ORD-"
                + LocalDateTime.now().getYear()
                + "-"
                + String.format(
                "%05d",
                sequence
        );
    }
}