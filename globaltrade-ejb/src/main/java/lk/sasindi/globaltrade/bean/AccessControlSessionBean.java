package lk.sasindi.globaltrade.bean;

import jakarta.annotation.security.DeclareRoles;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.inject.Inject;

import lk.sasindi.globaltrade.dao.PermissionDAO;
import lk.sasindi.globaltrade.dao.RoleDAO;
import lk.sasindi.globaltrade.dao.RolePermissionDAO;
import lk.sasindi.globaltrade.dao.UserDAO;

import lk.sasindi.globaltrade.entity.Permission;
import lk.sasindi.globaltrade.entity.Role;
import lk.sasindi.globaltrade.entity.RolePermission;
import lk.sasindi.globaltrade.entity.User;

import lk.sasindi.globaltrade.security.SecurityRoles;

import java.util.List;
import java.util.stream.Collectors;


@Stateless
@DeclareRoles({
        SecurityRoles.ADMIN,
        SecurityRoles.STAFF,
        SecurityRoles.CUSTOMS,
        SecurityRoles.USER
})
public class AccessControlSessionBean {

    @Inject
    private PermissionDAO permissionDAO;

    @Inject
    private RolePermissionDAO rolePermissionDAO;

    @Inject
    private RoleDAO roleDAO;

    @Inject
    private UserDAO userDAO;

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public boolean hasPermission(
            Integer userId,
            String permissionName
    ) {

        if (userId == null ||
                permissionName == null ||
                permissionName.trim().isEmpty()) {

            return false;
        }

        User user =
                userDAO.findById(userId);

        if (user == null ||
                user.getRole() == null) {

            return false;
        }

        List<RolePermission> grantsForRole =
                rolePermissionDAO.findByRole(
                        user.getRole().getId()
                );

        if (grantsForRole.isEmpty()) {

            System.out.println(
                    "[ACCESS-CONTROL] Role '"
                            + user.getRole().getName()
                            + "' has no permissions configured yet - "
                            + "allowing by default. Run "
                            + "db-seed-access-control.sql (or grant "
                            + "permissions via /access-control) to "
                            + "start enforcing."
            );

            return true;
        }

        return grantsForRole
                .stream()
                .anyMatch(
                        rp ->
                                rp.getPermission() != null
                                        &&
                                        permissionName.equalsIgnoreCase(
                                                rp.getPermission().getName()
                                        )
                );
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public boolean hasRole(
            Integer userId,
            String roleName
    ) {

        if (userId == null ||
                roleName == null ||
                roleName.trim().isEmpty()) {

            return false;
        }

        User user =
                userDAO.findById(userId);

        if (user == null ||
                user.getRole() == null ||
                user.getRole().getName() == null) {

            return false;
        }

        return roleName.equalsIgnoreCase(
                user.getRole().getName()
        );
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public void requirePermission(
            Integer userId,
            String permissionName
    ) {

        if (!hasPermission(
                userId,
                permissionName
        )) {

            throw new SecurityException(
                    "Access denied. Required permission: "
                            + permissionName
            );
        }
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void grantPermission(
            Integer roleId,
            Integer permissionId
    ) {

        if (roleId == null ||
                permissionId == null) {

            throw new IllegalArgumentException(
                    "Role and permission are required."
            );
        }

        if (rolePermissionDAO
                .existsForRoleAndPermission(
                        roleId,
                        permissionId
                )) {

            return;
        }

        Role role =
                roleDAO.findById(roleId);

        Permission permission =
                permissionDAO.findById(permissionId);

        if (role == null ||
                permission == null) {

            throw new IllegalArgumentException(
                    "Role or permission was not found."
            );
        }

        rolePermissionDAO.save(
                new RolePermission(
                        role,
                        permission
                )
        );
    }


    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void revokePermission(
            Integer rolePermissionId
    ) {

        if (rolePermissionId == null) {

            throw new IllegalArgumentException(
                    "Role permission is required."
            );
        }

        rolePermissionDAO.delete(
                rolePermissionId
        );
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Permission createPermission(
            String name,
            String description
    ) {

        if (name == null ||
                name.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Permission name is required."
            );
        }

        if (permissionDAO.findByName(
                name.trim()
        ) != null) {

            throw new IllegalArgumentException(
                    "A permission with that name already exists."
            );
        }

        return permissionDAO.save(
                new Permission(
                        name.trim()
                                .toUpperCase()
                                .replace(" ", "_"),
                        description
                )
        );
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<Permission> getAllPermissions() {

        return permissionDAO.findAll();
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<Role> getAllRoles() {

        return roleDAO.findAll();
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<RolePermission> getAllRolePermissions() {

        return rolePermissionDAO.findAll();
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<String> getPermissionNamesForRole(
            Integer roleId
    ) {

        return rolePermissionDAO
                .findByRole(roleId)
                .stream()
                .filter(
                        rp ->
                                rp.getPermission() != null
                )
                .map(
                        rp ->
                                rp.getPermission()
                                        .getName()
                )
                .collect(
                        Collectors.toList()
                );
    }
}

