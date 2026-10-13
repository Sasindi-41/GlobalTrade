package lk.sasindi.globaltrade.exception;

import jakarta.ejb.ApplicationException;

@ApplicationException(
        rollback = true,
        inherited = true
)
public class RouteOptimizationException
        extends Exception {

    private static final long serialVersionUID = 1L;


    public RouteOptimizationException(
            String message
    ) {
        super(message);
    }


    public RouteOptimizationException(
            String message,
            Throwable cause
    ) {
        super(message, cause);
    }
}

