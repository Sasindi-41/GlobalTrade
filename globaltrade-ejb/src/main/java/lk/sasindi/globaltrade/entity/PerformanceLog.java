package lk.sasindi.globaltrade.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;


@Entity
@Table(name = "performance_logs")
public class PerformanceLog implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "class", nullable = false, length = 150)
    private String className;

    @Column(name = "method", nullable = false, length = 150)
    private String method;

    @Column(name = "execution_time_ms", nullable = false)
    private Long executionTimeMs;

    @Column(name = "error", length = 500)
    private String error;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "users_id",
            nullable = true
    )
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "performance_status_id",
            nullable = false
    )
    private PerformanceStatus performanceStatus;

    public PerformanceLog() {
    }


    public PerformanceLog(
            String className,
            String method,
            Long executionTimeMs,
            PerformanceStatus performanceStatus
    ) {

        this.className = className;
        this.method = method;
        this.executionTimeMs = executionTimeMs;
        this.performanceStatus = performanceStatus;
        this.createdAt = LocalDateTime.now();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }


    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }


    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }


    public Long getExecutionTimeMs() {
        return executionTimeMs;
    }

    public void setExecutionTimeMs(Long executionTimeMs) {
        this.executionTimeMs = executionTimeMs;
    }


    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }


    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }


    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }


    public PerformanceStatus getPerformanceStatus() {
        return performanceStatus;
    }

    public void setPerformanceStatus(
            PerformanceStatus performanceStatus
    ) {

        this.performanceStatus = performanceStatus;
    }
}