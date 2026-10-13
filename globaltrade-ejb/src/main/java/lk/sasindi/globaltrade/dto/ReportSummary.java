package lk.sasindi.globaltrade.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class ReportSummary implements Serializable {

    private static final long serialVersionUID = 1L;

    private long totalShipments;
    private long pendingShipments;
    private long deliveredShipments;
    private long cancelledShipments;

    private long totalVendors;
    private long activeVendors;
    private BigDecimal averageVendorPerformance;

    private long totalInventoryItems;
    private long lowStockItems;
    private BigDecimal totalInventoryValue;

    private long totalRoutes;
    private BigDecimal averageOptimizationScore;
    private long highScoreRoutes;
    private BigDecimal averageDistance;

    private long totalAuditLogs;
    private long createAuditLogs;
    private long updateAuditLogs;
    private long deleteAuditLogs;

    public ReportSummary() {
    }

    public long getTotalShipments() {
        return totalShipments;
    }

    public void setTotalShipments(long totalShipments) {
        this.totalShipments = totalShipments;
    }

    public long getPendingShipments() {
        return pendingShipments;
    }

    public void setPendingShipments(long pendingShipments) {
        this.pendingShipments = pendingShipments;
    }

    public long getDeliveredShipments() {
        return deliveredShipments;
    }

    public void setDeliveredShipments(long deliveredShipments) {
        this.deliveredShipments = deliveredShipments;
    }

    public long getCancelledShipments() {
        return cancelledShipments;
    }

    public void setCancelledShipments(long cancelledShipments) {
        this.cancelledShipments = cancelledShipments;
    }

    public long getTotalVendors() {
        return totalVendors;
    }

    public void setTotalVendors(long totalVendors) {
        this.totalVendors = totalVendors;
    }

    public long getActiveVendors() {
        return activeVendors;
    }

    public void setActiveVendors(long activeVendors) {
        this.activeVendors = activeVendors;
    }

    public BigDecimal getAverageVendorPerformance() {
        return averageVendorPerformance;
    }

    public void setAverageVendorPerformance(
            BigDecimal averageVendorPerformance) {
        this.averageVendorPerformance = averageVendorPerformance;
    }

    public long getTotalInventoryItems() {
        return totalInventoryItems;
    }

    public void setTotalInventoryItems(long totalInventoryItems) {
        this.totalInventoryItems = totalInventoryItems;
    }

    public long getLowStockItems() {
        return lowStockItems;
    }

    public void setLowStockItems(long lowStockItems) {
        this.lowStockItems = lowStockItems;
    }

    public BigDecimal getTotalInventoryValue() {
        return totalInventoryValue;
    }

    public void setTotalInventoryValue(
            BigDecimal totalInventoryValue) {
        this.totalInventoryValue = totalInventoryValue;
    }

    public long getTotalRoutes() {
        return totalRoutes;
    }

    public void setTotalRoutes(long totalRoutes) {
        this.totalRoutes = totalRoutes;
    }

    public BigDecimal getAverageOptimizationScore() {
        return averageOptimizationScore;
    }

    public void setAverageOptimizationScore(
            BigDecimal averageOptimizationScore) {
        this.averageOptimizationScore = averageOptimizationScore;
    }

    public long getHighScoreRoutes() {
        return highScoreRoutes;
    }

    public void setHighScoreRoutes(long highScoreRoutes) {
        this.highScoreRoutes = highScoreRoutes;
    }

    public BigDecimal getAverageDistance() {
        return averageDistance;
    }

    public void setAverageDistance(BigDecimal averageDistance) {
        this.averageDistance = averageDistance;
    }

    public long getTotalAuditLogs() {
        return totalAuditLogs;
    }

    public void setTotalAuditLogs(long totalAuditLogs) {
        this.totalAuditLogs = totalAuditLogs;
    }

    public long getCreateAuditLogs() {
        return createAuditLogs;
    }

    public void setCreateAuditLogs(long createAuditLogs) {
        this.createAuditLogs = createAuditLogs;
    }

    public long getUpdateAuditLogs() {
        return updateAuditLogs;
    }

    public void setUpdateAuditLogs(long updateAuditLogs) {
        this.updateAuditLogs = updateAuditLogs;
    }

    public long getDeleteAuditLogs() {
        return deleteAuditLogs;
    }

    public void setDeleteAuditLogs(long deleteAuditLogs) {
        this.deleteAuditLogs = deleteAuditLogs;
    }
}