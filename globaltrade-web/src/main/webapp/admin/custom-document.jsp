<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="lk.sasindi.globaltrade.entity.CustomDocument" %>
<%@ page import="lk.sasindi.globaltrade.entity.DocumentType" %>
<%@ page import="lk.sasindi.globaltrade.entity.DocumentStatus" %>
<%@ page import="lk.sasindi.globaltrade.entity.Shipment" %>


<%

    jakarta.servlet.http.HttpSession adminSession = request.getSession(false);

    if (adminSession == null ||
            !Boolean.TRUE.equals(adminSession.getAttribute("authenticated"))) {

        response.sendRedirect(
                request.getContextPath() + "/signin"
        );

        return;
    }

    List<CustomDocument> customDocumentList =
            (List<CustomDocument>) request.getAttribute("customDocumentList");


    List<Shipment> shipmentList =
            (List<Shipment>) request.getAttribute("shipmentList");


    List<DocumentType> documentTypeList =
            (List<DocumentType>) request.getAttribute("documentTypeList");


    List<DocumentStatus> documentStatusList =
            (List<DocumentStatus>) request.getAttribute("documentStatusList");


    if (customDocumentList == null) {
        customDocumentList = new java.util.ArrayList<>();
    }


    if (shipmentList == null) {
        shipmentList = new java.util.ArrayList<>();
    }


    if (documentTypeList == null) {
        documentTypeList = new java.util.ArrayList<>();
    }


    if (documentStatusList == null) {
        documentStatusList = new java.util.ArrayList<>();
    }



    int totalDocuments =
            customDocumentList.size();


    int submittedDocuments = 0;

    int expiredDocuments = 0;

    int expiringDocuments = 0;

    int pendingDocuments = 0;


    java.time.LocalDate today =
            java.time.LocalDate.now();


    java.time.LocalDate warningDate =
            today.plusDays(30);


    for (CustomDocument document : customDocumentList) {


        if (document.getSubmittedAt() != null) {

            submittedDocuments++;

        }

        if (document.getExpiryDate() != null) {

            java.time.LocalDate expiry =
                    document.getExpiryDate();


            if (expiry.isBefore(today)) {

                expiredDocuments++;

            }
            else if (
                    !expiry.isAfter(warningDate)
            ) {

                expiringDocuments++;

            }

        }


        if (
                document.getDocumentStatus() != null &&
                        document.getDocumentStatus().getName() != null &&
                        document.getDocumentStatus()
                                .getName()
                                .equalsIgnoreCase("Pending")
        ) {

            pendingDocuments++;

        }

    }

    String success =
            request.getParameter("success");


    String error =
            request.getParameter("error");

    if (error == null || error.trim().isEmpty()) {
        Object errorMessage =
                request.getAttribute("errorMessage");

        if (errorMessage != null) {
            error = String.valueOf(errorMessage);
        }
    }

%>


<!DOCTYPE html>

<html lang="en">


<head>

    <meta charset="UTF-8">


    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">


    <title>
        Custom Documents | GlobalTrade
    </title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="preconnect"
          href="https://fonts.googleapis.com">


    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>


    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/admin.css">


    <style>
        :root{
            --navy:#003049;
            --navy-2:#00415f;
            --navy-3:#00506f;
            --yellow:#fcbf49;
            --yellow-light:#fff7df;
            --orange:#f77f00;
            --orange-light:#fff1df;
            --blue:#0066ff;
            --blue-light:#eef5ff;
            --green:#198754;
            --green-light:#eaf8f0;
            --red:#dc3545;
            --red-light:#fef2f2;
            --text:#16324a;
            --muted:#718096;
            --border:#e3e9ef;
            --bg:#f4f7f9;
            --white:#fff;
            --sidebar-width:270px;
            --topbar-height:70px;

            --primary:var(--blue);
            --accent:var(--blue);
            --background:var(--bg);
            --card:var(--white);
            --blue-bg:var(--blue-light);
            --green-bg:var(--green-light);
            --yellow-bg:var(--yellow-light);
            --red-bg:var(--red-light);
        }

        *{box-sizing:border-box}

        html,body{
            margin:0;
            padding:0;
            min-height:100%;
            font-family:"Segoe UI",Arial,sans-serif;
            background:var(--bg);
            color:var(--text);
            font-size:12px;
        }

        body{overflow-x:hidden}
        button,input,select,textarea{font-family:inherit}
        button{border:0}
        a{text-decoration:none;color:inherit}

        .main{
            margin-left:var(--sidebar-width);
            min-height:100vh;
        }

        .content{
            padding:25px 26px 18px;
        }

        .page-heading{
            display:flex;
            justify-content:space-between;
            align-items:flex-start;
            gap:20px;
            margin-bottom:19px;
        }

        .page-heading h1{
            margin:0;
            color:var(--navy);
            font-size:24px;
            line-height:1.2;
            font-weight:700;
            letter-spacing:-.5px;
        }

        .page-heading p{
            margin:5px 0 0;
            color:var(--muted);
            font-size:10px;
        }

        .btn.btn-primary,
        .primary-btn{
            height:40px;
            padding:0 17px;
            border-radius:7px;
            background:var(--yellow);
            color:var(--navy);
            font-size:10px;
            font-weight:700;
            cursor:pointer;
            display:inline-flex;
            align-items:center;
            gap:7px;
            box-shadow:0 3px 8px rgba(252,191,73,.20);
        }

        .btn.btn-primary:hover,
        .primary-btn:hover{
            background:#f5b63b;
        }

        .success-toast,
        .error-toast{
            position:fixed;
            top:84px;
            right:24px;
            min-width:280px;
            max-width:420px;
            padding:11px 13px;
            border-radius:8px;
            display:flex;
            align-items:center;
            gap:9px;
            font-size:10px;
            z-index:20000;
            box-shadow:0 8px 25px rgba(0,48,73,.12);
            animation:toastSlideIn .25s ease;
        }

        .success-toast{
            background:var(--green-light);
            border:1px solid #ccebd9;
            color:#146c43;
        }

        .error-toast{
            background:var(--red-light);
            border:1px solid #f4c7cb;
            color:#b02a37;
        }

        .success-toast>i:first-child,
        .error-toast>i:first-child{
            font-size:15px;
            flex-shrink:0;
        }

        .success-toast span,
        .error-toast span{
            line-height:1.5;
            flex:1;
        }

        .toast-close{
            margin-left:auto;
            width:25px;
            height:25px;
            display:flex;
            align-items:center;
            justify-content:center;
            background:transparent;
            color:inherit;
            cursor:pointer;
            border-radius:6px;
        }

        .toast-close:hover{background:rgba(0,0,0,.06)}

        @keyframes toastSlideIn{
            from{opacity:0;transform:translateX(30px)}
            to{opacity:1;transform:translateX(0)}
        }

        .stats-grid{
            display:grid;
            grid-template-columns:repeat(4,1fr);
            gap:12px;
            margin-bottom:15px;
        }

        .stat-card{
            min-height:83px;
            background:var(--card);
            border:1px solid var(--border);
            border-radius:11px;
            padding:15px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
            box-shadow:0 2px 8px rgba(15,48,64,.025);
        }

        .stat-content h4{
            margin:0 0 4px;
            color:var(--muted);
            font-size:9px;
            font-weight:600;
        }

        .stat-label{
            color:var(--muted);
            font-size:9px;
            text-transform:uppercase;
            letter-spacing:.45px;
            font-weight:700;
        }

        .number,
        .stat-value{
            margin-top:6px;
            color:var(--navy);
            font-size:20px;
            font-weight:700;
            line-height:1;
        }

        .stat-icon{
            width:42px;
            height:42px;
            border-radius:9px;
            display:flex;
            align-items:center;
            justify-content:center;
            background:rgba(252,191,73,.20);
            color:var(--orange);
            font-size:15px;
            flex-shrink:0;
        }

        .stat-blue,.stat-green,.stat-yellow,.stat-red{
            background:var(--yellow-light);
            color:var(--orange);
        }

        .document-panel,
        .table-card{
            background:#fff;
            border:1px solid var(--border);
            border-radius:10px;
            overflow:hidden;
            box-shadow:none;
        }

        .panel-header,
        .table-header{
            min-height:68px;
            padding:14px 17px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:15px;
            border-bottom:1px solid var(--border);
        }

        .panel-header h2,
        .table-title h2{
            margin:0;
            color:var(--navy);
            font-size:14px;
            font-weight:700;
        }

        .panel-header p,
        .table-title p{
            margin:4px 0 0;
            color:var(--muted);
            font-size:9px;
        }

        .search-area,
        .table-tools{
            display:flex;
            align-items:center;
            gap:8px;
        }

        .search-box,
        .table-search{
            position:relative;
            width:225px;
            height:35px;
            border:1px solid var(--border);
            border-radius:7px;
            display:flex;
            align-items:center;
            padding:0 10px;
            background:#fafcfd;
        }

        .search-box i,
        .table-search i{
            position:static;
            transform:none;
            color:#8b9aaa;
            margin-right:8px;
            font-size:10px;
        }

        .search-box input,
        .table-search input{
            width:100%;
            border:0;
            outline:0;
            background:transparent;
            color:var(--text);
            font-size:9px;
        }

        .search-box input:focus,
        .table-search input:focus{
            box-shadow:none;
        }

        .filter-select{
            height:35px;
            min-width:120px;
            padding:0 9px;
            border:1px solid var(--border);
            border-radius:7px;
            background:#fafcfd;
            color:var(--text);
            outline:none;
            font-size:9px;
            cursor:pointer;
        }

        .table-wrapper,
        .table-wrap{
            width:100%;
            overflow-x:auto;
        }

        .document-table,
        table{
            width:100%;
            border-collapse:collapse;
            min-width:930px;
        }

        .document-table th,
        thead th{
            height:39px;
            padding:0 14px;
            background:#f8fafb;
            color:#60758a;
            border-bottom:1px solid var(--border);
            text-align:left;
            font-size:8px;
            text-transform:uppercase;
            letter-spacing:.45px;
            font-weight:700;
            white-space:nowrap;
        }

        .document-table td,
        tbody td{
            padding:12px 14px;
            border-bottom:1px solid #edf1f4;
            color:var(--text);
            font-size:9px;
            vertical-align:middle;
        }

        .document-table tbody tr:last-child td,
        tbody tr:last-child td{border-bottom:0}

        .document-table tbody tr:hover,
        tbody tr:hover{background:#fbfcfd}

        .document-info{
            display:flex;
            align-items:center;
            gap:10px;
        }

        .document-icon{
            width:35px;
            height:35px;
            border-radius:8px;
            background:var(--yellow-light);
            color:var(--orange);
            display:flex;
            align-items:center;
            justify-content:center;
            flex-shrink:0;
            font-size:13px;
        }

        .document-name{
            color:var(--navy);
            font-size:10px;
            font-weight:700;
        }

        .document-number{
            margin-top:3px;
            color:var(--muted);
            font-size:8px;
        }

        .shipment-number{
            color:var(--navy);
            font-weight:700;
            font-size:9px;
        }

        .shipment-label{
            margin-top:3px;
            color:var(--muted);
            font-size:8px;
        }

        .status-badge{
            display:inline-flex;
            align-items:center;
            gap:5px;
            padding:5px 8px;
            border-radius:20px;
            font-size:8px;
            font-weight:700;
            white-space:nowrap;
        }

        .status-badge i{font-size:8px}

        .status-submitted{
            background:var(--green-light);
            color:var(--green);
        }

        .status-pending{
            background:var(--yellow-light);
            color:var(--orange);
        }

        .status-expired{
            background:var(--red-light);
            color:var(--red);
        }

        .status-default{
            background:#eef2f6;
            color:#687385;
        }

        .expiry-normal{color:#475467}
        .expiry-warning{color:var(--orange);font-weight:700}
        .expiry-danger{color:var(--red);font-weight:700}

        .actions{
            display:flex;
            align-items:center;
            gap:5px;
        }

        .action-btn{
            width:30px;
            height:30px;
            border-radius:7px;
            border:0;
            cursor:pointer;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            font-size:10px;
        }

        .action-edit{
            background:var(--blue-light);
            color:var(--blue);
        }

        .action-edit:hover{background:#dceaff}

        .action-delete{
            background:var(--red-light);
            color:var(--red);
        }

        .action-delete:hover{background:#fde0e3}

        .empty-state{
            padding:55px 20px;
            text-align:center;
            color:var(--muted);
        }

        .empty-state i{
            font-size:28px;
            color:#c5d0d9;
            margin-bottom:10px;
        }

        .empty-state h3{
            margin:0;
            color:var(--navy);
            font-size:12px;
        }

        .empty-state p{
            margin:5px 0 0;
            color:var(--muted);
            font-size:9px;
        }

        .footer,
        .page-footer{
            padding:18px 2px 0;
            display:flex;
            justify-content:space-between;
            color:#81909e;
            font-size:8px;
        }

        .modal-overlay,
        .selection-overlay{
            position:fixed;
            inset:0;
            background:rgba(0,48,73,.48);
            display:none;
            align-items:center;
            justify-content:center;
            padding:20px;
            z-index:10000;
        }

        .modal-overlay.active{display:flex}
        .selection-overlay.show{display:flex}

        .document-modal,
        .vendor-modal{
            width:100%;
            max-width:610px;
            max-height:92vh;
            overflow-y:auto;
            background:#fff;
            border-radius:12px;
            box-shadow:0 24px 60px rgba(0,0,0,.22);
        }

        .modal-header{
            min-height:62px;
            padding:12px 17px;
            border-bottom:1px solid var(--border);
            display:flex;
            align-items:center;
            justify-content:space-between;
        }

        .modal-header-content,
        .modal-heading{
            display:flex;
            align-items:center;
            gap:10px;
        }

        .modal-header-icon,
        .modal-icon{
            width:36px;
            height:36px;
            border-radius:9px;
            background:var(--yellow-light);
            color:var(--orange);
            display:flex;
            align-items:center;
            justify-content:center;
        }

        .modal-header h2{
            margin:0;
            color:var(--navy);
            font-size:15px;
        }

        .modal-header p{
            margin:3px 0 0;
            color:var(--muted);
            font-size:8px;
        }

        .close-modal{
            width:30px;
            height:30px;
            border-radius:7px;
            background:transparent;
            color:#64748b;
            cursor:pointer;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:13px;
        }

        .close-modal:hover{
            background:var(--red-light);
            color:var(--red);
        }

        .modal-body{padding:18px}

        .form-grid{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:13px;
        }

        .form-group{
            display:flex;
            flex-direction:column;
        }

        .form-group.full-width,
        .form-group.full{
            grid-column:1/-1;
        }

        .form-group label{
            display:block;
            margin-bottom:6px;
            color:#617487;
            font-size:9px;
            font-weight:700;
        }

        .required{color:var(--red)}

        .form-control{
            width:100%;
            height:38px;
            padding:0 10px;
            border:1px solid var(--border);
            border-radius:7px;
            background:#fffdf7;
            outline:none;
            color:var(--navy);
            font-size:10px;
        }

        textarea.form-control{
            min-height:82px;
            height:auto;
            resize:vertical;
            padding-top:10px;
        }

        .form-control:focus{
            border-color:var(--yellow);
            box-shadow:0 0 0 3px rgba(252,191,73,.12);
        }

        .form-control[readonly]{
            background:#f4f7f9;
            color:var(--navy);
            font-weight:700;
            cursor:not-allowed;
        }

        .field-help,
        .form-help{
            margin-top:4px;
            color:var(--muted);
            font-size:8px;
        }

        .auto-generated-field{
            min-height:38px;
            padding:8px 10px;
            border:1px solid var(--border);
            border-radius:7px;
            background:#f4f7f9;
            display:flex;
            align-items:center;
            gap:9px;
        }

        .auto-generated-field>i{
            color:var(--orange);
            font-size:12px;
        }

        .auto-generated-content{min-width:0}
        .auto-generated-title{
            color:var(--navy);
            font-size:10px;
            font-weight:700;
        }

        .auto-generated-subtitle{
            display:block;
            margin-top:2px;
            color:var(--muted);
            font-size:8px;
        }

        .selector-field{
            display:flex;
            align-items:center;
            min-height:38px;
            border:1px solid var(--border);
            border-radius:7px;
            background:#fffdf7;
            overflow:hidden;
        }

        .selector-field:focus-within{
            border-color:var(--yellow);
            box-shadow:0 0 0 3px rgba(252,191,73,.12);
        }

        .selector-display{
            flex:1;
            min-width:0;
            padding:0 10px;
            color:var(--navy);
            font-size:10px;
            white-space:nowrap;
            overflow:hidden;
            text-overflow:ellipsis;
        }

        .selector-display.placeholder{color:#98a2b3}

        .selector-button{
            height:38px;
            padding:0 11px;
            border-left:1px solid var(--border);
            background:#f8fafb;
            color:var(--blue);
            font-size:9px;
            font-weight:700;
            cursor:pointer;
            display:flex;
            align-items:center;
            gap:6px;
        }

        .selector-button:hover{
            background:var(--blue-light);
        }

        .selected-info{
            display:flex;
            align-items:center;
            gap:5px;
            margin-top:4px;
            color:var(--green);
            font-size:8px;
            font-weight:600;
        }

        .modal-footer{
            padding:12px 17px;
            border-top:1px solid var(--border);
            display:flex;
            justify-content:flex-end;
            gap:8px;
            background:#fff;
        }

        .btn-secondary,
        .btn-save,
        .btn-delete{
            height:35px;
            padding:0 15px;
            border-radius:7px;
            font-size:9px;
            font-weight:700;
            cursor:pointer;
        }

        .btn-secondary{
            background:#f2f5f7;
            color:#566b7c;
        }

        .btn-secondary:hover{background:#e7ecef}

        .btn-save{
            background:var(--yellow);
            color:var(--navy);
        }

        .btn-save:hover{background:#f4b63d}

        .btn-delete{
            background:var(--red);
            color:#fff;
        }

        .btn-delete:hover{background:#c82333}

        .delete-content,
        .delete-message{
            padding:24px 20px 8px;
            text-align:center;
        }

        .delete-icon{
            width:46px;
            height:46px;
            margin:0 auto 10px;
            border-radius:50%;
            background:var(--red-light);
            color:var(--red);
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:18px;
        }

        .delete-content h3,
        .delete-message h3{
            margin:0;
            color:var(--navy);
            font-size:13px;
        }

        .delete-content p,
        .delete-message p{
            margin:7px 0 0;
            color:var(--muted);
            font-size:9px;
            line-height:1.5;
        }

        .field-error{
            display:none;
            margin-top:4px;
            color:var(--red);
            font-size:8px;
        }

        .selection-modal{
            width:100%;
            max-width:520px;
            max-height:75vh;
            background:#fff;
            border-radius:12px;
            overflow:hidden;
            box-shadow:0 24px 60px rgba(0,0,0,.22);
        }

        .selection-modal-header{
            min-height:56px;
            padding:12px 17px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            border-bottom:1px solid var(--border);
        }

        .selection-modal-header h2{
            margin:0;
            color:var(--navy);
            font-size:14px;
            font-weight:700;
        }

        .selection-modal-header h2 i{
            margin-right:7px;
            color:var(--orange);
        }

        .selection-close{
            width:30px;
            height:30px;
            border-radius:7px;
            background:transparent;
            color:#64748b;
            cursor:pointer;
            font-size:13px;
        }

        .selection-close:hover{
            background:var(--red-light);
            color:var(--red);
        }

        .selection-search-area{
            padding:12px 15px;
            border-bottom:1px solid var(--border);
        }

        .selection-search-wrapper{position:relative}

        .selection-search-wrapper i{
            position:absolute;
            left:11px;
            top:50%;
            transform:translateY(-50%);
            color:#8b9aaa;
            font-size:10px;
        }

        .selection-search{
            width:100%;
            height:35px;
            padding:0 10px 0 31px;
            border:1px solid var(--border);
            border-radius:7px;
            outline:none;
            background:#fafcfd;
            color:var(--text);
            font-size:9px;
        }

        .selection-search:focus{
            border-color:var(--yellow);
            box-shadow:0 0 0 3px rgba(252,191,73,.10);
        }

        .selection-content{
            max-height:390px;
            overflow-y:auto;
        }

        .selection-empty{
            display:none;
            padding:35px 20px;
            text-align:center;
            color:var(--muted);
        }

        .selection-empty i{
            font-size:25px;
            color:#c5d0d9;
            margin-bottom:8px;
        }

        .selection-empty p{
            margin:0;
            font-size:9px;
        }

        .selection-item{
            padding:11px 15px;
            border-bottom:1px solid #edf1f4;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:10px;
            transition:.15s ease;
        }

        .selection-item:hover{background:#fbfcfd}

        .selection-item:last-child{border-bottom:0}

        .selection-item-info{
            min-width:0;
            flex:1;
        }

        .selection-item-title{
            display:block;
            color:var(--navy);
            font-size:10px;
            font-weight:700;
        }

        .selection-item-subtitle{
            display:block;
            margin-top:3px;
            color:var(--muted);
            font-size:8px;
        }

        .selection-item-button{
            height:30px;
            padding:0 10px;
            border-radius:7px;
            background:var(--yellow-light);
            color:var(--orange);
            cursor:pointer;
            font-size:8px;
            font-weight:700;
            flex-shrink:0;
        }

        .selection-item-button:hover{
            background:#ffefc2;
        }

        @media (max-width:1050px){
            .main{margin-left:225px}
            .stats-grid{grid-template-columns:repeat(2,1fr)}
        }

        @media (max-width:760px){
            .main{margin-left:0}
            .content{padding:18px 14px}
            .page-heading{
                flex-direction:column;
                align-items:flex-start;
            }
            .stats-grid{grid-template-columns:1fr}
            .panel-header,
            .table-header{
                align-items:flex-start;
                flex-direction:column;
            }
            .search-area,
            .table-tools{width:100%}
            .search-box,
            .table-search{width:100%}
            .form-grid{grid-template-columns:1fr}
            .form-group.full-width,
            .form-group.full{grid-column:auto}
            .success-toast,
            .error-toast{
                top:75px;
                left:15px;
                right:15px;
                min-width:auto;
                max-width:none;
            }
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;

            width: var(--sidebar-width);

            background: var(--navy);
            color: white;

            display: flex;
            flex-direction: column;

            z-index: 1000;

            overflow-y: auto;

            box-shadow:
                    2px 0 10px rgba(0, 0, 0, 0.08);
        }

        .brand {
            height: 75px;

            display: flex;
            align-items: center;

            padding: 0 18px;

            gap: 10px;

            border-bottom:
                    1px solid rgba(255,255,255,.08);

            flex-shrink: 0;
        }


        .brand-logo {
            width: 38px;
            height: 38px;

            border-radius: 9px;

            background: var(--orange);
            color: white;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 17px;

            flex-shrink: 0;
        }


        .brand-copy {
            display: flex;
            flex-direction: column;

            min-width: 0;
        }


        .brand-title {
            color: white;

            font-size: 16px;
            font-weight: 700;

            line-height: 1.2;
        }


        .brand-subtitle {
            color: rgba(255,255,255,.65);

            font-size: 9px;

            margin-top: 3px;
        }

        .nav {
            flex: 1;

            padding: 12px 10px;

            overflow-y: auto;
        }


        .nav-item {
            height: 39px;

            display: flex;
            align-items: center;

            gap: 11px;

            padding: 0 11px;

            margin-bottom: 3px;

            border-radius: 7px;

            color: rgba(255,255,255,.75);

            font-size: 11px;
            font-weight: 500;

            transition: .2s ease;

            white-space: nowrap;
        }


        .nav-item i:first-child {
            width: 17px;

            text-align: center;

            font-size: 13px;

            flex-shrink: 0;
        }


        .nav-item span {
            overflow: hidden;

            text-overflow: ellipsis;
        }


        .nav-item .chevron {
            margin-left: auto;

            font-size: 8px;

            opacity: .7;
        }


        .nav-item:hover {
            background: rgba(255,255,255,.08);

            color: white;
        }


        .nav-item.active {
            background: var(--orange);

            color: white;

            font-weight: 600;
        }


        .sidebar::-webkit-scrollbar,
        .nav::-webkit-scrollbar {
            width: 4px;
        }


        .sidebar::-webkit-scrollbar-thumb,
        .nav::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,.2);

            border-radius: 5px;
        }

        .badge {
            margin-left: auto;

            min-width: 18px;
            height: 18px;

            padding: 0 5px;

            border-radius: 10px;

            background: var(--red);

            color: white;

            font-size: 8px;

            display: flex;
            align-items: center;
            justify-content: center;

            font-weight: 700;
        }

        .profile-mini {
            padding: 12px;

            border-top:
                    1px solid rgba(255,255,255,.08);

            display: flex;
            align-items: center;

            gap: 10px;

            background: rgba(0,0,0,.08);

            flex-shrink: 0;
        }


        .avatar {
            width: 35px;
            height: 35px;

            border-radius: 50%;

            background: var(--soft-yellow);

            color: var(--orange);

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 13px;

            flex-shrink: 0;
        }


        .profile-copy {
            min-width: 0;

            flex: 1;
        }


        .profile-copy .profile-name {
            color: white;

            font-size: 10px;
            font-weight: 600;

            margin-bottom: 4px;
        }


        .profile-link {
            display: flex;
            align-items: center;

            gap: 6px;

            color: rgba(255,255,255,.65);

            font-size: 9px;
        }


        .profile-link:hover {
            color: white;
        }


        .profile-link.active {
            color: var(--yellow);
        }

        .main {
            margin-left: var(--sidebar-width);

            min-height: 100vh;
        }

        .topbar {
            height: 65px;

            display: flex;
            align-items: center;

            padding: 0 22px;

            background: var(--card);

            border-bottom:
                    1px solid var(--border);

            gap: 15px;

            position: relative;

            z-index: 900;
        }


        .menu-btn {
            width: 35px;
            height: 35px;

            border: none;

            background: transparent;

            color: var(--navy);

            font-size: 19px;

            cursor: pointer;

            display: flex;
            align-items: center;
            justify-content: center;
        }


        .menu-btn:hover {
            color: var(--orange);
        }


        .search {
            width: 285px;
            height: 35px;

            display: flex;
            align-items: center;

            gap: 9px;

            padding: 0 11px;

            background: var(--card);

            border:
                    1px solid #F8E4A9;

            border-radius: 7px;

            color: var(--muted);
        }


        .search:focus-within {
            border-color: var(--yellow);

            box-shadow:
                    0 0 0 3px rgba(252,191,73,.12);
        }


        .search i {
            font-size: 13px;

            color: var(--muted);
        }


        .search input {
            width: 100%;
            height: 100%;

            border: none;
            outline: none;

            background: transparent;

            color: var(--navy);

            font-size: 11px;
        }


        .search input::placeholder {
            color: #94A3B8;
        }


        .top-actions {
            margin-left: auto;

            display: flex;
            align-items: center;

            gap: 16px;
        }


        .icon-btn {
            position: relative;

            border: none;

            background: transparent;

            color: var(--navy);

            font-size: 16px;

            cursor: pointer;

            display: flex;
            align-items: center;
            justify-content: center;
        }


        .icon-btn:hover {
            color: var(--orange);
        }


        .notification-count {
            position: absolute;

            top: -5px;
            right: -7px;

            min-width: 17px;
            height: 17px;

            padding: 0 4px;

            border-radius: 50%;

            background: var(--red);

            color: white;

            font-size: 9px;

            display: flex;
            align-items: center;
            justify-content: center;

            font-weight: 700;
        }


        .top-user {
            display: flex;
            align-items: center;

            gap: 8px;

            color: var(--navy);

            font-size: 12px;
            font-weight: 600;

            white-space: nowrap;
        }


        .top-user:hover {
            color: var(--orange);
        }


        .top-avatar {
            width: 33px;
            height: 33px;

            border-radius: 50%;

            background: var(--soft-yellow);

            color: var(--orange);

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 14px;

            font-weight: 700;
        }
    </style>


</head>


<body>

<jsp:include page="admin-sidebar.jsp"/>


<main class="main">


    <jsp:include page="admin-topbar.jsp"/>


    <section class="content">

        <div class="page-heading">

            <div>

                <h1>
                    Customs Documents
                </h1>

                <p>
                    Manage shipment documentation, compliance records and document validity.
                </p>

            </div>


            <button
                    class="btn btn-primary"
                    type="button"
                    onclick="openCreateModal()"
            >

                <i class="fa-solid fa-file-circle-plus"></i>

                Add Document

            </button>

        </div>

        <% if ("created".equals(success)) { %>

        <div
                class="success-toast"
                id="successToast"
        >

            <i class="fa-solid fa-circle-check"></i>

            <span>
                Customs document created successfully.
            </span>

            <button
                    type="button"
                    class="toast-close"
                    onclick="closeToast('successToast')"
            >

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <% } else if ("updated".equals(success)) { %>

        <div
                class="success-toast"
                id="successToast"
        >

            <i class="fa-solid fa-circle-check"></i>

            <span>
                Customs document updated successfully.
            </span>

            <button
                    type="button"
                    class="toast-close"
                    onclick="closeToast('successToast')"
            >

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <% } else if ("deleted".equals(success)) { %>

        <div
                class="success-toast"
                id="successToast"
        >

            <i class="fa-solid fa-circle-check"></i>

            <span>
                Customs document deleted successfully.
            </span>

            <button
                    type="button"
                    class="toast-close"
                    onclick="closeToast('successToast')"
            >

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <% } %>


        <% if (error != null && !error.trim().isEmpty()) { %>

        <div
                class="error-toast"
                id="errorToast"
        >

            <i class="fa-solid fa-circle-exclamation"></i>

            <span>
                <%= error %>
            </span>

            <button
                    type="button"
                    class="toast-close"
                    onclick="closeToast('errorToast')"
            >

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <% } %>

        <div class="stats-grid">

            <div class="stat-card">

                <div class="stat-content">

                    <h4>
                        Total Documents
                    </h4>

                    <div class="number">
                        <%= totalDocuments %>
                    </div>

                </div>

                <div class="stat-icon stat-blue">

                    <i class="fa-solid fa-file-lines"></i>

                </div>

            </div>

            <div class="stat-card">

                <div class="stat-content">

                    <h4>
                        Submitted
                    </h4>

                    <div class="number">
                        <%= submittedDocuments %>
                    </div>

                </div>

                <div class="stat-icon stat-green">

                    <i class="fa-solid fa-file-circle-check"></i>

                </div>

            </div>

            <div class="stat-card">

                <div class="stat-content">

                    <h4>
                        Expiring Soon
                    </h4>

                    <div class="number">
                        <%= expiringDocuments %>
                    </div>

                </div>

                <div class="stat-icon stat-yellow">

                    <i class="fa-solid fa-clock"></i>

                </div>

            </div>

            <div class="stat-card">

                <div class="stat-content">

                    <h4>
                        Expired
                    </h4>

                    <div class="number">
                        <%= expiredDocuments %>
                    </div>

                </div>

                <div class="stat-icon stat-red">

                    <i class="fa-solid fa-file-circle-xmark"></i>

                </div>

            </div>

        </div>

        <div class="document-panel">

            <div class="panel-header">

                <div>

                    <h2>
                        Customs Document Records
                    </h2>

                    <p>
                        Manage documentation associated with international shipments.
                    </p>

                </div>


                <div class="search-area">


                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input
                                type="text"
                                id="documentSearch"
                                placeholder="Search document..."
                                onkeyup="filterDocuments()"
                        >

                    </div>


                    <select
                            class="filter-select"
                            id="documentFilter"
                            onchange="filterDocuments()"
                    >

                        <option value="all">
                            All Documents
                        </option>

                        <option value="draft">
                            Draft
                        </option>

                        <option value="submitted">
                            Submitted
                        </option>

                        <option value="approved">
                            Approved
                        </option>

                        <option value="rejected">
                            Rejected
                        </option>

                        <option value="expired">
                            Expired
                        </option>

                    </select>

                </div>

            </div>

            <div class="table-wrapper">


                <table
                        class="document-table"
                        id="documentTable"
                >


                    <thead>

                    <tr>

                        <th>
                            Document
                        </th>

                        <th>
                            Shipment
                        </th>

                        <th>
                            Document Type
                        </th>

                        <th>
                            Issue Date
                        </th>

                        <th>
                            Expiry Date
                        </th>

                        <th>
                            Submitted
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Actions
                        </th>

                    </tr>

                    </thead>


                    <tbody>


                    <% if (customDocumentList.isEmpty()) { %>

                    <tr>

                        <td colspan="8">

                            <div class="empty-state">

                                <i class="fa-solid fa-file-circle-question"></i>

                                <h3>
                                    No customs documents
                                </h3>

                                <p>
                                    Add your first customs document to begin managing trade compliance records.
                                </p>

                            </div>

                        </td>

                    </tr>

                    <% } else { %>


                    <% for (CustomDocument document : customDocumentList) {


                        String documentStatus =
                                document.getDocumentStatus() == null
                                        ? ""
                                        : document.getDocumentStatus().getName();


                        String statusLower =
                                documentStatus == null
                                        ? ""
                                        : documentStatus.toLowerCase();


                        boolean submitted =
                                document.getSubmittedAt() != null;


                        boolean expired = false;

                        boolean expiringSoon = false;


                        if (document.getExpiryDate() != null) {

                            java.time.LocalDate expiry =
                                    document.getExpiryDate();


                            expired =
                                    expiry.isBefore(today);


                            expiringSoon =
                                    !expired &&
                                            !expiry.isAfter(warningDate);

                        }


                        String statusClass;


                        if (expired) {

                            statusClass =
                                    "status-expired";

                        }
                        else if (
                                statusLower.contains("submit") ||
                                        submitted
                        ) {

                            statusClass =
                                    "status-submitted";

                        }
                        else if (
                                statusLower.contains("pending")
                        ) {

                            statusClass =
                                    "status-pending";

                        }
                        else {

                            statusClass =
                                    "status-default";

                        }


                        String statusIcon;


                        if (expired) {

                            statusIcon =
                                    "fa-circle-xmark";

                        }
                        else if (
                                statusLower.contains("submit") ||
                                        submitted
                        ) {

                            statusIcon =
                                    "fa-circle-check";

                        }
                        else if (
                                statusLower.contains("pending")
                        ) {

                            statusIcon =
                                    "fa-clock";

                        }
                        else {

                            statusIcon =
                                    "fa-circle-info";

                        }


                        String expiryClass =
                                expired
                                        ? "expiry-danger"
                                        : expiringSoon
                                        ? "expiry-warning"
                                        : "expiry-normal";


                    %>


                    <tr

                            data-document="
                            <%= document.getDocumentNumber() == null
                                    ? ""
                                    : document.getDocumentNumber().toLowerCase() %>
                            "

                            data-description="
                            <%= document.getDescription() == null
                                    ? ""
                                    : document.getDescription().toLowerCase() %>
                            "

                            data-shipment="
                            <%= document.getShipment() == null ||
                                    document.getShipment().getTrackingNumber() == null
                                    ? ""
                                    : document.getShipment()
                                            .getTrackingNumber()
                                            .toLowerCase() %>
                            "

                            data-status="<%= expired
                                    ? "expired"
                                    : (statusLower == null
                                    ? ""
                                    : statusLower) %>"
                    >

                        <td>

                            <div class="document-info">


                                <div class="document-icon">

                                    <i class="fa-solid fa-file-lines"></i>

                                </div>


                                <div>

                                    <div class="document-name">

                                        <%= document.getDocumentType() == null
                                                ? "Customs Document"
                                                : document.getDocumentType().getName() %>

                                    </div>


                                    <div class="document-number">

                                        <%= document.getDocumentNumber() == null
                                                ? "-"
                                                : document.getDocumentNumber() %>

                                    </div>

                                </div>

                            </div>

                        </td>


                        <td>

                            <%
                                if (document.getShipment() != null) {
                            %>

                            <div class="shipment-number">

                                <%= document.getShipment().getTrackingNumber() %>

                            </div>

                            <div class="shipment-label">

                                Shipment ID:
                                <%= document.getShipment().getId() %>

                            </div>

                            <%
                            } else {
                            %>

                            <span style="color:#aaa;">
                                —
                            </span>

                            <%
                                }
                            %>

                        </td>


                        <td>

                            <%= document.getDocumentType() == null
                                    ? "—"
                                    : document.getDocumentType().getName() %>

                        </td>

                        <td>

                            <%= document.getIssueDate() == null
                                    ? "—"
                                    : document.getIssueDate().toString() %>

                        </td>

                        <td>

                            <span class="<%= expiryClass %>">

                                <%= document.getExpiryDate() == null
                                        ? "No expiry"
                                        : document.getExpiryDate().toString() %>

                            </span>

                        </td>

                        <td>

                            <%
                                if (document.getSubmittedAt() != null) {
                            %>

                            <span style="
                                font-size:10px;
                                color:#667085;
                            ">

                                <%= document.getSubmittedAt()
                                        .toString()
                                        .replace("T", " ") %>

                            </span>

                            <%
                            } else {
                            %>

                            <span style="
                                color:#98A2B3;
                                font-size:10px;
                            ">

                                Not submitted

                            </span>

                            <%
                                }
                            %>

                        </td>


                        <td>

                            <span class="status-badge <%= statusClass %>">

                                <i class="fa-solid <%= statusIcon %>"></i>

                                <%= expired
                                        ? "Expired"
                                        : (documentStatus == null ||
                                        documentStatus.trim().isEmpty()
                                        ? "Unknown"
                                        : documentStatus) %>

                            </span>

                        </td>

                        <td>

                            <div class="actions">

                                <button
                                        type="button"
                                        class="action-btn action-edit"
                                        title="Edit"
                                        onclick='openEditModal(
                                            <%= document.getId() %>,
                                            <%= jsString(document.getDocumentNumber()) %>,
                                            <%= jsString(
                                                    document.getIssueDate() == null
                                                            ? ""
                                                            : document.getIssueDate().toString()
                                            ) %>,
                                            <%= jsString(
                                                    document.getExpiryDate() == null
                                                            ? ""
                                                            : document.getExpiryDate().toString()
                                            ) %>,
                                            <%= jsString(document.getDescription()) %>,

                                            <%= document.getShipment() == null
                                                    ? "null"
                                                    : document.getShipment().getId() %>,

                                            <%= document.getShipment() == null
                                                    ? "null"
                                                    : jsString(
                                                        document.getShipment().getTrackingNumber()
                                                    ) %>,

                                            <%= document.getDocumentType() == null
                                                    ? "null"
                                                    : document.getDocumentType().getId() %>,

                                            <%= document.getDocumentType() == null
                                                    ? "null"
                                                    : jsString(
                                                        document.getDocumentType().getName()
                                                    ) %>,

                                            <%= document.getDocumentStatus() == null
                                                    ? "null"
                                                    : document.getDocumentStatus().getId() %>,

                                            <%= document.getDocumentStatus() == null
                                                    ? "null"
                                                    : jsString(
                                                        document.getDocumentStatus().getName()
                                                    ) %>
                                                )'
                                >

                                    <i class="fa-solid fa-pen"></i>

                                </button>


                                <button
                                        type="button"
                                        class="action-btn action-delete"
                                        title="Delete"
                                        onclick='openDeleteModal(
                                            <%= document.getId() %>,
                                            <%= jsString(document.getDocumentNumber()) %>
                                                )'
                                >

                                    <i class="fa-solid fa-trash"></i>

                                </button>


                            </div>

                        </td>


                    </tr>


                    <% } %>

                    <% } %>


                    </tbody>

                </table>

            </div>

        </div>

        <footer class="footer">

            <span>
                © 2026 GlobalTrade Logistics System. All rights reserved.
            </span>

            <span>
                Administrator Portal • Version 1.0.0
            </span>

        </footer>


    </section>

</main>

<div
        class="modal-overlay"
        id="createModal"
        onclick="closeModalOutside(event, 'createModal')"
>


    <div class="document-modal">

        <div class="modal-header">

            <div class="modal-header-content">

                <div class="modal-header-icon">

                    <i class="fa-solid fa-file-circle-plus"></i>

                </div>


                <div>

                    <h2>
                        Add Customs Document
                    </h2>

                    <p>
                        Create a new shipment compliance document.
                    </p>

                </div>

            </div>


            <button
                    type="button"
                    class="close-modal"
                    onclick="closeModal('createModal')"
            >

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <form
                method="post"
                action="<%= request.getContextPath() %>/custom-documents"
                onsubmit="return validateCreateForm();"
        >


            <input
                    type="hidden"
                    name="action"
                    value="create"
            >


            <div class="modal-body">


                <div class="form-grid">


                    <div class="form-group">

                        <label>
                            Document Number
                        </label>

                        <div class="auto-generated-field">

                            <i class="fa-solid fa-file-circle-check"></i>

                            <div class="auto-generated-content">

            <span
                    id="editDocumentNumber"
                    class="auto-generated-title"
            >
                -
            </span>

                                <span class="auto-generated-subtitle">
                This document number is automatically generated and cannot be changed.
            </span>

                            </div>

                        </div>

                        <small class="form-help">
                            <i class="fa-solid fa-lock"></i>
                            Document numbers cannot be changed after creation.
                        </small>

                    </div>

                    <div class="form-group">

                        <label>

                            Document Type

                            <span class="required">*</span>

                        </label>


                        <div class="selector-field">

                            <div
                                    class="selector-display placeholder"
                                    id="createDocumentTypeDisplay"
                            >

                                Select Document Type

                            </div>


                            <button
                                    type="button"
                                    class="selector-button"
                                    onclick="openSelector('documentType','create')"
                            >

                                <i class="fa-solid fa-file-lines"></i>

                                Select

                            </button>

                        </div>


                        <input
                                type="hidden"
                                name="documentTypeId"
                                id="createDocumentTypeId"
                        >


                        <div
                                class="selected-info"
                                id="createDocumentTypeSelectedInfo"
                                style="display:none;"
                        >

                            <i class="fa-solid fa-circle-check"></i>

                            Document type selected

                        </div>

                    </div>

                    <div class="form-group">

                        <label>

                            Issue Date

                            <span class="required">*</span>

                        </label>


                        <input
                                type="date"
                                name="issueDate"
                                id="createIssueDate"
                                class="form-control"
                                required
                        >

                    </div>

                    <div class="form-group">

                        <label>
                            Expiry Date
                        </label>


                        <input
                                type="date"
                                name="expiryDate"
                                id="createExpiryDate"
                                class="form-control"
                        >

                    </div>

                    <div class="form-group">

                        <label>

                            Shipment

                            <span class="required">*</span>

                        </label>


                        <div class="selector-field">

                            <div
                                    class="selector-display placeholder"
                                    id="createShipmentDisplay"
                            >

                                Select Shipment

                            </div>


                            <button
                                    type="button"
                                    class="selector-button"
                                    onclick="openSelector('shipment','create')"
                            >

                                <i class="fa-solid fa-truck-fast"></i>

                                Select

                            </button>

                        </div>


                        <input
                                type="hidden"
                                name="shipmentId"
                                id="createShipmentId"
                        >


                        <div
                                class="selected-info"
                                id="createShipmentSelectedInfo"
                                style="display:none;"
                        >

                            <i class="fa-solid fa-circle-check"></i>

                            Shipment selected

                        </div>

                    </div>

                    <div class="form-group">

                        <label>

                            Document Status

                            <span class="required">*</span>

                        </label>


                        <div class="selector-field">

                            <div
                                    class="selector-display placeholder"
                                    id="createDocumentStatusDisplay"
                            >

                                Select Status

                            </div>


                            <button
                                    type="button"
                                    class="selector-button"
                                    onclick="openSelector('documentStatus','create')"
                            >

                                <i class="fa-solid fa-circle-info"></i>

                                Select

                            </button>

                        </div>


                        <input
                                type="hidden"
                                name="documentStatusId"
                                id="createDocumentStatusId"
                        >


                        <div
                                class="selected-info"
                                id="createDocumentStatusSelectedInfo"
                                style="display:none;"
                        >

                            <i class="fa-solid fa-circle-check"></i>

                            Status selected

                        </div>

                    </div>

                    <div class="form-group full-width">

                        <label>

                            Description

                            <span class="required">*</span>

                        </label>


                        <textarea
                                name="description"
                                id="createDescription"
                                class="form-control"
                                maxlength="500"
                                placeholder="Enter document description..."
                                required
                        ></textarea>

                    </div>


                </div>

            </div>


            <div class="modal-footer">


                <button
                        type="button"
                        class="btn-secondary"
                        onclick="closeModal('createModal')"
                >

                    Cancel

                </button>


                <button
                        type="submit"
                        class="btn-save"
                >

                    <i class="fa-solid fa-check"></i>

                    Create Document

                </button>


            </div>


        </form>

    </div>

</div>

<div
        class="modal-overlay"
        id="editModal"
        onclick="closeModalOutside(event, 'editModal')"
>


    <div class="document-modal">

        <div class="modal-header">

            <div class="modal-header-content">

                <div class="modal-header-icon">

                    <i class="fa-solid fa-pen"></i>

                </div>


                <div>

                    <h2>
                        Edit Customs Document
                    </h2>

                    <p>
                        Update shipment document information.
                    </p>

                </div>

            </div>


            <button
                    type="button"
                    class="close-modal"
                    onclick="closeModal('editModal')"
            >

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <form
                method="post"
                action="<%= request.getContextPath() %>/custom-documents"
                onsubmit="return validateEditForm();"
        >


            <input
                    type="hidden"
                    name="action"
                    value="update"
            >


            <input
                    type="hidden"
                    name="id"
                    id="editId"
            >


            <div class="modal-body">


                <div class="form-grid">


                    <div class="form-group">

                        <label>
                            Document Number
                        </label>

                        <div class="auto-generated-field">

                            <i class="fa-solid fa-wand-magic-sparkles"></i>

                            <div class="auto-generated-content">
            <span class="auto-generated-title">
                Auto-generated
            </span>

                            </div>

                        </div>

                    </div>

                    <div class="form-group">

                        <label>

                            Document Type

                            <span class="required">*</span>

                        </label>


                        <div class="selector-field">

                            <div
                                    class="selector-display placeholder"
                                    id="editDocumentTypeDisplay"
                            >

                                Select Document Type

                            </div>


                            <button
                                    type="button"
                                    class="selector-button"
                                    onclick="openSelector('documentType','edit')"
                            >

                                <i class="fa-solid fa-file-lines"></i>

                                Select

                            </button>

                        </div>


                        <input
                                type="hidden"
                                name="documentTypeId"
                                id="editDocumentTypeId"
                        >


                        <div
                                class="selected-info"
                                id="editDocumentTypeSelectedInfo"
                                style="display:none;"
                        >

                            <i class="fa-solid fa-circle-check"></i>

                            Document type selected

                        </div>

                    </div>

                    <div class="form-group">

                        <label>

                            Issue Date

                            <span class="required">*</span>

                        </label>


                        <input
                                type="date"
                                name="issueDate"
                                id="editIssueDate"
                                class="form-control"
                                required
                        >

                    </div>

                    <div class="form-group">

                        <label>
                            Expiry Date
                        </label>


                        <input
                                type="date"
                                name="expiryDate"
                                id="editExpiryDate"
                                class="form-control"
                        >

                    </div>

                    <div class="form-group">

                        <label>

                            Shipment

                            <span class="required">*</span>

                        </label>


                        <div class="selector-field">

                            <div
                                    class="selector-display placeholder"
                                    id="editShipmentDisplay"
                            >

                                Select Shipment

                            </div>


                            <button
                                    type="button"
                                    class="selector-button"
                                    onclick="openSelector('shipment','edit')"
                            >

                                <i class="fa-solid fa-truck-fast"></i>

                                Select

                            </button>

                        </div>


                        <input
                                type="hidden"
                                name="shipmentId"
                                id="editShipmentId"
                        >


                        <div
                                class="selected-info"
                                id="editShipmentSelectedInfo"
                                style="display:none;"
                        >

                            <i class="fa-solid fa-circle-check"></i>

                            Shipment selected

                        </div>

                    </div>

                    <div class="form-group">

                        <label>

                            Document Status

                            <span class="required">*</span>

                        </label>


                        <div class="selector-field">

                            <div
                                    class="selector-display placeholder"
                                    id="editDocumentStatusDisplay"
                            >

                                Select Status

                            </div>


                            <button
                                    type="button"
                                    class="selector-button"
                                    onclick="openSelector('documentStatus','edit')"
                            >

                                <i class="fa-solid fa-circle-info"></i>

                                Select

                            </button>

                        </div>


                        <input
                                type="hidden"
                                name="documentStatusId"
                                id="editDocumentStatusId"
                        >


                        <div
                                class="selected-info"
                                id="editDocumentStatusSelectedInfo"
                                style="display:none;"
                        >

                            <i class="fa-solid fa-circle-check"></i>

                            Status selected

                        </div>

                    </div>

                    <div class="form-group full-width">

                        <label>

                            Description

                            <span class="required">*</span>

                        </label>


                        <textarea
                                name="description"
                                id="editDescription"
                                class="form-control"
                                maxlength="500"
                                required
                        ></textarea>

                    </div>


                </div>

            </div>


            <div class="modal-footer">


                <button
                        type="button"
                        class="btn-secondary"
                        onclick="closeModal('editModal')"
                >

                    Cancel

                </button>


                <button
                        type="submit"
                        class="btn-save"
                >

                    <i class="fa-solid fa-floppy-disk"></i>

                    Save Changes

                </button>


            </div>


        </form>

    </div>

</div>

<div
        class="modal-overlay"
        id="deleteModal"
        onclick="closeModalOutside(event, 'deleteModal')"
>

    <div
            class="document-modal"
            style="max-width:430px;"
    >

        <div class="modal-header">

            <div class="modal-header-content">

                <div
                        class="modal-header-icon"
                        style="
                        background:#fef2f2;
                        color:var(--red);
                    "
                >

                    <i class="fa-solid fa-trash"></i>

                </div>


                <div>

                    <h2>
                        Delete Document
                    </h2>

                    <p>
                        Confirm document deletion
                    </p>

                </div>

            </div>


            <button
                    type="button"
                    class="close-modal"
                    onclick="closeModal('deleteModal')"
            >

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>

        <div class="modal-body">

            <div class="delete-content">

                <div class="delete-icon">

                    <i class="fa-solid fa-trash-can"></i>

                </div>


                <h3>
                    Delete this document?
                </h3>


                <p>

                    You are about to delete:

                    <strong
                            id="deleteDocumentNumber"
                    >
                        -
                    </strong>

                    <br><br>

                    This action cannot be undone.

                </p>

            </div>

        </div>


        <div class="modal-footer">

            <button
                    type="button"
                    class="btn-secondary"
                    onclick="closeModal('deleteModal')"
            >

                Cancel

            </button>


            <form
                    method="post"
                    action="<%= request.getContextPath() %>/custom-documents"
                    style="display:inline;"
            >

                <input
                        type="hidden"
                        name="action"
                        value="delete"
                >


                <input
                        type="hidden"
                        name="id"
                        id="deleteId"
                >


                <button
                        type="submit"
                        class="btn-delete"
                >

                    <i class="fa-solid fa-trash"></i>

                    Delete

                </button>

            </form>

        </div>

    </div>

</div>

<div
        class="selection-overlay"
        id="selectionOverlay"
        onclick="closeSelectorOutside(event)"
>


    <div class="selection-modal">


        <div class="selection-modal-header">


            <h2 id="selectionTitle">

                <i class="fa-solid fa-list"></i>

                Select

            </h2>


            <button
                    type="button"
                    class="selection-close"
                    onclick="closeSelector()"
            >

                <i class="fa-solid fa-xmark"></i>

            </button>


        </div>


        <div class="selection-search-area">


            <div class="selection-search-wrapper">

                <i class="fa-solid fa-magnifying-glass"></i>


                <input
                        type="text"
                        id="selectionSearch"
                        class="selection-search"
                        placeholder="Search..."
                        onkeyup="searchSelection()"
                >

            </div>


        </div>


        <div
                class="selection-content"
                id="selectionContent"
        ></div>


        <div
                class="selection-empty"
                id="selectionEmpty"
                style="display:none;"
        >

            <i class="fa-solid fa-magnifying-glass"></i>

            <h3>
                No results found
            </h3>

            <p>
                Try another search term.
            </p>

        </div>


    </div>

</div>


<script>

    const shipments = [

        <% for (int i = 0; i < shipmentList.size(); i++) {

            Shipment shipment =
                    shipmentList.get(i);
        %>

        {
            id: "<%= shipment.getId() %>",

            trackingNumber:
                "<%= jsEscape(shipment.getTrackingNumber()) %>"
        }

        <%= i < shipmentList.size() - 1 ? "," : "" %>

        <% } %>

    ];


    const documentTypes = [

        <% for (int i = 0; i < documentTypeList.size(); i++) {

            DocumentType type =
                    documentTypeList.get(i);
        %>

        {
            id: "<%= type.getId() %>",

            name:
                "<%= jsEscape(type.getName()) %>"
        }

        <%= i < documentTypeList.size() - 1 ? "," : "" %>

        <% } %>

    ];


    const documentStatuses = [

        <% for (int i = 0; i < documentStatusList.size(); i++) {

            DocumentStatus status =
                    documentStatusList.get(i);
        %>

        {
            id: "<%= status.getId() %>",

            name:
                "<%= jsEscape(status.getName()) %>"
        }

        <%= i < documentStatusList.size() - 1 ? "," : "" %>

        <% } %>

    ];

    let selectorType = "";

    let selectorMode = "create";

    function openCreateModal() {
        const createDocumentNumber =
            document.getElementById("createDocumentNumber");

        if (createDocumentNumber) {
            createDocumentNumber.value =
                "Generated automatically";
        }

        const description =
            document.getElementById("createDescription");

        const shipmentId =
            document.getElementById("createShipmentId");

        const documentTypeId =
            document.getElementById("createDocumentTypeId");

        const documentStatusId =
            document.getElementById("createDocumentStatusId");

        const issueDate =
            document.getElementById("createIssueDate");

        const expiryDate =
            document.getElementById("createExpiryDate");


        if (description) {
            description.value = "";
        }

        if (shipmentId) {
            shipmentId.value = "";
        }

        if (documentTypeId) {
            documentTypeId.value = "";
        }

        if (documentStatusId) {
            documentStatusId.value = "";
        }

        if (issueDate) {
            issueDate.value = "";
        }

        if (expiryDate) {
            expiryDate.value = "";
            expiryDate.min = "";
        }



        setSelectorDisplay(
            "shipment",
            "create",
            "",
            "Select Shipment"
        );

        setSelectorDisplay(
            "documentType",
            "create",
            "",
            "Select Document Type"
        );

        setSelectorDisplay(
            "documentStatus",
            "create",
            "",
            "Select Status"
        );

        const modal =
            document.getElementById("createModal");

        if (modal) {

            modal.classList.add("active");

            document.body.classList.add("modal-open");
        }
    }

    function openEditModal(
        id,
        documentNumber,
        issueDate,
        expiryDate,
        description,
        shipmentId,
        shipmentNumber,
        documentTypeId,
        documentTypeName,
        documentStatusId,
        documentStatusName
    ) {

        document.getElementById(
            "editId"
        ).value = id || "";


        document.getElementById(
            "editDocumentNumber"
        ).textContent =
            documentNumber || "-";


        document.getElementById(
            "editIssueDate"
        ).value =
            issueDate || "";


        document.getElementById(
            "editExpiryDate"
        ).value =
            expiryDate || "";


        document.getElementById(
            "editDescription"
        ).value =
            description || "";

        document.getElementById(
            "editShipmentId"
        ).value =
            shipmentId || "";


        setSelectorDisplay(
            "shipment",
            "edit",
            shipmentId || "",
            shipmentNumber || "Select Shipment"
        );

        document.getElementById(
            "editDocumentTypeId"
        ).value =
            documentTypeId || "";


        setSelectorDisplay(
            "documentType",
            "edit",
            documentTypeId || "",
            documentTypeName || "Select Document Type"
        );

        document.getElementById(
            "editDocumentStatusId"
        ).value =
            documentStatusId || "";


        setSelectorDisplay(
            "documentStatus",
            "edit",
            documentStatusId || "",
            documentStatusName || "Select Status"
        );

        const modal =
            document.getElementById(
                "editModal"
            );


        if (modal) {

            modal.classList.add(
                "active"
            );

            document.body.classList.add(
                "modal-open"
            );
        }
    }


    function openDeleteModal(
        id,
        documentNumber
    ) {

        document.getElementById(
            "deleteId"
        ).value = id || "";


        document.getElementById(
            "deleteDocumentNumber"
        ).textContent =
            documentNumber || "this document";


        document.getElementById(
            "deleteModal"
        ).classList.add(
            "active"
        );


        document.body.classList.add(
            "modal-open"
        );
    }

    function closeModal(id) {


        const modal =
            document.getElementById(id);


        if (modal) {

            modal.classList.remove(
                "active"
            );

        }


        document.body.classList.remove(
            "modal-open"
        );

    }


    function closeModalOutside(
        event,
        modalId
    ) {


        if (
            event.target.id === modalId
        ) {

            closeModal(modalId);

        }

    }

    document.addEventListener(
        "keydown",
        function(event) {


            if (
                event.key === "Escape"
            ) {


                document
                    .querySelectorAll(
                        ".modal-overlay.active"
                    )
                    .forEach(
                        function(modal) {

                            modal.classList.remove(
                                "active"
                            );

                        }
                    );


                closeSelector();


                document.body.classList.remove(
                    "modal-open"
                );

            }

        }
    );


    function openSelector(
        type,
        mode
    ) {


        selectorType =
            type;


        selectorMode =
            mode || "create";


        const title =
            document.getElementById(
                "selectionTitle"
            );


        const search =
            document.getElementById(
                "selectionSearch"
            );


        if (type === "shipment") {

            title.innerHTML =
                '<i class="fa-solid fa-truck-fast"></i> Select Shipment';

        }
        else if (
            type === "documentType"
        ) {

            title.innerHTML =
                '<i class="fa-solid fa-file-lines"></i> Select Document Type';

        }
        else {

            title.innerHTML =
                '<i class="fa-solid fa-circle-info"></i> Select Document Status';

        }


        search.value = "";


        renderSelectionItems();


        document
            .getElementById(
                "selectionOverlay"
            )
            .classList.add(
            "show"
        );


        setTimeout(
            function() {

                search.focus();

            },
            50
        );

    }

    function renderSelectionItems() {


        let list;


        if (
            selectorType === "shipment"
        ) {

            list =
                shipments;

        }
        else if (
            selectorType === "documentType"
        ) {

            list =
                documentTypes;

        }
        else {

            list =
                documentStatuses;

        }


        const query =
            document
                .getElementById(
                    "selectionSearch"
                )
                .value
                .toLowerCase()
                .trim();


        const content =
            document.getElementById(
                "selectionContent"
            );


        const empty =
            document.getElementById(
                "selectionEmpty"
            );


        const filtered =
            list.filter(
                function(item) {


                    if (
                        selectorType === "shipment"
                    ) {

                        return (
                            (item.trackingNumber || "")
                                .toLowerCase()
                                .includes(query)
                        );

                    }


                    return (
                        (item.name || "")
                            .toLowerCase()
                            .includes(query)
                    );

                }
            );


        content.innerHTML = "";


        filtered.forEach(
            function(item) {


                const row =
                    document.createElement(
                        "div"
                    );


                row.className =
                    "selection-item";


                let title;

                let subtitle;


                if (
                    selectorType === "shipment"
                ) {

                    title =
                        item.trackingNumber;

                    subtitle =
                        "Shipment ID: " +
                        item.id;

                }
                else {

                    title =
                        item.name;

                    subtitle =
                        "ID: " +
                        item.id;

                }


                row.innerHTML =

                    '<div class="selection-item-info">' +

                    '<span class="selection-item-title">' +

                    escapeHtml(
                        title || "-"
                    ) +

                    '</span>' +

                    '<span class="selection-item-subtitle">' +

                    escapeHtml(
                        subtitle
                    ) +

                    '</span>' +

                    '</div>' +

                    '<button type="button" ' +

                    'class="selection-item-button">' +

                    '<i class="fa-solid fa-check"></i> ' +

                    'Select' +

                    '</button>';

                const selectButton =
                    row.querySelector(
                        ".selection-item-button"
                    );

                selectButton.addEventListener(
                    "click",
                    function () {
                        chooseSelection(item.id);
                    }
                );

                content.appendChild(
                    row
                );

            }
        );


        empty.style.display =
            filtered.length
                ? "none"
                : "block";

    }


    function searchSelection() {

        renderSelectionItems();

    }

    function chooseSelection(id) {


        let list;


        if (
            selectorType === "shipment"
        ) {

            list =
                shipments;

        }
        else if (
            selectorType === "documentType"
        ) {

            list =
                documentTypes;

        }
        else {

            list =
                documentStatuses;

        }


        const item =
            list.find(
                function(x) {

                    return String(x.id) ===
                        String(id);

                }
            );


        if (!item) {

            return;

        }


        let display;


        if (
            selectorType === "shipment"
        ) {

            display =
                item.trackingNumber;

        }
        else {

            display =
                item.name;

        }


        let fieldId;


        if (
            selectorType === "shipment"
        ) {

            fieldId =
                selectorMode === "edit"
                    ? "editShipmentId"
                    : "createShipmentId";

        }
        else if (
            selectorType === "documentType"
        ) {

            fieldId =
                selectorMode === "edit"
                    ? "editDocumentTypeId"
                    : "createDocumentTypeId";

        }
        else {

            fieldId =
                selectorMode === "edit"
                    ? "editDocumentStatusId"
                    : "createDocumentStatusId";

        }


        document.getElementById(
            fieldId
        ).value =
            item.id;


        setSelectorDisplay(
            selectorType,
            selectorMode,
            item.id,
            display
        );


        closeSelector();

    }

    function setSelectorDisplay(
        type,
        mode,
        id,
        text
    ) {


        const prefix =
            mode === "edit"
                ? "edit"
                : "create";


        let base;


        if (
            type === "shipment"
        ) {

            base =
                prefix +
                "ShipmentDisplay";

        }
        else if (
            type === "documentType"
        ) {

            base =
                prefix +
                "DocumentTypeDisplay";

        }
        else {

            base =
                prefix +
                "DocumentStatusDisplay";

        }


        const element =
            document.getElementById(
                base
            );


        if (!element) {

            return;

        }


        let placeholder;


        if (
            type === "shipment"
        ) {

            placeholder =
                "Select Shipment";

        }
        else if (
            type === "documentType"
        ) {

            placeholder =
                "Select Document Type";

        }
        else {

            placeholder =
                "Select Status";

        }


        element.textContent =
            text || placeholder;


        element.classList.toggle(
            "placeholder",
            !id
        );


        let infoId;


        if (
            type === "shipment"
        ) {

            infoId =
                prefix +
                "ShipmentSelectedInfo";

        }
        else if (
            type === "documentType"
        ) {

            infoId =
                prefix +
                "DocumentTypeSelectedInfo";

        }
        else {

            infoId =
                prefix +
                "DocumentStatusSelectedInfo";

        }


        const info =
            document.getElementById(
                infoId
            );


        if (info) {

            info.style.display =
                id
                    ? "flex"
                    : "none";

        }

    }

    function closeSelector() {


        document
            .getElementById(
                "selectionOverlay"
            )
            .classList.remove(
            "show"
        );

    }


    function closeSelectorOutside(event) {


        if (
            event.target.id ===
            "selectionOverlay"
        ) {

            closeSelector();

        }

    }

    function validateCreateForm() {


        const shipment =
            document.getElementById(
                "createShipmentId"
            ).value;


        const type =
            document.getElementById(
                "createDocumentTypeId"
            ).value;


        const status =
            document.getElementById(
                "createDocumentStatusId"
            ).value;


        if (!shipment) {

            alert(
                "Please select a shipment."
            );

            return false;

        }


        if (!type) {

            alert(
                "Please select a document type."
            );

            return false;

        }


        if (!status) {

            alert(
                "Please select a document status."
            );

            return false;

        }


        const issue =
            document.getElementById(
                "createIssueDate"
            ).value;


        const expiry =
            document.getElementById(
                "createExpiryDate"
            ).value;


        if (
            expiry &&
            issue &&
            expiry < issue
        ) {

            alert(
                "Expiry date cannot be before issue date."
            );

            return false;

        }


        return true;

    }

    function validateEditForm() {


        const shipment =
            document.getElementById(
                "editShipmentId"
            ).value;


        const type =
            document.getElementById(
                "editDocumentTypeId"
            ).value;


        const status =
            document.getElementById(
                "editDocumentStatusId"
            ).value;


        if (!shipment) {

            alert(
                "Please select a shipment."
            );

            return false;

        }


        if (!type) {

            alert(
                "Please select a document type."
            );

            return false;

        }


        if (!status) {

            alert(
                "Please select a document status."
            );

            return false;

        }


        const issue =
            document.getElementById(
                "editIssueDate"
            ).value;


        const expiry =
            document.getElementById(
                "editExpiryDate"
            ).value;


        if (
            expiry &&
            issue &&
            expiry < issue
        ) {

            alert(
                "Expiry date cannot be before issue date."
            );

            return false;

        }


        return true;

    }

    function filterDocuments() {


        const search =
            document
                .getElementById(
                    "documentSearch"
                )
                .value
                .toLowerCase()
                .trim();


        const status =
            document
                .getElementById(
                    "documentFilter"
                )
                .value;


        const rows =
            document.querySelectorAll(
                "#documentTable tbody tr[data-status]"
            );


        rows.forEach(
            function(row) {


                const documentNumber =
                    row.dataset.document || "";


                const description =
                    row.dataset.description || "";


                const shipment =
                    row.dataset.shipment || "";


                const rowStatus =
                    row.dataset.status || "";


                const matchesSearch =

                    documentNumber.includes(
                        search
                    ) ||

                    description.includes(
                        search
                    ) ||

                    shipment.includes(
                        search
                    );


                const matchesStatus =

                    status === "all" ||

                    rowStatus === status;


                row.style.display =
                    matchesSearch &&
                    matchesStatus
                        ? ""
                        : "none";

            }
        );

    }

    function escapeHtml(value) {


        return String(value)

            .replace(
                /&/g,
                "&amp;"
            )

            .replace(
                /</g,
                "&lt;"
            )

            .replace(
                />/g,
                "&gt;"
            )

            .replace(
                /"/g,
                "&quot;"
            )

            .replace(
                /'/g,
                "&#039;"
            );

    }

    function closeToast(id) {


        const toast =
            document.getElementById(id);


        if (!toast) {

            return;

        }


        toast.style.opacity =
            "0";


        toast.style.transform =
            "translateX(20px)";


        setTimeout(
            function() {

                toast.remove();

            },
            300
        );

    }

    setTimeout(
        function() {


            const successToast =
                document.getElementById(
                    "successToast"
                );


            if (successToast) {

                closeToast(
                    "successToast"
                );

            }


            const errorToast =
                document.getElementById(
                    "errorToast"
                );


            if (errorToast) {

                closeToast(
                    "errorToast"
                );

            }

        },
        4500
    );

    function validateDocumentDates(issueId, expiryId) {

        const issue =
            document.getElementById(issueId);

        const expiry =
            document.getElementById(expiryId);


        if (!issue || !expiry) {
            return true;
        }


        if (issue.value && expiry.value) {

            if (expiry.value <= issue.value) {

                alert(
                    "Expiry date must be after issue date."
                );

                expiry.focus();

                return false;
            }
        }


        return true;
    }
    function validateCreateForm() {

        const shipment =
            document.getElementById(
                "createShipmentId"
            ).value;


        const documentType =
            document.getElementById(
                "createDocumentTypeId"
            ).value;


        const status =
            document.getElementById(
                "createDocumentStatusId"
            ).value;


        const description =
            document.getElementById(
                "createDescription"
            ).value.trim();


        if (!shipment) {

            alert(
                "Please select a shipment."
            );

            return false;
        }


        if (!documentType) {

            alert(
                "Please select a document type."
            );

            return false;
        }


        if (!status) {

            alert(
                "Please select a document status."
            );

            return false;
        }


        if (!description) {

            alert(
                "Document description is required."
            );

            document.getElementById(
                "createDescription"
            ).focus();

            return false;
        }


        if (description.length > 500) {

            alert(
                "Description cannot exceed 500 characters."
            );

            return false;
        }


        return validateDocumentDates(
            "createIssueDate",
            "createExpiryDate"
        );
    }
    function validateEditForm() {

        const shipment =
            document.getElementById(
                "editShipmentId"
            ).value;


        const documentType =
            document.getElementById(
                "editDocumentTypeId"
            ).value;


        const status =
            document.getElementById(
                "editDocumentStatusId"
            ).value;


        const description =
            document.getElementById(
                "editDescription"
            ).value.trim();


        if (!shipment) {

            alert(
                "Please select a shipment."
            );

            return false;
        }


        if (!documentType) {

            alert(
                "Please select a document type."
            );

            return false;
        }


        if (!status) {

            alert(
                "Please select a document status."
            );

            return false;
        }


        if (!description) {

            alert(
                "Document description is required."
            );

            document.getElementById(
                "editDescription"
            ).focus();

            return false;
        }


        if (description.length > 500) {

            alert(
                "Description cannot exceed 500 characters."
            );

            return false;
        }


        return validateDocumentDates(
            "editIssueDate",
            "editExpiryDate"
        );
    }

</script>


</body>

</html>


<%!


    private String jsEscape(String value) {


        if (value == null) {

            return "";

        }


        return value

                .replace(
                        "\\",
                        "\\\\"
                )

                .replace(
                        "'",
                        "\\'"
                )

                .replace(
                        "\"",
                        "\\\""
                )

                .replace(
                        "\r",
                        "\\r"
                )

                .replace(
                        "\n",
                        "\\n"
                )

                .replace(
                        "<",
                        "\\u003C"
                )

                .replace(
                        ">",
                        "\\u003E"
                )

                .replace(
                        "&",
                        "\\u0026"
                );

    }


    private String jsString(String value) {

        return "\"" +
                jsEscape(value) +
                "\"";

    }

%>
