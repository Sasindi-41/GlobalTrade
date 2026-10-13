package lk.sasindi.globaltrade.ejb;

import jakarta.ejb.EJB;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;

@Singleton
@Startup
public class RouteOptimizationTimerBean {

    @EJB
    private RouteOptimizationServiceBean
            routeOptimizationService;

    @Schedule(
            second = "0",
            minute = "*/15",
            hour = "*",
            persistent = true
    )
    public void optimizeRoutesAutomatically() {

        System.out.println(
                "[ROUTE-TIMER] Starting automatic route optimization..."
        );


        try {

            int optimized =
                    routeOptimizationService
                            .optimizeAllRoutes();


            System.out.println(
                    "[ROUTE-TIMER] " +
                            optimized +
                            " route(s) recalculated successfully."
            );


        } catch (Exception e) {

            System.err.println(
                    "[ROUTE-TIMER] Route optimization failed: " +
                            e.getMessage()
            );


            e.printStackTrace();
        }
    }
}