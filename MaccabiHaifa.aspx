<%@ Page Title="מכבי חיפה" Language="C#" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .team-header {
            text-align: center;
            padding: 30px 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .team-logo {
            max-width: 150px;
            height: auto;
            margin-bottom: 20px;
        }
        .team-title {
            color: #2c3e50;
            font-size: 2.5em;
            margin-bottom: 20px;
        }
        .team-info {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .info-section {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .info-section h3 {
            color: #27ae60;
            margin-bottom: 15px;
            border-bottom: 2px solid #27ae60;
            padding-bottom: 5px;
        }
        .info-section p {
            line-height: 1.6;
            color: #34495e;
        }
        .info-section ul {
            list-style-type: none;
            padding-right: 20px;
        }
        .info-section li {
            margin-bottom: 10px;
            position: relative;
        }
        .info-section li:before {
            content: "•";
            color: #27ae60;
            font-weight: bold;
            position: absolute;
            right: -15px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="team-header">
        <div class="logo-container">
            <asp:Image ID="teamLogo" runat="server" CssClass="team-logo" AlternateText="לוגו מכבי חיפה" />
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