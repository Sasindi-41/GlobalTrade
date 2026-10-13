package lk.sasindi.globaltrade.test;

import jakarta.ejb.ApplicationException;

import lk.sasindi.globaltrade.exception.AlertException;
import lk.sasindi.globaltrade.exception.CustomDocumentException;
import lk.sasindi.globaltrade.exception.InventoryConcurrencyException;
import lk.sasindi.globaltrade.exception.ReplenishmentException;
import lk.sasindi.globaltrade.exception.RouteOptimizationException;
import lk.sasindi.globaltrade.exception.TransactionFailureException;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class AdvancedExceptionHandlingTest {

    @Test
    void replenishmentExceptionShouldBeApplicationException() {


        assertApplicationException(
                ReplenishmentException.class
        );


    }

    @Test
    void inventoryConcurrencyExceptionShouldBeApplicationException() {


        assertApplicationException(
                InventoryConcurrencyException.class
        );


    }

    @Test
    void routeOptimizationExceptionShouldBeApplicationException() {


        assertApplicationException(
                RouteOptimizationException.class
        );


    }

    @Test
    void customDocumentExceptionShouldBeApplicationException() {


        assertApplicationException(
                CustomDocumentException.class
        );


    }

    @Test
    void transactionFailureExceptionShouldBeApplicationException() {


        assertApplicationException(
                TransactionFailureException.class
        );


    }

    @Test
    void alertExceptionShouldBeApplicationException() {


        assertApplicationException(
                AlertException.class
        );


    }

    @Test
    void replenishmentExceptionShouldTriggerRollback() {


        assertRollback(
                ReplenishmentException.class
        );


    }

    @Test
    void inventoryConcurrencyExceptionShouldTriggerRollback() {


        assertRollback(
                InventoryConcurrencyException.class
        );


    }

    @Test
    void routeOptimizationExceptionShouldTriggerRollback() {

        assertRollback(
                RouteOptimizationException.class
        );

    }

    @Test
    void customDocumentExceptionShouldTriggerRollback() {

        assertRollback(
                CustomDocumentException.class
        );

    }

    @Test
    void transactionFailureExceptionShouldTriggerRollback() {

        assertRollback(
                TransactionFailureException.class
        );

    }

    private void assertApplicationException(
            Class<?> exceptionClass
    ) {

        ApplicationException annotation =
                exceptionClass.getAnnotation(
                        ApplicationException.class
                );


        assertNotNull(
                annotation,
                exceptionClass.getSimpleName()
                        + " must be configured with @ApplicationException."
        );

    }

    private void assertRollback(
            Class<?> exceptionClass
    ) {

        ApplicationException annotation =
                exceptionClass.getAnnotation(
                        ApplicationException.class
                );


        assertNotNull(
                annotation,
                exceptionClass.getSimpleName()
                        + " must have @ApplicationException."
        );


        assertTrue(
                annotation.rollback(),
                exceptionClass.getSimpleName()
                        + " must have rollback=true."
        );


    }
}
