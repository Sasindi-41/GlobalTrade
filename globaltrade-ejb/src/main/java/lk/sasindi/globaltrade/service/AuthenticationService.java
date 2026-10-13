package lk.sasindi.globaltrade.service;

import jakarta.ejb.Stateless;
import jakarta.inject.Inject;

import lk.sasindi.globaltrade.dao.UserDAO;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.exception.AuthenticationException;
import lk.sasindi.globaltrade.util.PasswordUtil;

@Stateless
public class AuthenticationService {

    @Inject
    private UserDAO userDAO;

    public User authenticate(
            String username,
            String password
    ) throws AuthenticationException {

        if (username == null ||
                password == null ||
                username.isBlank() ||
                password.isEmpty()) {

            throw new AuthenticationException(
                    "Invalid username or password."
            );
        }

        username = username.trim();

        User user = userDAO.findByUsername(username);

        if (user == null) {

            throw new AuthenticationException(
                    "Invalid username or password."
            );
        }

        boolean validPassword =
                PasswordUtil.verifyPassword(
                        password,
                        user.getPasswordHash()
                );


        if (!validPassword) {

            throw new AuthenticationException(
                    "Invalid username or password."
            );
        }

        if (user.getStatus() == null) {

            throw new AuthenticationException(
                    "Account status is not available."
            );
        }


        String status =
                user.getStatus()
                        .getName();


        if (!"ACTIVE".equalsIgnoreCase(status)) {

            throw new AuthenticationException(
                    "Your account is not active."
            );
        }

        if (user.getRole() == null ||
                user.getRole().getName() == null ||
                user.getRole().getName().isBlank()) {

            throw new AuthenticationException(
                    "Your account does not have a valid role."
            );
        }

        return user;
    }
}