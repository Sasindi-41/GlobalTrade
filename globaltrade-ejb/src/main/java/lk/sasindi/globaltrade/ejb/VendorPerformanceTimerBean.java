package lk.sasindi.globaltrade.ejb;

import jakarta.ejb.EJB;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;

import lk.sasindi.globaltrade.entity.JobExecutionLog;
import lk.sasindi.globaltrade.service.TimerJobService;

@Singleton
@Startup
public class VendorPerformanceTimerBean {

    @EJB
    private VendorPerformanceEvaluationBean evaluationBean;

    @EJB
    private TimerJobService timerJobService;

    @Schedule(
            second = "0",
            minute = "0",
            hour = "*/6",
            persistent = true
    )
    public void evaluateVendors() {
        String jobName = "Vendor Performance Evaluation Job";
        JobExecutionLog log = null;

        try {
            log = timerJobService.startExecution(jobName);
            int records = evaluationBean.evaluateAllVendors();
            timerJobService.completeSuccessfully(log, records);

            System.out.println(
                    "[VENDOR-TIMER] Evaluated " + records + " vendor(s)."
            );
        } catch (Exception e) {
            if (log != null) {
                try {
                    timerJobService.completeWithFailure(log, e);
                } catch (Exception logException) {
                    logException.printStackTrace();
                }
            }
            System.err.println("[VENDOR-TIMER] Failed: " + e.getMessage());
        }
    }
}
