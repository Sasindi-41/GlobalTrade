package lk.sasindi.globaltrade.interceptor;

import jakarta.ejb.EJB;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import lk.sasindi.globaltrade.ejb.AuditLogServiceBean;
import lk.sasindi.globaltrade.entity.User;

import java.time.LocalDateTime;

public class UserAuditInterceptor {

    @EJB
    private AuditLogServiceBean auditLogService;

    @AroundInvoke
    public Object audit(
            InvocationContext context
    ) throws Exception {

        String className =
                context.getTarget()
                        .getClass()
                        .getSimpleName();

        String methodName =
                context.getMethod()
                        .getName();

        LocalDateTime startedAt =
                LocalDateTime.now();


        System.out.println(
                "[USER-AUDIT] START | " +
                        startedAt +
                        " | " +
                        className +
                        "." +
                        methodName
        );


        Object[] parameters =
                context.getParameters();

        Integer entityId =
                extractEntityId(parameters);

        Integer actorId =
                extractActorId(parameters);

        String oldValue = null;


        if (entityId != null &&
                shouldCaptureOldValue(methodName)) {

            try {

                User oldUser =
                        auditLogService
                                .getUserForAudit(entityId);


                if (oldUser != null) {

                    oldValue =
                            buildUserValue(
                                    oldUser
                            );
                }

            } catch (Exception e) {

                System.err.println(
                        "[USER-AUDIT] " +
                                "Unable to capture old value: " +
                                e.getMessage()
                );
            }
        }


        try {
            Object result =
                    context.proceed();

            if (shouldPersistAudit(methodName)) {

                if (entityId != null &&
                        actorId != null) {

                    String newValue =
                            buildNewValue(
                                    result
                            );


                    auditLogService.createAuditLog(
                            actorId,
                            determineAction(methodName),
                            oldValue,
                            newValue,
                            buildDetails(methodName),
                            entityId,
                            "USER"
                    );
                }
            }


            System.out.println(
                    "[USER-AUDIT] SUCCESS | " +
                            className +
                            "." +
                            methodName
            );


            return result;


        } catch (Exception e) {

            System.err.println(
                    "[USER-AUDIT] FAILURE | " +
                            className +
                            "." +
                            methodName +
                            " | " +
                            e.getClass().getSimpleName() +
                            " | " +
                            e.getMessage()
            );


            throw e;
        }
    }

    private Integer extractEntityId(
            Object[] parameters
    ) {

        if (parameters == null ||
                parameters.length == 0) {

            return null;
        }


        Object first =
                parameters[0];


        if (first instanceof Integer) {

            return (Integer) first;
        }


        return null;
    }

    private Integer extractActorId(
            Object[] parameters
    ) {

        if (parameters == null ||
                parameters.length == 0) {

            return null;
        }

        Object last =
                parameters[
                        parameters.length - 1
                        ];


        if (last instanceof Integer) {

            return (Integer) last;
        }


        return null;
    }

    private String determineAction(
            String methodName
    ) {

        return switch (methodName) {

            case "changeUserStatus",
                 "changeUserRole" ->
                    "UPDATE";

            case "deleteUser" ->
                    "DELETE";

            default ->
                    methodName.toUpperCase();
        };
    }

    private boolean shouldPersistAudit(
            String methodName
    ) {

        return
                "changeUserStatus".equals(methodName)
                        ||
                        "changeUserRole".equals(methodName)
                        ||
                        "deleteUser".equals(methodName);
    }

    private boolean shouldCaptureOldValue(
            String methodName
    ) {

        return
                "changeUserStatus".equals(methodName)
                        ||
                        "changeUserRole".equals(methodName)
                        ||
                        "deleteUser".equals(methodName);
    }

    private String buildNewValue(
            Object result
    ) {

        if (!(result instanceof User user)) {

            return null;
        }


        return buildUserValue(user);
    }

    private String buildUserValue(
            User user
    ) {

        if (user == null) {

            return null;
        }


        String roleName =
                user.getRole() != null
                        ? user.getRole().getName()
                        : "N/A";


        String statusName =
                user.getStatus() != null
                        ? user.getStatus().getName()
                        : "N/A";


        String cityName =
                user.getCity() != null
                        ? user.getCity().getName()
                        : "N/A";


        return
                "User ID: " +
                        user.getId() +

                        ", Username: " +
                        user.getUsername() +

                        ", First Name: " +
                        user.getFirstName() +

                        ", Last Name: " +
                        user.getLastName() +

                        ", Email: " +
                        user.getEmail() +

                        ", Mobile: " +
                        user.getMobile() +

                        ", Company: " +
                        user.getCompany() +

                        ", Job Title: " +
                        user.getJobTitle() +

                        ", Address: " +
                        user.getAddress() +

                        ", Postal Code: " +
                        user.getPostalCode() +

                        ", City: " +
                        cityName +

                        ", Role: " +
                        roleName +

                        ", Status: " +
                        statusName;
    }


    private String buildDetails(
            String methodName
    ) {

        return switch (methodName) {

            case "changeUserStatus" ->
                    "User status updated.";

            case "changeUserRole" ->
                    "User role updated.";

            case "deleteUser" ->
                    "User record deleted.";

            default ->
                    "User operation: " +
                            methodName;
        };
    }
}

