package lk.sasindi.globaltrade.test;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;

import lk.sasindi.globaltrade.bean.ShipmentSessionBean;
import lk.sasindi.globaltrade.ejb.InventoryReplenishmentBean;
import lk.sasindi.globaltrade.ejb.TransactionRecoveryServiceBean;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;

class AdvancedTransactionTest {


    @Test
    void inventoryBeanShouldUseBeanManagedTransactions() {

        TransactionManagement annotation =
                InventoryReplenishmentBean.class
                        .getAnnotation(
                                TransactionManagement.class
                        );


        assertNotNull(annotation);


        assertEquals(
                TransactionManagementType.BEAN,
                annotation.value()
        );
    }


    @Test
    void inventoryBeanShouldBeStateless() {

        assertNotNull(
                InventoryReplenishmentBean.class
                        .getAnnotation(
                                Stateless.class
                        )
        );
    }


    @Test
    void shipmentBeanShouldBeStateless() {

        assertNotNull(
                ShipmentSessionBean.class
                        .getAnnotation(
                                Stateless.class
                        )
        );
    }


    @Test
    void recoveryServiceShouldBeStateless() {

        assertNotNull(
                TransactionRecoveryServiceBean.class
                        .getAnnotation(
                                Stateless.class
                        )
        );
    }


    @Test
    void recoveryServiceShouldNotJoinCallerTransaction()
            throws Exception {

        Method method =
                TransactionRecoveryServiceBean.class
                        .getDeclaredMethod(
                                "executeWithRetry",
                                java.util.concurrent.Callable.class
                        );


        TransactionAttribute attribute =
                method.getAnnotation(
                        TransactionAttribute.class
                );


        assertNotNull(attribute);


        assertEquals(
                TransactionAttributeType.NOT_SUPPORTED,
                attribute.value()
        );
    }


    @Test
    void configurableRecoveryMethodShouldNotJoinCallerTransaction()
            throws Exception {

        Method method =
                TransactionRecoveryServiceBean.class
                        .getDeclaredMethod(
                                "executeWithRetry",
                                java.util.concurrent.Callable.class,
                                int.class,
                                long.class
                        );


        TransactionAttribute attribute =
                method.getAnnotation(
                        TransactionAttribute.class
                );


        assertNotNull(attribute);


        assertEquals(
                TransactionAttributeType.NOT_SUPPORTED,
                attribute.value()
        );
    }
}