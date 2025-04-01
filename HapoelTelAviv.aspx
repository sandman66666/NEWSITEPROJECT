<%@ Page Title="הפועל תל אביב" Language="C#" MasterPageFile="~/MasterPage.master" %>

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
            <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAANUAAADtCAMAAAAft8BxAAABIFBMVEX/AQP////+AAD7AAD8/////v/5///4AAD//f/9AQP//P/+//38/v///v38//38/f/9RUb9//r+w8L5//v+1tX9b3D+fX7/3Nr0AAD/0M/2//38//j99PX/6ef++fn+tLL8IyL+hYP89u/+6eP97+z+WFf93+D+Z2L9OjP+qaj+X2D5oZv7nZ79VlD8QkP5nqP5kIz/Nz35FhT9d3T7jY3+sKj86Nz+lZn5zMT/u7n6xMT+2tH5NSv9HyD/2tv+Ki39ra/1vcP6UFX4RVP+tqr8iH33vLT6PEP6ZGn4y8/+nJP94NfzRD76d2vysKrzg4L7cXr4xbf5l4n8WE3goaP7p5r3e276eX770b7/nI37bmD8UVz/+On3JjH9ZVr9hpFAng1I" class="team-logo" alt="לוגו הפועל תל אביב" />
        </div>
        <h1 class="team-title">הפועל תל אביב</h1>
    </div>

    <div class="team-info">
        <div class="info-section">
            <h3>היסטוריה</h3>
            <p>הפועל תל אביב נוסדה בשנת 1923 והיא אחת הקבוצות הוותיקות והמובילות בכדורגל הישראלי. הקבוצה מזוהה עם השכונות והמעמד העובדים בתל אביב.</p>
        </div>

        <div class="info-section">
            <h3>הישגים</h3>
            <ul>
                <li>אליפויות: 13</li>
                <li>גביעי מדינה: 16</li>
                <li>גביעי טוטו: 3</li>
                <li>השתתפות בליגת האלופות</li>
            </ul>
        </div>

        <div class="info-section">
            <h3>שחקנים מפורסמים</h3>
            <ul>
                <li>אלי אוחנה</li>
                <li>ניסים אבוקסיס</li>
                <li>אלון מזרחי</li>
                <li>שלום תקווה</li>
            </ul>
        </div>
    </div>
</asp:Content>