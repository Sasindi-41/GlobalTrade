package lk.sasindi.globaltrade.test;

import lk.sasindi.globaltrade.ejb.TransactionRecoveryServiceBean;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.*;

class TransactionRecoveryServiceTest {


    private TransactionRecoveryServiceBean recoveryService;


    @BeforeEach
    void setUp() {

        recoveryService =
                new TransactionRecoveryServiceBean();
    }


    @Test
    void successfulOperationShouldExecuteOnce()
            throws Exception {

        AtomicInteger attempts =
                new AtomicInteger(0);


        String result =
                recoveryService.executeWithRetry(
                        () -> {

                            attempts.incrementAndGet();

                            return "SUCCESS";
                        }
                );


        assertEquals(
                "SUCCESS",
                result
        );


        assertEquals(
                1,
                attempts.get()
        );
    }


    @Test
    void transientFailureShouldBeRetried()
            throws Exception {

        AtomicInteger attempts =
                new AtomicInteger(0);


        String result =
                recoveryService.executeWithRetry(
                        () -> {

                            int current =
                                    attempts.incrementAndGet();


                            if (current < 3) {

                                throw new Exception(
                                        "Temporary failure"
                                );
                            }


                            return "RECOVERED";
                        },

                        3,

                        1
                );


        assertEquals(
                "RECOVERED",
                result
        );


        assertEquals(
                3,
                attempts.get()
        );
    }


    @Test
    void operationShouldStopAfterMaximumRetries() {

        AtomicInteger attempts =
                new AtomicInteger(0);


        Exception exception =
                assertThrows(
                        Exception.class,
                        () ->
                                recoveryService.executeWithRetry(
                                        () -> {

                                            attempts.incrementAndGet();

                                            throw new Exception(
                                                    "Permanent failure"
                                            );
                                        },

                                        2,

                                        1
                                )
                );


        assertTrue(
                exception.getMessage()
                        .contains(
                                "failed after"
                        )
        );

        assertEquals(
                3,
                attempts.get()
        );
    }


    @Test
    void nullOperationShouldBeRejected() {

        assertThrows(
                IllegalArgumentException.class,
                () ->
                        recoveryService.executeWithRetry(
                                null
                        )
        );
    }


    @Test
    void negativeRetryCountShouldBeRejected() {

        assertThrows(
                IllegalArgumentException.class,
                () ->
                        recoveryService.executeWithRetry(
                                () -> "OK",
                                -1,
                                1
                        )
        );
    }


    @Test
    void negativeBackoffShouldBeRejected() {

        assertThrows(
                IllegalArgumentException.class,
                () ->
                        recoveryService.executeWithRetry(
                                () -> "OK",
                                1,
                                -1
                        )
        );
    }
}

