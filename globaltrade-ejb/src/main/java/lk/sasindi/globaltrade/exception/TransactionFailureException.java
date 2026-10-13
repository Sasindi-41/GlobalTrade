package lk.sasindi.globaltrade.exception;

import jakarta.ejb.ApplicationException;

@ApplicationException(
        rollback = true,
        inherited = true
)
public class TransactionFailureException extends Exception {

    private static final long serialVersionUID = 1L;


    public TransactionFailureException(
            String message
    ) {
        super(message);
    }


    public TransactionFailureException(
            String message,
            Throwable cause
    ) {
        super(message, cause);
    }
}

