package lk.sasindi.globaltrade.test;

import lk.sasindi.globaltrade.interceptor.TransactionMonitorInterceptor;

import jakarta.interceptor.InvocationContext;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class Phase5PerformanceTest {


    @Test
    void measureTransactionInterceptorOverhead()
            throws Exception {

        final int iterations = 1000;


        TransactionMonitorInterceptor interceptor =
                new TransactionMonitorInterceptor();


        Method method =
                TestService.class
                        .getDeclaredMethod(
                                "operation"
                        );


        List<Long> measurements =
                new ArrayList<>();


        for (int i = 0; i < iterations; i++) {

            InvocationContext context =
                    mock(
                            InvocationContext.class
                    );


            when(
                    context.getMethod()
            ).thenReturn(method);


            when(
                    context.proceed()
            ).thenReturn("OK");


            long start =
                    System.nanoTime();


            Object result =
                    interceptor.monitor(
                            context
                    );


            long end =
                    System.nanoTime();


            assertEquals(
                    "OK",
                    result
            );


            measurements.add(
                    end - start
            );
        }


        long total =
                measurements.stream()
                        .mapToLong(
                                Long::longValue
                        )
                        .sum();


        double averageNanos =
                (double) total
                        / iterations;


        double averageMicros =
                averageNanos
                        / 1_000.0;


        long minimum =
                measurements.stream()
                        .mapToLong(
                                Long::longValue
                        )
                        .min()
                        .orElse(0);


        long maximum =
                measurements.stream()
                        .mapToLong(
                                Long::longValue
                        )
                        .max()
                        .orElse(0);


        System.out.println(
                "=============================================="
        );


        System.out.println(
                "PHASE 5 INTERCEPTOR PERFORMANCE TEST"
        );


        System.out.println(
                "Iterations        : "
                        + iterations
        );


        System.out.println(
                "Average time      : "
                        + averageMicros
                        + " microseconds"
        );


        System.out.println(
                "Minimum time      : "
                        + minimum
                        + " ns"
        );


        System.out.println(
                "Maximum time      : "
                        + maximum
                        + " ns"
        );


        System.out.println(
                "=============================================="
        );


        assertTrue(
                averageNanos >= 0
        );
    }


    private static class TestService {

        private String operation() {

            return "OK";
        }
    }
}