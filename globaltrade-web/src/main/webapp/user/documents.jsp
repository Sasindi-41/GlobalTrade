<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sasindi.globaltrade.entity.CustomDocument" %>
<%@ page import="java.util.List" %>

<%
  request.setAttribute("activePage", "documents");

  List<CustomDocument> myDocuments =
          (List<CustomDocument>) request.getAttribute("myDocuments");

  String errorMessage =
          (String) request.getAttribute("errorMessage");

  String successMessage =
          (String) request.getAttribute("successMessage");
%>

<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="UTF-8">

  <meta name="viewport"
        content="width=device-width, initial-scale=1.0">

  <title>GlobalTrade | Documents</title>

  <!-- Font Awesome -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

  <!-- User CSS -->
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/user/assets/user-style.css">

</head>

<body>

<!-- =========================================================
     SIDEBAR
     ========================================================= -->

<jsp:include page="user-sidebar.jsp"/>


<!-- =========================================================
     MAIN CONTENT
     ========================================================= -->

<main class="main">

  <!-- =====================================================
       TOP BAR
       ===================================================== -->

  <jsp:include page="user-topbar.jsp"/>


  <!-- =====================================================
       CONTENT
       ===================================================== -->

  <section class="content">


    <!-- =================================================
         PAGE HEADING
         ================================================= -->

    <div class="page-heading">

      <div>

        <h1>
          Documents
        </h1>

        <p>
          View customs and trade documents associated
          with your shipments.
        </p>

      </div>

    </div>


    <!-- =================================================
         FLASH ERROR
         ================================================= -->

    <% if (errorMessage != null &&
            !errorMessage.trim().isEmpty()) { %>

    <div class="flash-message flash-error">

      <i class="fa-solid fa-circle-exclamation"></i>

      <%= errorMessage %>

    </div>

    <% } %>


    <!-- =================================================
         FLASH SUCCESS
         ================================================= -->

    <% if (successMessage != null &&
            !successMessage.trim().isEmpty()) { %>

    <div class="flash-message flash-success">

      <i class="fa-solid fa-circle-check"></i>

      <%= successMessage %>

    </div>

    <% } %>


    <!-- =================================================
         DOCUMENT SUMMARY
         ================================================= -->

    <div class="page-grid">


      <!-- =================================================
           MAIN DOCUMENT CARD
           ================================================= -->

      <div class="card"
           style="grid-column: 1 / -1;">


        <!-- =============================================
             CARD HEADER
             ============================================= -->

        <div class="card-header">

          <div>

            <h2>
              Your Documents
            </h2>

            <p style="margin-top: 5px;
                                color: #64748b;
                                  font-size: 13px;">

              Official documents associated with
              your shipments.

            </p>

          </div>


          <!-- DOCUMENT COUNT -->

          <div style="
                            display:flex;
                            align-items:center;
                            gap:8px;
                            font-size:13px;
                            color: #64748b;
                         ">

            <i class="fa-solid fa-file-lines"></i>

            <span>

                            <%= myDocuments == null
                                    ? 0
                                    : myDocuments.size() %>

                            document(s)

                        </span>

          </div>

        </div>


        <!-- =============================================
             DOCUMENT TABLE
             ============================================= -->

        <div class="table-wrap">

          <% if (myDocuments == null ||
                  myDocuments.isEmpty()) { %>


          <!-- =====================================
               EMPTY STATE
               ===================================== -->

          <div class="empty-state">

            <i class="fa-solid fa-folder-open"></i>

            <h3 style="margin-top:12px;">
              No Documents Available
            </h3>

            <p style="margin-top:6px;">
              No customs or trade documents
              have been associated with your
              shipments yet.
            </p>

          </div>


          <% } else { %>


          <!-- =====================================
               DOCUMENT TABLE
               ===================================== -->

          <table>

            <thead>

            <tr>

              <th>
                Document No.
              </th>

              <th>
                Type
              </th>

              <th>
                Shipment
              </th>

              <th>
                Status
              </th>

              <th>
                Issued
              </th>

              <th>
                Expires
              </th>

              <th>
                Description
              </th>

            </tr>

            </thead>


            <tbody>


            <% for (CustomDocument document
                    : myDocuments) {


              String statusName =
                      document.getDocumentStatus() != null
                              &&
                              document.getDocumentStatus().getName() != null
                              ? document.getDocumentStatus().getName().trim()
                              : "Unknown";


              String statusClass =
                      statusName
                              .toLowerCase()
                              .replace(" ", "-")
                              .replace("_", "-");


              String documentNumber =
                      document.getDocumentNumber() != null
                              ? document.getDocumentNumber()
                              : "-";


              String documentType =
                      document.getDocumentType() != null
                              &&
                              document.getDocumentType().getName() != null
                              ? document.getDocumentType().getName()
                              : "-";


              String trackingNumber =
                      document.getShipment() != null
                              &&
                              document.getShipment().getTrackingNumber() != null
                              ? document.getShipment().getTrackingNumber()
                              : "-";


              String issueDate =
                      document.getIssueDate() != null
                              ? document.getIssueDate().toString()
                              : "-";


              String expiryDate =
                      document.getExpiryDate() != null
                              ? document.getExpiryDate().toString()
                              : "-";


              String description =
                      document.getDescription() != null
                              &&
                              !document.getDescription().trim().isEmpty()
                              ? document.getDescription()
                              : "-";

            %>


            <!-- =================================
                 DOCUMENT ROW
                 ================================= -->

            <tr>


              <!-- DOCUMENT NUMBER -->

              <td>

                <strong>
                  <%= documentNumber %>
                </strong>

              </td>


              <!-- DOCUMENT TYPE -->

              <td>

                <div style="
                                            display:flex;
                                            align-items:center;
                                            gap:8px;
                                         ">

                  <i class="fa-solid fa-file-lines"
                     style="opacity:.65;">
                  </i>

                  <span>
                                            <%= documentType %>
                                        </span>

                </div>

              </td>


              <!-- SHIPMENT -->

              <td>

                <div style="
                                            display:flex;
                                            align-items:center;
                                            gap:8px;
                                         ">

                  <i class="fa-solid fa-truck"
                     style="opacity:.65;">
                  </i>

                  <span>
                                            <%= trackingNumber %>
                                        </span>

                </div>

              </td>


              <!-- STATUS -->

              <td>

                                    <span class="
                                        status-pill
                                        status-<%= statusClass %>
                                    ">

                                        <%= statusName %>

                                    </span>

              </td>


              <!-- ISSUE DATE -->

              <td>

                <%= issueDate %>

              </td>


              <!-- EXPIRY DATE -->

              <td>

                <%= expiryDate %>

              </td>


              <!-- DESCRIPTION -->

              <td>

                                    <span
                                            title="<%= description %>"
                                            style="
                                            display:inline-block;
                                            max-width:260px;
                                            white-space:nowrap;
                                            overflow:hidden;
                                            text-overflow:ellipsis;
                                        ">

                                        <%= description %>

                                    </span>

              </td>


            </tr>


            <% } %>


            </tbody>

          </table>


          <% } %>

        </div>

      </div>


    </div>


    <!-- =================================================
         INFORMATION CARD
         ================================================= -->

    <div class="card"
         style="margin-top:14px;">

      <div class="card-header">

        <h2>
          <i class="fa-solid fa-circle-info"
             style="margin-right:8px;">
          </i>

          About Your Documents

        </h2>

      </div>


      <div style="
                    padding:18px;
                    display:grid;
                    grid-template-columns:
                        repeat(auto-fit, minmax(220px, 1fr));
                    gap:16px;
                 ">


        <!-- =========================================
             ITEM 1
             ========================================= -->

        <div style="
                        display:flex;
                        gap:12px;
                        align-items:flex-start;
                     ">

          <div style="
                            width:38px;
                            height:38px;
                            border-radius:10px;
                            display:flex;
                            align-items:center;
                            justify-content:center;
                            background:rgba(0,102,255,.10);
                            flex-shrink:0;
                         ">

            <i class="fa-solid fa-file-shield"></i>

          </div>

          <div>

            <strong>
              Official Documents
            </strong>

            <p style="
                            margin-top:5px;
                            font-size:13px;
                           color: #64748b;
                        ">

              Documents are prepared and managed
              by the GlobalTrade logistics team.

            </p>

          </div>

        </div>


        <!-- =========================================
             ITEM 2
             ========================================= -->

        <div style="
                        display:flex;
                        gap:12px;
                        align-items:flex-start;
                     ">

          <div style="
                            width:38px;
                            height:38px;
                            border-radius:10px;
                            display:flex;
                            align-items:center;
                            justify-content:center;
                            background:rgba(16,185,129,.10);
                            flex-shrink:0;
                         ">

            <i class="fa-solid fa-link"></i>

          </div>

          <div>

            <strong>
              Shipment Linked
            </strong>

            <p style="
                            margin-top:5px;
                            font-size:13px;
                           color: #64748b;
                        ">

              Each document is associated with
              one of your shipments.

            </p>

          </div>

        </div>


        <!-- =========================================
             ITEM 3
             ========================================= -->

        <div style="
                        display:flex;
                        gap:12px;
                        align-items:flex-start;
                     ">

          <div style="
                            width:38px;
                            height:38px;
                            border-radius:10px;
                            display:flex;
                            align-items:center;
                            justify-content:center;
                            background:rgba(245,158,11,.10);
                            flex-shrink:0;
                         ">

            <i class="fa-solid fa-clock"></i>

          </div>

          <div>

            <strong>
              Expiry Monitoring
            </strong>

            <p style="
                            margin-top:5px;
                            font-size:13px;
                           color: #64748b;
                        ">

              Documents with expiry dates are
              monitored by the system.

            </p>

          </div>

        </div>


      </div>

    </div>


    <!-- =================================================
         FOOTER
         ================================================= -->

    <footer class="footer"
            style="margin-top:14px;">

            <span>
                &copy; 2026 GlobalTrade Logistics System.
                All rights reserved.
            </span>

      <span>
                Version 1.0.0
            </span>

    </footer>


  </section>

</main>


</body>

</html>
