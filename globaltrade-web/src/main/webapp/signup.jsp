<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>GlobalTrade | Sign Up</title>

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>

        :root {
            --navy: #003049;
            --orange: #F77F00;
            --yellow: #FCBF49;
            --red: #D62828;

            --light-yellow: #fff8df;
            --light-orange: #fff1df;
            --light-red: #fff0ef;

            --white: #ffffff;
            --text: #003049;
            --muted: #6d7b83;

            --border: #e8e1d2;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
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
        input,
        select {
            font-family: inherit;
        }

        .page {
            min-height: 100vh;
            display: flex;
        }

        /* =========================
           LEFT SECTION
           ========================= */

        .left-section {
            width: 46%;
            min-height: 100vh;

            background:
                    radial-gradient(
                            circle at 20% 20%,
                            rgba(252, 191, 73, 0.20),
                            transparent 28%
                    ),
                    radial-gradient(
                            circle at 85% 75%,
                            rgba(247, 127, 0, 0.18),
                            transparent 30%
                    ),
                    var(--navy);

            color: var(--white);

            display: flex;
            align-items: center;
            justify-content: center;

            padding: 45px;

            position: relative;
            overflow: hidden;
        }

        .circle-one {
            position: absolute;

            width: 230px;
            height: 230px;

            border-radius: 50%;

            border: 35px solid rgba(252, 191, 73, 0.10);

            top: -80px;
            left: -70px;
        }

        .circle-two {
            position: absolute;

            width: 280px;
            height: 280px;

            border-radius: 50%;

            border: 40px solid rgba(247, 127, 0, 0.10);

            bottom: -120px;
            right: -100px;
        }

        .left-content {
            width: 100%;
            max-width: 480px;

            position: relative;
            z-index: 2;
        }

        /* =========================
           BRAND
           ========================= */

        .brand {
            display: flex;
            align-items: center;

            gap: 13px;

            margin-bottom: 55px;
        }

        .brand-icon {
            width: 48px;
            height: 48px;

            background: var(--orange);

            border-radius: 13px;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 21px;

            box-shadow:
                    0 8px 20px rgba(247, 127, 0, 0.25);
        }

        .brand-text h2 {
            font-size: 21px;
            font-weight: 700;

            letter-spacing: -0.4px;
        }

        .brand-text span {
            display: block;

            font-size: 11px;

            color: rgba(255,255,255,.62);

            margin-top: 2px;
        }

        /* =========================
           LEFT CONTENT
           ========================= */

        .left-content h1 {
            font-size: 40px;

            line-height: 1.15;

            letter-spacing: -1px;

            margin-bottom: 18px;
        }

        .left-content h1 span {
            color: var(--yellow);
        }

        .left-content > p {
            color: rgba(255,255,255,.72);

            font-size: 14px;

            line-height: 1.7;

            max-width: 420px;

            margin-bottom: 35px;
        }

        /* =========================
           FEATURES
           ========================= */

        .features {
            display: flex;

            flex-direction: column;

            gap: 17px;
        }

        .feature {
            display: flex;

            align-items: center;

            gap: 13px;
        }

        .feature-icon {
            width: 37px;
            height: 37px;

            flex: 0 0 37px;

            background: rgba(252,191,73,.13);

            border: 1px solid rgba(252,191,73,.20);

            color: var(--yellow);

            border-radius: 9px;

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 13px;
        }

        .feature-text strong {
            display: block;

            font-size: 12px;

            margin-bottom: 2px;
        }

        .feature-text span {
            font-size: 10px;

            color: rgba(255,255,255,.55);
        }

        /* =========================
           RIGHT SECTION
           ========================= */

        .right-section {
            width: 54%;

            min-height: 100vh;

            display: flex;

            align-items: center;
            justify-content: center;

            padding: 30px 45px;

            background: var(--light-yellow);
        }

        /* =========================
           SIGNUP CARD
           ========================= */

        .signup-card {
            width: 100%;

            max-width: 560px;

            background: var(--white);

            border: 1px solid rgba(0,48,73,.08);

            border-radius: 17px;

            padding: 31px 35px 27px;

            box-shadow:
                    0 15px 45px rgba(0,48,73,.09);
        }

        .form-heading {
            margin-bottom: 23px;
        }

        .form-heading h1 {
            color: var(--navy);

            font-size: 26px;

            letter-spacing: -.5px;

            margin-bottom: 6px;
        }

        .form-heading p {
            color: var(--muted);

            font-size: 12px;
        }

        /* =========================
           FORM
           ========================= */

        .form-row {
            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 13px;
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-group label {
            display: block;

            color: var(--navy);

            font-size: 11px;

            font-weight: 600;

            margin-bottom: 6px;
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

            font-size: 12px;

            pointer-events: none;
        }

        .input-wrapper input,
        .input-wrapper select {
            width: 100%;

            height: 43px;

            border: 1px solid var(--border);

            border-radius: 8px;

            background: #fff;

            color: var(--navy);

            outline: none;

            padding: 0 13px 0 36px;

            font-size: 12px;

            transition: .2s ease;
        }

        .input-wrapper input::placeholder {
            color: #a1a9ad;
        }

        .input-wrapper input:focus,
        .input-wrapper select:focus {
            border-color: var(--orange);

            box-shadow:
                    0 0 0 3px rgba(247,127,0,.10);
        }

        /* =========================
           PASSWORD
           ========================= */

        .password-wrapper input {
            padding-right: 40px;
        }

        .password-toggle {
            position: absolute;

            right: 12px;

            top: 50%;

            transform: translateY(-50%);

            color: var(--muted);

            cursor: pointer;

            font-size: 12px;

            pointer-events: auto !important;
        }

        .password-toggle:hover {
            color: var(--orange);
        }

        .password-hint {
            margin-top: 5px;

            font-size: 9px;

            color: var(--muted);

            line-height: 1.4;
        }

        /* =========================
           TERMS
           ========================= */

        .terms {
            display: flex;

            align-items: flex-start;

            gap: 8px;

            margin: 3px 0 17px;

            color: var(--muted);

            font-size: 10px;

            line-height: 1.5;
        }

        .terms input {
            margin-top: 2px;

            accent-color: var(--orange);
        }

        .terms a {
            color: var(--orange);

            font-weight: 600;
        }

        /* =========================
           BUTTON
           ========================= */

        .signup-btn {
            width: 100%;

            height: 44px;

            border: none;

            border-radius: 8px;

            background: var(--orange);

            color: var(--white);

            font-size: 12px;

            font-weight: 700;

            cursor: pointer;

            transition: .2s ease;

            box-shadow:
                    0 7px 17px rgba(247,127,0,.22);
        }

        .signup-btn:hover {
            background: var(--red);

            transform: translateY(-1px);

            box-shadow:
                    0 9px 20px rgba(214,40,40,.20);
        }

        .signup-btn:disabled {
            opacity: .7;

            cursor: not-allowed;

            transform: none;
        }

        /* =========================
           DIVIDER
           ========================= */

        .divider {
            display: flex;

            align-items: center;

            gap: 10px;

            margin: 20px 0 17px;

            color: #9ba3a7;

            font-size: 9px;
        }

        .divider::before,
        .divider::after {
            content: "";

            height: 1px;

            flex: 1;

            background: #eee8dc;
        }

        /* =========================
           SIGN IN
           ========================= */

        .signin-text {
            text-align: center;

            color: var(--muted);

            font-size: 11px;
        }

        .signin-text a {
            color: var(--orange);

            font-weight: 700;

            margin-left: 3px;
        }

        .signin-text a:hover {
            color: var(--red);
        }

        /* =========================
           MESSAGE
           ========================= */

        .message {
            display: none;

            padding: 9px 11px;

            margin-bottom: 15px;

            border-radius: 7px;

            font-size: 10px;

            line-height: 1.4;
        }

        .message.error {
            display: block;

            background: var(--light-red);

            color: var(--red);

            border: 1px solid rgba(214,40,40,.15);
        }

        .message.success {
            display: block;

            background: #fff8df;

            color: var(--navy);

            border: 1px solid rgba(252,191,73,.35);
        }

        /* =========================
           RESPONSIVE
           ========================= */

        @media (max-width: 950px) {

            .page {
                display: block;
            }

            .left-section {
                width: 100%;

                min-height: auto;

                padding: 35px 30px;
            }

            .left-content {
                max-width: 700px;
            }

            .brand {
                margin-bottom: 30px;
            }

            .left-content h1 {
                font-size: 32px;
            }

            .features {
                display: grid;

                grid-template-columns: repeat(3, 1fr);
            }

            .right-section {
                width: 100%;

                min-height: auto;

                padding: 35px 20px;
            }
        }

        @media (max-width: 600px) {

            .left-section {
                padding: 28px 20px;
            }

            .left-content h1 {
                font-size: 28px;
            }

            .left-content > p {
                font-size: 12px;
            }

            .features {
                display: none;
            }

            .right-section {
                padding: 25px 15px 35px;
            }

            .signup-card {
                padding: 25px 21px 23px;

                border-radius: 13px;
            }

            .form-row {
                grid-template-columns: 1fr;

                gap: 0;
            }
        }

    </style>

</head>

<body>

<div class="page">

    <!-- =====================================================
         LEFT SECTION
         ===================================================== -->

    <section class="left-section">

        <div class="circle-one"></div>
        <div class="circle-two"></div>

        <div class="left-content">

            <!-- Brand -->

            <div class="brand">

                <div class="brand-icon">
                    <i class="fa-solid fa-globe"></i>
                </div>

                <div class="brand-text">

                    <h2>GlobalTrade</h2>

                    <span>
                        Logistics Management System
                    </span>

                </div>

            </div>

            <!-- Heading -->

            <h1>
                Join <span>GlobalTrade</span>
                today.
            </h1>

            <p>
                Create your GlobalTrade account and get
                access to shipment management, inventory,
                vendors, customs documents and global
                supply chain operations.
            </p>

            <!-- Features -->

            <div class="features">

                <div class="feature">

                    <div class="feature-icon">
                        <i class="fa-solid fa-truck-fast"></i>
                    </div>

                    <div class="feature-text">

                        <strong>Track Shipments</strong>

                        <span>
                            Monitor your shipments in real time.
                        </span>

                    </div>

                </div>

                <div class="feature">

                    <div class="feature-icon">
                        <i class="fa-solid fa-boxes-stacked"></i>
                    </div>

                    <div class="feature-text">

                        <strong>Manage Inventory</strong>

                        <span>
                            Keep your inventory under control.
                        </span>

                    </div>

                </div>

                <div class="feature">

                    <div class="feature-icon">
                        <i class="fa-solid fa-chart-line"></i>
                    </div>

                    <div class="feature-text">

                        <strong>Smart Analytics</strong>

                        <span>
                            Make better decisions with insights.
                        </span>

                    </div>

                </div>

            </div>

        </div>

    </section>


    <!-- =====================================================
         RIGHT SECTION
         ===================================================== -->

    <section class="right-section">

        <div class="signup-card">

            <!-- Heading -->

            <div class="form-heading">

                <h1>Create Account</h1>

                <p>
                    Enter your details to create your
                    GlobalTrade account.
                </p>

            </div>


            <!-- =================================================
                 SERVER MESSAGE
                 ================================================= -->

            <%

                String errorMessage =
                        (String) request.getAttribute("errorMessage");

                String successMessage =
                        (String) request.getAttribute("successMessage");

                if (errorMessage != null &&
                        !errorMessage.trim().isEmpty()) {

            %>

            <div id="message"
                 class="message error">

                <%= errorMessage %>

            </div>

            <%

            } else if (successMessage != null &&
                    !successMessage.trim().isEmpty()) {

            %>

            <div id="message"
                 class="message success">

                <%= successMessage %>

            </div>

            <%

            } else {

            %>

            <div id="message"
                 class="message">
            </div>

            <%

                }

            %>


            <!-- =================================================
                 FORM
                 ================================================= -->

            <form action="${pageContext.request.contextPath}/signup"
                  method="post"
                  onsubmit="return validateForm();">


                <!-- =========================
                     FIRST + LAST NAME
                     ========================= -->

                <div class="form-row">

                    <!-- First Name -->

                    <div class="form-group">

                        <label for="firstName">
                            First Name
                        </label>

                        <div class="input-wrapper">

                            <i class="fa-solid fa-user"></i>

                            <input
                                    type="text"
                                    id="firstName"
                                    name="firstName"
                                    placeholder="First name"
                                    autocomplete="given-name"
                                    minlength="2"
                                    maxlength="50"
                                    value="<%= request.getAttribute("firstName") != null
                                        ? request.getAttribute("firstName") : "" %>"
                                    required>

                        </div>

                    </div>


                    <!-- Last Name -->

                    <div class="form-group">

                        <label for="lastName">
                            Last Name
                        </label>

                        <div class="input-wrapper">

                            <i class="fa-solid fa-user"></i>

                            <input
                                    type="text"
                                    id="lastName"
                                    name="lastName"
                                    placeholder="Last name"
                                    autocomplete="family-name"
                                    minlength="2"
                                    maxlength="50"
                                    value="<%= request.getAttribute("lastName") != null
                                        ? request.getAttribute("lastName") : "" %>"
                                    required>

                        </div>

                    </div>

                </div>


                <!-- =========================
                     EMAIL
                     ========================= -->

                <div class="form-group">

                    <label for="email">
                        Email Address
                    </label>

                    <div class="input-wrapper">

                        <i class="fa-solid fa-envelope"></i>

                        <input
                                type="email"
                                id="email"
                                name="email"
                                placeholder="Enter your email"
                                autocomplete="email"
                                maxlength="150"
                                value="<%= request.getAttribute("email") != null
                                    ? request.getAttribute("email") : "" %>"
                                required>

                    </div>

                </div>


                <!-- =========================
      PHONE
      ========================= -->

                <div class="form-group">

                    <label for="phone">
                        Phone Number
                    </label>

                    <div class="input-wrapper">

                        <i class="fa-solid fa-phone"></i>

                        <input
                                type="tel"
                                id="phone"
                                name="phone"
                                placeholder="07XXXXXXXX"
                                maxlength="10"
                                minlength="10"
                                autocomplete="tel"
                                value="<%= request.getAttribute("phone") != null
                    ? request.getAttribute("phone") : "" %>"
                                required>

                    </div>

                </div>


                <!-- =========================
                     USERNAME
                     ========================= -->

                <div class="form-group">

                    <label for="username">
                        Username
                    </label>

                    <div class="input-wrapper">

                        <i class="fa-solid fa-at"></i>

                        <input
                                type="text"
                                id="username"
                                name="username"
                                placeholder="Choose a username"
                                autocomplete="username"
                                minlength="4"
                                maxlength="50"
                                value="<%= request.getAttribute("username") != null
                                    ? request.getAttribute("username") : "" %>"
                                required>

                    </div>

                </div>


                <!-- =========================
                     PASSWORD
                     ========================= -->

                <div class="form-group">

                    <label for="password">
                        Password
                    </label>

                    <div class="input-wrapper password-wrapper">

                        <i class="fa-solid fa-lock"></i>

                        <input
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Create a password"
                                autocomplete="new-password"
                                minlength="8"
                                maxlength="100"
                                required>

                        <i
                                class="fa-solid fa-eye password-toggle"
                                id="passwordEye"
                                onclick="togglePassword(
                                'password',
                                'passwordEye'
                            )">
                        </i>

                    </div>

                    <div class="password-hint">
                        Minimum 8 characters with at least one
                        uppercase letter, one lowercase letter,
                        one number and one special character.
                    </div>

                </div>


                <!-- =========================
                     CONFIRM PASSWORD
                     ========================= -->

                <div class="form-group">

                    <label for="confirmPassword">
                        Confirm Password
                    </label>

                    <div class="input-wrapper password-wrapper">

                        <i class="fa-solid fa-lock"></i>

                        <input
                                type="password"
                                id="confirmPassword"
                                name="confirmPassword"
                                placeholder="Confirm your password"
                                autocomplete="new-password"
                                minlength="8"
                                maxlength="100"
                                required>

                        <i
                                class="fa-solid fa-eye password-toggle"
                                id="confirmPasswordEye"
                                onclick="togglePassword(
                                'confirmPassword',
                                'confirmPasswordEye'
                            )">
                        </i>

                    </div>

                </div>


                <!-- =========================
                     TERMS
                     ========================= -->

                <div class="terms">

                    <input
                            type="checkbox"
                            id="terms"
                            name="terms"
                            required>

                    <label for="terms">

                        I agree to the

                        <a href="#" onclick="return false;">
                            Terms & Conditions
                        </a>

                        and

                        <a href="#" onclick="return false;">
                            Privacy Policy
                        </a>.

                    </label>

                </div>


                <!-- =========================
                     SUBMIT
                     ========================= -->

                <button
                        type="submit"
                        class="signup-btn"
                        id="signupButton">

                    <i class="fa-solid fa-user-plus"></i>

                    &nbsp; Create Account

                </button>

            </form>


            <!-- =========================
                 DIVIDER
                 ========================= -->

            <div class="divider">
                OR
            </div>


            <!-- =========================
                 SIGN IN
                 ========================= -->

            <div class="signin-text">

                Already have an account?

                <a href="${pageContext.request.contextPath}/signin">
                    Sign In
                </a>

            </div>

        </div>

    </section>

</div>


<script>

    /* =====================================================
       PASSWORD VISIBILITY
       ===================================================== */

    function togglePassword(inputId, eyeId) {

        const input =
            document.getElementById(inputId);

        const eye =
            document.getElementById(eyeId);

        if (input.type === "password") {

            input.type = "text";

            eye.classList.remove("fa-eye");

            eye.classList.add("fa-eye-slash");

        } else {

            input.type = "password";

            eye.classList.remove("fa-eye-slash");

            eye.classList.add("fa-eye");
        }
    }


    /* =====================================================
       FORM VALIDATION
       ===================================================== */

    function validateForm() {

        const firstName =
            document.getElementById("firstName")
                .value
                .trim();

        const lastName =
            document.getElementById("lastName")
                .value
                .trim();

        const email =
            document.getElementById("email")
                .value
                .trim();

        const phone =
            document.getElementById("phone")
                .value
                .trim();

        const role =
            document.getElementById("role")
                .value;

        const username =
            document.getElementById("username")
                .value
                .trim();

        const password =
            document.getElementById("password")
                .value;

        const confirmPassword =
            document.getElementById("confirmPassword")
                .value;

        const terms =
            document.getElementById("terms")
                .checked;

        const message =
            document.getElementById("message");

        const button =
            document.getElementById("signupButton");


        /* Clear previous message */

        message.style.display = "none";

        message.className = "message";


        /* First Name */

        if (firstName.length < 2) {

            showError(
                "Please enter your first name."
            );

            return false;
        }


        /* Last Name */

        if (lastName.length < 2) {

            showError(
                "Please enter your last name."
            );

            return false;
        }


        /* Email */

        const emailPattern =
            /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailPattern.test(email)) {

            showError(
                "Please enter a valid email address."
            );

            return false;
        }


        /* Phone */

        const phonePattern =
            /^07[0-9]{8}$/;

        if (!phonePattern.test(phone)) {

            showError(
                "Please enter a valid Sri Lankan mobile number."
            );

            return false;
        }


        /* Role */

        if (!role) {

            showError(
                "Please select an account type."
            );

            return false;
        }


        /* Username */

        const usernamePattern =
            /^[A-Za-z0-9_]{4,50}$/;

        if (!usernamePattern.test(username)) {

            showError(
                "Username must contain 4-50 characters using letters, numbers or underscore."
            );

            return false;
        }


        /* Password */

        if (password.length < 8) {

            showError(
                "Password must contain at least 8 characters."
            );

            return false;
        }


        if (!/[A-Z]/.test(password)) {

            showError(
                "Password must contain at least one uppercase letter."
            );

            return false;
        }


        if (!/[a-z]/.test(password)) {

            showError(
                "Password must contain at least one lowercase letter."
            );

            return false;
        }


        if (!/[0-9]/.test(password)) {

            showError(
                "Password must contain at least one number."
            );

            return false;
        }


        if (!/[^A-Za-z0-9]/.test(password)) {

            showError(
                "Password must contain at least one special character."
            );

            return false;
        }


        /* Confirm Password */

        if (password !== confirmPassword) {

            showError(
                "Passwords do not match."
            );

            return false;
        }


        /* Terms */

        if (!terms) {

            showError(
                "Please agree to the Terms & Conditions."
            );

            return false;
        }


        /* Prevent double submission */

        button.disabled = true;

        button.innerHTML =
            '<i class="fa-solid fa-spinner fa-spin"></i>' +
            '&nbsp; Creating Account...';

        return true;
    }


    /* =====================================================
       ERROR MESSAGE
       ===================================================== */

    function showError(text) {

        const message =
            document.getElementById("message");

        message.textContent = text;

        message.className =
            "message error";

        message.style.display =
            "block";
    }


    /* =====================================================
       AUTO HIDE SUCCESS MESSAGE
       ===================================================== */

    window.addEventListener("load", function () {

        const message =
            document.getElementById("message");

        if (
            message &&
            message.classList.contains("success")
        ) {

            setTimeout(function () {

                message.style.display = "none";

            }, 5000);
        }

    });

</script>

</body>

</html>