package lk.sasindi.globaltrade.bean;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.inject.Inject;
import jakarta.interceptor.Interceptors;

import lk.sasindi.globaltrade.dao.SupportTicketDAO;
import lk.sasindi.globaltrade.dao.UserDAO;

import lk.sasindi.globaltrade.entity.SupportTicket;
import lk.sasindi.globaltrade.entity.User;

import java.time.LocalDateTime;
import java.util.List;

@Stateless
@Interceptors(lk.sasindi.globaltrade.interceptor.SupportTicketAuditInterceptor.class)
public class SupportTicketSessionBean {

    private static final List<String> VALID_PRIORITIES =
            List.of("LOW", "NORMAL", "HIGH", "URGENT");

    @Inject
    private SupportTicketDAO supportTicketDAO;

    @Inject
    private UserDAO userDAO;

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public SupportTicket createTicket(
            Integer userId,
            String subject,
            String message,
            String priority
    ) {

        if (userId == null) {
            throw new IllegalArgumentException(
                    "User is required."
            );
        }

        if (subject == null || subject.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Subject is required."
            );
        }

        if (message == null || message.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Message is required."
            );
        }

        User user = userDAO.findById(userId);

        if (user == null) {
            throw new IllegalArgumentException(
                    "User was not found."
            );
        }

        String cleanPriority =
                priority != null &&
                        VALID_PRIORITIES.contains(priority.trim().toUpperCase())
                        ? priority.trim().toUpperCase()
                        : "NORMAL";

        SupportTicket ticket = new SupportTicket();

        ticket.setTicketNumber(generateTicketNumber());
        ticket.setUser(user);
        ticket.setSubject(subject.trim());
        ticket.setMessage(message.trim());
        ticket.setPriority(cleanPriority);
        ticket.setStatus("OPEN");

        LocalDateTime now = LocalDateTime.now();

        ticket.setCreatedAt(now);
        ticket.setUpdatedAt(now);

        return supportTicketDAO.save(ticket);
    }


    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<SupportTicket> getMyTickets(Integer userId) {
        return supportTicketDAO.findByUser(userId);
    }


    private String generateTicketNumber() {

        long sequence = supportTicketDAO.getNextTicketSequence();

        return "TCK-"
                + LocalDateTime.now().getYear()
                + "-"
                + String.format("%05d", sequence);
    }
}
