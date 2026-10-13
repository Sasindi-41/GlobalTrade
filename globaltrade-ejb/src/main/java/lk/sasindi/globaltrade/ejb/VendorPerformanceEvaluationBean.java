package lk.sasindi.globaltrade.ejb;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.entity.Vendor;
import lk.sasindi.globaltrade.entity.VendorPerformance;
import lk.sasindi.globaltrade.interceptor.VendorAuditInterceptor;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;

@Stateless
@Interceptors(VendorAuditInterceptor.class)
public class VendorPerformanceEvaluationBean {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public int evaluateAllVendors() {
        List<Vendor> vendors = em.createQuery(
                "SELECT v FROM Vendor v ORDER BY v.id",
                Vendor.class
        ).getResultList();

        int evaluated = 0;
        for (Vendor vendor : vendors) {
            evaluateVendor(vendor.getId());
            evaluated++;
        }
        return evaluated;
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public VendorPerformance evaluateVendor(Integer vendorId) {
        Vendor vendor = em.find(Vendor.class, vendorId);
        if (vendor == null) {
            return null;
        }

        List<Shipment> shipments = em.createQuery(
                "SELECT s FROM Shipment s " +
                        "LEFT JOIN FETCH s.shipmentStatus " +
                        "WHERE s.vendor.id = :vendorId",
                Shipment.class
        ).setParameter("vendorId", vendorId).getResultList();

        int delivered = 0;
        int onTime = 0;
        int delayed = 0;

        for (Shipment shipment : shipments) {
            if (shipment.getActualDelivery() != null) {
                delivered++;
                if (shipment.getExpectedDelivery() != null &&
                        !shipment.getActualDelivery().isAfter(shipment.getExpectedDelivery())) {
                    onTime++;
                } else {
                    delayed++;
                }
            }
        }

        BigDecimal deliveryScore = delivered == 0
                ? BigDecimal.ZERO
                : percent(onTime, delivered);

        BigDecimal reliabilityScore = shipments.isEmpty()
                ? BigDecimal.ZERO
                : percent(delivered, shipments.size());

        Long alertCount = em.createQuery(
                        "SELECT COUNT(a) FROM Alert a " +
                                "WHERE a.vendor.id = :vendorId " +
                                "AND a.createdAt >= :since",
                        Long.class
                ).setParameter("vendorId", vendorId)
                .setParameter("since", LocalDateTime.now().minusDays(90))
                .getSingleResult();

        BigDecimal qualityScore = BigDecimal.valueOf(
                Math.max(0, 100 - (alertCount * 5))
        ).setScale(2, RoundingMode.HALF_UP);

        BigDecimal overall = deliveryScore.multiply(new BigDecimal("0.50"))
                .add(reliabilityScore.multiply(new BigDecimal("0.25")))
                .add(qualityScore.multiply(new BigDecimal("0.25")))
                .setScale(2, RoundingMode.HALF_UP);

        vendor.setPerformanceScore(overall);
        em.merge(vendor);

        VendorPerformance performance = new VendorPerformance();
        performance.setVendor(vendor);
        performance.setDeliveryScore(deliveryScore);
        performance.setReliabilityScore(reliabilityScore);
        performance.setQualityScore(qualityScore);
        performance.setOverallScore(overall);
        performance.setEvaluationDate(LocalDateTime.now());
        performance.setNote(
                "Automated evaluation: " + delivered + " delivered, " +
                        onTime + " on-time, " + delayed + " delayed shipment(s)."
        );

        em.persist(performance);
        em.flush();
        return performance;
    }

    private BigDecimal percent(int numerator, int denominator) {
        if (denominator <= 0) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
        return BigDecimal.valueOf(numerator)
                .multiply(BigDecimal.valueOf(100))
                .divide(BigDecimal.valueOf(denominator), 2, RoundingMode.HALF_UP);
    }
}
