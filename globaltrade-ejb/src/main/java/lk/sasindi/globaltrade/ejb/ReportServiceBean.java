package lk.sasindi.globaltrade.ejb;

import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.dto.ReportSummary;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;

import javax.sql.DataSource;

import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Stateless
public class ReportServiceBean {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    @Resource(lookup = "jdbc/GlobalTradeDS")
    private DataSource dataSource;

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public ReportSummary generateSummary() {

        ReportSummary summary =
                new ReportSummary();

        loadShipmentReports(summary);
        loadVendorReports(summary);
        loadInventoryReports(summary);
        loadRouteReports(summary);
        loadAuditReports(summary);

        return summary;
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public ReportSummary generateReport(
            String reportType,
            LocalDate startDate,
            LocalDate endDate) {

        ReportSummary summary =
                new ReportSummary();


        if (reportType == null ||
                reportType.trim().isEmpty()) {

            return generateSummary();
        }


        String type =
                reportType.trim().toUpperCase();


        switch (type) {

            case "SHIPMENT":

                loadShipmentReport(
                        summary,
                        startDate,
                        endDate
                );

                break;

            case "INVENTORY":

                loadInventoryReports(summary);

                break;

            case "VENDOR":

                loadVendorReports(summary);

                break;

            case "ROUTE":

                loadRouteReports(summary);

                break;

            case "ALERT":

                loadShipmentReports(summary);
                loadInventoryReports(summary);

                break;

            case "AUDIT":

                loadAuditReport(
                        summary,
                        startDate,
                        endDate
                );

                break;

            case "PERFORMANCE":

                loadVendorReports(summary);
                loadRouteReports(summary);

                break;

            default:

                return generateSummary();
        }


        return summary;
    }

    private void loadShipmentReport(
            ReportSummary summary,
            LocalDate startDate,
            LocalDate endDate) {


        if (startDate == null &&
                endDate == null) {

            loadShipmentReports(summary);

            return;
        }


        LocalDateTime startDateTime =
                startDate != null
                        ? startDate.atStartOfDay()
                        : LocalDateTime.of(
                        1900,
                        1,
                        1,
                        0,
                        0
                );


        LocalDateTime endDateTime =
                endDate != null
                        ? endDate
                        .plusDays(1)
                        .atStartOfDay()
                        : LocalDateTime.of(
                        2999,
                        12,
                        31,
                        0,
                        0
                );


        Long total =
                em.createQuery(
                                """
                                SELECT COUNT(s)
                                FROM Shipment s
                                WHERE s.expectedDelivery >= :startDate
                                  AND s.expectedDelivery < :endDate
                                """,
                                Long.class
                        )
                        .setParameter(
                                "startDate",
                                startDateTime
                        )
                        .setParameter(
                                "endDate",
                                endDateTime
                        )
                        .getSingleResult();


        summary.setTotalShipments(
                total != null ? total : 0
        );

        Long pending =
                em.createQuery(
                                """
                                SELECT COUNT(s)
                                FROM Shipment s
                                JOIN s.shipmentStatus status
                                WHERE UPPER(status.name) = 'PENDING'
                                  AND s.expectedDelivery >= :startDate
                                  AND s.expectedDelivery < :endDate
                                """,
                                Long.class
                        )
                        .setParameter(
                                "startDate",
                                startDateTime
                        )
                        .setParameter(
                                "endDate",
                                endDateTime
                        )
                        .getSingleResult();


        summary.setPendingShipments(
                pending != null ? pending : 0
        );

        Long delivered =
                em.createQuery(
                                """
                                SELECT COUNT(s)
                                FROM Shipment s
                                JOIN s.shipmentStatus status
                                WHERE UPPER(status.name) = 'DELIVERED'
                                  AND s.expectedDelivery >= :startDate
                                  AND s.expectedDelivery < :endDate
                                """,
                                Long.class
                        )
                        .setParameter(
                                "startDate",
                                startDateTime
                        )
                        .setParameter(
                                "endDate",
                                endDateTime
                        )
                        .getSingleResult();


        summary.setDeliveredShipments(
                delivered != null ? delivered : 0
        );

        Long cancelled =
                em.createQuery(
                                """
                                SELECT COUNT(s)
                                FROM Shipment s
                                JOIN s.shipmentStatus status
                                WHERE UPPER(status.name) = 'CANCELLED'
                                  AND s.expectedDelivery >= :startDate
                                  AND s.expectedDelivery < :endDate
                                """,
                                Long.class
                        )
                        .setParameter(
                                "startDate",
                                startDateTime
                        )
                        .setParameter(
                                "endDate",
                                endDateTime
                        )
                        .getSingleResult();


        summary.setCancelledShipments(
                cancelled != null ? cancelled : 0
        );
    }

    private void loadShipmentReports(
            ReportSummary summary) {

        Long total =
                em.createQuery(
                                """
                                SELECT COUNT(s)
                                FROM Shipment s
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setTotalShipments(
                total != null ? total : 0
        );


        Long pending =
                em.createQuery(
                                """
                                SELECT COUNT(s)
                                FROM Shipment s
                                JOIN s.shipmentStatus status
                                WHERE UPPER(status.name) = 'PENDING'
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setPendingShipments(
                pending != null ? pending : 0
        );


        Long delivered =
                em.createQuery(
                                """
                                SELECT COUNT(s)
                                FROM Shipment s
                                JOIN s.shipmentStatus status
                                WHERE UPPER(status.name) = 'DELIVERED'
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setDeliveredShipments(
                delivered != null ? delivered : 0
        );


        Long cancelled =
                em.createQuery(
                                """
                                SELECT COUNT(s)
                                FROM Shipment s
                                JOIN s.shipmentStatus status
                                WHERE UPPER(status.name) = 'CANCELLED'
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setCancelledShipments(
                cancelled != null ? cancelled : 0
        );
    }

    private void loadVendorReports(
            ReportSummary summary) {

        Long total =
                em.createQuery(
                                """
                                SELECT COUNT(v)
                                FROM Vendor v
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setTotalVendors(
                total != null ? total : 0
        );


        Long active =
                em.createQuery(
                                """
                                SELECT COUNT(v)
                                FROM Vendor v
                                JOIN v.status status
                                WHERE UPPER(status.name) = 'ACTIVE'
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setActiveVendors(
                active != null ? active : 0
        );


        Double average =
                em.createQuery(
                                """
                                SELECT AVG(v.performanceScore)
                                FROM Vendor v
                                """,
                                Double.class
                        )
                        .getSingleResult();


        summary.setAverageVendorPerformance(
                decimalValue(average)
        );
    }

    private void loadInventoryReports(
            ReportSummary summary) {

        Long total =
                em.createQuery(
                                """
                                SELECT COUNT(i)
                                FROM Inventory i
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setTotalInventoryItems(
                total != null ? total : 0
        );


        Long lowStock =
                em.createQuery(
                                """
                                SELECT COUNT(i)
                                FROM Inventory i
                                WHERE i.quantity <= i.reorderLevel
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setLowStockItems(
                lowStock != null ? lowStock : 0
        );


        BigDecimal inventoryValue =
                em.createQuery(
                                """
                                SELECT SUM(
                                    i.quantity * si.unitValue
                                )
                                FROM Inventory i
                                JOIN i.shipmentItems si
                                """,
                                BigDecimal.class
                        )
                        .getSingleResult();


        if (inventoryValue == null) {

            inventoryValue =
                    BigDecimal.ZERO;
        }


        summary.setTotalInventoryValue(
                inventoryValue.setScale(
                        2,
                        RoundingMode.HALF_UP
                )
        );
    }

    private void loadRouteReports(
            ReportSummary summary) {

        Long total =
                em.createQuery(
                                """
                                SELECT COUNT(r)
                                FROM RouteOptimization r
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setTotalRoutes(
                total != null ? total : 0
        );


        Double averageScore =
                em.createQuery(
                                """
                                SELECT AVG(r.optimizationScore)
                                FROM RouteOptimization r
                                """,
                                Double.class
                        )
                        .getSingleResult();


        summary.setAverageOptimizationScore(
                decimalValue(averageScore)
        );


        Long highScore =
                em.createQuery(
                                """
                                SELECT COUNT(r)
                                FROM RouteOptimization r
                                WHERE r.optimizationScore >= 80
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setHighScoreRoutes(
                highScore != null ? highScore : 0
        );


        Double averageDistance =
                em.createQuery(
                                """
                                SELECT AVG(r.estimatedDistance)
                                FROM RouteOptimization r
                                """,
                                Double.class
                        )
                        .getSingleResult();


        summary.setAverageDistance(
                decimalValue(averageDistance)
        );
    }


    private void loadAuditReport(
            ReportSummary summary,
            LocalDate startDate,
            LocalDate endDate) {

        if (startDate == null &&
                endDate == null) {

            loadAuditReports(summary);

            return;
        }

        LocalDateTime startDateTime =
                startDate != null
                        ? startDate.atStartOfDay()
                        : LocalDateTime.of(
                        1900,
                        1,
                        1,
                        0,
                        0
                );


        LocalDateTime endDateTime =
                endDate != null
                        ? endDate
                        .plusDays(1)
                        .atStartOfDay()
                        : LocalDateTime.of(
                        2999,
                        12,
                        31,
                        0,
                        0
                );


        Long total =
                em.createQuery(
                                """
                                SELECT COUNT(a)
                                FROM AuditLog a
                                WHERE a.timestamp >= :startDate
                                  AND a.timestamp < :endDate
                                """,
                                Long.class
                        )
                        .setParameter(
                                "startDate",
                                startDateTime
                        )
                        .setParameter(
                                "endDate",
                                endDateTime
                        )
                        .getSingleResult();


        summary.setTotalAuditLogs(
                total != null ? total : 0
        );

        Long creates =
                em.createQuery(
                                """
                                SELECT COUNT(a)
                                FROM AuditLog a
                                WHERE
                                    (
                                        UPPER(a.action) LIKE '%CREATE%'
                                        OR
                                        UPPER(a.action) LIKE '%CREATED%'
                                    )
                                    AND a.timestamp >= :startDate
                                    AND a.timestamp < :endDate
                                """,
                                Long.class
                        )
                        .setParameter(
                                "startDate",
                                startDateTime
                        )
                        .setParameter(
                                "endDate",
                                endDateTime
                        )
                        .getSingleResult();


        summary.setCreateAuditLogs(
                creates != null ? creates : 0
        );


        Long updates =
                em.createQuery(
                                """
                                SELECT COUNT(a)
                                FROM AuditLog a
                                WHERE
                                    (
                                        UPPER(a.action) LIKE '%UPDATE%'
                                        OR
                                        UPPER(a.action) LIKE '%UPDATED%'
                                    )
                                    AND a.timestamp >= :startDate
                                    AND a.timestamp < :endDate
                                """,
                                Long.class
                        )
                        .setParameter(
                                "startDate",
                                startDateTime
                        )
                        .setParameter(
                                "endDate",
                                endDateTime
                        )
                        .getSingleResult();


        summary.setUpdateAuditLogs(
                updates != null ? updates : 0
        );


        Long deletes =
                em.createQuery(
                                """
                                SELECT COUNT(a)
                                FROM AuditLog a
                                WHERE
                                    (
                                        UPPER(a.action) LIKE '%DELETE%'
                                        OR
                                        UPPER(a.action) LIKE '%DELETED%'
                                    )
                                    AND a.timestamp >= :startDate
                                    AND a.timestamp < :endDate
                                """,
                                Long.class
                        )
                        .setParameter(
                                "startDate",
                                startDateTime
                        )
                        .setParameter(
                                "endDate",
                                endDateTime
                        )
                        .getSingleResult();


        summary.setDeleteAuditLogs(
                deletes != null ? deletes : 0
        );
    }

    private void loadAuditReports(
            ReportSummary summary) {

        Long total =
                em.createQuery(
                                """
                                SELECT COUNT(a)
                                FROM AuditLog a
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setTotalAuditLogs(
                total != null ? total : 0
        );


        Long creates =
                em.createQuery(
                                """
                                SELECT COUNT(a)
                                FROM AuditLog a
                                WHERE UPPER(a.action) LIKE '%CREATE%'
                                   OR UPPER(a.action) LIKE '%CREATED%'
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setCreateAuditLogs(
                creates != null ? creates : 0
        );


        Long updates =
                em.createQuery(
                                """
                                SELECT COUNT(a)
                                FROM AuditLog a
                                WHERE UPPER(a.action) LIKE '%UPDATE%'
                                   OR UPPER(a.action) LIKE '%UPDATED%'
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setUpdateAuditLogs(
                updates != null ? updates : 0
        );


        Long deletes =
                em.createQuery(
                                """
                                SELECT COUNT(a)
                                FROM AuditLog a
                                WHERE UPPER(a.action) LIKE '%DELETE%'
                                   OR UPPER(a.action) LIKE '%DELETED%'
                                """,
                                Long.class
                        )
                        .getSingleResult();


        summary.setDeleteAuditLogs(
                deletes != null ? deletes : 0
        );
    }

    private BigDecimal decimalValue(
            Double value) {

        if (value == null) {

            return BigDecimal.ZERO.setScale(
                    2,
                    RoundingMode.HALF_UP
            );
        }


        return BigDecimal
                .valueOf(value)
                .setScale(
                        2,
                        RoundingMode.HALF_UP
                );
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public byte[] generatePdfReport(
            String reportType,
            LocalDate startDate,
            LocalDate endDate) {

        if (reportType == null ||
                reportType.isBlank()) {

            throw new IllegalArgumentException(
                    "Report type is required."
            );
        }


        if (startDate == null ||
                endDate == null) {

            throw new IllegalArgumentException(
                    "Report dates are required."
            );
        }


        if (startDate.isAfter(endDate)) {

            throw new IllegalArgumentException(
                    "Start date cannot be after end date."
            );
        }

        String templatePath =
                getTemplatePath(reportType);

        try (
                InputStream template =
                        getClass()
                                .getClassLoader()
                                .getResourceAsStream(
                                        templatePath
                                )
        ) {

            if (template == null) {

                throw new IllegalStateException(
                        "Jasper report template not found: "
                                + templatePath
                );
            }


            JasperReport jasperReport =
                    JasperCompileManager.compileReport(
                            template
                    );


            Map<String, Object> parameters =
                    new HashMap<>();


            parameters.put(
                    "START_DATE",
                    java.sql.Date.valueOf(startDate)
            );


            parameters.put(
                    "END_DATE",
                    java.sql.Date.valueOf(endDate)
            );


            parameters.put(
                    "REPORT_TYPE",
                    reportType
                            .trim()
                            .toUpperCase()
            );


            if (dataSource == null) {

                throw new IllegalStateException(
                        "Payara datasource jdbc/GlobalTradeDS "
                                + "could not be injected."
                );
            }


            try (
                    Connection connection =
                            dataSource.getConnection()
            ) {

                if (connection == null) {

                    throw new IllegalStateException(
                            "Unable to obtain database connection "
                                    + "from jdbc/GlobalTradeDS."
                    );
                }

                JasperPrint jasperPrint =
                        JasperFillManager.fillReport(
                                jasperReport,
                                parameters,
                                connection
                        );


                return JasperExportManager
                        .exportReportToPdf(
                                jasperPrint
                        );
            }


        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException(
                    "Failed to generate Jasper report.",
                    e
            );
        }
    }


    private String getTemplatePath(
            String reportType) {

        switch (
                reportType
                        .trim()
                        .toUpperCase()
        ) {

            case "SHIPMENT":

                return "reports/shipment-report.jrxml";


            case "INVENTORY":

                return "reports/inventory-report.jrxml";


            case "VENDOR":

                return "reports/vendor-report.jrxml";


            case "ROUTE":

                return "reports/route-report.jrxml";


            case "ALERT":

                return "reports/alert-report.jrxml";


            case "AUDIT":

                return "reports/audit-report.jrxml";


            default:

                throw new IllegalArgumentException(
                        "Unsupported report type: "
                                + reportType
                );
        }
    }
}