<%@ Page Title="מכבי חיפה" Language="C#" MasterPageFile="~/MasterPage.master" %>

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
            <img src="Images/macabiHJaifa.jpeg" class="team-logo" alt="לוגו מכבי חיפה" />
        </div>
        <h1 class="team-title">מכבי חיפה</h1>
    </div>

    <div class="team-info">
        <div class="info-section">
            <h3>היסטוריה</h3>
            <p>מכבי חיפה נוסדה בשנת 1913 והיא אחת הקבוצות הוותיקות והמובילות בכדורגל הישראלי. הקבוצה זכתה באליפות המדינה מספר פעמים והיא אחת הקבוצות המובילות בישראל.</p>
        </div>

        <div class="info-section">
            <h3>הישגים</h3>
            <ul>
                <li>אליפויות: 15</li>
                <li>גביעי מדינה: 6</li>
                <li>גביעי טוטו: 4</li>
                <li>השתתפות בליגת האלופות</li>
            </ul>
        </div>

        <div class="info-section">
            <h3>שחקנים מפורסמים</h3>
            <ul>
                <li>יוסי בניון</li>
                <li>אלון מזרחי</li>
                <li>ניסים אבוקסיס</li>
                <li>רן בן שמעון</li>
            </ul>
        </div>
    </div>
</asp:Content>