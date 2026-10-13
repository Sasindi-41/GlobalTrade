package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.service.PerformanceMonitoringService;

public class RoutePerformanceInterceptor {

    @EJB
    private PerformanceMonitoringService performanceMonitoringService;


    @AroundInvoke
    public Object measure(
            InvocationContext context
    ) throws Exception {

        long start =
                System.nanoTime();


        String error = null;


        try {


            return context.proceed();


        } catch (Exception e) {


            error =
                    e.getClass().getSimpleName()
                            + ": "
                            + e.getMessage();

            throw e;


        } finally {

            long elapsed =
                    System.nanoTime() - start;


            double milliseconds =
                    elapsed / 1_000_000.0;

            System.out.println(
                    "[ROUTE-PERFORMANCE] "
                            + context.getMethod().getName()
                            + " completed in "
                            + String.format(
                            "%.3f",
                            milliseconds
                    )
                            + " ms"
            );

            try {

                performanceMonitoringService.record(
                        context.getMethod()
                                .getDeclaringClass()
                                .getName(),

                        context.getMethod()
                                .getName(),

                        milliseconds,

                        error
                );

            } catch (Exception monitoringException) {


                System.err.println(
                        "[ROUTE-PERFORMANCE] "
                                + "Unable to record database "
                                + "performance log: "
                                + monitoringException.getMessage()
                );
            }
        }
    }
}