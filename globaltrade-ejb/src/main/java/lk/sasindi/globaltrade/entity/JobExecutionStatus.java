package lk.sasindi.globaltrade.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(
        name = "job_execution_status",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "job_execution_status_name_UNIQUE",
                        columnNames = "name"
                )
        }
)
public class JobExecutionStatus implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(
            name = "name",
            nullable = false,
            length = 30
    )
    private String name;

    @Column(
            name = "description",
            length = 255
    )
    private String description;

    @OneToMany(
            mappedBy = "jobExecutionStatus",
            fetch = FetchType.LAZY
    )
    private List<JobExecutionLog> jobExecutionLogs =
            new ArrayList<>();

    public JobExecutionStatus() {
    }

    public JobExecutionStatus(
            String name,
            String description
    ) {
        this.name = name;
        this.description = description;
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


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public List<JobExecutionLog> getJobExecutionLogs() {
        return jobExecutionLogs;
    }

    public void setJobExecutionLogs(
            List<JobExecutionLog> jobExecutionLogs
    ) {
        this.jobExecutionLogs = jobExecutionLogs;
    }

    @Override
    public String toString() {
        return "JobExecutionStatus{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}