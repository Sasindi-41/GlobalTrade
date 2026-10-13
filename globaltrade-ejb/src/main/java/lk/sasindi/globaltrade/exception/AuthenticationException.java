package lk.sasindi.globaltrade.exception;

import jakarta.ejb.ApplicationException;


@ApplicationException(rollback = false)
public class AuthenticationException extends Exception {

    private static final long serialVersionUID = 1L;

    public AuthenticationException(String message) {
        super(message);
    }

    public AuthenticationException(String message, Throwable cause) {
        super(message, cause);
    }
}