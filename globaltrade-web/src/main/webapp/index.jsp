<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>GlobalTrade | Logistics System</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>

        :root {
            --yellow: #FCBF49;
            --orange: #F77F00;
            --red: #D62828;
            --navy: #003049;

            --light-yellow: #FFF9EA;
            --lighter-yellow: #FFFCF4;
            --white: #FFFFFF;

            --text: #003049;
            --muted: #596775;
            --border: #F3DFAE;

            --container: 1390px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background: var(--lighter-yellow);
            line-height: 1.6;
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


        .navbar {
            height: 74px;
            background: var(--navy);
            display: flex;
            align-items: center;
            padding: 0 4.5%;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .navbar-container {
            width: 100%;
            max-width: var(--container);
            margin: auto;
            display: flex;
            align-items: center;
        }


        .logo {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .logo-icon {
            width: 42px;
            height: 42px;
            background: var(--yellow);
            color: var(--navy);
            border-radius: 9px;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 19px;
        }

        .logo-text {
            color: var(--white);
        }

        .logo-title {
            font-size: 20px;
            font-weight: 750;
            line-height: 1.1;
        }

        .logo-subtitle {
            font-size: 11px;
            color: rgba(255,255,255,.72);
            margin-top: 2px;
        }


        .nav-links {
            display: flex;
            align-items: center;
            gap: 38px;
            margin-left: auto;
            margin-right: 30px;
        }

        .nav-links a {
            color: rgba(255,255,255,.9);
            font-size: 14px;
            font-weight: 600;
            position: relative;
            padding: 26px 0;
            transition: .2s ease;
        }

        .nav-links a:hover {
            color: var(--yellow);
        }

        .nav-links a.active {
            color: var(--white);
        }

        .nav-links a.active::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;

            height: 3px;
            background: var(--yellow);
        }


        .nav-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .nav-signin {
            height: 42px;
            padding: 0 18px;

            border: 1px solid rgba(255,255,255,.75);
            border-radius: 6px;

            color: var(--white);
            background: transparent;

            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;

            font-size: 13px;
            font-weight: 600;

            transition: .2s ease;
        }

        .nav-signin:hover {
            background: rgba(255,255,255,.08);
            border-color: var(--yellow);
            color: var(--yellow);
        }

        .nav-signup {
            height: 42px;
            padding: 0 20px;

            border-radius: 6px;
            border: 1px solid var(--yellow);

            background: var(--yellow);
            color: var(--navy);

            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;

            font-size: 13px;
            font-weight: 700;

            transition: .2s ease;
        }

        .nav-signup:hover {
            background: var(--orange);
            border-color: var(--orange);
            color: var(--white);
        }

        .hero {
            min-height: 455px;
            background: var(--light-yellow);
            position: relative;
            overflow: hidden;
        }

        .hero-container {
            max-width: var(--container);
            min-height: 455px;
            margin: auto;

            display: flex;
            align-items: center;

            padding: 40px 0;
            position: relative;
        }

        .hero-map {
            position: absolute;
            left: 32%;
            top: 45px;

            width: 420px;
            height: 330px;

            opacity: .16;

            background-image:
                    radial-gradient(
                            circle,
                            var(--yellow) 1.4px,
                            transparent 1.5px
                    );

            background-size: 9px 9px;

            border-radius: 50%;
            transform: rotate(-12deg);
        }


        .hero-content {
            width: 50%;
            position: relative;
            z-index: 2;
        }

        .hero-small-title {
            color: var(--orange);
            font-size: 14px;
            font-weight: 800;
            letter-spacing: .7px;
            text-transform: uppercase;
            margin-bottom: 12px;
        }

        .hero-title {
            color: var(--navy);
            font-size: 52px;
            line-height: 1.08;
            letter-spacing: -1.5px;
            font-weight: 800;
            max-width: 650px;
        }

        .hero-line {
            width: 60px;
            height: 4px;
            background: var(--yellow);
            margin: 21px 0;
        }

        .hero-description {
            max-width: 570px;
            color: var(--muted);
            font-size: 15px;
            line-height: 1.75;
        }


        .hero-buttons {
            display: flex;
            gap: 15px;
            margin-top: 27px;
        }

        .hero-btn {
            height: 47px;
            padding: 0 25px;

            border-radius: 6px;

            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;

            font-size: 13px;
            font-weight: 700;

            transition: .2s ease;
        }

        .hero-btn-primary {
            background: var(--yellow);
            color: var(--navy);
            border: 1px solid var(--yellow);
        }

        .hero-btn-primary:hover {
            background: var(--orange);
            border-color: var(--orange);
            color: var(--white);
            transform: translateY(-2px);
        }

        .hero-btn-secondary {
            background: transparent;
            color: var(--orange);
            border: 1px solid var(--orange);
        }

        .hero-btn-secondary:hover {
            background: var(--orange);
            color: var(--white);
            transform: translateY(-2px);
        }

        .hero-visual {
            position: absolute;
            right: -30px;
            top: 0;

            width: 55%;
            height: 100%;

            overflow: hidden;
        }

        .visual-background {
            position: absolute;
            inset: 0;

            background:
                    linear-gradient(
                            135deg,
                            rgba(252,191,73,.16),
                            rgba(247,127,0,.18)
                    );
        }


        .ship-scene {
            position: absolute;
            right: 0;
            bottom: 0;

            width: 100%;
            height: 90%;
        }

        .sun {
            position: absolute;
            right: 21%;
            top: 10%;

            width: 130px;
            height: 130px;

            border-radius: 50%;
            background: rgba(252,191,73,.45);
        }

        .water {
            position: absolute;
            bottom: 0;
            left: 0;

            width: 100%;
            height: 34%;

            background:
                    repeating-linear-gradient(
                            0deg,
                            rgba(0,48,73,.07) 0px,
                            rgba(0,48,73,.07) 2px,
                            transparent 2px,
                            transparent 13px
                    );
        }


        .ship {
            position: absolute;

            width: 410px;
            height: 125px;

            right: 23%;
            bottom: 20%;

            background: var(--navy);

            clip-path: polygon(
                    0 18%,
                    85% 18%,
                    100% 72%,
                    82% 100%,
                    15% 100%,
                    0 75%
            );

            box-shadow: 0 15px 25px rgba(0,48,73,.2);
        }

        .ship-top {
            position: absolute;
            left: 60px;
            top: -32px;

            width: 270px;
            height: 45px;

            background: var(--red);

            display: flex;
            align-items: center;
            gap: 5px;
            padding: 5px;
        }

        .container-box {
            width: 39px;
            height: 34px;
            background: var(--yellow);
        }

        .container-box:nth-child(2) {
            background: var(--orange);
        }

        .container-box:nth-child(3) {
            background: var(--red);
        }

        .container-box:nth-child(4) {
            background: var(--yellow);
        }

        .container-box:nth-child(5) {
            background: var(--orange);
        }

        .ship-window {
            position: absolute;
            right: 55px;
            top: 28px;

            width: 75px;
            height: 42px;

            background: var(--white);
            border-radius: 4px;
        }


        .crane {
            position: absolute;
            right: 7%;
            bottom: 24%;

            width: 150px;
            height: 190px;
        }

        .crane-pole {
            position: absolute;
            bottom: 0;
            right: 55px;

            width: 8px;
            height: 170px;

            background: var(--orange);
        }

        .crane-arm {
            position: absolute;
            top: 20px;
            right: 0;

            width: 150px;
            height: 7px;

            background: var(--orange);
            transform: rotate(-7deg);
            transform-origin: right;
        }


        .truck {
            position: absolute;
            right: 2%;
            bottom: 12%;

            width: 175px;
            height: 70px;
        }

        .truck-body {
            position: absolute;
            left: 0;
            bottom: 12px;

            width: 125px;
            height: 45px;

            background: var(--white);
            border: 4px solid var(--navy);
            border-radius: 4px;
        }

        .truck-cabin {
            position: absolute;
            right: 0;
            bottom: 12px;

            width: 55px;
            height: 43px;

            background: var(--orange);
            border-radius: 3px;
        }

        .truck-window {
            position: absolute;
            right: 7px;
            top: 7px;

            width: 35px;
            height: 19px;

            background: var(--light-yellow);
        }

        .wheel {
            position: absolute;
            bottom: 0;

            width: 22px;
            height: 22px;

            border-radius: 50%;
            background: var(--navy);

            border: 4px solid var(--white);
        }

        .wheel-one {
            left: 25px;
        }

        .wheel-two {
            right: 28px;
        }

        .features-section {
            padding: 42px 4.5% 35px;
            background: var(--white);
        }

        .section-container {
            max-width: var(--container);
            margin: auto;
        }

        .section-heading {
            text-align: center;
            margin-bottom: 28px;
        }

        .section-label {
            color: var(--orange);
            text-transform: uppercase;

            font-size: 12px;
            font-weight: 800;
            letter-spacing: 1px;
        }

        .section-heading h2 {
            color: var(--navy);
            font-size: 28px;
            margin-top: 5px;
        }

        .section-heading-line {
            width: 45px;
            height: 3px;
            background: var(--yellow);
            margin: 10px auto 0;
        }


        .feature-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 13px;
        }

        .feature-card {
            border: 1px solid var(--border);
            border-radius: 10px;

            background: var(--lighter-yellow);

            padding: 18px 16px;

            min-height: 150px;

            transition: .25s ease;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            border-color: var(--yellow);

            box-shadow:
                    0 10px 25px rgba(252,191,73,.14);
        }

        .feature-icon {
            width: 38px;
            height: 38px;

            border-radius: 8px;

            display: flex;
            align-items: center;
            justify-content: center;

            background: var(--yellow);
            color: var(--navy);

            font-size: 15px;
            margin-bottom: 12px;
        }

        .feature-card:nth-child(2) .feature-icon {
            background: var(--orange);
            color: var(--white);
        }

        .feature-card:nth-child(3) .feature-icon {
            background: var(--red);
            color: var(--white);
        }

        .feature-card:nth-child(4) .feature-icon {
            background: var(--navy);
            color: var(--yellow);
        }

        .feature-card:nth-child(5) .feature-icon {
            background: var(--orange);
            color: var(--white);
        }

        .feature-card:nth-child(6) .feature-icon {
            background: var(--yellow);
            color: var(--navy);
        }

        .feature-card h3 {
            font-size: 12px;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .feature-card p {
            font-size: 10px;
            line-height: 1.55;
            color: var(--muted);
        }

        .stats {
            margin-top: 14px;

            border: 1px solid var(--border);
            border-radius: 10px;

            background: var(--light-yellow);

            min-height: 92px;

            display: grid;
            grid-template-columns: repeat(5, 1fr);
            align-items: center;
        }

        .stat {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;

            border-right: 1px solid var(--border);
        }

        .stat:last-child {
            border-right: 0;
        }

        .stat-icon {
            font-size: 23px;
            color: var(--orange);
        }

        .stat-number {
            display: block;
            color: var(--navy);
            font-size: 22px;
            font-weight: 800;
            line-height: 1;
        }

        .stat-label {
            display: block;
            color: var(--muted);
            font-size: 10px;
            margin-top: 4px;
        }

        .cta-section {
            padding: 14px 4.5% 35px;
            background: var(--white);
        }

        .cta {
            max-width: var(--container);
            margin: auto;

            min-height: 87px;

            padding: 16px 40px;

            background: var(--navy);

            border-radius: 10px;

            display: flex;
            align-items: center;
        }

        .cta-logo {
            width: 43px;
            height: 43px;

            border-radius: 8px;

            background: var(--yellow);
            color: var(--navy);

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 18px;

            margin-right: 15px;
        }

        .cta-text {
            flex: 1;
        }

        .cta-text h2 {
            color: var(--white);
            font-size: 20px;
            line-height: 1.2;
        }

        .cta-text p {
            color: rgba(255,255,255,.7);
            font-size: 11px;
            margin-top: 3px;
        }

        .cta-buttons {
            display: flex;
            gap: 12px;
        }

        .cta-signin {
            height: 40px;
            padding: 0 20px;

            background: var(--yellow);
            border: 1px solid var(--yellow);

            border-radius: 5px;

            color: var(--navy);

            display: flex;
            align-items: center;
            gap: 8px;

            font-size: 12px;
            font-weight: 700;

            transition: .2s;
        }

        .cta-signin:hover {
            background: var(--orange);
            border-color: var(--orange);
            color: var(--white);
        }

        .cta-signup {
            height: 40px;
            padding: 0 20px;

            background: transparent;
            border: 1px solid rgba(255,255,255,.8);

            border-radius: 5px;

            color: var(--white);

            display: flex;
            align-items: center;
            gap: 8px;

            font-size: 12px;
            font-weight: 700;

            transition: .2s;
        }

        .cta-signup:hover {
            background: var(--white);
            color: var(--navy);
        }

        footer {
            background: var(--navy);
            color: var(--white);

            padding: 20px 4.5% 15px;
        }

        .footer-container {
            max-width: var(--container);
            margin: auto;

            display: flex;
            align-items: center;
        }

        .footer-logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .footer-logo-icon {
            width: 38px;
            height: 38px;

            border-radius: 8px;

            background: var(--yellow);
            color: var(--navy);

            display: flex;
            align-items: center;
            justify-content: center;
        }

        .footer-logo strong {
            display: block;
            font-size: 17px;
        }

        .footer-logo span {
            display: block;
            font-size: 9px;
            color: rgba(255,255,255,.65);
        }

        .footer-links {
            margin-left: auto;

            display: flex;
            gap: 30px;
        }

        .footer-links a {
            color: rgba(255,255,255,.75);
            font-size: 10px;
            transition: .2s;
        }

        .footer-links a:hover {
            color: var(--yellow);
        }

        .social-links {
            display: flex;
            gap: 15px;
            margin-left: 35px;
        }

        .social-links a {
            width: 28px;
            height: 28px;

            border: 1px solid rgba(255,255,255,.4);
            border-radius: 50%;

            display: flex;
            align-items: center;
            justify-content: center;

            color: var(--white);

            font-size: 11px;

            transition: .2s;
        }

        .social-links a:hover {
            background: var(--yellow);
            color: var(--navy);
            border-color: var(--yellow);
        }

        .copyright {
            max-width: var(--container);
            margin: 13px auto 0;

            padding-top: 10px;

            border-top: 1px solid rgba(255,255,255,.12);

            text-align: center;

            color: rgba(255,255,255,.5);
            font-size: 9px;
        }

        @media (max-width: 1200px) {

            .hero-container {
                padding-left: 5%;
                padding-right: 5%;
            }

            .feature-grid {
                grid-template-columns: repeat(3, 1fr);
            }

            .hero-title {
                font-size: 45px;
            }

        }


        @media (max-width: 950px) {

            .nav-links {
                display: none;
            }

            .hero {
                min-height: 650px;
            }

            .hero-container {
                min-height: 650px;
                align-items: flex-start;
                padding-top: 65px;
            }

            .hero-content {
                width: 100%;
            }

            .hero-visual {
                width: 100%;
                height: 330px;
                top: auto;
                bottom: 0;
                opacity: .75;
            }

            .stats {
                grid-template-columns: repeat(3, 1fr);
                padding: 15px;
                gap: 15px;
            }

            .stat:nth-child(3) {
                border-right: 0;
            }

            .stat:nth-child(4),
            .stat:nth-child(5) {
                border-top: 1px solid var(--border);
                padding-top: 15px;
            }

            .stat:nth-child(4) {
                border-right: 1px solid var(--border);
            }

            .cta {
                padding: 20px;
            }

        }


        @media (max-width: 650px) {

            .navbar {
                padding: 0 18px;
            }

            .logo-title {
                font-size: 17px;
            }

            .logo-subtitle {
                font-size: 9px;
            }

            .nav-signin {
                display: none;
            }

            .nav-signup {
                padding: 0 13px;
            }

            .hero-container {
                padding: 45px 20px 0;
            }

            .hero-title {
                font-size: 38px;
            }

            .hero-description {
                font-size: 13px;
            }

            .hero-buttons {
                flex-direction: column;
                width: 190px;
            }

            .feature-grid {
                grid-template-columns: 1fr;
            }

            .features-section {
                padding-left: 20px;
                padding-right: 20px;
            }

            .stats {
                grid-template-columns: 1fr 1fr;
            }

            .stat {
                border-right: 0;
            }

            .stat:nth-child(3),
            .stat:nth-child(4),
            .stat:nth-child(5) {
                border-top: 1px solid var(--border);
                padding-top: 12px;
            }

            .cta-section {
                padding-left: 20px;
                padding-right: 20px;
            }

            .cta {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }

            .cta-logo {
                margin-right: 0;
            }

            .cta-buttons {
                flex-direction: column;
                width: 100%;
            }

            .cta-signin,
            .cta-signup {
                justify-content: center;
            }

            .footer-container {
                flex-direction: column;
                gap: 20px;
            }

            .footer-links {
                margin-left: 0;
                flex-wrap: wrap;
                justify-content: center;
                gap: 15px;
            }

            .social-links {
                margin-left: 0;
            }

        }

    </style>

</head>


<body>

<header class="navbar">

    <div class="navbar-container">

        <a href="${pageContext.request.contextPath}/"
           class="logo">

            <div class="logo-icon">
                <i class="fa-solid fa-globe"></i>
            </div>

            <div class="logo-text">

                <div class="logo-title">
                    GlobalTrade
                </div>

                <div class="logo-subtitle">
                    Logistics System
                </div>

            </div>

        </a>

        <nav class="nav-links">

            <a href="${pageContext.request.contextPath}/"
               class="active">
                Home
            </a>

            <a href="#features">
                Features
            </a>

            <a href="#services">
                Services
            </a>

            <a href="#about">
                About Us
            </a>

            <a href="#contact">
                Contact
            </a>

        </nav>

        <div class="nav-actions">

            <a href="${pageContext.request.contextPath}/signin"
               class="nav-signin">

                <i class="fa-regular fa-user"></i>

                Sign In

            </a>

            <a href="${pageContext.request.contextPath}/signup"
               class="nav-signup">

                <i class="fa-solid fa-user-plus"></i>

                Create Account

            </a>

        </div>

    </div>

</header>

<section class="hero">

    <div class="hero-container">

        <div class="hero-map"></div>


        <div class="hero-content">

            <div class="hero-small-title">
                Welcome to GlobalTrade
            </div>

            <h1 class="hero-title">
                Smart Logistics,
                <br>
                Stronger Connections
            </h1>

            <div class="hero-line"></div>

            <p class="hero-description">

                GlobalTrade Logistics System helps businesses
                manage shipments, track deliveries, handle
                inventory, and streamline the entire supply
                chain in one powerful platform.

            </p>


            <div class="hero-buttons">


                <a href="${pageContext.request.contextPath}/signin"
                   class="hero-btn hero-btn-primary">

                    <i class="fa-regular fa-user"></i>

                    Sign In

                    <i class="fa-solid fa-arrow-right"></i>

                </a>


                <a href="${pageContext.request.contextPath}/signup"
                   class="hero-btn hero-btn-secondary">

                    <i class="fa-solid fa-user-plus"></i>

                    Create Account

                    <i class="fa-solid fa-arrow-right"></i>

                </a>

            </div>

        </div>

        <div class="hero-visual">

            <div class="visual-background"></div>

            <div class="ship-scene">

                <div class="sun"></div>

                <div class="water"></div>

                <div class="ship">

                    <div class="ship-window"></div>

                    <div class="ship-top">

                        <div class="container-box"></div>
                        <div class="container-box"></div>
                        <div class="container-box"></div>
                        <div class="container-box"></div>
                        <div class="container-box"></div>

                    </div>

                </div>

                <div class="crane">

                    <div class="crane-pole"></div>

                    <div class="crane-arm"></div>

                </div>

                <div class="truck">

                    <div class="truck-body"></div>

                    <div class="truck-cabin">

                        <div class="truck-window"></div>

                    </div>

                    <div class="wheel wheel-one"></div>

                    <div class="wheel wheel-two"></div>

                </div>

            </div>

        </div>

    </div>

</section>

<section class="features-section"
         id="features">

    <div class="section-container">

        <div class="section-heading">

            <div class="section-label">
                Our Features
            </div>

            <h2>
                Everything You Need for Smarter Logistics
            </h2>

            <div class="section-heading-line"></div>

        </div>



        <div class="feature-grid">

            <div class="feature-card">

                <div class="feature-icon">
                    <i class="fa-solid fa-box"></i>
                </div>

                <h3>
                    Shipment Tracking
                </h3>

                <p>
                    Real-time tracking of your shipments
                    from origin to destination.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">
                    <i class="fa-solid fa-truck"></i>
                </div>

                <h3>
                    Inventory Management
                </h3>

                <p>
                    Monitor stock levels and manage
                    inventory across multiple locations.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">
                    <i class="fa-solid fa-file-lines"></i>
                </div>

                <h3>
                    Customs Documents
                </h3>

                <p>
                    Manage and store customs and
                    shipping documents securely.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">
                    <i class="fa-solid fa-route"></i>
                </div>

                <h3>
                    Route Optimization
                </h3>

                <p>
                    Find efficient and cost-effective
                    routes for your shipments.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">
                    <i class="fa-solid fa-bell"></i>
                </div>

                <h3>
                    Alerts & Notifications
                </h3>

                <p>
                    Get instant alerts on delays,
                    updates, and important activities.
                </p>

            </div>

            <div class="feature-card">

                <div class="feature-icon">
                    <i class="fa-solid fa-chart-column"></i>
                </div>

                <h3>
                    Reports & Analytics
                </h3>

                <p>
                    Powerful analytics and reports
                    to make better business decisions.
                </p>

            </div>

        </div>

        <div class="stats">

            <div class="stat">

                <i class="fa-solid fa-users stat-icon"></i>

                <div>
                    <span class="stat-number">10K+</span>
                    <span class="stat-label">
                        Happy Customers
                    </span>
                </div>

            </div>


            <div class="stat">

                <i class="fa-solid fa-truck-fast stat-icon"></i>

                <div>
                    <span class="stat-number">50K+</span>
                    <span class="stat-label">
                        Shipments Delivered
                    </span>
                </div>

            </div>


            <div class="stat">

                <i class="fa-solid fa-globe stat-icon"></i>

                <div>
                    <span class="stat-number">50+</span>
                    <span class="stat-label">
                        Countries Covered
                    </span>
                </div>

            </div>


            <div class="stat">

                <i class="fa-solid fa-ship stat-icon"></i>

                <div>
                    <span class="stat-number">99.9%</span>
                    <span class="stat-label">
                        On-time Delivery
                    </span>
                </div>

            </div>


            <div class="stat">

                <i class="fa-solid fa-shield-halved stat-icon"></i>

                <div>
                    <span class="stat-number">24/7</span>
                    <span class="stat-label">
                        Customer Support
                    </span>
                </div>

            </div>

        </div>

    </div>

</section>

<section class="cta-section"
         id="services">

    <div class="cta">

        <div class="cta-logo">
            <i class="fa-solid fa-globe"></i>
        </div>


        <div class="cta-text">

            <h2>
                Ready to Simplify Your Logistics?
            </h2>

            <p>
                Join businesses that trust GlobalTrade
                for their logistics needs.
            </p>

        </div>


        <div class="cta-buttons">

            <a href="${pageContext.request.contextPath}/signin"
               class="cta-signin">

                <i class="fa-regular fa-user"></i>

                Sign In

                <i class="fa-solid fa-arrow-right"></i>

            </a>

            <a href="${pageContext.request.contextPath}/signup"
               class="cta-signup">

                <i class="fa-solid fa-user-plus"></i>

                Create Account

            </a>

        </div>

    </div>

</section>

<footer id="contact">

    <div class="footer-container">

        <div class="footer-logo">

            <div class="footer-logo-icon">
                <i class="fa-solid fa-globe"></i>
            </div>

            <div>

                <strong>
                    GlobalTrade
                </strong>

                <span>
                    Logistics System
                </span>

            </div>

        </div>

        <div class="footer-links">

            <a href="#about">
                About Us
            </a>

            <a href="#services">
                Services
            </a>

            <a href="#">
                Privacy Policy
            </a>

            <a href="#">
                Terms of Service
            </a>

            <a href="#contact">
                Contact Us
            </a>

        </div>

        <div class="social-links">

            <a href="#" title="Facebook">
                <i class="fa-brands fa-facebook-f"></i>
            </a>

            <a href="#" title="Twitter">
                <i class="fa-brands fa-twitter"></i>
            </a>

            <a href="#" title="LinkedIn">
                <i class="fa-brands fa-linkedin-in"></i>
            </a>

            <a href="#" title="Instagram">
                <i class="fa-brands fa-instagram"></i>
            </a>

        </div>

    </div>


    <div class="copyright">

        © 2026 GlobalTrade Logistics System.
        All rights reserved.

    </div>

</footer>


</body>
</html>