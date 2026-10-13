package lk.sasindi.globaltrade.test;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.security.WebSecurityUtil;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class WebSecurityUtilTest {


    @Test
    void unauthenticatedRequestShouldReturnFalse() {

        HttpServletRequest request =
                mock(HttpServletRequest.class);


        when(
                request.getSession(false)
        ).thenReturn(null);


        assertFalse(
                WebSecurityUtil.isAuthenticated(
                        request
                )
        );
    }


    @Test
    void authenticatedSessionShouldReturnTrue() {

        HttpServletRequest request =
                mock(HttpServletRequest.class);


        HttpSession session =
                mock(HttpSession.class);


        when(
                request.getSession(false)
        ).thenReturn(session);


        when(
                session.getAttribute(
                        "authenticated"
                )
        ).thenReturn(true);


        assertTrue(
                WebSecurityUtil.isAuthenticated(
                        request
                )
        );
    }


    @Test
    void userIdShouldBeRetrievedFromSession() {

        HttpServletRequest request =
                mock(HttpServletRequest.class);


        HttpSession session =
                mock(HttpSession.class);


        when(
                request.getSession(false)
        ).thenReturn(session);


        when(
                session.getAttribute(
                        "userId"
                )
        ).thenReturn(25);


        assertEquals(
                25,
                WebSecurityUtil.getUserId(
                        request
                )
        );
    }


    @Test
    void numericUserIdShouldBeConverted() {

        HttpServletRequest request =
                mock(HttpServletRequest.class);


        HttpSession session =
                mock(HttpSession.class);


        when(
                request.getSession(false)
        ).thenReturn(session);


        when(
                session.getAttribute(
                        "userId"
                )
        ).thenReturn(Long.valueOf(42));


        assertEquals(
                42,
                WebSecurityUtil.getUserId(
                        request
                )
        );
    }


    @Test
    void roleShouldBeNormalizedToUpperCase() {

        HttpServletRequest request =
                mock(HttpServletRequest.class);


        HttpSession session =
                mock(HttpSession.class);


        when(
                request.getSession(false)
        ).thenReturn(session);


        when(
                session.getAttribute(
                        "role"
                )
        ).thenReturn("admin");


        assertEquals(
                "ADMIN",
                WebSecurityUtil.getRole(
                        request
                )
        );
    }


    @Test
    void correctRoleShouldBeAccepted() {

        HttpServletRequest request =
                authenticatedRequest(
                        "ADMIN"
                );


        assertTrue(
                WebSecurityUtil.hasRole(
                        request,
                        "ADMIN"
                )
        );
    }


    @Test
    void incorrectRoleShouldBeRejected() {

        HttpServletRequest request =
                authenticatedRequest(
                        "STAFF"
                );


        assertFalse(
                WebSecurityUtil.hasRole(
                        request,
                        "ADMIN"
                )
        );
    }


    @Test
    void anyAllowedRoleShouldBeAccepted() {

        HttpServletRequest request =
                authenticatedRequest(
                        "CUSTOMS"
                );


        assertTrue(
                WebSecurityUtil.hasAnyRole(
                        request,
                        "ADMIN",
                        "CUSTOMS"
                )
        );
    }


    @Test
    void unauthorizedRoleShouldBeRejected() {

        HttpServletRequest request =
                authenticatedRequest(
                        "USER"
                );


        assertFalse(
                WebSecurityUtil.hasAnyRole(
                        request,
                        "ADMIN",
                        "CUSTOMS"
                )
        );
    }


    @Test
    void sessionShouldBeInvalidated() {

        HttpServletRequest request =
                mock(HttpServletRequest.class);


        HttpSession session =
                mock(HttpSession.class);


        when(
                request.getSession(false)
        ).thenReturn(session);


        WebSecurityUtil.invalidateSession(
                request
        );


        verify(
                session,
                times(1)
        ).invalidate();
    }


    private HttpServletRequest authenticatedRequest(
            String role
    ) {

        HttpServletRequest request =
                mock(HttpServletRequest.class);


        HttpSession session =
                mock(HttpSession.class);


        when(
                request.getSession(false)
        ).thenReturn(session);


        when(
                session.getAttribute(
                        "authenticated"
                )
        ).thenReturn(true);


        when(
                session.getAttribute(
                        "role"
                )
        ).thenReturn(role);


        return request;
    }
}