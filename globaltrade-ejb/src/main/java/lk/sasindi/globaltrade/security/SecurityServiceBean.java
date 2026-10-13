package lk.sasindi.globaltrade.security;

import jakarta.annotation.security.RolesAllowed;
import jakarta.ejb.Stateless;
import jakarta.interceptor.Interceptors;

import lk.sasindi.globaltrade.interceptor.SecurityAuditInterceptor;
import lk.sasindi.globaltrade.security.SecurityRoles;

@Stateless
@Interceptors(SecurityAuditInterceptor.class)
public class SecurityServiceBean {

    @RolesAllowed(SecurityRoles.ADMIN)
    public String verifyAdminAccess() {

        return "ADMIN authorization successful.";
    }

    @RolesAllowed({
            SecurityRoles.ADMIN,
            SecurityRoles.STAFF
    })
    public String verifyLogisticsAccess() {

        return "LOGISTICS authorization successful.";
    }

    @RolesAllowed({
            SecurityRoles.ADMIN,
            SecurityRoles.CUSTOMS
    })
    public String verifyCustomsAccess() {

        return "CUSTOMS authorization successful.";
    }
}

