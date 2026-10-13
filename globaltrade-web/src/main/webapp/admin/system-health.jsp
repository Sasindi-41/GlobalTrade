<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html lang="en">

<head>


    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        GlobalTrade | System Health
    </title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/admin/assets/admin-style.css">

    <style>

        .health-content {
            padding: 22px;
        }

        .health-header {
            margin-bottom: 20px;
        }

        .health-header h1 {
            font-size: 23px;
            margin-bottom: 5px;
        }

        .health-header p {
            font-size: 12px;
            color: #777;
        }

        .health-status {
            display: flex;
            align-items: center;
            gap: 9px;
            background: #eaf7ee;
            border: 1px solid #bce5c8;
            color: #218838;
            padding: 12px 15px;
            border-radius: 9px;
            margin-bottom: 15px;
            font-size: 11px;
            font-weight: 700;
        }

        .health-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #28a745;
        }

        .health-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }

        .health-card {
            background: #fff;
            border: 1px solid #e6e6e6;
            border-radius: 10px;
            padding: 18px;
        }

        .health-card h2 {
            font-size: 13px;
            margin-bottom: 14px;
        }

        .health-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eeeeee;
            font-size: 10px;
        }

        .health-row:last-child {
            border-bottom: none;
        }

        .health-label {
            color: #777;
        }

        .health-value {
            font-weight: 700;
        }

        @media (max-width: 900px) {

            .health-grid {
                grid-template-columns: 1fr;
            }
        }

    </style>


</head>

<body>

<jsp:include page="admin-sidebar.jsp"/>

<main class="main">


    <jsp:include page="admin-topbar.jsp"/>


    <section class="health-content">


        <div class="health-header">

            <h1>
                System Health
            </h1>

            <p>
                Current application runtime and environment information.
            </p>

        </div>


        <div class="health-status">

            <span class="health-dot"></span>

            GlobalTrade application is running

        </div>


        <div class="health-grid">


            <div class="health-card">

                <h2>
                    Application
                </h2>

                <div class="health-row">

                <span class="health-label">
                    Status
                </span>

                    <span class="health-value">
                    <%= request.getAttribute("applicationStatus") %>
                </span>

                </div>

                <div class="health-row">

                <span class="health-label">
                    Server Time
                </span>

                    <span class="health-value">
                    <%= request.getAttribute("serverTime") %>
                </span>

                </div>

            </div>


            <div class="health-card">

                <h2>
                    Java Runtime
                </h2>

                <div class="health-row">

                <span class="health-label">
                    Java Version
                </span>

                    <span class="health-value">
                    <%= request.getAttribute("javaVersion") %>
                </span>

                </div>

                <div class="health-row">

                <span class="health-label">
                    Processors
                </span>

                    <span class="health-value">
                    <%= request.getAttribute("availableProcessors") %>
                </span>

                </div>

            </div>


            <div class="health-card">

                <h2>
                    Operating System
                </h2>

                <div class="health-row">

                <span class="health-label">
                    OS
                </span>

                    <span class="health-value">
                    <%= request.getAttribute("osName") %>
                </span>

                </div>

                <div class="health-row">

                <span class="health-label">
                    Version
                </span>

                    <span class="health-value">
                    <%= request.getAttribute("osVersion") %>
                </span>

                </div>

            </div>


            <div class="health-card">

                <h2>
                    JVM Memory
                </h2>

                <div class="health-row">

                <span class="health-label">
                    Used
                </span>

                    <span class="health-value">
                    <%= request.getAttribute("usedMemory") %>
                </span>

                </div>

                <div class="health-row">

                <span class="health-label">
                    Allocated
                </span>

                    <span class="health-value">
                    <%= request.getAttribute("totalMemory") %>
                </span>

                </div>

                <div class="health-row">

                <span class="health-label">
                    Maximum
                </span>

                    <span class="health-value">
                    <%= request.getAttribute("maxMemory") %>
                </span>

                </div>

            </div>

        </div>

    </section>


</main>

</body>

</html>
