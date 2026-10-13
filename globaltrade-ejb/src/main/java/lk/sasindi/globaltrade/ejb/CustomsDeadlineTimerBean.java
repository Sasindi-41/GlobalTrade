package lk.sasindi.globaltrade.ejb;

import jakarta.ejb.EJB;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Alert;
import lk.sasindi.globaltrade.entity.AlertStatus;
import lk.sasindi.globaltrade.entity.AlertType;
import lk.sasindi.globaltrade.entity.CustomDocument;
import lk.sasindi.globaltrade.entity.Inventory;
import lk.sasindi.globaltrade.entity.Severity;
import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.entity.JobExecutionLog;
import lk.sasindi.globaltrade.service.TimerJobService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;


@Singleton
@Startup
public class CustomsDeadlineTimerBean {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    @EJB
    private TimerJobService timerJobService;

    @Schedule(
            second = "0",
            minute = "*/30",
            hour = "*",
            persistent = true
    )
    public void monitorCustomsDeadlines() {
        String jobName = "Customs Deadline Monitoring Job";
        JobExecutionLog log = null;

        try {
            log = timerJobService.startExecution(jobName);
            int records = processExpiringDocuments();
            timerJobService.completeSuccessfully(log, records);
            System.out.println(
                    "[CUSTOMS-TIMER] Processed " + records + " document(s)."
            );
        } catch (Exception e) {
            if (log != null) {
                try {
                    timerJobService.completeWithFailure(log, e);
                } catch (Exception logException) {
                    logException.printStackTrace();
                }
            }
            System.err.println("[CUSTOMS-TIMER] Failed: " + e.getMessage());
        }
    }

    private int processExpiringDocuments() {
        LocalDate today = LocalDate.now();
        LocalDate threshold = today.plusDays(3);

        List<CustomDocument> documents = em.createQuery(
                "SELECT DISTINCT d FROM CustomDocument d " +
                        "JOIN FETCH d.shipment s " +
                        "JOIN FETCH s.vendor v " +
                        "JOIN FETCH d.documentType t " +
                        "JOIN FETCH d.documentStatus st " +
                        "WHERE d.expiryDate IS NOT NULL " +
                        "AND d.expiryDate <= :threshold " +
                        "AND UPPER(st.name) <> 'EXPIRED'",
                CustomDocument.class
        ).setParameter("threshold", threshold).getResultList();

        int processed = 0;
        for (CustomDocument document : documents) {
            createDeadlineAlertIfPossible(document, today);
            processed++;
        }
        return processed;
    }

    private void createDeadlineAlertIfPossible(CustomDocument document, LocalDate today) {
        Shipment shipment = document.getShipment();
        if (shipment == null || shipment.getVendor() == null) {
            return;
        }

        Inventory inventory = em.createQuery(
                        "SELECT si.inventory FROM ShipmentItem si " +
                                "WHERE si.shipment.id = :shipmentId " +
                                "AND si.inventory IS NOT NULL " +
                                "ORDER BY si.id",
                        Inventory.class
                ).setParameter("shipmentId", shipment.getId())
                .setMaxResults(1)
                .getResultStream()
                .findFirst()
                .orElse(null);


        if (inventory == null) {
            return;
        }

        AlertType type = findByName(AlertType.class, "Customs Deadline");
        AlertStatus open = findByName(AlertStatus.class, "OPEN");
        Severity severity = findByName(
                Severity.class,
                document.getExpiryDate().isBefore(today) ? "CRITICAL" : "WARNING"
        );

        if (type == null || open == null || severity == null) {
            System.err.println(
                    "[CUSTOMS-TIMER] Required alert reference data is missing. " +
                            "Seed Customs Deadline / OPEN / WARNING / CRITICAL."
            );
            return;
        }

        Long existing = em.createQuery(
                        "SELECT COUNT(a) FROM Alert a " +
                                "WHERE a.shipment.id = :shipmentId " +
                                "AND a.alertType.id = :typeId " +
                                "AND a.alertStatus.id = :statusId " +
                                "AND a.message LIKE :message",
                        Long.class
                ).setParameter("shipmentId", shipment.getId())
                .setParameter("typeId", type.getId())
                .setParameter("statusId", open.getId())
                .setParameter("message", "%" + document.getDocumentNumber() + "%")
                .getSingleResult();

        if (existing > 0) {
            return;
        }

        long days = ChronoUnit.DAYS.between(today, document.getExpiryDate());
        String message = days < 0
                ? "Customs document " + document.getDocumentNumber() +
                " has expired and requires compliance review."
                : "Customs document " + document.getDocumentNumber() +
                " expires in " + days + " day(s) on " + document.getExpiryDate() + ".";

        Alert alert = new Alert();
        alert.setMessage(message);
        alert.setCreatedAt(LocalDateTime.now());
        alert.setShipment(shipment);
        alert.setVendor(shipment.getVendor());
        alert.setInventory(inventory);
        alert.setAlertType(type);
        alert.setSeverity(severity);
        alert.setAlertStatus(open);
        em.persist(alert);
    }

    private <T> T findByName(Class<T> entityClass, String name) {
        return em.createQuery(
                        "SELECT e FROM " + entityClass.getSimpleName() +
                                " e WHERE UPPER(e.name) = UPPER(:name)",
                        entityClass
                ).setParameter("name", name)
                .setMaxResults(1)
                .getResultStream()
                .findFirst()
                .orElse(null);
    }
}
