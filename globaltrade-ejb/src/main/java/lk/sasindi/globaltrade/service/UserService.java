package lk.sasindi.globaltrade.service;

import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.interceptor.Interceptors;

import lk.sasindi.globaltrade.dao.RoleDAO;
import lk.sasindi.globaltrade.dao.StatusDAO;
import lk.sasindi.globaltrade.dao.UserDAO;
import lk.sasindi.globaltrade.entity.City;
import lk.sasindi.globaltrade.entity.Role;
import lk.sasindi.globaltrade.entity.Status;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.interceptor.UserAuditInterceptor;
import lk.sasindi.globaltrade.util.PasswordUtil;

@Stateless
public class UserService {

    @Inject
    private UserDAO userDAO;

    @Inject
    private RoleDAO roleDAO;

    @Inject
    private StatusDAO statusDAO;

    public void registerUser(User user) {


        userDAO.save(user);
    }

    public boolean usernameExists(String username) {

        return userDAO.findByUsername(username) != null;
    }

    public boolean emailExists(String email) {

        return userDAO.findByEmail(email) != null;
    }

    public User findByUsername(String username) {

        return userDAO.findByUsername(username);
    }

    public User findById(int id) {

        return userDAO.findById(id);
    }

    public Role findRoleByName(String name) {

        return roleDAO.findByName(name);
    }

    public Status findStatusByName(String name) {

        return statusDAO.findByName(name);
    }

    public User updateProfile(
            int userId,
            String firstName,
            String lastName,
            String mobile,
            String company,
            String jobTitle,
            String address,
            String postalCode,
            City city
    ) {

        User user =
                userDAO.findById(userId);


        if (user == null) {

            return null;
        }


        user.setFirstName(
                cleanValue(firstName)
        );


        user.setLastName(
                cleanValue(lastName)
        );


        user.setMobile(
                cleanValue(mobile)
        );


        user.setCompany(
                cleanValue(company)
        );


        user.setJobTitle(
                cleanValue(jobTitle)
        );


        user.setAddress(
                cleanValue(address)
        );


        user.setPostalCode(
                cleanValue(postalCode)
        );


        user.setCity(city);


        return userDAO.update(user);
    }

    public User updateAdminProfile(
            int userId,
            String firstName,
            String lastName,
            String mobile,
            String company,
            String jobTitle,
            String address,
            String postalCode,
            City city
    ) {

        User user =
                userDAO.findById(userId);


        if (user == null) {

            return null;
        }


        if (user.getRole() == null ||
                !"ADMIN".equalsIgnoreCase(
                        user.getRole().getName()
                )) {

            return null;
        }


        user.setFirstName(
                cleanValue(firstName)
        );


        user.setLastName(
                cleanValue(lastName)
        );


        user.setMobile(
                cleanValue(mobile)
        );


        user.setCompany(
                cleanValue(company)
        );


        user.setJobTitle(
                cleanValue(jobTitle)
        );


        user.setAddress(
                cleanValue(address)
        );


        user.setPostalCode(
                cleanValue(postalCode)
        );


        user.setCity(city);


        return userDAO.update(user);
    }

    @Interceptors(UserAuditInterceptor.class)
    public User changeUserStatus(
            Integer userId,
            Integer statusId,
            Integer actorId
    ) {

        if (userId == null ||
                statusId == null) {

            throw new IllegalArgumentException(
                    "User ID and status ID are required."
            );
        }


        User user =
                userDAO.findById(userId);


        if (user == null) {

            throw new IllegalArgumentException(
                    "User not found."
            );
        }


        Status status =
                statusDAO.findById(statusId);


        if (status == null) {

            throw new IllegalArgumentException(
                    "Status not found."
            );
        }


        user.setStatus(status);


        return userDAO.update(user);
    }

    @Interceptors(UserAuditInterceptor.class)
    public User changeUserRole(
            Integer userId,
            Integer roleId,
            Integer actorId
    ) {

        if (userId == null ||
                roleId == null) {

            throw new IllegalArgumentException(
                    "User ID and role ID are required."
            );
        }


        User user =
                userDAO.findById(userId);


        if (user == null) {

            throw new IllegalArgumentException(
                    "User not found."
            );
        }


        Role role =
                roleDAO.findById(roleId);


        if (role == null) {

            throw new IllegalArgumentException(
                    "Role not found."
            );
        }


        user.setRole(role);


        return userDAO.update(user);
    }

    @Interceptors(UserAuditInterceptor.class)
    public boolean deleteUser(
            Integer userId,
            Integer actorId
    ) {

        if (userId == null) {

            throw new IllegalArgumentException(
                    "User ID is required."
            );
        }


        User user =
                userDAO.findById(userId);


        if (user == null) {

            return false;
        }

        if (user.getRole() != null &&
                "ADMIN".equalsIgnoreCase(
                        user.getRole().getName()
                )) {

            throw new IllegalArgumentException(
                    "Administrator accounts cannot be deleted from this page."
            );
        }


        return userDAO.delete(userId);
    }

    public void changePassword(
            Integer userId,
            String currentPassword,
            String newPassword
    ) {

        if (userId == null) {
            throw new IllegalArgumentException(
                    "User is required."
            );
        }

        if (newPassword == null ||
                newPassword.trim().length() < 8) {

            throw new IllegalArgumentException(
                    "New password must be at least 8 characters."
            );
        }

        User user = userDAO.findById(userId);

        if (user == null) {
            throw new IllegalArgumentException(
                    "User was not found."
            );
        }

        if (!PasswordUtil.verifyPassword(
                currentPassword == null ? "" : currentPassword,
                user.getPasswordHash()
        )) {

            throw new IllegalArgumentException(
                    "Current password is incorrect."
            );
        }

        user.setPasswordHash(
                PasswordUtil.hashPassword(newPassword.trim())
        );

        userDAO.update(user);
    }

    private String cleanValue(String value) {

        if (value == null) {

            return null;
        }


        value = value.trim();


        if (value.isEmpty()) {

            return null;
        }


        return value;
    }
}

