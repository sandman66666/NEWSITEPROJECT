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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="welcome-section">
        <div class="logo-container">
            <!-- Try using a direct HTML img tag with a relative path -->
            <img src="Images1/schoolLogo.png" class="school-logo" alt="לוגו בית הספר" />
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