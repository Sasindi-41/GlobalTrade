package lk.sasindi.globaltrade.test;

import lk.sasindi.globaltrade.bean.OrderSessionBean;
import lk.sasindi.globaltrade.dao.AddressDAO;
import lk.sasindi.globaltrade.dao.OrderDAO;
import lk.sasindi.globaltrade.dao.UserDAO;
import lk.sasindi.globaltrade.entity.Address;
import lk.sasindi.globaltrade.entity.Order;
import lk.sasindi.globaltrade.entity.User;
import lk.sasindi.globaltrade.exception.OrderException;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrderSessionBeanTest {

    @Mock
    private OrderDAO orderDAO;

    @Mock
    private AddressDAO addressDAO;

    @Mock
    private UserDAO userDAO;

    @InjectMocks
    private OrderSessionBean orderSessionBean;

    private User validUser;
    private Address originAddress;
    private Address destinationAddress;

    @BeforeEach
    void setUp() {

        validUser = new User();
        validUser.setId(1);

        originAddress = new Address();
        originAddress.setId(10);

        destinationAddress = new Address();
        destinationAddress.setId(20);
    }

    @Test
    void createOrderThrowsOrderExceptionWhenUserIdIsNull() {

        assertThrows(
                OrderException.class,
                () -> orderSessionBean.createOrder(
                        null, "Ceramic tiles", 5, 10, 20, null
                )
        );
    }

    @Test
    void createOrderThrowsOrderExceptionWhenUserDoesNotExist() {

        when(userDAO.findById(1)).thenReturn(null);

        OrderException ex = assertThrows(
                OrderException.class,
                () -> orderSessionBean.createOrder(
                        1, "Ceramic tiles", 5, 10, 20, null
                )
        );

        assertTrue(ex.getMessage().toLowerCase().contains("user"));
    }

    @Test
    void createOrderThrowsOrderExceptionWhenDescriptionIsBlank() {

        when(userDAO.findById(1)).thenReturn(validUser);

        assertThrows(
                OrderException.class,
                () -> orderSessionBean.createOrder(
                        1, "   ", 5, 10, 20, null
                )
        );
    }

    @Test
    void createOrderThrowsOrderExceptionWhenQuantityIsZeroOrNegative() {

        when(userDAO.findById(1)).thenReturn(validUser);

        assertThrows(
                OrderException.class,
                () -> orderSessionBean.createOrder(
                        1, "Ceramic tiles", 0, 10, 20, null
                )
        );
    }

    @Test
    void createOrderThrowsOrderExceptionWhenOriginEqualsDestination() {

        when(userDAO.findById(1)).thenReturn(validUser);

        assertThrows(
                OrderException.class,
                () -> orderSessionBean.createOrder(
                        1, "Ceramic tiles", 5, 10, 10, null
                )
        );
    }

    @Test
    void createOrderSucceedsAndDefaultsStatusToPending() throws OrderException {

        when(userDAO.findById(1)).thenReturn(validUser);
        when(addressDAO.findById(10)).thenReturn(originAddress);
        when(addressDAO.findById(20)).thenReturn(destinationAddress);
        when(orderDAO.getNextOrderSequence()).thenReturn(1L);
        when(orderDAO.save(any(Order.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Order result = orderSessionBean.createOrder(
                1, "Ceramic tiles", 5, 10, 20, "Handle with care"
        );

        assertEquals("PENDING", result.getStatus());
        assertEquals(5, result.getQuantity());
        assertEquals("Handle with care", result.getNotes());
        verify(orderDAO, times(1)).save(any(Order.class));
    }

    @Test
    void cancelOrderThrowsOrderExceptionWhenNotOwnedByCaller() {

        Order order = new Order();
        order.setId(99);
        order.setUser(validUser);
        order.setStatus("PENDING");

        when(orderDAO.findById(99)).thenReturn(order);

        OrderException ex = assertThrows(
                OrderException.class,
                () -> orderSessionBean.cancelOrder(99, 2)
        );

        assertTrue(ex.getMessage().toLowerCase().contains("not allowed"));
    }

    @Test
    void cancelOrderThrowsOrderExceptionWhenNotPending() {

        Order order = new Order();
        order.setId(99);
        order.setUser(validUser);
        order.setStatus("APPROVED");

        when(orderDAO.findById(99)).thenReturn(order);

        assertThrows(
                OrderException.class,
                () -> orderSessionBean.cancelOrder(99, 1)
        );
    }

    @Test
    void cancelOrderSucceedsForOwnerWhenPending() throws OrderException {

        Order order = new Order();
        order.setId(99);
        order.setUser(validUser);
        order.setStatus("PENDING");

        when(orderDAO.findById(99)).thenReturn(order);
        when(orderDAO.update(any(Order.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Order result = orderSessionBean.cancelOrder(99, 1);

        assertEquals("CANCELLED", result.getStatus());
    }
}
