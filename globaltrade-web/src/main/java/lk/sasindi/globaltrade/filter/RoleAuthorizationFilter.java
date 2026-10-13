package lk.sasindi.globaltrade.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import lk.sasindi.globaltrade.security.SecurityRoles;

@WebFilter(
        urlPatterns = {
                "/admin/*",
                "/staff/*",
                "/customs/*"
        }
)
public class RoleAuthorizationFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain
    ) throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        HttpSession session =
                httpRequest.getSession(false);


        if (session == null ||
                !Boolean.TRUE.equals(
                        session.getAttribute(
                                "authenticated"
                        )
                )) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                            + "/signin"
            );

            return;
        }

        Object roleObject =
                session.getAttribute("role");

        String role =
                roleObject == null
                        ? null
                        : roleObject
                        .toString()
                        .toUpperCase();


        if (role == null) {

            session.invalidate();

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                            + "/signin"
            );

            return;
        }

        String requestURI =
                httpRequest.getRequestURI();

        String contextPath =
                httpRequest.getContextPath();

        String path =
                requestURI.substring(
                        contextPath.length()
                );

        if (path.startsWith("/admin/")) {

            if (!SecurityRoles.ADMIN.equalsIgnoreCase(
                    role
            )) {

                sendForbidden(httpResponse);
                return;
            }
        }

        if (path.startsWith("/staff/")) {

            if (!SecurityRoles.STAFF.equalsIgnoreCase(role)
                    &&
                    !SecurityRoles.ADMIN.equalsIgnoreCase(
                            role
                    )) {

                sendForbidden(httpResponse);
                return;
            }
        }

        if (path.startsWith("/customs/")) {

            if (!SecurityRoles.CUSTOMS.equalsIgnoreCase(
                    role
            )
                    &&
                    !SecurityRoles.ADMIN.equalsIgnoreCase(
                            role
                    )) {

                sendForbidden(httpResponse);
                return;
            }
        }

        chain.doFilter(
                request,
                response
        );
    }


    private void sendForbidden(
            HttpServletResponse response
    ) throws IOException {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "You are not authorized to access this resource."
        );
    }
}

