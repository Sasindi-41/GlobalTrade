<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>GlobalTrade | Sign In</title>


    <!-- Font Awesome -->

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <style>

        :root {
            --yellow: #FCBF49;
            --orange: #F77F00;
            --red: #D62828;
            --navy: #003049;

            --light-yellow: #FFF9E8;
            --white: #FFFFFF;
            --light-gray: #F7F7F5;
            --border: #E9E3D5;
            --text: #003049;
            --muted: #6F7478;

            --shadow: 0 12px 35px rgba(0, 48, 73, 0.10);
        }


        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }


        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: var(--light-yellow);
            color: var(--text);
            min-height: 100vh;
        }


        a {
            text-decoration: none;
            color: inherit;
        }


        button,
        input {
            font: inherit;
        }


        /* =========================
           PAGE
           ========================= */

        .page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 25px;
        }


        /* =========================
           MAIN CONTAINER
           ========================= */

        .auth-container {
            width: 100%;
            max-width: 920px;
            min-height: 570px;
            background: var(--white);
            border-radius: 18px;
            overflow: hidden;
            display: grid;
            grid-template-columns: 42% 58%;
            box-shadow: var(--shadow);
            border: 1px solid rgba(0, 48, 73, 0.06);
        }


        /* =========================
           LEFT SIDE
           ========================= */

        .auth-left {
            background: var(--navy);
            padding: 42px 38px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }


        .auth-left::before {
            content: "";
            position: absolute;
            width: 230px;
            height: 230px;
            background: var(--orange);
            border-radius: 50%;
            top: -120px;
            right: -100px;
            opacity: .95;
        }


        .auth-left::after {
            content: "";
            position: absolute;
            width: 180px;
            height: 180px;
            background: var(--yellow);
            border-radius: 50%;
            bottom: -100px;
            left: -90px;
            opacity: .9;
        }


        .brand {
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            gap: 11px;
        }


        .brand-logo {
            width: 43px;
            height: 43px;
            border-radius: 11px;
            background: var(--yellow);
            color: var(--navy);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }


        .brand-name {
            color: white;
            font-size: 20px;
            font-weight: 700;
        }


        .brand-subtitle {
            color: rgba(255,255,255,.65);
            font-size: 10px;
            margin-top: 2px;
        }


        .welcome-content {
            position: relative;
            z-index: 2;
        }


        .welcome-content h1 {
            color: white;
            font-size: 31px;
            line-height: 1.15;
            margin-bottom: 13px;
        }


        .welcome-content h1 span {
            color: var(--yellow);
        }


        .welcome-content p {
            color: rgba(255,255,255,.72);
            font-size: 13px;
            line-height: 1.7;
            max-width: 300px;
        }


        .feature-list {
            position: relative;
            z-index: 2;
            list-style: none;
            margin-top: 25px;
        }


        .feature-list li {
            display: flex;
            align-items: center;
            gap: 10px;
            color: rgba(255,255,255,.82);
            font-size: 11px;
            margin: 12px 0;
        }


        .feature-list i {
            width: 23px;
            height: 23px;
            border-radius: 50%;
            background: rgba(252,191,73,.15);
            color: var(--yellow);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
        }


        .copyright {
            position: relative;
            z-index: 2;
            color: rgba(255,255,255,.45);
            font-size: 9px;
        }


        /* =========================
           RIGHT SIDE
           ========================= */

        .auth-right {
            padding: 42px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }


        .form-heading {
            margin-bottom: 25px;
        }


        .form-heading h2 {
            color: var(--navy);
            font-size: 25px;
            margin-bottom: 6px;
        }


        .form-heading p {
            color: var(--muted);
            font-size: 12px;
        }


        /* =========================
           FORM
           ========================= */

        .form-group {
            margin-bottom: 16px;
        }


        .form-label {
            display: block;
            color: var(--navy);
            font-size: 11px;
            font-weight: 600;
            margin-bottom: 7px;
        }


        .input-wrapper {
            position: relative;
        }


        .input-wrapper > i {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--orange);
            font-size: 13px;
            pointer-events: none;
        }


        .form-input {
            width: 100%;
            height: 44px;
            border: 1px solid var(--border);
            border-radius: 7px;
            outline: none;
            padding: 0 13px 0 38px;
            background: #FFFDF7;
            color: var(--navy);
            font-size: 12px;
            transition: .2s ease;
        }


        .form-input:focus {
            border-color: var(--orange);
            background: white;
            box-shadow: 0 0 0 3px rgba(247,127,0,.10);
        }


        .form-input::placeholder {
            color: #A5A5A5;
        }


        /* =========================
           PASSWORD
           ========================= */

        .password-toggle {
            position: absolute;
            right: 13px;
            top: 50%;
            transform: translateY(-50%);
            border: 0;
            background: transparent;
            color: #999;
            cursor: pointer;
            font-size: 13px;
        }


        .password-toggle:hover {
            color: var(--orange);
        }


        /* =========================
           FORM OPTIONS
           ========================= */

        .form-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 3px 0 20px;
        }


        .remember {
            display: flex;
            align-items: center;
            gap: 7px;
            color: var(--muted);
            font-size: 10px;
            cursor: pointer;
        }


        .remember input {
            accent-color: var(--orange);
            width: 13px;
            height: 13px;
        }


        .forgot-password {
            color: var(--orange);
            font-size: 10px;
            font-weight: 600;
        }


        .forgot-password:hover {
            color: var(--red);
        }


        /* =========================
           BUTTON
           ========================= */

        .signin-btn {
            width: 100%;
            height: 45px;
            border: 0;
            border-radius: 7px;
            background: var(--orange);
            color: white;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: .2s ease;
            box-shadow: 0 6px 15px rgba(247,127,0,.20);
        }


        .signin-btn:hover {
            background: var(--red);
            transform: translateY(-1px);
            box-shadow: 0 8px 18px rgba(214,40,40,.20);
        }


        .signin-btn i {
            margin-left: 7px;
        }


        /* =========================
           DIVIDER
           ========================= */

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 22px 0;
        }


        .divider::before,
        .divider::after {
            content: "";
            height: 1px;
            background: var(--border);
            flex: 1;
        }


        .divider span {
            color: #999;
            font-size: 9px;
        }


        /* =========================
           SIGN UP
           ========================= */

        .signup-text {
            text-align: center;
            color: var(--muted);
            font-size: 11px;
        }


        .signup-text a {
            color: var(--orange);
            font-weight: 700;
            margin-left: 4px;
        }


        .signup-text a:hover {
            color: var(--red);
        }


        /* =========================
           ERROR
           ========================= */

        .error-message {
            background: #FFF0EF;
            border: 1px solid rgba(214,40,40,.18);
            color: var(--red);
            border-radius: 6px;
            padding: 9px 11px;
            margin-bottom: 15px;
            font-size: 10px;
        }


        .error-message i {
            margin-right: 5px;
        }


        /* =========================
           SUCCESS
           ========================= */

        .success-message {
            background: #EFFAF3;
            border: 1px solid rgba(25,135,84,.18);
            color: #198754;
            border-radius: 6px;
            padding: 9px 11px;
            margin-bottom: 15px;
            font-size: 10px;
        }


        .success-message i {
            margin-right: 5px;
        }


        /* =========================
           RESPONSIVE
           ========================= */

        @media (max-width: 750px) {

            .auth-container {
                max-width: 480px;
                grid-template-columns: 1fr;
            }


            .auth-left {
                min-height: 230px;
                padding: 28px;
            }


            .welcome-content {
                margin-top: 25px;
            }


            .welcome-content h1 {
                font-size: 25px;
            }


            .welcome-content p,
            .feature-list,
            .copyright {
                display: none;
            }


            .auth-right {
                padding: 35px 30px;
            }
        }


        @media (max-width: 450px) {

            .page {
                padding: 12px;
            }


            .auth-container {
                border-radius: 12px;
            }


            .auth-left {
                padding: 25px;
            }


            .auth-right {
                padding: 30px 22px;
            }


            .form-heading h2 {
                font-size: 22px;
            }
        }

    </style>

</head>


<body>

<div class="page">

    <div class="auth-container">


        <!-- =========================================
             LEFT SIDE
             ========================================= -->

        <section class="auth-left">


            <div class="brand">

                <div class="brand-logo">
                    <i class="fa-solid fa-globe"></i>
                </div>


                <div>

                    <div class="brand-name">
                        GlobalTrade
                    </div>

                    <div class="brand-subtitle">
                        Logistics System
                    </div>

                </div>

            </div>


            <div class="welcome-content">

                <h1>
                    Welcome<br>
                    <span>back!</span>
                </h1>


                <p>
                    Manage shipments, inventory, vendors and
                    global trade operations from one place.
                </p>


                <ul class="feature-list">

                    <li>
                        <i class="fa-solid fa-truck-fast"></i>
                        Track shipments in real time
                    </li>


                    <li>
                        <i class="fa-solid fa-boxes-stacked"></i>
                        Manage inventory efficiently
                    </li>


                    <li>
                        <i class="fa-solid fa-chart-line"></i>
                        Monitor your operations
                    </li>

                </ul>

            </div>


            <div class="copyright">
                © 2026 GlobalTrade Logistics System
            </div>

        </section>


        <!-- =========================================
             RIGHT SIDE
             ========================================= -->

        <section class="auth-right">


            <div class="form-heading">

                <h2>
                    Sign In
                </h2>

                <p>
                    Enter your username and password to access your account.
                </p>

            </div>


            <!-- =========================================
                 SERVER ERROR MESSAGE
                 ========================================= -->

            <%
                String errorMessage =
                        (String) request.getAttribute("errorMessage");

                if (errorMessage != null &&
                        !errorMessage.trim().isEmpty()) {
            %>

            <div class="error-message">

                <i class="fa-solid fa-circle-exclamation"></i>

                <%= errorMessage %>

            </div>

            <%
                }
            %>


            <!-- =========================================
                 REGISTRATION SUCCESS MESSAGE
                 ========================================= -->

            <%
                String registered =
                        request.getParameter("registered");

                if ("true".equals(registered)) {
            %>

            <div class="success-message">

                <i class="fa-solid fa-circle-check"></i>

                Account created successfully.
                Please sign in.

            </div>

            <%
                }
            %>


            <!-- =========================================
                 SIGN IN FORM
                 ========================================= -->

            <form
                    action="${pageContext.request.contextPath}/signin"
                    method="post"
                    onsubmit="return validateForm();">


                <!-- =====================================
                     USERNAME
                     ===================================== -->

                <div class="form-group">

                    <label
                            class="form-label"
                            for="username">

                        Username

                    </label>


                    <div class="input-wrapper">

                        <i class="fa-regular fa-user"></i>


                        <input
                                type="text"
                                id="username"
                                name="username"
                                class="form-input"
                                placeholder="Enter your username"
                                value="<%= request.getAttribute("username") != null
                                        ? request.getAttribute("username")
                                        : "" %>"
                                required
                                autocomplete="username">

                    </div>

                </div>


                <!-- =====================================
                     PASSWORD
                     ===================================== -->

                <div class="form-group">

                    <label
                            class="form-label"
                            for="password">

                        Password

                    </label>


                    <div class="input-wrapper">

                        <i class="fa-solid fa-lock"></i>


                        <input
                                type="password"
                                id="password"
                                name="password"
                                class="form-input"
                                placeholder="Enter your password"
                                required
                                autocomplete="current-password">


                        <button
                                type="button"
                                class="password-toggle"
                                onclick="togglePassword()"
                                title="Show password"
                                aria-label="Show password">

                            <i
                                    class="fa-regular fa-eye"
                                    id="passwordIcon">
                            </i>

                        </button>

                    </div>

                </div>


                <!-- =====================================
                     OPTIONS
                     ===================================== -->

                <div class="form-options">

                    <label class="remember">

                        <input
                                type="checkbox"
                                name="remember">

                        Remember me

                    </label>


                    <a
                            href="${pageContext.request.contextPath}/forgot-password"
                            class="forgot-password">

                        Forgot password?

                    </a>

                </div>


                <!-- =====================================
                     BUTTON
                     ===================================== -->

                <button
                        type="submit"
                        class="signin-btn">

                    Sign In

                    <i class="fa-solid fa-arrow-right"></i>

                </button>

            </form>


            <div class="divider">

                <span>
                    OR
                </span>

            </div>


            <div class="signup-text">

                Don't have an account?

                <a href="${pageContext.request.contextPath}/signup">
                    Create Account
                </a>

            </div>


        </section>

    </div>

</div>


<script>


    // =========================================================
    // PASSWORD VISIBILITY
    // =========================================================

    function togglePassword() {

        const password =
            document.getElementById("password");

        const icon =
            document.getElementById("passwordIcon");


        if (password.type === "password") {

            password.type = "text";

            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");

        } else {

            password.type = "password";

            icon.classList.remove("fa-eye-slash");
            icon.classList.add("fa-eye");
        }
    }


    // =========================================================
    // BASIC CLIENT-SIDE VALIDATION
    // =========================================================

    function validateForm() {

        const username =
            document.getElementById("username")
                .value
                .trim();


        const password =
            document.getElementById("password")
                .value;


        if (username === "" ||
            password === "") {

            return false;
        }


        return true;
    }

</script>


</body>

</html>