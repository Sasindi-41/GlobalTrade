package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lk.sasindi.globaltrade.entity.Inventory;
import lk.sasindi.globaltrade.entity.Vendor;
import lk.sasindi.globaltrade.entity.Warehouse;
import lk.sasindi.globaltrade.service.InventoryService;
import lk.sasindi.globaltrade.service.VendorService;
import lk.sasindi.globaltrade.service.WarehouseService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import jakarta.servlet.http.HttpSession;
@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private InventoryService inventoryService;

    @EJB
    private VendorService vendorService;

    @EJB
    private WarehouseService warehouseService;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            List<Inventory> inventoryList =
                    inventoryService.getAllInventory();

            request.setAttribute(
                    "inventoryList",
                    inventoryList
            );

            List<Vendor> vendorList =
                    getVendors();

            request.setAttribute(
                    "vendorList",
                    vendorList
            );

            List<Warehouse> warehouseList =
                    getWarehouses();

            request.setAttribute(
                    "warehouseList",
                    warehouseList
            );

            request.getRequestDispatcher(
                    "/admin/inventory.jsp"
            ).forward(request, response);


        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Unable to load inventory data."
            );

            request.setAttribute(
                    "inventoryList",
                    java.util.Collections.emptyList()
            );

            request.setAttribute(
                    "vendorList",
                    java.util.Collections.emptyList()
            );

            request.setAttribute(
                    "warehouseList",
                    java.util.Collections.emptyList()
            );

            request.getRequestDispatcher(
                    "/admin/inventory.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action =
                request.getParameter("action");


        try {

            if ("create".equalsIgnoreCase(action)) {

                createInventory(request);

                response.sendRedirect(
                        request.getContextPath()
                                + "/inventory?success=created"
                );

                return;
            }

            if ("update".equalsIgnoreCase(action)) {

                updateInventory(request);

                response.sendRedirect(
                        request.getContextPath()
                                + "/inventory?success=updated"
                );

                return;
            }

            if ("delete".equalsIgnoreCase(action)) {

                deleteInventory(request);

                response.sendRedirect(
                        request.getContextPath()
                                + "/inventory?success=deleted"
                );

                return;
            }

            if ("updateQuantity".equalsIgnoreCase(action)) {

                updateQuantity(request);

                response.sendRedirect(
                        request.getContextPath()
                                + "/inventory?success=quantity"
                );

                return;
            }

            throw new IllegalArgumentException(
                    "Invalid inventory action."
            );


        } catch (IllegalArgumentException e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/inventory?error="
                            + URLEncoder.encode(
                            e.getMessage(),
                            StandardCharsets.UTF_8
                    )
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/inventory?error=system"
            );
        }
    }

    private void createInventory(
            HttpServletRequest request
    ) {


        String productName =
                request.getParameter("productName");

        Integer quantity =
                parseInteger(
                        request.getParameter("quantity")
                );

        Integer reorderLevel =
                parseInteger(
                        request.getParameter("reorderLevel")
                );

        Integer vendorId =
                parseInteger(
                        request.getParameter("vendorId")
                );

        Integer warehouseId =
                parseInteger(
                        request.getParameter("warehouseId")
                );


        Vendor vendor =
                findVendor(vendorId);

        Warehouse warehouse =
                findWarehouse(warehouseId);


        inventoryService.createInventory(
                productName,
                quantity,
                reorderLevel,
                vendor,
                warehouse,
                getLoggedInUserId(request)
        );
    }

    private void updateInventory(
            HttpServletRequest request
    ) {

        Integer id =
                parseInteger(
                        request.getParameter("id")
                );


        String productName =
                request.getParameter("productName");

        Integer quantity =
                parseInteger(
                        request.getParameter("quantity")
                );

        Integer reorderLevel =
                parseInteger(
                        request.getParameter("reorderLevel")
                );

        Integer vendorId =
                parseInteger(
                        request.getParameter("vendorId")
                );

        Integer warehouseId =
                parseInteger(
                        request.getParameter("warehouseId")
                );


        Vendor vendor =
                findVendor(vendorId);

        Warehouse warehouse =
                findWarehouse(warehouseId);


        inventoryService.updateInventory(
                id,
                productName,
                quantity,
                reorderLevel,
                vendor,
                warehouse,
                getLoggedInUserId(request)
        );
    }

    private void deleteInventory(
            HttpServletRequest request
    ) {

        Integer id =
                parseInteger(
                        request.getParameter("id")
                );

        inventoryService.deleteInventory(
                id,
                getLoggedInUserId(request)
        );
    }

    private void updateQuantity(
            HttpServletRequest request
    ) {

        Integer inventoryId =
                parseInteger(
                        request.getParameter("inventoryId")
                );

        Integer quantityChange =
                parseInteger(
                        request.getParameter("quantityChange")
                );


        if (inventoryId == null) {

            throw new IllegalArgumentException(
                    "Inventory ID is required."
            );
        }


        if (quantityChange == null ||
                quantityChange == 0) {

            throw new IllegalArgumentException(
                    "Quantity change cannot be zero."
            );
        }

        if (quantityChange > 0) {

            inventoryService.addStock(
                    inventoryId,
                    quantityChange,
                    getLoggedInUserId(request)
            );

            return;
        }

        inventoryService.removeStock(
                inventoryId,
                Math.abs(quantityChange),
                getLoggedInUserId(request)
        );
    }

    private Integer parseInteger(
            String value
    ) {

        if (value == null ||
                value.trim().isEmpty()) {

            return null;
        }

        try {

            return Integer.valueOf(
                    value.trim()
            );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid numeric value: " + value
            );
        }
    }

    private List<Vendor> getVendors() {

        return vendorService.findAll();
    }


    private Vendor findVendor(
            Integer id
    ) {

        if (id == null) {

            throw new IllegalArgumentException(
                    "Vendor is required."
            );
        }

        Vendor vendor =
                vendorService.findById(id);

        if (vendor == null) {

            throw new IllegalArgumentException(
                    "Selected vendor was not found."
            );
        }

        return vendor;
    }

    private List<Warehouse> getWarehouses() {

        return warehouseService.findAll();
    }


    private Warehouse findWarehouse(
            Integer id
    ) {

        if (id == null) {

            throw new IllegalArgumentException(
                    "Warehouse is required."
            );
        }

        Warehouse warehouse =
                warehouseService.findById(id);

        if (warehouse == null) {

            throw new IllegalArgumentException(
                    "Selected warehouse was not found."
            );
        }

        return warehouse;
    }
    private Integer getLoggedInUserId(
            HttpServletRequest request
    ) {

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            throw new IllegalArgumentException(
                    "User session not found."
            );
        }

        Object userObject =
                session.getAttribute("userId");

        if (!(userObject instanceof Number)) {

            throw new IllegalArgumentException(
                    "Authenticated user not found."
            );
        }

        return ((Number) userObject).intValue();
    }
}