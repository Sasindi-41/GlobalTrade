package lk.sasindi.globaltrade.exception;

import jakarta.ejb.ApplicationException;

@ApplicationException(
        rollback = true,
        inherited = true
)
public class CustomDocumentException
        extends Exception {

    private static final long serialVersionUID = 1L;


    public CustomDocumentException(
            String message
    ) {
        super(message);
    }


    public CustomDocumentException(
            String message,
            Throwable cause
    ) {
        super(message, cause);
    }
}

