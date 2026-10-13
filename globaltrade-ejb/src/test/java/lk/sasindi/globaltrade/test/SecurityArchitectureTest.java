package lk.sasindi.globaltrade.test;

import jakarta.annotation.security.DenyAll;
import jakarta.annotation.security.PermitAll;
import jakarta.annotation.security.RolesAllowed;
import jakarta.ejb.Stateless;
import jakarta.interceptor.Interceptors;

import lk.sasindi.globaltrade.interceptor.SecurityAuditInterceptor;
import lk.sasindi.globaltrade.security.DeclarativeSecurityBean;

import lk.sasindi.globaltrade.security.SecurityRoles;
import lk.sasindi.globaltrade.security.SecurityServiceBean;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;
import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;

class SecurityArchitectureTest {

    @Test
    void securityServiceShouldBeStateless() {

        assertNotNull(
                SecurityServiceBean.class
                        .getAnnotation(
                                Stateless.class
                        )
        );
    }


    @Test
    void securityServiceShouldUseSecurityInterceptor() {

        Interceptors annotation =
                SecurityServiceBean.class
                        .getAnnotation(
                                Interceptors.class
                        );


        assertNotNull(annotation);


        assertTrue(
                Arrays.asList(
                        annotation.value()
                ).contains(
                        SecurityAuditInterceptor.class
                )
        );
    }

    @Test
    void adminMethodShouldRequireAdminRole()
            throws Exception {

        Method method =
                SecurityServiceBean.class
                        .getDeclaredMethod(
                                "verifyAdminAccess"
                        );


        RolesAllowed roles =
                method.getAnnotation(
                        RolesAllowed.class
                );


        assertNotNull(roles);


        assertArrayEquals(
                new String[]{
                        SecurityRoles.ADMIN
                },
                roles.value()
        );
    }

    @Test
    void logisticsMethodShouldAllowAdminAndStaff()
            throws Exception {

        Method method =
                SecurityServiceBean.class
                        .getDeclaredMethod(
                                "verifyLogisticsAccess"
                        );


        RolesAllowed roles =
                method.getAnnotation(
                        RolesAllowed.class
                );


        assertNotNull(roles);


        assertArrayEquals(
                new String[]{
                        SecurityRoles.ADMIN,
                        SecurityRoles.STAFF
                },
                roles.value()
        );
    }

    @Test
    void customsMethodShouldAllowAdminAndCustoms()
            throws Exception {

        Method method =
                SecurityServiceBean.class
                        .getDeclaredMethod(
                                "verifyCustomsAccess"
                        );


        RolesAllowed roles =
                method.getAnnotation(
                        RolesAllowed.class
                );


        assertNotNull(roles);


        assertArrayEquals(
                new String[]{
                        SecurityRoles.ADMIN,
                        SecurityRoles.CUSTOMS
                },
                roles.value()
        );
    }

    @Test
    void publicMethodShouldUsePermitAll()
            throws Exception {

        Method method =
                DeclarativeSecurityBean.class
                        .getDeclaredMethod(
                                "publicSecurityCheck"
                        );


        assertNotNull(
                method.getAnnotation(
                        PermitAll.class
                )
        );
    }


    @Test
    void disabledMethodShouldUseDenyAll()
            throws Exception {

        Method method =
                DeclarativeSecurityBean.class
                        .getDeclaredMethod(
                                "disabledOperation"
                        );


        assertNotNull(
                method.getAnnotation(
                        DenyAll.class
                )
        );
    }


    @Test
    void adminOperationShouldRequireAdmin()
            throws Exception {

        Method method =
                DeclarativeSecurityBean.class
                        .getDeclaredMethod(
                                "adminOperation"
                        );


        RolesAllowed roles =
                method.getAnnotation(
                        RolesAllowed.class
                );


        assertNotNull(roles);


        assertArrayEquals(
                new String[]{
                        SecurityRoles.ADMIN
                },
                roles.value()
        );
    }


    @Test
    void customsOperationShouldAllowAdminAndCustoms()
            throws Exception {

        Method method =
                DeclarativeSecurityBean.class
                        .getDeclaredMethod(
                                "customsOperation"
                        );


        RolesAllowed roles =
                method.getAnnotation(
                        RolesAllowed.class
                );


        assertNotNull(roles);


        assertArrayEquals(
                new String[]{
                        SecurityRoles.ADMIN,
                        SecurityRoles.CUSTOMS
                },
                roles.value()
        );
    }
}