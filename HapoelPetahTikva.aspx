<%@ Page Title="הפועל פתח תקווה" Language="C#" MasterPageFile="~/MasterPage.master" %>

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
            <img src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/4QC6RXhpZgAATU0AKgAAAAgAAgESAAMAAAABAAEAAIdpAAQAAAABAAAAJgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAuKADAAQAAAABAAAA9AAAAADr1iNJAAAACXBIWXMAAAsTAAALEwEAmpwYAAAJCklEQVR4Ae2da2/cVh3Fz3g8M7Zn7MBi0gYwpPR9QlDK0jZpG7V9UVRCPFGR4g0fiJT0FRIfgiI+AAKJFyBRHpCQeIKqW9E0pOkTaZY2dZytHcexvc94PL7n3l3n2o7tcXYnTrZ/R9qxPZ7Le4/POffO5ZoRTI7JyHnr47Hl9PH0PcPzhfnrVw9YjrfK0mRpUuGkMlGzMpQYlHSpxD2p75eQl3rRKyvbltgDkFDKdkDjhYCl1FJKP9tBJedZOWgrR3Ye165d3f7V5u7Pef0vz/GlKYGFGQDQCcBXMxnAoP4HM4BpDNCawUP48Rno9QVUy6BUMaGkYhXt6YvN9jcC+IIA/m5eGa8KMC0a0MAUQ3nkjMbAJJF1Oq8ZoIATNP6E8xykpGu3HVQaCnfO4cHx+UbZflcAX5XJl0/hDnIm3BPA3NEzwIPE6lmq+QCYUkKqZuCGP4hLcI91pUTTCWpVabk8Bxs62CYSvwAW5dC+BXtUF06PAuxnCvIRTGYJU8BKZ+AVHgqTc7BtC+XJDG0Y6IHlPIIwGIE1m8E5nYHJAZo64XLVQGnTQIvCLVFWB1QzqDZQvD+L+t0Z1KUL38qZvbTgyFvk5y9gOe0ZHgETOPKCDFJQgHUBrFQFcMaAKcCGFGNbJ6igqIDuagaVuvRlSTbz8FSGdV9mLHtDc4AEyLjDjEhP4JIEKzlDCrEA+tNi1QTQ08ZswIjpL7LSGUK8DPfgGZrtOuCdgY3C4HGGHXzDZUALMMQQfOgVYF4B+uexbcwQoBDgGeyWjHuSdYQ+c/rCzQaK9Qwal8ew2r3VXWdYnUHmr8r0s5exmPYyHiEiQHkcBwKCg/QByuM44MgjXCpFyzDLQCnIlB5PkhkAB+lzqG1MoH5HRnyjVWkUraZdvp0xL9cda6nm2IeSBaW4AGfD+OG5GHkiSN0Cp7AAK2KYrA0MXW6gMJUjswOkjw5cHsdaZlBN8eDR6RyW700hXc+xtDyKlbRtleKc1Wxns5EJm+DcSBHlXGRYXkbqcXFM4jgQHIS4I9lHgIZ4o1cK0mcVYE4slYORt53NIlEYxBnK1RLK4mJDsdJR5oXZq6jfk9GWrArQbRbNpWLWvJyzLy2krH6rzcqwNipGIkdUHoBTXwFSlYgZclAEKGAqXojrbMpAaE0plkoJqx9eOhHhfjC4pEAZ12k3kM8LSqRyRMmQFbm8VgxgeWMczbkxNGQkvCyDa65aS/XCWhWQlxzrcSFIbQrUZh3GKQWI/e6j1fJgSsQRrLKS0hvlVYN0Bww6RRnIDWKcZNnmRgV31oqodaZlUvfhtJrUr6Ydy0wxJ1JQu8dAUUvnEmQkNksBIuczMYgNVpqTOTlCXNGqZsHwM96aCdJnfM1bMxnYZQ12yChlMcCWhN5Y5CY/UINC1vLWTJRuI23HS" class="team-logo" alt="לוגו הפועל פתח תקווה" />
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