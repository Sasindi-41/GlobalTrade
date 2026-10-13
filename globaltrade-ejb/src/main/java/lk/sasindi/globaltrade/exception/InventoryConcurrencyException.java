package lk.sasindi.globaltrade.exception;

import jakarta.ejb.ApplicationException;


@ApplicationException(
        rollback = true,
        inherited = true
)
public class InventoryConcurrencyException
        extends Exception {

    private static final long serialVersionUID = 1L;


    public InventoryConcurrencyException(
            String message
    ) {
        super(message);
    }


    public InventoryConcurrencyException(
            String message,
            Throwable cause
    ) {
        super(message, cause);
    }
}

