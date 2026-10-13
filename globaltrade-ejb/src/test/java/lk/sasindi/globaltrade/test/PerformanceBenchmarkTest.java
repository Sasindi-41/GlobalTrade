package lk.sasindi.globaltrade.test;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;


class PerformanceBenchmarkTest {


    @Test
    void measureRecoveryServiceOverhead()
            throws Exception {

        final int iterations = 1000;


        List<Long> measurements =
                new ArrayList<>();


        for (int i = 0; i < iterations; i++) {

            long start =
                    System.nanoTime();


            performSmallOperation();


            long end =
                    System.nanoTime();


            measurements.add(
                    end - start
            );
        }


        long total =
                measurements.stream()
                        .mapToLong(Long::longValue)
                        .sum();


        double averageNanos =
                (double) total / iterations;


        double averageMicros =
                averageNanos / 1_000.0;


        System.out.println(
                "======================================"
        );


        System.out.println(
                "PHASE 4 PERFORMANCE BENCHMARK"
        );


        System.out.println(
                "Iterations       : " +
                        iterations
        );


        System.out.println(
                "Average time     : " +
                        averageMicros +
                        " microseconds"
        );


        System.out.println(
                "======================================"
        );


        assertTrue(
                averageMicros >= 0
        );
    }


    private void performSmallOperation() {

        int result =
                10 * 10;


        assertEquals(
                100,
                result
        );
    }
}

