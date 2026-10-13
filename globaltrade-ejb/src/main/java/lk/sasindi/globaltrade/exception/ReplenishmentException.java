package lk.sasindi.globaltrade.exception;

import jakarta.ejb.ApplicationException;

@ApplicationException(
        rollback = true,
        inherited = true
)
public class ReplenishmentException
        extends Exception {

    private static final long serialVersionUID = 1L;


    public ReplenishmentException(
            String message
    ) {
        super(message);
    }


    public ReplenishmentException(
            String message,
            Throwable cause
    ) {
        super(message, cause);
    }
}

