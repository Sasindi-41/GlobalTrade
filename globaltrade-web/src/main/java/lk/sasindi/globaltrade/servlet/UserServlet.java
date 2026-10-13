package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lk.sasindi.globaltrade.dao.RoleDAO;
import lk.sasindi.globaltrade.dao.StatusDAO;
import lk.sasindi.globaltrade.dao.UserDAO;
import lk.sasindi.globaltrade.entity.Role;
import lk.sasindi.globaltrade.entity.Status;
import lk.sasindi.globaltrade.entity.User;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.http.HttpSession;
import lk.sasindi.globaltrade.service.UserService;
import lk.sasindi.globaltrade.bean.AccessControlSessionBean;
@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @EJB
    private UserDAO userDAO;

    @EJB
    private StatusDAO statusDAO;

    @EJB
    private RoleDAO roleDAO;

    @EJB
    private UserService userService;

    @EJB
    private AccessControlSessionBean accessControlSessionBean;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }


        switch (action) {

            case "list":
                listUsers(request, response);
                break;

            case "search":
                searchUsers(request, response);
                break;

            case "view":
                viewUser(request, response);
                break;

            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");


        if (action == null || action.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/UserServlet?action=list"
            );

            return;
        }


        switch (action) {

            case "changeStatus":
            case "changeRole":
            case "delete": {

                HttpSession authSession = request.getSession(false);

                Object sessionUserIdObject =
                        authSession != null
                                ? authSession.getAttribute("userId")
                                : null;

                Integer sessionUserId =
                        sessionUserIdObject instanceof Number
                                ? ((Number) sessionUserIdObject).intValue()
                                : null;

                if (!accessControlSessionBean.hasPermission(
                        sessionUserId,
                        "MANAGE_USERS"
                )) {

                    request.getSession().setAttribute(
                            "userError",
                            "You do not have permission to manage users."
                    );

                    response.sendRedirect(
                            request.getContextPath() + "/UserServlet?action=list"
                    );

                    return;
                }

                if ("changeStatus".equals(action)) {
                    changeStatus(request, response);
                } else if ("changeRole".equals(action)) {
                    changeRole(request, response);
                } else {
                    deleteUser(request, response);
                }

                break;
            }

            default:

                response.sendRedirect(
                        request.getContextPath()
                                + "/UserServlet?action=list"
                );

                break;
        }
    }

    private void listUsers(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            List<User> users = userDAO.findAll();

            List<Status> statuses = statusDAO.findAll();

            List<Role> roles = roleDAO.findAll();


            request.setAttribute("users", users);

            request.setAttribute("statuses", statuses);

            request.setAttribute("roles", roles);


            request.getRequestDispatcher("/admin/users.jsp")
                    .forward(request, response);


        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Unable to load users."
            );

            request.getRequestDispatcher("/admin/users.jsp")
                    .forward(request, response);
        }
    }

    private void searchUsers(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        try {

            List<User> users = userDAO.search(keyword);

            List<Status> statuses = statusDAO.findAll();

            List<Role> roles = roleDAO.findAll();


            request.setAttribute("users", users);

            request.setAttribute("statuses", statuses);

            request.setAttribute("roles", roles);

            request.setAttribute("searchKeyword", keyword);


            request.getRequestDispatcher("/admin/users.jsp")
                    .forward(request, response);


        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Unable to search users."
            );

            request.getRequestDispatcher("/admin/users.jsp")
                    .forward(request, response);
        }
    }

    private void viewUser(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        Integer id = parseId(request.getParameter("id"));

        if (id == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/UserServlet?action=list"
            );

            return;
        }


        User user = userDAO.findById(id);


        if (user == null) {

            request.getSession().setAttribute(
                    "errorMessage",
                    "User not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/UserServlet?action=list"
            );

            return;
        }


        request.setAttribute("selectedUser", user);

        listUsers(request, response);
    }

    private void changeStatus(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Integer userId =
                parseId(
                        request.getParameter("id")
                );

        Integer statusId =
                parseId(
                        request.getParameter("statusId")
                );


        if (userId == null ||
                statusId == null) {

            setErrorAndRedirect(
                    request,
                    response,
                    "Invalid user or status."
            );

            return;
        }

        HttpSession session =
                request.getSession(false);


        Integer actorId = null;


        if (session != null) {

            Object actorObject =
                    session.getAttribute("userId");


            if (actorObject instanceof Number) {

                actorId =
                        ((Number) actorObject).intValue();
            }
        }


        if (actorId == null) {

            setErrorAndRedirect(
                    request,
                    response,
                    "Authenticated administrator could not be identified."
            );

            return;
        }


        try {

            userService.changeUserStatus(
                    userId,
                    statusId,
                    actorId
            );


            setSuccessAndRedirect(
                    request,
                    response,
                    "User status updated successfully."
            );


        } catch (IllegalArgumentException e) {

            setErrorAndRedirect(
                    request,
                    response,
                    e.getMessage()
            );


        } catch (Exception e) {

            e.printStackTrace();

            setErrorAndRedirect(
                    request,
                    response,
                    "Unable to change user status."
            );
        }
    }

    private void changeRole(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Integer userId =
                parseId(
                        request.getParameter("id")
                );

        Integer roleId =
                parseId(
                        request.getParameter("roleId")
                );


        if (userId == null ||
                roleId == null) {

            setErrorAndRedirect(
                    request,
                    response,
                    "Invalid user or role."
            );

            return;
        }

        HttpSession session =
                request.getSession(false);


        Integer actorId = null;


        if (session != null) {

            Object actorObject =
                    session.getAttribute("userId");


            if (actorObject instanceof Number) {

                actorId =
                        ((Number) actorObject).intValue();
            }
        }


        if (actorId == null) {

            setErrorAndRedirect(
                    request,
                    response,
                    "Authenticated administrator could not be identified."
            );

            return;
        }


        try {

            userService.changeUserRole(
                    userId,
                    roleId,
                    actorId
            );


            setSuccessAndRedirect(
                    request,
                    response,
                    "User role updated successfully."
            );


        } catch (IllegalArgumentException e) {

            setErrorAndRedirect(
                    request,
                    response,
                    e.getMessage()
            );


        } catch (Exception e) {

            e.printStackTrace();

            setErrorAndRedirect(
                    request,
                    response,
                    "Unable to change user role."
            );
        }
    }

    private void deleteUser(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Integer userId =
                parseId(
                        request.getParameter("id")
                );


        if (userId == null) {

            setErrorAndRedirect(
                    request,
                    response,
                    "Invalid user ID."
            );

            return;
        }

        HttpSession session =
                request.getSession(false);


        Integer actorId = null;


        if (session != null) {

            Object actorObject =
                    session.getAttribute("userId");


            if (actorObject instanceof Number) {

                actorId =
                        ((Number) actorObject).intValue();
            }
        }


        if (actorId == null) {

            setErrorAndRedirect(
                    request,
                    response,
                    "Authenticated administrator could not be identified."
            );

            return;
        }


        try {

            boolean deleted =
                    userService.deleteUser(
                            userId,
                            actorId
                    );


            if (deleted) {

                setSuccessAndRedirect(
                        request,
                        response,
                        "User deleted successfully."
                );

            } else {

                setErrorAndRedirect(
                        request,
                        response,
                        "Unable to delete user."
                );
            }


        } catch (IllegalArgumentException e) {

            setErrorAndRedirect(
                    request,
                    response,
                    e.getMessage()
            );


        } catch (Exception e) {

            e.printStackTrace();

            setErrorAndRedirect(
                    request,
                    response,
                    "User cannot be deleted because this user may be linked to other records."
            );
        }
    }

    private Integer parseId(String value) {

        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {

            return Integer.valueOf(value);

        } catch (NumberFormatException e) {

            return null;
        }
    }

    private void setSuccessAndRedirect(
            HttpServletRequest request,
            HttpServletResponse response,
            String message
    ) throws IOException {

        request.getSession().setAttribute(
                "successMessage",
                message
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/UserServlet?action=list"
        );
    }

    private void setErrorAndRedirect(
            HttpServletRequest request,
            HttpServletResponse response,
            String message
    ) throws IOException {

        request.getSession().setAttribute(
                "errorMessage",
                message
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/UserServlet?action=list"
        );
    }
}