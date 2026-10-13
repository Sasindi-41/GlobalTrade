package lk.sasindi.globaltrade.entity;

import jakarta.persistence.*;

import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "audit_logs")
public class AuditLog implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(
            name = "action",
            nullable = false,
            length = 100
    )
    private String action;

    @Column(
            name = "old_value",
            columnDefinition = "TEXT"
    )
    private String oldValue;

    @Column(
            name = "new_value",
            columnDefinition = "TEXT"
    )
    private String newValue;

    @Column(
            name = "timestamp",
            nullable = false
    )
    private LocalDateTime timestamp;

    @Column(
            name = "details",
            columnDefinition = "TEXT"
    )
    private String details;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "users_id",
            nullable = false
    )
    private User user;

    @Column(
            name = "entity_id",
            nullable = false
    )
    private Integer entityId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(
            name = "entity_type_id",
            nullable = false
    )
    private EntityType entityType;

    public AuditLog() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }


    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }


    public String getOldValue() {
        return oldValue;
    }

    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }


    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }


    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }


    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }


    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }


    public Integer getEntityId() {
        return entityId;
    }

    public void setEntityId(Integer entityId) {
        this.entityId = entityId;
    }


    public EntityType getEntityType() {
        return entityType;
    }

    public void setEntityType(EntityType entityType) {
        this.entityType = entityType;
    }
}