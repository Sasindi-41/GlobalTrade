package lk.sasindi.globaltrade.interceptor;

import jakarta.annotation.Resource;
import jakarta.ejb.SessionContext;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.security.SecurityAudited;


@SecurityAudited
public class SecurityAuditInterceptor {

    @Resource
    private SessionContext sessionContext;


    @AroundInvoke
    public Object auditSecurity(
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

        } finally {

            long executionTime =
                    (System.nanoTime() - start)
                            / 1_000_000L;


            System.out.println(
                    "[SECURITY-AUDIT] "
                            + "caller=" + caller
                            + ", method=" + methodName
                            + ", executionTimeMs="
                            + executionTime
            );
        }
    }
}

