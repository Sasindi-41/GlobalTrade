package lk.sasindi.globaltrade.entity;

import jakarta.persistence.*;

import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "stock_movements")
public class StockMovement implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Column(
            name = "qty",
            nullable = false
    )
    private int qty;

    @Column(
            name = "previous_qty",
            nullable = false
    )
    private int previousQty;

    @Column(
            name = "new_qty",
            nullable = false
    )
    private int newQty;

    @Column(
            name = "reason",
            length = 255
    )
    private String reason;

    @Column(
            name = "created_at",
            nullable = false
    )
    private LocalDateTime createdAt;

    @ManyToOne(
            fetch = FetchType.LAZY,
            optional = false
    )
    @JoinColumn(
            name = "inventory_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_stock_movements_inventory1"
            )
    )
    private Inventory inventory;

    @ManyToOne(
            fetch = FetchType.LAZY,
            optional = false
    )
    @JoinColumn(
            name = "users_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_stock_movements_users1"
            )
    )
    private User user;

    @ManyToOne(
            fetch = FetchType.LAZY,
            optional = false
    )
    @JoinColumn(
            name = "movement_type_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_stock_movements_movement_type1"
            )
    )
    private MovementType movementType;

    @ManyToOne(
            fetch = FetchType.LAZY,
            optional = false
    )
    @JoinColumn(
            name = "reference_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_stock_movements_reference1"
            )
    )
    private Reference reference;

    public StockMovement() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    public int getPreviousQty() {
        return previousQty;
    }

    public void setPreviousQty(int previousQty) {
        this.previousQty = previousQty;
    }

    public int getNewQty() {
        return newQty;
    }

    public void setNewQty(int newQty) {
        this.newQty = newQty;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Inventory getInventory() {
        return inventory;
    }

    public void setInventory(Inventory inventory) {
        this.inventory = inventory;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public MovementType getMovementType() {
        return movementType;
    }

    public void setMovementType(MovementType movementType) {
        this.movementType = movementType;
    }

    public Reference getReference() {
        return reference;
    }

    public void setReference(Reference reference) {
        this.reference = reference;
    }
}