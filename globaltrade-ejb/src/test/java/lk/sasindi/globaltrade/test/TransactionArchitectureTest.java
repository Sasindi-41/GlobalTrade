package lk.sasindi.globaltrade.test;

import lk.sasindi.globaltrade.bean.ShipmentSessionBean;
import lk.sasindi.globaltrade.ejb.InventoryReplenishmentBean;


import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class TransactionArchitectureTest {


    @Test
    void inventoryReplenishmentShouldUseBMT() {

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
    void inventoryReplenishmentShouldBeStateless() {

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
}

