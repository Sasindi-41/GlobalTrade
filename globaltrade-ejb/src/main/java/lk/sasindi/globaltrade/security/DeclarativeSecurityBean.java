 package lk.sasindi.globaltrade.security;

import jakarta.annotation.security.DenyAll;
import jakarta.annotation.security.PermitAll;
import jakarta.annotation.security.RolesAllowed;
import jakarta.ejb.Stateless;

@Stateless
public class DeclarativeSecurityBean {

    @PermitAll
    public String publicSecurityCheck() {

        return "Public security operation.";
    }

    @RolesAllowed(SecurityRoles.ADMIN)
    public String adminOperation() {

        return "Administrative security operation authorized.";
    }

    @RolesAllowed({
            SecurityRoles.ADMIN,
            SecurityRoles.STAFF
    })
    public String logisticsOperation() {

        return "Logistics operation authorized.";
    }

    @RolesAllowed({
            SecurityRoles.ADMIN,
            SecurityRoles.CUSTOMS
    })
    public String customsOperation() {

        return "Customs operation authorized.";
    }

    @DenyAll
    public String disabledOperation() {

        return "This operation should never be accessible.";
    }
}

