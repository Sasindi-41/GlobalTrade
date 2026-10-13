<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sasindi.globaltrade.entity.*" %>
<%@ page import="java.util.List" %>
<%
  request.setAttribute("activePage", "access-control");

  List<Role> roles = (List<Role>) request.getAttribute("roles");
  List<Permission> permissions = (List<Permission>) request.getAttribute("permissions");
  List<RolePermission> rolePermissions = (List<RolePermission>) request.getAttribute("rolePermissions");

  String errorMessage = (String) request.getAttribute("errorMessage");
  String successMessage = (String) request.getAttribute("successMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>GlobalTrade | Access Control</title>

  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/admin/assets/admin-style.css">

</head>
<body>

<jsp:include page="admin-sidebar.jsp"/>

<main class="main">

  <jsp:include page="admin-topbar.jsp"/>

  <section class="content">

    <div class="page-heading">
      <div>
        <h1>Access Control</h1>
        <p>Grant or revoke permissions per role - the programmatic
          authorization layer </p>
      </div>
    </div>

    <% if (errorMessage != null) { %>
    <div class="flash-message flash-error">
      <i class="fa-solid fa-circle-exclamation"></i>
      <%= errorMessage %>
    </div>
    <% } %>

    <% if (successMessage != null) { %>
    <div class="flash-message flash-success">
      <i class="fa-solid fa-circle-check"></i>
      <%= successMessage %>
    </div>
    <% } %>

    <div class="page-grid">

      <div class="card">

        <div class="card-header">
          <h2>Role &rarr; Permission Grants</h2>
        </div>

        <div class="table-wrap">

          <% if (rolePermissions == null || rolePermissions.isEmpty()) { %>

          <div class="empty-state">
            <i class="fa-solid fa-user-shield"></i>
            <p>No permissions have been granted to any role yet.
              Create a permission and grant it using the form.</p>
          </div>

          <% } else { %>

          <table>
            <thead>
            <tr>
              <th>Role</th>
              <th>Permission</th>
              <th>Description</th>
              <th></th>
            </tr>
            </thead>
            <tbody>

            <% for (RolePermission rp : rolePermissions) { %>

            <tr>
              <td><strong><%= rp.getRole().getName() %></strong></td>
              <td>
                                <span class="status-pill status-active">
                                    <%= rp.getPermission().getName() %>
                                </span>
              </td>
              <td>
                <%= rp.getPermission().getDescription() != null
                        ? rp.getPermission().getDescription() : "-" %>
              </td>
              <td>
                <form method="post"
                      action="${pageContext.request.contextPath}/access-control"
                      style="display:inline;">
                  <input type="hidden" name="action" value="revoke">
                  <input type="hidden" name="rolePermissionId" value="<%= rp.getId() %>">
                  <button type="submit" class="btn btn-danger"
                          style="padding:6px 10px;font-size:9px;">
                    Revoke
                  </button>
                </form>
              </td>
            </tr>

            <% } %>

            </tbody>
          </table>

          <% } %>

        </div>

      </div>

      <div>

        <div class="card">

          <div class="card-header">
            <h2>Grant a Permission</h2>
          </div>

          <form method="post"
                action="${pageContext.request.contextPath}/access-control">

            <input type="hidden" name="action" value="grant">

            <div style="padding: 0 18px;">

              <div class="form-group">
                <label>Role</label>
                <select name="roleId" required>
                  <option value="">Select role</option>
                  <% if (roles != null) {
                    for (Role role : roles) { %>
                  <option value="<%= role.getId() %>"><%= role.getName() %></option>
                  <% } } %>
                </select>
              </div>

              <div class="form-group">
                <label>Permission</label>
                <select name="permissionId" required>
                  <option value="">Select permission</option>
                  <% if (permissions != null) {
                    for (Permission permission : permissions) { %>
                  <option value="<%= permission.getId() %>">
                    <%= permission.getName() %>
                  </option>
                  <% } } %>
                </select>
              </div>

            </div>

            <div class="form-actions">
              <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-check"></i>
                Grant
              </button>
            </div>

          </form>

        </div>

        <div class="card" style="margin-top:14px;">

          <div class="card-header">
            <h2>New Permission</h2>
          </div>

          <form method="post"
                action="${pageContext.request.contextPath}/access-control">

            <input type="hidden" name="action" value="createPermission">

            <div style="padding: 0 18px;">

              <div class="form-group">
                <label>Name</label>
                <input type="text" name="name"
                       placeholder="e.g. MANAGE_VENDORS" required>
              </div>

              <div class="form-group">
                <label>Description</label>
                <input type="text" name="description"
                       placeholder="What this permission allows">
              </div>

            </div>

            <div class="form-actions">
              <button type="submit" class="btn btn-secondary">
                <i class="fa-solid fa-plus"></i>
                Create Permission
              </button>
            </div>

          </form>

        </div>

      </div>

    </div>

    <footer class="footer" style="margin-top:14px;">
      <span>&copy; 2026 GlobalTrade Logistics System. All rights reserved.</span>
      <span>Version 1.0.0</span>
    </footer>

  </section>

</main>

</body>
</html>
