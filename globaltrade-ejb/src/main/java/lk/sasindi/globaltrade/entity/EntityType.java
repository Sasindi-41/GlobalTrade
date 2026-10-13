package lk.sasindi.globaltrade.entity;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name = "entity_type")
public class EntityType implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(
            name = "name",
            nullable = false,
            length = 45
    )
    private String name;

    public EntityType() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}