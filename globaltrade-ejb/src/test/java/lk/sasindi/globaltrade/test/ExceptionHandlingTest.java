package lk.sasindi.globaltrade.test;

import lk.sasindi.globaltrade.exception.CustomDocumentException;
import lk.sasindi.globaltrade.exception.InventoryConcurrencyException;
import lk.sasindi.globaltrade.exception.ReplenishmentException;
import lk.sasindi.globaltrade.exception.RouteOptimizationException;
import lk.sasindi.globaltrade.exception.TransactionFailureException;

import jakarta.ejb.ApplicationException;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ExceptionHandlingTest {


    @Test
    void replenishmentExceptionShouldBeApplicationException() {

        ApplicationException annotation =
                ReplenishmentException.class
                        .getAnnotation(
                                ApplicationException.class
                        );

        assertNotNull(annotation);

        assertTrue(
                annotation.rollback(),
                "ReplenishmentException must trigger rollback."
        );
    }


    @Test
    void inventoryConcurrencyExceptionShouldRollback() {

        ApplicationException annotation =
                InventoryConcurrencyException.class
                        .getAnnotation(
                                ApplicationException.class
                        );

        assertNotNull(annotation);

        assertTrue(
                annotation.rollback()
        );
    }


    @Test
    void routeOptimizationExceptionShouldRollback() {

        ApplicationException annotation =
                RouteOptimizationException.class
                        .getAnnotation(
                                ApplicationException.class
                        );

        assertNotNull(annotation);

        assertTrue(
                annotation.rollback()
        );
    }


    @Test
    void customDocumentExceptionShouldRollback() {

        ApplicationException annotation =
                CustomDocumentException.class
                        .getAnnotation(
                                ApplicationException.class
                        );

        assertNotNull(annotation);

        assertTrue(
                annotation.rollback()
        );
    }


    @Test
    void transactionFailureExceptionShouldRollback() {

        ApplicationException annotation =
                TransactionFailureException.class
                        .getAnnotation(
                                ApplicationException.class
                        );

        assertNotNull(annotation);

        assertTrue(
                annotation.rollback()
        );
    }


    @Test
    void exceptionShouldPreserveCause() {

        RuntimeException cause =
                new RuntimeException(
                        "Database connection failure"
                );

        ReplenishmentException exception =
                new ReplenishmentException(
                        "Replenishment failed.",
                        cause
                );

        assertEquals(
                "Replenishment failed.",
                exception.getMessage()
        );

        assertSame(
                cause,
                exception.getCause()
        );
    }
}

