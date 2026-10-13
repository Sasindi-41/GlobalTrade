package lk.sasindi.globaltrade.bean;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.inject.Inject;
import jakarta.interceptor.Interceptors;

import lk.sasindi.globaltrade.dao.InvoiceDAO;
import lk.sasindi.globaltrade.dao.ShipmentDAO;
import lk.sasindi.globaltrade.dao.UserDAO;

import lk.sasindi.globaltrade.entity.Invoice;
import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.entity.User;

import lk.sasindi.globaltrade.exception.InvoiceException;

import net.sf.jasperreports.engine.*;


import java.io.InputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lk.sasindi.globaltrade.interceptor.TransactionMonitorInterceptor;


@Stateless
@Interceptors({
        lk.sasindi.globaltrade.interceptor.InvoiceAuditInterceptor.class,
        TransactionMonitorInterceptor.class
})
public class InvoiceSessionBean {

    private static final DateTimeFormatter DATE_FORMAT =
            DateTimeFormatter.ofPattern("dd MMM yyyy");

    @Inject
    private InvoiceDAO invoiceDAO;

    @Inject
    private ShipmentDAO shipmentDAO;

    @Inject
    private UserDAO userDAO;

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Invoice generateInvoiceForShipment(
            Integer shipmentId,
            Integer userId,
            BigDecimal amount
    ) throws InvoiceException {

        Shipment shipment = shipmentDAO.findById(shipmentId);

        if (shipment == null) {
            throw new InvoiceException(
                    "Shipment was not found."
            );
        }

        User user = userDAO.findById(userId);

        if (user == null) {
            throw new InvoiceException(
                    "User was not found."
            );
        }

        Invoice invoice = new Invoice();

        invoice.setInvoiceNumber(generateInvoiceNumber());
        invoice.setShipment(shipment);
        invoice.setUser(user);
        invoice.setAmount(
                amount != null ? amount : BigDecimal.ZERO
        );
        invoice.setStatus("UNPAID");
        invoice.setIssueDate(LocalDate.now());
        invoice.setDueDate(LocalDate.now().plusDays(14));
        invoice.setCreatedAt(LocalDateTime.now());

        return invoiceDAO.save(invoice);
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Invoice markAsPaid(Integer invoiceId, Integer userId) throws InvoiceException {

        Invoice invoice = invoiceDAO.findByIdForUser(invoiceId, userId);

        if (invoice == null) {
            throw new InvoiceException(
                    "Invoice was not found."
            );
        }

        String currentStatus = invoice.getStatus();

        if ("PAID".equalsIgnoreCase(currentStatus)) {
            throw new InvoiceException(
                    "This invoice has already been marked as paid."
            );
        }

        if ("CANCELLED".equalsIgnoreCase(currentStatus)) {
            throw new InvoiceException(
                    "A cancelled invoice cannot be marked as paid."
            );
        }

        if (!"UNPAID".equalsIgnoreCase(currentStatus)
                && !"OVERDUE".equalsIgnoreCase(currentStatus)) {

            throw new InvoiceException(
                    "This invoice cannot be marked as paid."
            );
        }

        invoice.setStatus("PAID");
        invoice.setPaidAt(LocalDateTime.now());

        return invoiceDAO.update(invoice);
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<Invoice> getMyInvoices(Integer userId) {
        return invoiceDAO.findByUser(userId);
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public Invoice getMyInvoice(Integer invoiceId, Integer userId) {
        return invoiceDAO.findByIdForUser(invoiceId, userId);
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public byte[] generateInvoicePdf(Integer invoiceId, Integer userId) {

        Invoice invoice = invoiceDAO.findByIdForUser(invoiceId, userId);

        if (invoice == null) {
            throw new IllegalArgumentException(
                    "Invoice was not found."
            );
        }

        Shipment shipment = invoice.getShipment();

        try (
                InputStream template =
                        getClass()
                                .getClassLoader()
                                .getResourceAsStream("reports/invoice.jrxml")
        ) {

            if (template == null) {
                throw new IllegalStateException(
                        "Jasper invoice template not found: reports/invoice.jrxml"
                );
            }

            JasperReport jasperReport =
                    JasperCompileManager.compileReport(template);

            Map<String, Object> parameters = new HashMap<>();

            parameters.put("INVOICE_NUMBER", invoice.getInvoiceNumber());
            parameters.put("ISSUE_DATE", invoice.getIssueDate().format(DATE_FORMAT));
            parameters.put("DUE_DATE", invoice.getDueDate().format(DATE_FORMAT));
            parameters.put("STATUS", invoice.getStatus());

            parameters.put(
                    "CUSTOMER_NAME",
                    (invoice.getUser().getFirstName() != null
                            ? invoice.getUser().getFirstName() + " "
                            : "")
                            + (invoice.getUser().getLastName() != null
                            ? invoice.getUser().getLastName()
                            : "")
            );
            parameters.put("CUSTOMER_EMAIL", invoice.getUser().getEmail());

            parameters.put("TRACKING_NUMBER", shipment.getTrackingNumber());
            parameters.put(
                    "VENDOR_NAME",
                    shipment.getVendor() != null
                            ? shipment.getVendor().getCompanyName()
                            : "-"
            );
            parameters.put(
                    "ORIGIN_ADDRESS",
                    formatAddress(shipment)
            );
            parameters.put(
                    "DESTINATION_ADDRESS",
                    shipment.getDestinationAddress() != null
                            ? shipment.getDestinationAddress().getLine1()
                            : "-"
            );
            parameters.put(
                    "EXPECTED_DELIVERY",
                    shipment.getExpectedDelivery() != null
                            ? shipment.getExpectedDelivery().format(DATE_FORMAT)
                            : "-"
            );
            parameters.put(
                    "AMOUNT",
                    "Rs. " + invoice.getAmount().setScale(
                            2,
                            java.math.RoundingMode.HALF_UP
                    )
            );

            JasperPrint jasperPrint =
                    JasperFillManager.fillReport(
                            jasperReport,
                            parameters,
                            new JREmptyDataSource()
                    );

            return JasperExportManager.exportReportToPdf(jasperPrint);

        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException(
                    "Failed to generate invoice PDF.",
                    e
            );
        }
    }

    private String formatAddress(Shipment shipment) {

        return shipment.getOriginAddress() != null
                ? shipment.getOriginAddress().getLine1()
                : "-";
    }


    private String generateInvoiceNumber() {

        long sequence = invoiceDAO.getNextInvoiceSequence();

        return "INV-"
                + LocalDateTime.now().getYear()
                + "-"
                + String.format("%05d", sequence);
    }
}
