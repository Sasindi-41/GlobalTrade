package lk.sasindi.globaltrade.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(
        name = "movement_type",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "movement_type_unique",
                        columnNames = "type"
                )
        }
)
public class MovementType implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Column(
            name = "type",
            nullable = false,
            length = 45
    )
    private String type;

    @OneToMany(
            mappedBy = "movementType",
            fetch = FetchType.LAZY
    )
    private List<StockMovement> stockMovements =
            new ArrayList<>();

    public MovementType() {
    }

    public MovementType(String type) {
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public List<StockMovement> getStockMovements() {
        return stockMovements;
    }

    public void setStockMovements(
            List<StockMovement> stockMovements
    ) {
        this.stockMovements = stockMovements;
    }

    @Override
    public String toString() {
        return type;
    }
}