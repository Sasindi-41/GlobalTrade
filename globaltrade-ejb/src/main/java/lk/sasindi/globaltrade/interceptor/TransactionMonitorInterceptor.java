package lk.sasindi.globaltrade.interceptor;

import jakarta.annotation.Resource;
import jakarta.ejb.SessionContext;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

public class TransactionMonitorInterceptor {


    @Resource
    private SessionContext sessionContext;


    @AroundInvoke
    public Object monitor(
            InvocationContext context
    ) throws Exception {


        long start =
                System.nanoTime();


        String methodName =
                context.getMethod() == null
                        ? "unknown"
                        : context.getMethod()
                        .getName();


        String caller =
                "anonymous";


        try {

            if (sessionContext != null &&
                    sessionContext.getCallerPrincipal() != null) {

                caller =
                        sessionContext
                                .getCallerPrincipal()
                                .getName();
            }

        } catch (Exception ignored) {

        }


        try {

            return context.proceed();


        } catch (Exception e) {

            long elapsed =
                    (System.nanoTime() - start)
                            / 1_000_000L;


            System.err.println(
                    "[TRANSACTION-MONITOR] " +
                            "method=" +
                            methodName +
                            ", caller=" +
                            caller +
                            ", failed=true" +
                            ", durationMs=" +
                            elapsed +
                            ", exception=" +
                            e.getClass()
                                    .getSimpleName()
            );


            throw e;


        } finally {

            long elapsed =
                    (System.nanoTime() - start)
                            / 1_000_000L;


            System.out.println(
                    "[TRANSACTION-MONITOR] " +
                            "method=" +
                            methodName +
                            ", caller=" +
                            caller +
                            ", durationMs=" +
                            elapsed
            );
        }
    }
}

