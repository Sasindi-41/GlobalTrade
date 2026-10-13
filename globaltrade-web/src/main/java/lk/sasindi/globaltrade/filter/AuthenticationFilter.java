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

@WebFilter(
        urlPatterns = {
                "/dashboard",
                "/admin/*",
                "/staff/*",
                "/customs/*",
                "/user/*"
        }
)
public class AuthenticationFilter implements Filter {

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

        httpResponse.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate"
        );

        httpResponse.setHeader(
                "Pragma",
                "no-cache"
        );

        httpResponse.setDateHeader(
                "Expires",
                0
        );

        httpResponse.setHeader(
                "X-Content-Type-Options",
                "nosniff"
        );

        httpResponse.setHeader(
                "X-Frame-Options",
                "SAMEORIGIN"
        );

        httpResponse.setHeader(
                "Referrer-Policy",
                "strict-origin-when-cross-origin"
        );

        HttpSession session =
                httpRequest.getSession(false);


        boolean authenticated =
                session != null
                        &&
                        Boolean.TRUE.equals(
                                session.getAttribute(
                                        "authenticated"
                                )
                        );


        if (!authenticated) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                            + "/signin"
            );

            return;
        }

        Object userId =
                session.getAttribute("userId");

        Object role =
                session.getAttribute("role");

        Object username =
                session.getAttribute("username");


        if (userId == null ||
                role == null ||
                username == null) {

            session.invalidate();

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                            + "/signin"
            );

            return;
        }

        chain.doFilter(
                request,
                response
        );
    }
}

