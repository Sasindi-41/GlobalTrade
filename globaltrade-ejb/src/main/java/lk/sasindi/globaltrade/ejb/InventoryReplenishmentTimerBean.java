package lk.sasindi.globaltrade.ejb;

import jakarta.ejb.EJB;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;

import lk.sasindi.globaltrade.entity.JobExecutionLog;
import lk.sasindi.globaltrade.service.TimerJobService;


@Singleton
@Startup
public class InventoryReplenishmentTimerBean {

    @EJB
    private InventoryReplenishmentBean replenishmentBean;

    @EJB
    private TimerJobService timerJobService;

    @Schedule(
            second = "0",
            minute = "0",
            hour = "*/1",
            persistent = true
    )
    public void executeReplenishment() {
        String jobName = "Inventory Replenishment Job";
        JobExecutionLog log = null;

        try {
            log = timerJobService.startExecution(jobName);
            int records = replenishmentBean.replenishLowStock();
            timerJobService.completeSuccessfully(log, records);

            System.out.println(
                    "[REPLENISHMENT-TIMER] Successfully replenished " +
                            records + " inventory item(s)."
            );

    } catch (Exception e) {

        if (log != null) {

            try {

                timerJobService.completeWithFailure(
                        log,
                        e
                );

            } catch (Exception logException) {

                System.err.println(
                        "[REPLENISHMENT-TIMER] " +
                                "Unable to record timer failure: " +
                                logException.getMessage()
                );

                logException.printStackTrace();
            }
        }


        System.err.println(
                "[REPLENISHMENT-TIMER] " +
                        "Execution failed: " +
                        e.getClass().getSimpleName() +
                        " - " +
                        e.getMessage()
        );
    }

}
}
