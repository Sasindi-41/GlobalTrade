package lk.sasindi.globaltrade.exception;

public class SystemFailureException
        extends RuntimeException {

    private static final long serialVersionUID = 1L;


    public SystemFailureException(
            String message
    ) {
        super(message);
    }


    public SystemFailureException(
            String message,
            Throwable cause
    ) {
        super(message, cause);
    }
}

