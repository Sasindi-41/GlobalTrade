package lk.sasindi.globaltrade.test;

import jakarta.annotation.security.RolesAllowed;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;

import lk.sasindi.globaltrade.bean.TimerServiceBean;
import lk.sasindi.globaltrade.ejb.AlertMonitoringTimerBean;
import lk.sasindi.globaltrade.ejb.CustomsDeadlineTimerBean;
import lk.sasindi.globaltrade.ejb.InventoryReplenishmentTimerBean;
import lk.sasindi.globaltrade.ejb.RouteOptimizationTimerBean;
import lk.sasindi.globaltrade.ejb.TransactionRecoveryServiceBean;
import lk.sasindi.globaltrade.ejb.VendorPerformanceTimerBean;
import lk.sasindi.globaltrade.security.SecurityServiceBean;
import lk.sasindi.globaltrade.security.SecurityRoles;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;

class EnterpriseFeatureIntegrationTest {


    @Test
    void timerSecurityAndTransactionArchitectureShouldExist() {

        assertTimerBean(
                TimerServiceBean.class
        );

        assertTimerBean(
                AlertMonitoringTimerBean.class
        );

        assertTimerBean(
                CustomsDeadlineTimerBean.class
        );

        assertTimerBean(
                InventoryReplenishmentTimerBean.class
        );

        assertTimerBean(
                RouteOptimizationTimerBean.class
        );

        assertTimerBean(
                VendorPerformanceTimerBean.class
        );


        assertNotNull(
                SecurityServiceBean.class
                        .getAnnotation(
                                Stateless.class
                        )
        );


        assertNotNull(
                TransactionRecoveryServiceBean.class
                        .getAnnotation(
                                Stateless.class
                        )
        );
    }


    @Test
    void securityAndTransactionBoundariesShouldBeDefined()
            throws Exception {

        Method securityMethod =
                SecurityServiceBean.class
                        .getDeclaredMethod(
                                "verifyAdminAccess"
                        );


        RolesAllowed roles =
                securityMethod.getAnnotation(
                        RolesAllowed.class
                );


        assertNotNull(roles);


        assertArrayEquals(
                new String[]{
                        SecurityRoles.ADMIN
                },
                roles.value()
        );


        Method recoveryMethod =
                TransactionRecoveryServiceBean.class
                        .getDeclaredMethod(
                                "executeWithRetry",
                                java.util.concurrent.Callable.class
                        );


        TransactionAttribute attribute =
                recoveryMethod.getAnnotation(
                        TransactionAttribute.class
                );


        assertNotNull(attribute);


        assertEquals(
                TransactionAttributeType.NOT_SUPPORTED,
                attribute.value()
        );
    }


    private void assertTimerBean(
            Class<?> beanClass
    ) {

        assertNotNull(
                beanClass.getAnnotation(
                        Singleton.class
                ),
                beanClass.getSimpleName()
                        + " should be a Singleton."
        );


        boolean scheduleExists =
                false;


        for (Method method :
                beanClass.getDeclaredMethods()) {

            if (method.isAnnotationPresent(
                    Schedule.class
            )) {

                scheduleExists = true;
                break;
            }
        }


        assertTrue(
                scheduleExists,
                beanClass.getSimpleName()
                        + " should contain an EJB timer schedule."
        );
    }
}