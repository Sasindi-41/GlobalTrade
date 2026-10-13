package lk.sasindi.globaltrade.service;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;

import lk.sasindi.globaltrade.dao.JobExecutionLogDAO;
import lk.sasindi.globaltrade.dao.JobExecutionStatusDAO;
import lk.sasindi.globaltrade.entity.JobExecutionLog;
import lk.sasindi.globaltrade.entity.JobExecutionStatus;

import java.time.LocalDateTime;

@Stateless
public class TimerJobService {

    @EJB
    private JobExecutionLogDAO jobExecutionLogDAO;

    @EJB
    private JobExecutionStatusDAO jobExecutionStatusDAO;

    public JobExecutionLog startExecution(String jobName) {

        JobExecutionStatus runningStatus =
                getOrCreateStatus(
                        "RUNNING",
                        "Job is currently executing"
                );

        JobExecutionLog log =
                new JobExecutionLog(
                        jobName,
                        LocalDateTime.now(),
                        runningStatus
                );

        log.setRecords(0);

        return jobExecutionLogDAO.save(log);
    }

    public void completeSuccessfully(
            JobExecutionLog log,
            int records) {

        LocalDateTime completedAt =
                LocalDateTime.now();

        log.setCompletedAt(completedAt);

        log.setRecords(records);

        if (log.getStartedAt() != null) {

            long executionTime =
                    java.time.Duration
                            .between(
                                    log.getStartedAt(),
                                    completedAt
                            )
                            .toMillis();

            log.setExecutionTimeMs(executionTime);
        }

        JobExecutionStatus successStatus =
                getOrCreateStatus(
                        "SUCCESS",
                        "Job completed successfully"
                );

        log.setJobExecutionStatus(successStatus);

        jobExecutionLogDAO.update(log);
    }

    public void completeWithFailure(
            JobExecutionLog log,
            Exception exception) {

        LocalDateTime completedAt =
                LocalDateTime.now();

        log.setCompletedAt(completedAt);

        if (log.getStartedAt() != null) {

            long executionTime =
                    java.time.Duration
                            .between(
                                    log.getStartedAt(),
                                    completedAt
                            )
                            .toMillis();

            log.setExecutionTimeMs(executionTime);
        }

        String message =
                exception.getMessage();

        if (message == null ||
                message.isBlank()) {

            message =
                    exception.getClass()
                            .getSimpleName();
        }

        log.setError(message);

        JobExecutionStatus failedStatus =
                getOrCreateStatus(
                        "FAILED",
                        "Job execution failed"
                );

        log.setJobExecutionStatus(failedStatus);

        jobExecutionLogDAO.update(log);
    }

    private JobExecutionStatus getOrCreateStatus(
            String name,
            String description) {

        JobExecutionStatus status =
                jobExecutionStatusDAO
                        .findByName(name);

        if (status == null) {

            status =
                    new JobExecutionStatus(
                            name,
                            description
                    );

            status =
                    jobExecutionStatusDAO
                            .save(status);
        }

        return status;
    }
}