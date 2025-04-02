<%@ Page Title="דף הבית" Language="C#" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .welcome-section {
            text-align: center;
            padding: 40px 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin: 20px 0;
        }
        .school-logo {
            max-width: 200px;
            height: auto;
            margin-bottom: 20px;
        }
        .welcome-title {
            color: #2c3e50;
            font-size: 2.5em;
            margin-bottom: 20px;
        }
        .welcome-text {
            color: #34495e;
            font-size: 1.2em;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }
        .btn-primary {
            background-color: #27ae60;
            border: none;
            padding: 12px 30px;
            font-size: 1.1em;
            border-radius: 5px;
            color: white;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        .btn-primary:hover {
            background-color: #219a52;
        }
        /* used a tool to create a cool logo */
        .school-logo-svg {
            width: 250px;
            height: 200px;
            margin: 0 auto 20px;
            display: block;
        }
        .logo-primary {
            fill: #34468B; /* Dark blue */
        }
        .logo-secondary {
            fill: #5A8AC6; /* Light blue */
        }
        .logo-accent {
            fill: #8CB24A; /* Green */
        }
        .logo-white {
            fill: #FFFFFF; /* White */
        }
        .logo-text {
            fill: #34468B; /* Dark blue text */
            font-family: 'Arial Hebrew', Arial, sans-serif;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="welcome-section">
        <div id="banner-container">
            <svg class="school-logo-svg" viewBox="0 0 300 240">
                <!-- Center flower/lotus symbol -->
                <path class="logo-primary" d="M150,40 C160,10 180,20 150,60 C120,20 140,10 150,40 Z" />  <!-- Top petal -->
                <path class="logo-secondary" d="M120,50 C90,30 90,60 130,70 C110,40 110,30 120,50 Z" />  <!-- Left petal -->
                <path class="logo-secondary" d="M180,50 C210,30 210,60 170,70 C190,40 190,30 180,50 Z" />  <!-- Right petal -->
                <path class="logo-accent" d="M90,60 C70,50 80,80 110,70 C90,50 80,50 90,60 Z" />  <!-- Far left leaf -->
                <path class="logo-accent" d="M210,60 C230,50 220,80 190,70 C210,50 220,50 210,60 Z" />  <!-- Far right leaf -->
                
                <!-- Center dot -->
                <circle class="logo-white" cx="150" cy="80" r="8" />
                <circle class="logo-primary" cx="150" cy="80" r="4" />
                
                <!-- Open book -->
                <path class="logo-primary" d="M80,100 L220,100 L220,110 L80,110 Z" />  <!-- Top line -->
                <path class="logo-primary" d="M90,110 C120,100 150,110 150,110 C150,110 180,100 210,110 L210,130 C180,120 150,130 150,130 C150,130 120,120 90,130 Z" />  <!-- Open book -->
                
                <!-- Text in Hebrew -->
                <text class="logo-primary" x="150" y="170" text-anchor="middle" font-size="28" font-weight="bold">תיכון חדש</text>
                <text class="logo-primary" x="150" y="190" text-anchor="middle" font-size="12">ע"ש יצחק רבין תל אביב</text>
                <text class="logo-accent" x="150" y="210" text-anchor="middle" font-size="10">מסעות של ידע, רוח ואדם בזמן</text>
            </svg>
        </div>
        <h1 class="welcome-title">ברוכים הבאים לאתר ליגת הכדורגל</h1>
        <p class="welcome-text">
            כאן תוכלו למצוא מידע על הקבוצות השונות, טבלת ליגה מעודכנת, ומידע על השחקנים.
            בחרו באחת מהאפשרויות הבאות כדי להתחיל:
        </p>
        <div class="action-buttons">
            <a href="TeamsTable.aspx" class="btn-primary">טבלת ליגה</a>
            <a href="WhyThisSubject.aspx" class="btn-primary">למה בחרתי בנושא זה</a>
            <a href="SiteMap.aspx" class="btn-primary">מפת האתר</a>
        </div>
    </div>
</asp:Content>