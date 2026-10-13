package lk.sasindi.globaltrade.ejb;

import jakarta.ejb.EJB;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;

import lk.sasindi.globaltrade.bean.AlertServiceBean;
import lk.sasindi.globaltrade.exception.AlertException;

@Singleton
@Startup
public class AlertMonitoringTimerBean {

    @EJB
    private AlertServiceBean alertServiceBean;

    @Schedule(
            second = "0",
            minute = "*/5",
            hour = "*",
            persistent = true
    )
    public void monitorSupplyChain() {

        System.out.println(
                "[ALERT-TIMER] Starting automated supply-chain monitoring..."
        );


        try {

            alertServiceBean.generateAutomaticAlerts();


            System.out.println(
                    "[ALERT-TIMER] Monitoring completed successfully."
            );


        } catch (AlertException e) {

            System.err.println(
                    "[ALERT-TIMER] Alert processing error: " +
                            e.getMessage()
            );


        } catch (Exception e) {

            System.err.println(
                    "[ALERT-TIMER] Unexpected monitoring error: " +
                            e.getMessage()
            );

            e.printStackTrace();
        }
    }
}