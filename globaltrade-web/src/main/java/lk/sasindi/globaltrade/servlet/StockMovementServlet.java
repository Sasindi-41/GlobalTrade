package lk.sasindi.globaltrade.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import lk.sasindi.globaltrade.bean.StockMovementSessionBean;
import lk.sasindi.globaltrade.entity.MovementType;
import lk.sasindi.globaltrade.entity.Reference;
import lk.sasindi.globaltrade.entity.StockMovement;

import java.io.IOException;
import java.util.List;

@WebServlet("/stock-history")
public class StockMovementServlet extends HttpServlet {

    @EJB
    private StockMovementSessionBean stockMovementSessionBean;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                !Boolean.TRUE.equals(
                        session.getAttribute("authenticated"))) {

            response.sendRedirect(
                    request.getContextPath() + "/signin"
            );

            return;
        }

        try {

            List<StockMovement> stockMovements =
                    stockMovementSessionBean
                            .getAllStockMovements();

            List<MovementType> movementTypes =
                    stockMovementSessionBean
                            .getAllMovementTypes();

            List<Reference> references =
                    stockMovementSessionBean
                            .getAllReferences();

            request.setAttribute(
                    "stockMovements",
                    stockMovements
            );

            request.setAttribute(
                    "movementTypes",
                    movementTypes
            );

            request.setAttribute(
                    "references",
                    references
            );

            request.getRequestDispatcher(
                    "/admin/history.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load stock movement history."
            );

            request.setAttribute(
                    "stockMovements",
                    java.util.Collections.emptyList()
            );

            request.setAttribute(
                    "movementTypes",
                    java.util.Collections.emptyList()
            );

            request.setAttribute(
                    "references",
                    java.util.Collections.emptyList()
            );

            request.getRequestDispatcher(
                    "/admin/history.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        response.sendError(
                HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                "Stock movement history is read-only."
        );
    }
}