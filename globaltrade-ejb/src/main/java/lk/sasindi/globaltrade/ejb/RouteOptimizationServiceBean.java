package lk.sasindi.globaltrade.ejb;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.entity.Address;
import lk.sasindi.globaltrade.entity.RouteOptimization;
import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.exception.RouteOptimizationException;
import lk.sasindi.globaltrade.interceptor.RouteAuditInterceptor;
import lk.sasindi.globaltrade.interceptor.RoutePerformanceInterceptor;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.interceptor.Interceptors;
import lk.sasindi.globaltrade.interceptor.TransactionMonitorInterceptor;
@Stateless
@Interceptors({
        RouteAuditInterceptor.class,
        RoutePerformanceInterceptor.class,
        TransactionMonitorInterceptor.class
})
public class RouteOptimizationServiceBean {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<RouteOptimization> getAllRoutes() {

        return em.createQuery(
                """
                SELECT DISTINCT r
                FROM RouteOptimization r

                LEFT JOIN FETCH r.shipment s
                LEFT JOIN FETCH s.vendor

                LEFT JOIN FETCH r.originAddress oa
                LEFT JOIN FETCH oa.country
                LEFT JOIN FETCH oa.city

                LEFT JOIN FETCH r.destinationAddress da
                LEFT JOIN FETCH da.country
                LEFT JOIN FETCH da.city

                ORDER BY r.calculatedAt DESC
                """,
                RouteOptimization.class
        ).getResultList();
    }

    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<Shipment> getAllShipments() {

        return em.createQuery(
                """
                SELECT DISTINCT s
                FROM Shipment s

                LEFT JOIN FETCH s.vendor

                LEFT JOIN FETCH s.originAddress oa
                LEFT JOIN FETCH oa.country
                LEFT JOIN FETCH oa.city

                LEFT JOIN FETCH s.destinationAddress da
                LEFT JOIN FETCH da.country
                LEFT JOIN FETCH da.city

                ORDER BY s.createdAt DESC
                """,
                Shipment.class
        ).getResultList();
    }


    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public RouteOptimization createRoute(
            Integer shipmentId,
            Integer userId
    ) throws RouteOptimizationException {

        validateIds(shipmentId, userId);

        Shipment shipment =
                findShipment(shipmentId);

        validateShipmentAddresses(shipment);


        RouteOptimization existingRoute =
                findRouteByShipment(shipmentId);


        if (existingRoute != null) {

            return calculateAndUpdateRoute(
                    existingRoute,
                    shipment
            );
        }

        Address origin =
                shipment.getOriginAddress();

        Address destination =
                shipment.getDestinationAddress();


        validateDifferentAddresses(
                origin,
                destination
        );

        RouteCalculation calculation =
                calculateRoute(
                        origin,
                        destination
                );

        RouteOptimization route =
                new RouteOptimization();

        route.setShipment(shipment);

        route.setOriginAddress(origin);

        route.setDestinationAddress(destination);

        route.setEstimatedDistance(
                calculation.distance()
        );

        route.setEstimatedDuration(
                calculation.duration()
        );

        route.setOptimizationScore(
                calculation.score()
        );

        route.setRecommendedRoute(
                calculation.recommendedRoute()
        );

        route.setCalculatedAt(
                LocalDateTime.now()
        );


        em.persist(route);

        em.flush();

        return route;
    }


    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public RouteOptimization optimizeRoute(
            Integer id,
            Integer userId
    ) throws RouteOptimizationException {

        if (id == null) {
            throw new RouteOptimizationException(
                    "Route ID is required."
            );
        }

        if (userId == null) {
            throw new RouteOptimizationException(
                    "User ID is required."
            );
        }


        RouteOptimization route =
                em.find(
                        RouteOptimization.class,
                        id
                );


        if (route == null) {

            throw new RouteOptimizationException(
                    "Route optimization record was not found."
            );
        }


        Shipment shipment =
                route.getShipment();


        if (shipment == null) {

            throw new RouteOptimizationException(
                    "The route is not associated with a shipment."
            );
        }


        validateShipmentAddresses(shipment);

        Address origin =
                shipment.getOriginAddress();

        Address destination =
                shipment.getDestinationAddress();


        validateDifferentAddresses(
                origin,
                destination
        );

        RouteCalculation calculation =
                calculateRoute(
                        origin,
                        destination
                );


        route.setOriginAddress(origin);

        route.setDestinationAddress(destination);

        route.setEstimatedDistance(
                calculation.distance()
        );

        route.setEstimatedDuration(
                calculation.duration()
        );

        route.setOptimizationScore(
                calculation.score()
        );

        route.setRecommendedRoute(
                calculation.recommendedRoute()
        );

        route.setCalculatedAt(
                LocalDateTime.now()
        );


        return route;
    }


    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public int optimizeAllRoutes() {

        List<RouteOptimization> routes =
                em.createQuery(
                        """
                        SELECT r
                        FROM RouteOptimization r
                        JOIN FETCH r.shipment s
                        JOIN FETCH s.originAddress
                        JOIN FETCH s.destinationAddress
                        """,
                        RouteOptimization.class
                ).getResultList();


        int count = 0;


        for (RouteOptimization route : routes) {

            Shipment shipment =
                    route.getShipment();


            if (shipment == null ||
                    shipment.getOriginAddress() == null ||
                    shipment.getDestinationAddress() == null) {

                continue;
            }


            Address origin =
                    shipment.getOriginAddress();

            Address destination =
                    shipment.getDestinationAddress();


            if (origin.getCountry() == null ||
                    origin.getCity() == null ||
                    destination.getCountry() == null ||
                    destination.getCity() == null) {

                continue;
            }


            RouteCalculation calculation =
                    calculateRoute(
                            origin,
                            destination
                    );


            route.setOriginAddress(origin);

            route.setDestinationAddress(destination);

            route.setEstimatedDistance(
                    calculation.distance()
            );

            route.setEstimatedDuration(
                    calculation.duration()
            );

            route.setOptimizationScore(
                    calculation.score()
            );

            route.setRecommendedRoute(
                    calculation.recommendedRoute()
            );

            route.setCalculatedAt(
                    LocalDateTime.now()
            );


            count++;
        }


        return count;
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void deleteRoute(
            Integer id,
            Integer userId
    ) throws RouteOptimizationException {

        if (id == null) {

            throw new RouteOptimizationException(
                    "Route ID is required."
            );
        }

        if (userId == null) {

            throw new RouteOptimizationException(
                    "User ID is required."
            );
        }


        RouteOptimization route =
                em.find(
                        RouteOptimization.class,
                        id
                );


        if (route == null) {

            throw new RouteOptimizationException(
                    "Route optimization record was not found."
            );
        }


        em.remove(route);
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public long getTotalCount() {

        return em.createQuery(
                """
                SELECT COUNT(r)
                FROM RouteOptimization r
                """,
                Long.class
        ).getSingleResult();
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public BigDecimal getAverageScore() {

        Double result =
                em.createQuery(
                        """
                        SELECT AVG(r.optimizationScore)
                        FROM RouteOptimization r
                        """,
                        Double.class
                ).getSingleResult();


        if (result == null) {

            return BigDecimal.ZERO.setScale(
                    2,
                    RoundingMode.HALF_UP
            );
        }


        return BigDecimal
                .valueOf(result)
                .setScale(
                        2,
                        RoundingMode.HALF_UP
                );
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public long getHighScoreCount() {

        return em.createQuery(
                """
                SELECT COUNT(r)
                FROM RouteOptimization r
                WHERE r.optimizationScore >= 80
                """,
                Long.class
        ).getSingleResult();
    }


    private Shipment findShipment(
            Integer shipmentId
    ) throws RouteOptimizationException {

        Shipment shipment =
                em.find(
                        Shipment.class,
                        shipmentId
                );


        if (shipment == null) {

            throw new RouteOptimizationException(
                    "Selected shipment was not found."
            );
        }


        return shipment;
    }

    private RouteOptimization findRouteByShipment(
            Integer shipmentId
    ) {

        List<RouteOptimization> results =
                em.createQuery(
                                """
                                SELECT r
                                FROM RouteOptimization r
                                WHERE r.shipment.id = :shipmentId
                                """,
                                RouteOptimization.class
                        )
                        .setParameter(
                                "shipmentId",
                                shipmentId
                        )
                        .setMaxResults(1)
                        .getResultList();


        if (results.isEmpty()) {
            return null;
        }


        return results.get(0);
    }

    private RouteOptimization calculateAndUpdateRoute(
            RouteOptimization route,
            Shipment shipment
    ) throws RouteOptimizationException {

        validateShipmentAddresses(shipment);


        Address origin =
                shipment.getOriginAddress();

        Address destination =
                shipment.getDestinationAddress();


        validateDifferentAddresses(
                origin,
                destination
        );


        RouteCalculation calculation =
                calculateRoute(
                        origin,
                        destination
                );


        route.setShipment(shipment);

        route.setOriginAddress(origin);

        route.setDestinationAddress(destination);

        route.setEstimatedDistance(
                calculation.distance()
        );

        route.setEstimatedDuration(
                calculation.duration()
        );

        route.setOptimizationScore(
                calculation.score()
        );

        route.setRecommendedRoute(
                calculation.recommendedRoute()
        );

        route.setCalculatedAt(
                LocalDateTime.now()
        );


        return route;
    }

    private void validateIds(
            Integer shipmentId,
            Integer userId
    ) throws RouteOptimizationException {

        if (shipmentId == null) {

            throw new RouteOptimizationException(
                    "Shipment is required."
            );
        }


        if (userId == null) {

            throw new RouteOptimizationException(
                    "User ID is required."
            );
        }
    }


    private void validateShipmentAddresses(
            Shipment shipment
    ) throws RouteOptimizationException {

        if (shipment.getOriginAddress() == null) {

            throw new RouteOptimizationException(
                    "The selected shipment does not have an origin address."
            );
        }


        if (shipment.getDestinationAddress() == null) {

            throw new RouteOptimizationException(
                    "The selected shipment does not have a destination address."
            );
        }


        Address origin =
                shipment.getOriginAddress();

        Address destination =
                shipment.getDestinationAddress();


        if (origin.getCountry() == null ||
                origin.getCity() == null) {

            throw new RouteOptimizationException(
                    "The shipment origin address is missing country/city information."
            );
        }


        if (destination.getCountry() == null ||
                destination.getCity() == null) {

            throw new RouteOptimizationException(
                    "The shipment destination address is missing country/city information."
            );
        }
    }


    private void validateDifferentAddresses(
            Address origin,
            Address destination
    ) throws RouteOptimizationException {

        if (origin.getId() != null &&
                origin.getId().equals(destination.getId())) {

            throw new RouteOptimizationException(
                    "Origin and destination cannot be the same address."
            );
        }
    }

    private RouteCalculation calculateRoute(
            Address origin,
            Address destination
    ) {

        boolean sameCountry =
                origin.getCountry() != null &&
                        destination.getCountry() != null &&
                        origin.getCountry()
                                .getId()
                                .equals(
                                        destination.getCountry().getId()
                                );


        boolean sameCity =
                origin.getCity() != null &&
                        destination.getCity() != null &&
                        origin.getCity()
                                .getId()
                                .equals(
                                        destination.getCity().getId()
                                );


        double distance;


        if (sameCity) {

            distance = 12.0;

        } else if (sameCountry) {

            int cityDifference =
                    Math.abs(
                            safeId(origin.getCity()) -
                                    safeId(destination.getCity())
                    );


            distance =
                    80.0 +
                            Math.min(
                                    cityDifference * 7.5,
                                    420.0
                            );

        } else {

            int countryDifference =
                    Math.abs(
                            safeId(origin.getCountry()) -
                                    safeId(destination.getCountry())
                    );


            int cityDifference =
                    Math.abs(
                            safeId(origin.getCity()) -
                                    safeId(destination.getCity())
                    );


            distance =
                    650.0 +
                            Math.min(
                                    countryDifference * 180.0,
                                    900.0
                            ) +
                            Math.min(
                                    cityDifference * 4.0,
                                    300.0
                            );
        }

        double averageSpeed =
                sameCity
                        ? 30.0
                        : sameCountry
                        ? 50.0
                        : 60.0;

        int duration =
                Math.max(
                        30,
                        (int) Math.ceil(
                                (distance / averageSpeed) * 60.0
                        ) + 30
                );


        BigDecimal distanceValue =
                BigDecimal
                        .valueOf(distance)
                        .setScale(
                                2,
                                RoundingMode.HALF_UP
                        );


        BigDecimal score =
                calculateOptimizationScore(
                        distanceValue,
                        duration
                );


        String recommendedRoute =
                buildRecommendedRoute(
                        origin,
                        destination,
                        distanceValue,
                        duration,
                        sameCountry,
                        sameCity
                );


        return new RouteCalculation(
                distanceValue,
                duration,
                score,
                recommendedRoute
        );
    }

    private BigDecimal calculateOptimizationScore(
            BigDecimal distance,
            Integer duration
    ) {

        double distanceScore =
                Math.max(
                        0,
                        100.0 -
                                (distance.doubleValue() / 20.0)
                );


        double durationScore =
                Math.max(
                        0,
                        100.0 -
                                (duration.doubleValue() / 20.0)
                );


        double finalScore =
                (distanceScore * 0.50) +
                        (durationScore * 0.50);


        finalScore =
                Math.min(
                        100.0,
                        Math.max(
                                0.0,
                                finalScore
                        )
                );


        return BigDecimal
                .valueOf(finalScore)
                .setScale(
                        2,
                        RoundingMode.HALF_UP
                );
    }

    private String buildRecommendedRoute(
            Address origin,
            Address destination,
            BigDecimal distance,
            int duration,
            boolean sameCountry,
            boolean sameCity
    ) {

        String originText =
                buildAddressText(origin);

        String destinationText =
                buildAddressText(destination);


        if (sameCity) {

            return
                    "Direct local delivery route from " +
                            originText +
                            " to " +
                            destinationText +
                            ". Use the shortest practical urban route " +
                            "and prioritize minimum handling time.";

        } else if (sameCountry) {

            return
                    "Domestic logistics corridor from " +
                            originText +
                            " to " +
                            destinationText +
                            ". Prioritize major highways and minimize " +
                            "unnecessary transfer points.";

        } else {

            return
                    "International logistics route from " +
                            originText +
                            " to " +
                            destinationText +
                            ". Prioritize major logistics corridors, " +
                            "border/customs efficiency and consolidated transfers.";
        }
    }

    private int safeId(Object entity) {

        if (entity instanceof lk.sasindi.globaltrade.entity.City city &&
                city.getId() != null) {

            return city.getId();
        }


        if (entity instanceof lk.sasindi.globaltrade.entity.Country country &&
                country.getId() != null) {

            return country.getId();
        }


        return 0;
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

    private record RouteCalculation(
            BigDecimal distance,
            Integer duration,
            BigDecimal score,
            String recommendedRoute
    ) {
    }
}