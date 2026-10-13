package lk.sasindi.globaltrade.service;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;

import lk.sasindi.globaltrade.dao.PerformanceLogDAO;
import lk.sasindi.globaltrade.dao.PerformanceStatusDAO;
import lk.sasindi.globaltrade.entity.PerformanceLog;
import lk.sasindi.globaltrade.entity.PerformanceStatus;


@Stateless
public class PerformanceMonitoringService {

    private static final double SLOW_THRESHOLD_MS = 500.0;

    @EJB
    private PerformanceLogDAO performanceLogDAO;

    @EJB
    private PerformanceStatusDAO performanceStatusDAO;

    @TransactionAttribute(
            TransactionAttributeType.REQUIRES_NEW
    )
    public void record(
            String className,
            String methodName,
            double milliseconds,
            String error
    ) {

        try {

            String statusName;

            if (error != null && !error.trim().isEmpty()) {

                statusName = "ERROR";

            } else if (milliseconds > SLOW_THRESHOLD_MS) {

                statusName = "SLOW";

            } else {

                statusName = "OK";
            }

            PerformanceStatus status =
                    getOrCreateStatus(statusName);

            PerformanceLog log =
                    new PerformanceLog(
                            className,
                            methodName,
                            Math.round(milliseconds),
                            status
                    );

            if (error != null &&
                    !error.trim().isEmpty()) {

                log.setError(
                        error.length() > 500
                                ? error.substring(0, 500)
                                : error
                );
            }

            performanceLogDAO.save(log);


            System.out.println(
                    "[PERFORMANCE-LOG] Saved: "
                            + className
                            + "."
                            + methodName
                            + " | "
                            + Math.round(milliseconds)
                            + " ms"
                            + " | "
                            + statusName
            );

        } catch (Exception e) {


            System.err.println(
                    "[PERFORMANCE-LOG] Unable to persist sample for "
                            + className
                            + "."
                            + methodName
                            + ": "
                            + e.getMessage()
            );
        }
    }

    private PerformanceStatus getOrCreateStatus(
            String name
    ) {

        PerformanceStatus status =
                performanceStatusDAO.findByName(name);


        if (status == null) {

            status =
                    performanceStatusDAO.save(
                            new PerformanceStatus(name)
                    );
        }


        return status;
    }
}