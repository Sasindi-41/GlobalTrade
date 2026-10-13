package lk.sasindi.globaltrade.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;


@Entity
@Table(name = "orders")
public class Order implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(
            name = "id",
            nullable = false
    )
    private Integer id;

    @Column(
            name = "order_number",
            nullable = false,
            unique = true,
            length = 45
    )
    private String orderNumber;

    @ManyToOne(
            fetch = FetchType.LAZY,
            optional = false
    )
    @JoinColumn(
            name = "users_id",
            nullable = false
    )
    private User user;

    @Column(
            name = "product_description",
            nullable = false,
            length = 500
    )
    private String productDescription;

    @Column(
            name = "quantity",
            nullable = false
    )
    private Integer quantity;

    @ManyToOne(
            fetch = FetchType.LAZY,
            optional = false
    )
    @JoinColumn(
            name = "origin_address",
            nullable = false
    )
    private Address originAddress;

    @ManyToOne(
            fetch = FetchType.LAZY,
            optional = false
    )
    @JoinColumn(
            name = "destination_address",
            nullable = false
    )
    private Address destinationAddress;

    @Column(
            name = "status",
            nullable = false,
            length = 30
    )
    private String status = "PENDING";

    @ManyToOne(
            fetch = FetchType.LAZY
    )
    @JoinColumn(
            name = "shipments_id",
            nullable = true
    )
    private Shipment shipment;

    @Column(
            name = "notes",
            length = 500
    )
    private String notes;

    @Column(
            name = "created_at",
            nullable = false
    )
    private LocalDateTime createdAt;

    @Column(
            name = "updated_at",
            nullable = false
    )
    private LocalDateTime updatedAt;

    public Order() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }


    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(
            String orderNumber
    ) {
        this.orderNumber = orderNumber;
    }


    public User getUser() {
        return user;
    }

    public void setUser(
            User user
    ) {
        this.user = user;
    }


    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(
            String productDescription
    ) {
        this.productDescription =
                productDescription;
    }


    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(
            Integer quantity
    ) {
        this.quantity = quantity;
    }


    public Address getOriginAddress() {
        return originAddress;
    }

    public void setOriginAddress(
            Address originAddress
    ) {
        this.originAddress =
                originAddress;
    }


    public Address getDestinationAddress() {
        return destinationAddress;
    }

    public void setDestinationAddress(
            Address destinationAddress
    ) {
        this.destinationAddress =
                destinationAddress;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(
            String status
    ) {
        this.status = status;
    }


    public Shipment getShipment() {
        return shipment;
    }

    public void setShipment(
            Shipment shipment
    ) {
        this.shipment = shipment;
    }


    public String getNotes() {
        return notes;
    }

    public void setNotes(
            String notes
    ) {
        this.notes = notes;
    }


    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(
            LocalDateTime createdAt
    ) {
        this.createdAt =
                createdAt;
    }


    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(
            LocalDateTime updatedAt
    ) {
        this.updatedAt =
                updatedAt;
    }
}