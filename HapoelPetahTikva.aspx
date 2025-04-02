<%@ Page Title="הפועל פתח תקווה" Language="C#" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .team-header {
            text-align: center;
            padding: 20px;
            background-color: #f8f9fa;
            margin-bottom: 20px;
        }
        .team-logo {
            max-width: 150px;
            height: auto;
            margin-bottom: 15px;
        }
        .team-title {
            color: #333;
            font-size: 24px;
            margin-bottom: 15px;
        }
        .team-info {
            max-width: 800px;
            margin: 0 auto;
            padding: 15px;
        }
        .info-section {
            background-color: white;
            padding: 15px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
        }
        .info-section h3 {
            color: #333;
            margin-bottom: 10px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 5px;
        }
        .info-section p {
            line-height: 1.5;
        }
        .info-section ul {
            padding-right: 20px;
        }
        .info-section li {
            margin-bottom: 5px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="team-header">
        <div class="logo-container">
            <img src="Images/hapoelpetahtikva.jpeg" class="team-logo" alt="לוגו הפועל פתח תקווה" />
        </div>
        <h1 class="team-title">הפועל פתח תקווה</h1>
    </div>

    <div class="team-info">
        <div class="info-section">
            <h3>היסטוריה</h3>
            <p>הפועל פתח תקווה נוסדה בשנת 1934 והיא אחת הקבוצות הוותיקות בכדורגל הישראלי. הקבוצה מזוהה עם העיר פתח תקווה ומשחקת באצטדיון המושבה.</p>
        </div>

        <div class="info-section">
            <h3>הישגים</h3>
            <ul>
                <li>אליפויות: 2</li>
                <li>גביעי מדינה: 2</li>
                <li>גביעי טוטו: 1</li>
            </ul>
        </div>

        <div class="info-section">
            <h3>שחקנים מפורסמים</h3>
            <ul>
                <li>אלי אוחנה</li>
                <li>אורי מלמיליאן</li>
                <li>איציק זוהר</li>
                <li>אריק בנדו</li>
            </ul>
        </div>
    </div>
</asp:Content>