package lk.sasindi.globaltrade.bean;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import lk.sasindi.globaltrade.compliance.TradeComplianceInterceptor;
import lk.sasindi.globaltrade.entity.CustomDocument;
import lk.sasindi.globaltrade.entity.DocumentStatus;
import lk.sasindi.globaltrade.entity.DocumentType;
import lk.sasindi.globaltrade.entity.Shipment;
import lk.sasindi.globaltrade.exception.CustomDocumentException;
import lk.sasindi.globaltrade.interceptor.CustomDocumentAuditInterceptor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import lk.sasindi.globaltrade.interceptor.TransactionMonitorInterceptor;
@Stateless
@Interceptors({
        CustomDocumentAuditInterceptor.class,
        TransactionMonitorInterceptor.class,
        TradeComplianceInterceptor.class
})
public class CustomDocumentSessionBean {

    @PersistenceContext(unitName = "GlobalTradePU")
    private EntityManager em;


    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )

    public List<CustomDocument> getMyDocuments(
            Integer userId
    ) {

        if (userId == null) {
            return java.util.Collections.emptyList();
        }

        return em.createQuery(
                        "SELECT DISTINCT d FROM CustomDocument d " +
                                "JOIN FETCH d.shipment s " +
                                "LEFT JOIN FETCH d.documentType " +
                                "LEFT JOIN FETCH d.documentStatus " +
                                "WHERE s.createdByUser.id = :userId " +
                                "ORDER BY d.issueDate DESC",
                        CustomDocument.class
                )
                .setParameter("userId", userId)
                .getResultList();
    }


    public List<CustomDocument> getAllDocuments() {

        return em.createQuery(
                """
                SELECT DISTINCT d
                FROM CustomDocument d
                JOIN FETCH d.shipment s
                JOIN FETCH d.documentType t
                JOIN FETCH d.documentStatus st
                ORDER BY d.id DESC
                """,
                CustomDocument.class
        ).getResultList();
    }


    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public CustomDocument getDocumentById(
            Integer id
    ) {

        if (id == null) {
            return null;
        }

        return em.createQuery(
                        """
                        SELECT d
                        FROM CustomDocument d
                        JOIN FETCH d.shipment
                        JOIN FETCH d.documentType
                        JOIN FETCH d.documentStatus
                        WHERE d.id = :id
                        """,
                        CustomDocument.class
                )
                .setParameter("id", id)
                .getResultStream()
                .findFirst()
                .orElse(null);
    }


    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<DocumentType> getDocumentTypes() {

        return em.createQuery(
                """
                SELECT t
                FROM DocumentType t
                ORDER BY t.name
                """,
                DocumentType.class
        ).getResultList();
    }


    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<DocumentStatus> getDocumentStatuses() {

        return em.createQuery(
                """
                SELECT s
                FROM DocumentStatus s
                ORDER BY s.name
                """,
                DocumentStatus.class
        ).getResultList();
    }


    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public List<Shipment> getShipments() {

        return em.createQuery(
                """
                SELECT s
                FROM Shipment s
                ORDER BY s.id DESC
                """,
                Shipment.class
        ).getResultList();
    }

    @TransactionAttribute(
            TransactionAttributeType.REQUIRED
    )
    public CustomDocument createDocument(

            LocalDate issueDate,

            LocalDate expiryDate,

            String description,

            Integer shipmentId,

            Integer documentTypeId,

            Integer documentStatusId,
            Integer userId

    ) throws CustomDocumentException {

        if (userId == null) {
            throw new CustomDocumentException(
                    "User ID is required for document audit."
            );
        }

        validateDocument(

                issueDate,

                expiryDate,

                description,

                shipmentId,

                documentTypeId,

                documentStatusId
        );


        Shipment shipment =
                em.find(
                        Shipment.class,
                        shipmentId
                );


        DocumentType documentType =
                em.find(
                        DocumentType.class,
                        documentTypeId
                );


        DocumentStatus documentStatus =
                em.find(
                        DocumentStatus.class,
                        documentStatusId
                );


        if (shipment == null) {

            throw new CustomDocumentException(
                    "Selected shipment does not exist."
            );
        }


        if (documentType == null) {

            throw new CustomDocumentException(
                    "Selected document type does not exist."
            );
        }


        if (documentStatus == null) {

            throw new CustomDocumentException(
                    "Selected document status does not exist."
            );
        }


        CustomDocument document =
                new CustomDocument();

        document.setDocumentNumber(
                generateDocumentNumber()
        );


        document.setIssueDate(
                issueDate
        );


        document.setExpiryDate(
                expiryDate
        );


        document.setDescription(
                description.trim()
        );


        document.setShipment(
                shipment
        );


        document.setDocumentType(
                documentType
        );


        document.setDocumentStatus(
                documentStatus
        );


        document.setSubmittedAt(
                LocalDateTime.now()
        );


        em.persist(document);
        em.flush();

        return document;
    }


    @TransactionAttribute(
            TransactionAttributeType.REQUIRED
    )
    public CustomDocument updateDocument(

            Integer id,

            LocalDate issueDate,

            LocalDate expiryDate,

            String description,

            Integer shipmentId,

            Integer documentTypeId,

            Integer documentStatusId,
            Integer userId

    ) throws CustomDocumentException {

        if (userId == null) {
            throw new CustomDocumentException(
                    "User ID is required for document audit."
            );
        }


        if (id == null) {

            throw new CustomDocumentException(
                    "Document ID is required."
            );
        }


        validateDocument(

                issueDate,

                expiryDate,

                description,

                shipmentId,

                documentTypeId,

                documentStatusId
        );


        CustomDocument document =
                em.find(
                        CustomDocument.class,
                        id
                );


        if (document == null) {

            throw new CustomDocumentException(
                    "Custom document not found."
            );
        }


        Shipment shipment =
                em.find(
                        Shipment.class,
                        shipmentId
                );


        DocumentType documentType =
                em.find(
                        DocumentType.class,
                        documentTypeId
                );


        DocumentStatus documentStatus =
                em.find(
                        DocumentStatus.class,
                        documentStatusId
                );


        if (shipment == null) {

            throw new CustomDocumentException(
                    "Selected shipment does not exist."
            );
        }


        if (documentType == null) {

            throw new CustomDocumentException(
                    "Selected document type does not exist."
            );
        }


        if (documentStatus == null) {

            throw new CustomDocumentException(
                    "Selected document status does not exist."
            );
        }


        document.setIssueDate(
                issueDate
        );


        document.setExpiryDate(
                expiryDate
        );


        document.setDescription(
                description.trim()
        );


        document.setShipment(
                shipment
        );


        document.setDocumentType(
                documentType
        );


        document.setDocumentStatus(
                documentStatus
        );


        if (
                document.getSubmittedAt() == null
                        &&
                        documentStatus.getName() != null
                        &&
                        documentStatus.getName()
                                .equalsIgnoreCase("Submitted")
        ) {

            document.setSubmittedAt(
                    LocalDateTime.now()
            );
        }
        em.flush();

        return document;
    }


    @TransactionAttribute(
            TransactionAttributeType.REQUIRED
    )
    public void deleteDocument(
            Integer id,
            Integer userId
    ) throws CustomDocumentException {
        if (userId == null) {
            throw new CustomDocumentException(
                    "User ID is required for document audit."
            );
        }

        if (id == null) {

            throw new CustomDocumentException(
                    "Document ID is required."
            );
        }


        CustomDocument document =
                em.find(
                        CustomDocument.class,
                        id
                );


        if (document == null) {

            throw new CustomDocumentException(
                    "Custom document not found."
            );
        }


        em.remove(document);
    }


    private void validateDocument(

            LocalDate issueDate,

            LocalDate expiryDate,

            String description,

            Integer shipmentId,

            Integer documentTypeId,

            Integer documentStatusId

    ) throws CustomDocumentException {


        if (issueDate == null) {

            throw new CustomDocumentException(
                    "Issue date is required."
            );
        }


        if (expiryDate != null) {

            if (
                    !expiryDate.isAfter(issueDate)
            ) {

                throw new CustomDocumentException(
                        "Expiry date must be after issue date."
                );
            }
        }


        if (
                description == null
                        ||
                        description.trim().isEmpty()
        ) {

            throw new CustomDocumentException(
                    "Document description is required."
            );
        }


        if (
                description.trim().length() > 500
        ) {

            throw new CustomDocumentException(
                    "Description cannot exceed 500 characters."
            );
        }


        if (shipmentId == null) {

            throw new CustomDocumentException(
                    "Shipment is required."
            );
        }


        if (documentTypeId == null) {

            throw new CustomDocumentException(
                    "Document type is required."
            );
        }


        if (documentStatusId == null) {

            throw new CustomDocumentException(
                    "Document status is required."
            );
        }
    }

    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public long getTotalExpiryDocumentCount() {

        LocalDate today = LocalDate.now();

        return em.createQuery(
                        """
                        SELECT COUNT(d)
                        FROM CustomDocument d
                        WHERE d.expiryDate IS NOT NULL
                          AND d.expiryDate < :today
                        """,
                        Long.class
                )
                .setParameter("today", today)
                .getSingleResult();
    }


    @TransactionAttribute(
            TransactionAttributeType.SUPPORTS
    )
    public long getExpirySoonDocumentCount() {

        LocalDate today = LocalDate.now();

        LocalDate expiryLimit =
                today.plusDays(30);

        return em.createQuery(
                        """
                        SELECT COUNT(d)
                        FROM CustomDocument d
                        WHERE d.expiryDate IS NOT NULL
                          AND d.expiryDate >= :today
                          AND d.expiryDate <= :expiryLimit
                        """,
                        Long.class
                )
                .setParameter("today", today)
                .setParameter("expiryLimit", expiryLimit)
                .getSingleResult();
    }

    private String generateDocumentNumber() {

        String date =
                LocalDate.now()
                        .toString()
                        .replace("-", "");


        String random =
                UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 6)
                        .toUpperCase();


        return "CD-"
                + date
                + "-"
                + random;
    }
}