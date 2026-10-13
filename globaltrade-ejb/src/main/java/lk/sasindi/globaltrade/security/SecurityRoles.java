package lk.sasindi.globaltrade.security;


public final class SecurityRoles {

    private SecurityRoles() {

    }

    public static final String ADMIN = "ADMIN";
    public static final String STAFF = "STAFF";
    public static final String CUSTOMS = "CUSTOMS";
    public static final String USER = "USER";

    public static final String[] ADMIN_ROLES = {
            ADMIN
    };

    public static final String[] LOGISTICS_ROLES = {
            ADMIN,
            STAFF
    };

    public static final String[] CUSTOMS_ROLES = {
            ADMIN,
            CUSTOMS
    };
}

