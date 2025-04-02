<%@ Page Title="בית''ר ירושלים" Language="C#" MasterPageFile="~/MasterPage.master" %>

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
            <img src="Images/beitarrjerusalem.png" class="team-logo" alt="לוגו בית''ר ירושלים" />
        </div>
        <h1 class="team-title">בית''ר ירושלים</h1>
    </div>

    <div class="team-info">
        <div class="info-section">
            <h3>היסטוריה</h3>
            <p>בית''ר ירושלים נוסדה בשנת 1936 והיא אחת הקבוצות הוותיקות והמובילות בכדורגל הישראלי. הקבוצה מזוהה עם העיר ירושלים ומשחקת באצטדיון טדי.</p>
        </div>

        <div class="info-section">
            <h3>הישגים</h3>
            <ul>
                <li>אליפויות: 6</li>
                <li>גביעי מדינה: 8</li>
                <li>גביעי טוטו: 3</li>
                <li>השתתפות בליגת האלופות</li>
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