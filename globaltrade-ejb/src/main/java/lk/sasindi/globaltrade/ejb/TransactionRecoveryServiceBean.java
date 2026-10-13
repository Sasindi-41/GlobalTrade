package lk.sasindi.globaltrade.ejb;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;

import java.util.concurrent.Callable;

@Stateless
public class TransactionRecoveryServiceBean {


    private static final int DEFAULT_MAX_RETRIES = 3;

    private static final long DEFAULT_BACKOFF_MILLIS = 250L;

    @TransactionAttribute(
            TransactionAttributeType.NOT_SUPPORTED
    )
    public <T> T executeWithRetry(
            Callable<T> operation
    ) throws Exception {

        return executeWithRetry(
                operation,
                DEFAULT_MAX_RETRIES,
                DEFAULT_BACKOFF_MILLIS
        );
    }

    @TransactionAttribute(
            TransactionAttributeType.NOT_SUPPORTED
    )
    public <T> T executeWithRetry(
            Callable<T> operation,
            int maxRetries,
            long backoffMillis
    ) throws Exception {

        if (operation == null) {

            throw new IllegalArgumentException(
                    "Recovery operation cannot be null."
            );
        }


        if (maxRetries < 0) {

            throw new IllegalArgumentException(
                    "Maximum retries cannot be negative."
            );
        }


        if (backoffMillis < 0) {

            throw new IllegalArgumentException(
                    "Backoff time cannot be negative."
            );
        }


        Exception lastException = null;


        for (
                int attempt = 0;
                attempt <= maxRetries;
                attempt++
        ) {

            try {

                return operation.call();

            } catch (Exception e) {

                lastException = e;


                System.err.println(
                        "[TRANSACTION-RECOVERY] " +
                                "Attempt " +
                                (attempt + 1) +
                                " failed: " +
                                e.getMessage()
                );


                if (attempt >= maxRetries) {
                    break;
                }


                if (backoffMillis > 0) {

                    try {

                        Thread.sleep(
                                backoffMillis *
                                        (attempt + 1)
                        );

                    } catch (InterruptedException interrupted) {

                        Thread.currentThread()
                                .interrupt();

                        throw new Exception(
                                "Transaction recovery was interrupted.",
                                interrupted
                        );
                    }
                }
            }
        }


        throw new Exception(
                "Operation failed after " +
                        (maxRetries + 1) +
                        " attempt(s).",
                lastException
        );
    }
}

