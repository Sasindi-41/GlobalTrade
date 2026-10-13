package lk.sasindi.globaltrade.test;

import lk.sasindi.globaltrade.interceptor.TransactionMonitorInterceptor;

import jakarta.interceptor.InvocationContext;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class TransactionMonitorInterceptorTest {


    @Test
    void interceptorShouldAllowSuccessfulInvocation()
            throws Exception {

        TransactionMonitorInterceptor interceptor =
                new TransactionMonitorInterceptor();


        InvocationContext context =
                mock(InvocationContext.class);


        Method method =
                TestBusinessService.class
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
    void interceptorShouldPropagateBusinessException()
            throws Exception {

        TransactionMonitorInterceptor interceptor =
                new TransactionMonitorInterceptor();


        InvocationContext context =
                mock(InvocationContext.class);


        Method method =
                TestBusinessService.class
                        .getDeclaredMethod(
                                "failedOperation"
                        );


        RuntimeException failure =
                new RuntimeException(
                        "Test failure"
                );


        when(context.getMethod())
                .thenReturn(method);


        when(context.proceed())
                .thenThrow(failure);


        RuntimeException thrown =
                assertThrows(
                        RuntimeException.class,
                        () ->
                                interceptor.monitor(
                                        context
                                )
                );


        assertSame(
                failure,
                thrown
        );


        verify(
                context,
                times(1)
        ).proceed();
    }


    private static class TestBusinessService {


        private String successfulOperation() {

            return "SUCCESS";
        }


        private void failedOperation() {

            throw new RuntimeException(
                    "Test failure"
            );
        }
    }
}
