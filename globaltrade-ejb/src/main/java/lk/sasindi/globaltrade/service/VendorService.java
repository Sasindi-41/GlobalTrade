package lk.sasindi.globaltrade.service;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;

import jakarta.interceptor.Interceptors;
import lk.sasindi.globaltrade.dao.VendorDAO;
import lk.sasindi.globaltrade.entity.Country;
import lk.sasindi.globaltrade.entity.Status;
import lk.sasindi.globaltrade.entity.Vendor;
import lk.sasindi.globaltrade.interceptor.VendorAuditInterceptor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Stateless
@Interceptors(VendorAuditInterceptor.class)
public class VendorService {

    @EJB
    private VendorDAO vendorDAO;

    public List<Vendor> findAll() {
        return vendorDAO.findAll();
    }

    public Vendor findById(Integer id) {

        if (id == null) {
            return null;
        }

        return vendorDAO.findById(id);
    }

    public String generateNextVendorCode() {

        List<String> codes =
                vendorDAO.findAllVendorCodes();

        int highestNumber = 0;

        for (String code : codes) {

            if (code == null) {
                continue;
            }

            String value =
                    code.trim().toUpperCase();

            if (!value.startsWith("VEN-")) {
                continue;
            }

            String numberPart =
                    value.substring(4).trim();

            try {

                int number =
                        Integer.parseInt(numberPart);

                if (number > highestNumber) {
                    highestNumber = number;
                }

            } catch (NumberFormatException ignored) {

            }
        }

        return String.format(
                "VEN-%03d",
                highestNumber + 1
        );
    }

    public List<Status> findAllStatuses() {
        return vendorDAO.findAllStatuses();
    }

    public List<Country> findAllCountries() {
        return vendorDAO.findAllCountries();
    }

    public Vendor createVendor(
            String displayedVendorCode,
            String companyName,
            String contactName,
            String email,
            String phone,
            BigDecimal performanceScore,
            Integer statusId,
            Integer countryId,
             Integer userId
    ) {
        if (userId == null) {
            throw new IllegalArgumentException(
                    "User ID is required for vendor audit."
            );
        }

        validateCommonFields(
                companyName,
                contactName,
                email,
                phone,
                performanceScore,
                statusId,
                countryId
        );

        String vendorCode =
                generateNextVendorCode();

        Vendor existing =
                vendorDAO.findByVendorCode(vendorCode);

        if (existing != null) {
            vendorCode = generateNextVendorCode();
        }

        Status status =
                vendorDAO.findStatusById(statusId);

        if (status == null) {
            throw new IllegalArgumentException(
                    "Selected status was not found."
            );
        }

        Country country =
                vendorDAO.findCountryById(countryId);

        if (country == null) {
            throw new IllegalArgumentException(
                    "Selected country was not found."
            );
        }

        Vendor vendor = new Vendor();

        vendor.setVendorCode(vendorCode);
        vendor.setCompanyName(companyName.trim());
        vendor.setContactName(contactName.trim());
        vendor.setEmail(email.trim());
        vendor.setPhone(phone.trim());
        vendor.setPerformanceScore(performanceScore);
        vendor.setStatus(status);
        vendor.setCountry(country);
        vendor.setCreatedAt(LocalDateTime.now());

        return vendorDAO.save(vendor);
    }

    public Vendor updateVendor(
            Integer id,
            String companyName,
            String contactName,
            String email,
            String phone,
            BigDecimal performanceScore,
            Integer statusId,
            Integer countryId,
            Integer userId
    ) {

        if (userId == null) {
            throw new IllegalArgumentException(
                    "User ID is required for vendor audit."
            );
        }
        if (id == null) {
            throw new IllegalArgumentException(
                    "Vendor ID is required."
            );
        }

        validateCommonFields(
                companyName,
                contactName,
                email,
                phone,
                performanceScore,
                statusId,
                countryId
        );

        Vendor vendor =
                vendorDAO.findById(id);

        if (vendor == null) {
            throw new IllegalArgumentException(
                    "Vendor record not found."
            );
        }

        Status status =
                vendorDAO.findStatusById(statusId);

        if (status == null) {
            throw new IllegalArgumentException(
                    "Selected status was not found."
            );
        }

        Country country =
                vendorDAO.findCountryById(countryId);

        if (country == null) {
            throw new IllegalArgumentException(
                    "Selected country was not found."
            );
        }

        vendor.setCompanyName(companyName.trim());
        vendor.setContactName(contactName.trim());
        vendor.setEmail(email.trim());
        vendor.setPhone(phone.trim());
        vendor.setPerformanceScore(performanceScore);
        vendor.setStatus(status);
        vendor.setCountry(country);

        return vendorDAO.update(vendor);
    }

    public void deleteVendor(
            Integer id,
            Integer userId
    ){
        if (userId == null) {
            throw new IllegalArgumentException(
                    "User ID is required for vendor audit."
            );
        }

        if (id == null) {
            throw new IllegalArgumentException(
                    "Vendor ID is required."
            );
        }

        Vendor vendor =
                vendorDAO.findById(id);

        if (vendor == null) {
            throw new IllegalArgumentException(
                    "Vendor record not found."
            );
        }

        if (vendor.getShipments() != null &&
                !vendor.getShipments().isEmpty()) {

            throw new IllegalArgumentException(
                    "Cannot delete this vendor because shipment records are associated with it."
            );
        }

        if (vendor.getInventories() != null &&
                !vendor.getInventories().isEmpty()) {

            throw new IllegalArgumentException(
                    "Cannot delete this vendor because inventory records are associated with it."
            );
        }

        vendorDAO.delete(id);
    }

    private void validateCommonFields(
            String companyName,
            String contactName,
            String email,
            String phone,
            BigDecimal performanceScore,
            Integer statusId,
            Integer countryId
    ) {

        if (isBlank(companyName)) {
            throw new IllegalArgumentException(
                    "Company name is required."
            );
        }

        if (companyName.length() > 150) {
            throw new IllegalArgumentException(
                    "Company name cannot exceed 150 characters."
            );
        }

        if (isBlank(contactName)) {
            throw new IllegalArgumentException(
                    "Contact name is required."
            );
        }

        if (contactName.length() > 100) {
            throw new IllegalArgumentException(
                    "Contact name cannot exceed 100 characters."
            );
        }

        if (isBlank(email)) {
            throw new IllegalArgumentException(
                    "Email is required."
            );
        }

        if (email.length() > 150 ||
                !email.matches(
                        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
                )) {

            throw new IllegalArgumentException(
                    "Please enter a valid email address."
            );
        }

        if (isBlank(phone) ||
                !phone.matches("\\d{10}")) {

            throw new IllegalArgumentException(
                    "Phone number must contain exactly 10 digits."
            );
        }

        if (performanceScore == null ||
                performanceScore.compareTo(BigDecimal.ZERO) < 0 ||
                performanceScore.compareTo(
                        new BigDecimal("100")
                ) > 0) {

            throw new IllegalArgumentException(
                    "Performance score must be between 0 and 100."
            );
        }

        if (statusId == null) {
            throw new IllegalArgumentException(
                    "Status is required."
            );
        }

        if (countryId == null) {
            throw new IllegalArgumentException(
                    "Country is required."
            );
        }
    }

    private boolean isBlank(String value) {

        return value == null ||
                value.trim().isEmpty();
    }
}
