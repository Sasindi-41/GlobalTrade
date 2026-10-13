package lk.sasindi.globaltrade.test;

import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;

import lk.sasindi.globaltrade.bean.TimerServiceBean;
import lk.sasindi.globaltrade.ejb.AlertMonitoringTimerBean;
import lk.sasindi.globaltrade.ejb.CustomsDeadlineTimerBean;
import lk.sasindi.globaltrade.ejb.InventoryReplenishmentTimerBean;
import lk.sasindi.globaltrade.ejb.RouteOptimizationTimerBean;
import lk.sasindi.globaltrade.ejb.VendorPerformanceTimerBean;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;

class TimerServiceTest {

    @Test
    void shipmentMonitoringTimerShouldBeSingleton() {


        assertNotNull(
                TimerServiceBean.class
                        .getAnnotation(Singleton.class)
        );


    }

    @Test
    void shipmentMonitoringTimerShouldStartAutomatically() {


        assertNotNull(
                TimerServiceBean.class
                        .getAnnotation(Startup.class)
        );


    }

    @Test
    void shipmentMonitoringScheduleShouldExist()
            throws Exception {


        assertScheduleExists(
                TimerServiceBean.class,
                "executeShipmentMonitoringJob"
        );


    }

    @Test
    void alertMonitoringTimerShouldBeConfigured()
            throws Exception {


        assertTimerConfigured(
                AlertMonitoringTimerBean.class,
                "monitorSupplyChain"
        );


    }

    @Test
    void inventoryReplenishmentTimerShouldBeConfigured()
            throws Exception {


        assertTimerConfigured(
                InventoryReplenishmentTimerBean.class,
                "executeReplenishment"
        );


    }

    @Test
    void customsDeadlineTimerShouldBeConfigured()
            throws Exception {


        assertTimerConfigured(
                CustomsDeadlineTimerBean.class,
                "monitorCustomsDeadlines"
        );


    }

    @Test
    void routeOptimizationTimerShouldBeConfigured()
            throws Exception {


        assertTimerConfigured(
                RouteOptimizationTimerBean.class,
                "optimizeRoutesAutomatically"
        );


    }

    @Test
    void vendorPerformanceTimerShouldBeConfigured()
            throws Exception {


        assertTimerConfigured(
                VendorPerformanceTimerBean.class,
                "evaluateVendors"
        );


    }

    private void assertTimerConfigured(
            Class<?> beanClass,
            String methodName
    ) throws Exception {

        assertNotNull(
                beanClass.getAnnotation(
                        Singleton.class
                ),
                beanClass.getSimpleName()
                        + " must be a Singleton."
        );

        assertNotNull(
                beanClass.getAnnotation(
                        Startup.class
                ),
                beanClass.getSimpleName()
                        + " must use @Startup."
        );

        assertScheduleExists(
                beanClass,
                methodName
        );


    }

    private void assertScheduleExists(
            Class<?> beanClass,
            String methodName
    ) throws Exception {


        Method method =
                beanClass.getDeclaredMethod(
                        methodName
                );


        Schedule schedule =
                method.getAnnotation(
                        Schedule.class
                );


        assertNotNull(
                schedule,
                "Expected @Schedule on "
                        + beanClass.getSimpleName()
                        + "."
                        + methodName
        );

        assertNotNull(
                schedule.second(),
                "Timer second expression must not be null."
        );


        assertNotNull(
                schedule.minute(),
                "Timer minute expression must not be null."
        );


        assertNotNull(
                schedule.hour(),
                "Timer hour expression must not be null."
        );


        assertNotNull(
                schedule.dayOfMonth(),
                "Timer day-of-month expression must not be null."
        );


        assertNotNull(
                schedule.month(),
                "Timer month expression must not be null."
        );


        assertNotNull(
                schedule.dayOfWeek(),
                "Timer day-of-week expression must not be null."
        );


        assertNotNull(
                schedule.year(),
                "Timer year expression must not be null."
        );

        assertTrue(
                method.isAnnotationPresent(
                        Schedule.class
                )
        );


    }
}
