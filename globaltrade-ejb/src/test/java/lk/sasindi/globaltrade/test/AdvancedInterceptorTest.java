package lk.sasindi.globaltrade.test;

import lk.sasindi.globaltrade.interceptor.AlertPerformanceInterceptor;
import lk.sasindi.globaltrade.interceptor.SecurityAuditInterceptor;
import lk.sasindi.globaltrade.interceptor.TransactionMonitorInterceptor;

import jakarta.interceptor.InvocationContext;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;


class AdvancedInterceptorTest {

    @Test
    void transactionInterceptorShouldAllowSuccessfulExecution()
            throws Exception {

        TransactionMonitorInterceptor interceptor =
                new TransactionMonitorInterceptor();


        InvocationContext context =
                mock(InvocationContext.class);


        Method method =
                TestService.class
                        .getDeclaredMethod(
                                "successfulOperation"
                        );


        when(context.getMethod())
                .thenReturn(method);


        when(context.proceed())
                .thenReturn("SUCCESS");


        Object result =
                interceptor.monitor(context);


        assertEquals(
                "SUCCESS",
                result
        );


        verify(
                context,
                times(1)
        ).proceed();
    }


    @Test
    void transactionInterceptorShouldPropagateException()
            throws Exception {

        TransactionMonitorInterceptor interceptor =
                new TransactionMonitorInterceptor();


        InvocationContext context =
                mock(InvocationContext.class);


        Method method =
                TestService.class
                        .getDeclaredMethod(
                                "failedOperation"
                        );


        RuntimeException failure =
                new RuntimeException(
                        "Controlled failure"
                );


        when(context.getMethod())
                .thenReturn(method);


        when(context.proceed())
                .thenThrow(failure);


        RuntimeException result =
                assertThrows(
                        RuntimeException.class,
                        () ->
                                interceptor.monitor(
                                        context
                                )
                );


        assertSame(
                failure,
                result
        );


        verify(
                context,
                times(1)
        ).proceed();
    }

    @Test
    void securityInterceptorShouldAllowSuccessfulExecution()
            throws Exception {

        SecurityAuditInterceptor interceptor =
                new SecurityAuditInterceptor();


        InvocationContext context =
                mock(InvocationContext.class);


        Method method =
                TestService.class
                        .getDeclaredMethod(
                                "successfulOperation"
                        );


        when(context.getMethod())
                .thenReturn(method);


        when(context.proceed())
                .thenReturn("SECURE");


        Object result =
                interceptor.auditSecurity(
                        context
                );


        assertEquals(
                "SECURE",
                result
        );


        verify(
                context,
                times(1)
        ).proceed();
    }


    @Test
    void securityInterceptorShouldNotSwallowException()
            throws Exception {

        SecurityAuditInterceptor interceptor =
                new SecurityAuditInterceptor();


        InvocationContext context =
                mock(InvocationContext.class);


        Method method =
                TestService.class
                        .getDeclaredMethod(
                                "failedOperation"
                        );


        RuntimeException failure =
                new RuntimeException(
                        "Security test failure"
                );


        when(context.getMethod())
                .thenReturn(method);


        when(context.proceed())
                .thenThrow(failure);


        RuntimeException result =
                assertThrows(
                        RuntimeException.class,
                        () ->
                                interceptor.auditSecurity(
                                        context
                                )
                );


        assertSame(
                failure,
                result
        );
    }

    @Test
    void alertPerformanceInterceptorShouldReturnBusinessResult()
            throws Exception {

        AlertPerformanceInterceptor interceptor =
                new AlertPerformanceInterceptor();


        InvocationContext context =
                mock(InvocationContext.class);


        Method method =
                TestService.class
                        .getDeclaredMethod(
                                "successfulOperation"
                        );


        when(context.getMethod())
                .thenReturn(method);


        when(context.proceed())
                .thenReturn("PERFORMANCE_OK");


        Object result =
                interceptor.measure(context);


        assertEquals(
                "PERFORMANCE_OK",
                result
        );


        verify(
                context,
                times(1)
        ).proceed();
    }


    @Test
    void alertPerformanceInterceptorShouldPropagateFailure()
            throws Exception {

        AlertPerformanceInterceptor interceptor =
                new AlertPerformanceInterceptor();


        InvocationContext context =
                mock(InvocationContext.class);


        Method method =
                TestService.class
                        .getDeclaredMethod(
                                "failedOperation"
                        );


        RuntimeException failure =
                new RuntimeException(
                        "Performance test failure"
                );


        when(context.getMethod())
                .thenReturn(method);


        when(context.proceed())
                .thenThrow(failure);


        RuntimeException result =
                assertThrows(
                        RuntimeException.class,
                        () ->
                                interceptor.measure(
                                        context
                                )
                );


        assertSame(
                failure,
                result
        );
    }

    private static class TestService {

        private String successfulOperation() {

            return "SUCCESS";
        }


        private void failedOperation() {

            throw new RuntimeException(
                    "Controlled failure"
            );
        }
    }
}