package lk.sasindi.globaltrade.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(
        name = "job_execution_logs",
        indexes = {
                @Index(
                        name = "idx_job_execution_log_name",
                        columnList = "name"
                ),
                @Index(
                        name = "idx_job_execution_log_started_at",
                        columnList = "started_at"
                ),
                @Index(
                        name = "idx_job_execution_log_status",
                        columnList = "job_execution_status_id"
                )
        }
)
public class JobExecutionLog implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(
            name = "name",
            nullable = false,
            length = 100
    )
    private String name;

    @Column(
            name = "started_at",
            nullable = false
    )
    private LocalDateTime startedAt;

    @Column(
            name = "completed_at"
    )
    private LocalDateTime completedAt;

    @Column(
            name = "execution_time_ms"
    )
    private Long executionTimeMs;

    @Column(
            name = "records"
    )
    private Integer records;

    @Column(
            name = "error",
            length = 500
    )
    private String error;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "job_execution_status_id",
            nullable = false
    )
    private JobExecutionStatus jobExecutionStatus;

    public JobExecutionLog() {
    }


    public JobExecutionLog(
            String name,
            LocalDateTime startedAt,
            JobExecutionStatus jobExecutionStatus
    ) {
        this.name = name;
        this.startedAt = startedAt;
        this.jobExecutionStatus = jobExecutionStatus;
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


    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }


    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }


    public Long getExecutionTimeMs() {
        return executionTimeMs;
    }

    public void setExecutionTimeMs(Long executionTimeMs) {
        this.executionTimeMs = executionTimeMs;
    }


    public Integer getRecords() {
        return records;
    }

    public void setRecords(Integer records) {
        this.records = records;
    }


    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }


    public JobExecutionStatus getJobExecutionStatus() {
        return jobExecutionStatus;
    }

    public void setJobExecutionStatus(
            JobExecutionStatus jobExecutionStatus
    ) {
        this.jobExecutionStatus = jobExecutionStatus;
    }

    @Override
    public String toString() {
        return "JobExecutionLog{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", startedAt=" + startedAt +
                ", completedAt=" + completedAt +
                ", executionTimeMs=" + executionTimeMs +
                ", records=" + records +
                ", error='" + error + '\'' +
                '}';
    }
}