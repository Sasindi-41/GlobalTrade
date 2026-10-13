package lk.sasindi.globaltrade.test;

import lk.sasindi.globaltrade.bean.InvoiceSessionBean;
import lk.sasindi.globaltrade.dao.InvoiceDAO;
import lk.sasindi.globaltrade.dao.ShipmentDAO;
import lk.sasindi.globaltrade.dao.UserDAO;
import lk.sasindi.globaltrade.entity.Invoice;
import lk.sasindi.globaltrade.exception.InvoiceException;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class InvoiceSessionBeanTest {

    @Mock
    private InvoiceDAO invoiceDAO;

    @Mock
    private ShipmentDAO shipmentDAO;

    @Mock
    private UserDAO userDAO;

    @InjectMocks
    private InvoiceSessionBean invoiceSessionBean;

    private Invoice invoiceWithStatus(String status) {

        Invoice invoice = new Invoice();
        invoice.setId(1);
        invoice.setInvoiceNumber("INV-2026-00001");
        invoice.setAmount(new BigDecimal("150.00"));
        invoice.setStatus(status);

        return invoice;
    }

    @Test
    void markAsPaidThrowsInvoiceExceptionWhenInvoiceNotFound() {

        when(invoiceDAO.findByIdForUser(1, 10)).thenReturn(null);

        assertThrows(
                InvoiceException.class,
                () -> invoiceSessionBean.markAsPaid(1, 10)
        );
    }

    @Test
    void markAsPaidThrowsInvoiceExceptionWhenAlreadyPaid() {

        when(invoiceDAO.findByIdForUser(1, 10))
                .thenReturn(invoiceWithStatus("PAID"));

        InvoiceException ex = assertThrows(
                InvoiceException.class,
                () -> invoiceSessionBean.markAsPaid(1, 10)
        );

        assertTrue(ex.getMessage().toLowerCase().contains("already"));
    }

    @Test
    void markAsPaidThrowsInvoiceExceptionWhenCancelled() {

        when(invoiceDAO.findByIdForUser(1, 10))
                .thenReturn(invoiceWithStatus("CANCELLED"));

        assertThrows(
                InvoiceException.class,
                () -> invoiceSessionBean.markAsPaid(1, 10)
        );
    }

    @Test
    void markAsPaidSucceedsFromUnpaid() throws InvoiceException {

        when(invoiceDAO.findByIdForUser(1, 10))
                .thenReturn(invoiceWithStatus("UNPAID"));

        when(invoiceDAO.update(any(Invoice.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Invoice result = invoiceSessionBean.markAsPaid(1, 10);

        assertEquals("PAID", result.getStatus());
        assertNotNull(result.getPaidAt());
    }

    @Test
    void markAsPaidSucceedsFromOverdue() throws InvoiceException {

        when(invoiceDAO.findByIdForUser(1, 10))
                .thenReturn(invoiceWithStatus("OVERDUE"));

        when(invoiceDAO.update(any(Invoice.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Invoice result = invoiceSessionBean.markAsPaid(1, 10);

        assertEquals("PAID", result.getStatus());
    }
}
