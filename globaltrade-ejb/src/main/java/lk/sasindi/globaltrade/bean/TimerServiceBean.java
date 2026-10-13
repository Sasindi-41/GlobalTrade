package lk.sasindi.globaltrade.bean;

import jakarta.annotation.PostConstruct;
import jakarta.ejb.EJB;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;

import lk.sasindi.globaltrade.entity.JobExecutionLog;
import lk.sasindi.globaltrade.service.TimerJobService;

@Singleton
@Startup
public class TimerServiceBean {

    @EJB
    private TimerJobService timerJobService;


    @EJB
    private ShipmentSessionBean shipmentSessionBean;


    @PostConstruct
    public void initialize() {

        System.out.println(
                "================================================="
        );

        System.out.println(
                "GlobalTrade EJB Timer Service initialized."
        );

        System.out.println(
                "Shipment monitoring timer is active."
        );

        System.out.println(
                "Schedule: Every 5 minutes."
        );

        System.out.println(
                "================================================="
        );
    }


    @Schedule(
            second = "0",
            minute = "*/5",
            hour = "*",
            persistent = false
    )
    public void executeShipmentMonitoringJob() {

        final String jobName =
                "Shipment Monitoring Job";


        long start =
                System.currentTimeMillis();


        JobExecutionLog log = null;


        try {

            log =
                    timerJobService
                            .startExecution(
                                    jobName
                            );


            System.out.println(
                    "================================================="
            );

            System.out.println(
                    "[TIMER] Starting: "
                            + jobName
            );

            System.out.println(
                    "[TIMER] Started at: "
                            + log.getStartedAt()
            );


            int records =
                    performShipmentMonitoring();

            timerJobService
                    .completeSuccessfully(
                            log,
                            records
                    );


            long executionTime =
                    System.currentTimeMillis()
                            - start;


            System.out.println(
                    "[TIMER] Completed successfully."
            );

            System.out.println(
                    "[TIMER] Job: "
                            + jobName
            );

            System.out.println(
                    "[TIMER] Records processed: "
                            + records
            );

            System.out.println(
                    "[TIMER] Execution time: "
                            + executionTime
                            + " ms"
            );

            System.out.println(
                    "================================================="
            );


        } catch (Exception e) {


            if (log != null) {

                try {

                    timerJobService
                            .completeWithFailure(
                                    log,
                                    e
                            );

                } catch (Exception logException) {

                    System.err.println(
                            "[TIMER] Unable to save "
                                    + "failure log: "
                                    + logException.getMessage()
                    );
                }
            }


            System.err.println(
                    "================================================="
            );

            System.err.println(
                    "[TIMER] Job failed: "
                            + jobName
            );

            System.err.println(
                    "[TIMER] Error: "
                            + e.getMessage()
            );

            e.printStackTrace();

            System.err.println(
                    "================================================="
            );
        }
    }

    private int performShipmentMonitoring() {

        System.out.println(
                "[TIMER] Running shipment monitoring..."
        );


        int records =
                shipmentSessionBean
                        .monitorShipments();


        System.out.println(
                "[TIMER] Shipment monitoring finished."
        );


        return records;
    }
}