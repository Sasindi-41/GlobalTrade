package lk.sasindi.globaltrade.entity;

import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(
        name = "route_optimizations",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_route_optimization_shipment",
                        columnNames = "shipments_id"
                )
        }
)
public class RouteOptimization
        implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(
            strategy = GenerationType.IDENTITY
    )
    @Column(
            name = "id",
            nullable = false
    )
    private Integer id;

    @Column(
            name = "estimated_distance",
            nullable = false,
            precision = 10,
            scale = 2
    )
    private BigDecimal estimatedDistance;

    @Column(
            name = "estimated_duration",
            nullable = false
    )
    private Integer estimatedDuration;

    @Column(
            name = "optimization_score",
            nullable = false,
            precision = 5,
            scale = 2
    )
    private BigDecimal optimizationScore;

    @Lob
    @Column(
            name = "recommended_route",
            nullable = false,
            columnDefinition = "TEXT"
    )
    private String recommendedRoute;

    @Column(
            name = "calculated_at",
            nullable = false
    )
    private LocalDateTime calculatedAt;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "shipments_id",
            nullable = false,
            unique = true
    )
    private Shipment shipment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "origin_address",
            nullable = false
    )
    private Address originAddress;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "destination_address",
            nullable = false
    )
    private Address destinationAddress;

    public RouteOptimization() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }


    public BigDecimal getEstimatedDistance() {
        return estimatedDistance;
    }

    public void setEstimatedDistance(
            BigDecimal estimatedDistance
    ) {
        this.estimatedDistance = estimatedDistance;
    }


    public Integer getEstimatedDuration() {
        return estimatedDuration;
    }

    public void setEstimatedDuration(
            Integer estimatedDuration
    ) {
        this.estimatedDuration = estimatedDuration;
    }


    public BigDecimal getOptimizationScore() {
        return optimizationScore;
    }

    public void setOptimizationScore(
            BigDecimal optimizationScore
    ) {
        this.optimizationScore = optimizationScore;
    }


    public String getRecommendedRoute() {
        return recommendedRoute;
    }

    public void setRecommendedRoute(
            String recommendedRoute
    ) {
        this.recommendedRoute = recommendedRoute;
    }


    public LocalDateTime getCalculatedAt() {
        return calculatedAt;
    }

    public void setCalculatedAt(
            LocalDateTime calculatedAt
    ) {
        this.calculatedAt = calculatedAt;
    }


    public Shipment getShipment() {
        return shipment;
    }

    public void setShipment(
            Shipment shipment
    ) {
        this.shipment = shipment;
    }


    public Address getOriginAddress() {
        return originAddress;
    }

    public void setOriginAddress(
            Address originAddress
    ) {
        this.originAddress = originAddress;
    }


    public Address getDestinationAddress() {
        return destinationAddress;
    }

    public void setDestinationAddress(
            Address destinationAddress
    ) {
        this.destinationAddress = destinationAddress;
    }

    @Transient
    public String getOrigin() {

        return buildAddressText(
                originAddress
        );
    }


    @Transient
    public String getDestination() {

        return buildAddressText(
                destinationAddress
        );
    }


    private String buildAddressText(
            Address address
    ) {

        if (address == null) {
            return "";
        }


        StringBuilder text =
                new StringBuilder();


        if (address.getLine1() != null &&
                !address.getLine1().trim().isEmpty()) {

            text.append(
                    address.getLine1().trim()
            );
        }


        if (address.getLine2() != null &&
                !address.getLine2().trim().isEmpty()) {

            if (text.length() > 0) {
                text.append(", ");
            }

            text.append(
                    address.getLine2().trim()
            );
        }


        if (address.getCity() != null &&
                address.getCity().getName() != null) {

            if (text.length() > 0) {
                text.append(", ");
            }

            text.append(
                    address.getCity().getName()
            );
        }


        if (address.getCountry() != null &&
                address.getCountry().getName() != null) {

            if (text.length() > 0) {
                text.append(", ");
            }

            text.append(
                    address.getCountry().getName()
            );
        }


        if (address.getPostalCode() != null &&
                !address.getPostalCode().trim().isEmpty()) {

            if (text.length() > 0) {
                text.append(" - ");
            }

            text.append(
                    address.getPostalCode().trim()
            );
        }


        return text.toString();
    }
}