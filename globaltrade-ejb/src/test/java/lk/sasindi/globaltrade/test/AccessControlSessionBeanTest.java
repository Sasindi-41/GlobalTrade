package lk.sasindi.globaltrade.test;

import lk.sasindi.globaltrade.bean.AccessControlSessionBean;
import lk.sasindi.globaltrade.dao.PermissionDAO;
import lk.sasindi.globaltrade.dao.RoleDAO;
import lk.sasindi.globaltrade.dao.RolePermissionDAO;
import lk.sasindi.globaltrade.dao.UserDAO;
import lk.sasindi.globaltrade.entity.Permission;
import lk.sasindi.globaltrade.entity.Role;
import lk.sasindi.globaltrade.entity.RolePermission;
import lk.sasindi.globaltrade.entity.User;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AccessControlSessionBeanTest {

    @Mock
    private PermissionDAO permissionDAO;

    @Mock
    private RolePermissionDAO rolePermissionDAO;

    @Mock
    private RoleDAO roleDAO;

    @Mock
    private UserDAO userDAO;

    @InjectMocks
    private AccessControlSessionBean accessControlSessionBean;

    private Role adminRole;
    private User adminUser;

    @BeforeEach
    void setUp() {

        adminRole = new Role();
        adminRole.setId(1);
        adminRole.setName("ADMIN");

        adminUser = new User();
        adminUser.setId(100);
        adminUser.setRole(adminRole);
    }

    @Test
    void hasPermissionReturnsFalseForNullUserId() {

        assertFalse(
                accessControlSessionBean.hasPermission(null, "MANAGE_VENDORS")
        );
    }

    @Test
    void hasPermissionReturnsFalseWhenUserDoesNotExist() {

        when(userDAO.findById(100)).thenReturn(null);

        assertFalse(
                accessControlSessionBean.hasPermission(100, "MANAGE_VENDORS")
        );
    }

    @Test
    void hasPermissionReturnsTrueWhenRoleHasNoGrantsConfiguredYet() {

        when(userDAO.findById(100)).thenReturn(adminUser);
        when(rolePermissionDAO.findByRole(1)).thenReturn(Collections.emptyList());

        assertTrue(
                accessControlSessionBean.hasPermission(100, "MANAGE_VENDORS")
        );
    }

    @Test
    void hasPermissionReturnsTrueWhenRoleHasTheGrant() {

        Permission manageVendors = new Permission("MANAGE_VENDORS", "Manage vendors");
        manageVendors.setId(5);

        RolePermission grant = new RolePermission(adminRole, manageVendors);

        when(userDAO.findById(100)).thenReturn(adminUser);
        when(rolePermissionDAO.findByRole(1)).thenReturn(List.of(grant));

        assertTrue(
                accessControlSessionBean.hasPermission(100, "MANAGE_VENDORS")
        );
    }

    @Test
    void hasPermissionReturnsFalseWhenRoleHasOtherGrantsButNotThisOne() {

        Permission viewReports = new Permission("VIEW_REPORTS", "View reports");
        viewReports.setId(6);

        RolePermission grant = new RolePermission(adminRole, viewReports);

        when(userDAO.findById(100)).thenReturn(adminUser);
        when(rolePermissionDAO.findByRole(1)).thenReturn(List.of(grant));

        assertFalse(
                accessControlSessionBean.hasPermission(100, "MANAGE_VENDORS")
        );
    }

    @Test
    void hasPermissionIsCaseInsensitive() {

        Permission manageVendors = new Permission("MANAGE_VENDORS", "Manage vendors");
        manageVendors.setId(5);

        RolePermission grant = new RolePermission(adminRole, manageVendors);

        when(userDAO.findById(100)).thenReturn(adminUser);
        when(rolePermissionDAO.findByRole(1)).thenReturn(List.of(grant));

        assertTrue(
                accessControlSessionBean.hasPermission(100, "manage_vendors")
        );
    }
}
