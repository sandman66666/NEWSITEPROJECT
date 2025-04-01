<%@ Page Title="מבנה האתר" Language="C#" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .sitemap-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
            font-family: Arial, sans-serif;
        }
        
        h1, h2, h3 {
            color: #2c3e50;
            text-align: center;
        }
        
        h1 {
            font-size: 32px;
            margin-bottom: 30px;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        
        .section {
            background-color: white;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 15px;
        }
        
        .card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .card h3 {
            color: #3498db;
            margin-bottom: 10px;
            text-align: center;
        }
        
        .card p {
            color: #666;
            margin-bottom: 10px;
        }
        
        .card-link {
            display: block;
            background-color: #27ae60;
            color: white;
            text-align: center;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            margin-top: 10px;
            transition: background-color 0.3s;
        }
        
        .card-link:hover {
            background-color: #219a52;
        }
        
        .team-cards {
            margin-top: 15px;
        }
        
        .hierarchy-line {
            width: 100%;
            height: 2px;
            background-color: #ddd;
            margin: 15px 0;
        }
        
        .main-section {
            background-color: #e8f4f8;
            border-left: 4px solid #3498db;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="sitemap-container">
        <h1>מפת האתר - מבנה האתר</h1>
        
        <div class="section main-section">
            <h2>דף הבית</h2>
            <p>העמוד הראשי של האתר עם מידע כללי על האתר ולוגו בית הספר</p>
            <a href="Default.aspx" class="card-link">לדף הבית</a>
        </div>

        <div class="section">
            <h2>עמודים ראשיים</h2>
            <div class="grid-container">
                <div class="card">
                    <h3>למה בחרתי בנושא</h3>
                    <p>הסבר על בחירת נושא כדורגל והסיבות מאחורי הפרויקט</p>
                    <a href="WhyThisSubject.aspx" class="card-link">פרטים נוספים</a>
                </div>

                <div class="card">
                    <h3>טבלת קבוצות</h3>
                    <p>צפייה, הוספה, עריכה ומחיקה של קבוצות כדורגל</p>
                    <a href="TeamsTable.aspx" class="card-link">לטבלת הקבוצות</a>
                </div>

                <div class="card">
                    <h3>מפת האתר</h3>
                    <p>העמוד הנוכחי - מציג את מבנה האתר והקישורים השונים</p>
                    <a href="SiteMap.aspx" class="card-link">לעמוד הנוכחי</a>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>עמודי קבוצות</h2>
            <p>מידע מפורט על הקבוצות המובילות בליגה</p>
            
            <div class="grid-container team-cards">
                <div class="card">
                    <h3>מכבי חיפה</h3>
                    <p>מידע מפורט על קבוצת מכבי חיפה, היסטוריה, הישגים ושחקנים מובילים</p>
                    <a href="MaccabiHaifa.aspx" class="card-link">לעמוד הקבוצה</a>
                </div>
                
                <div class="card">
                    <h3>הפועל תל אביב</h3>
                    <p>מידע מפורט על קבוצת הפועל תל אביב, היסטוריה, הישגים ושחקנים מובילים</p>
                    <a href="HapoelTelAviv.aspx" class="card-link">לעמוד הקבוצה</a>
                </div>
                
                <div class="card">
                    <h3>בית"ר ירושלים</h3>
                    <p>מידע מפורט על קבוצת בית"ר ירושלים, היסטוריה, הישגים ושחקנים מובילים</p>
                    <a href="BeitarJerusalem.aspx" class="card-link">לעמוד הקבוצה</a>
                </div>
                
                <div class="card">
                    <h3>הפועל פתח תקווה</h3>
                    <p>מידע מפורט על קבוצת הפועל פתח תקווה, היסטוריה, הישגים ושחקנים מובילים</p>
                    <a href="HapoelPetahTikva.aspx" class="card-link">לעמוד הקבוצה</a>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>ניהול משתמשים</h2>
            <div class="grid-container">
                <div class="card">
                    <h3>הרשמה</h3>
                    <p>טופס הרשמה למשתמשים חדשים המאפשר יצירת חשבון באתר</p>
                    <a href="SignUp.aspx" class="card-link">להרשמה</a>
                </div>

                <div class="card">
                    <h3>התחברות</h3>
                    <p>טופס התחברות למשתמשים רשומים באתר</p>
                    <a href="Signin.aspx" class="card-link">להתחברות</a>
                </div>
            </div>
        </div>
        
        <div class="section">
            <h2>מבנה היררכי של האתר</h2>
            <div style="direction: ltr; text-align: center; margin-top: 20px; font-family: monospace; font-size: 14px;">
                <pre style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; display: inline-block; text-align: left;">
דף הבית (Default.aspx)
│
├── למה בחרתי בנושא (WhyThisSubject.aspx)
│
├── טבלת קבוצות (TeamsTable.aspx)
│   │
│   ├── מכבי חיפה (MaccabiHaifa.aspx)
│   │
│   ├── הפועל תל אביב (HapoelTelAviv.aspx)
│   │
│   ├── בית"ר ירושלים (BeitarJerusalem.aspx)
│   │
│   └── הפועל פתח תקווה (HapoelPetahTikva.aspx)
│
├── מפת האתר (SiteMap.aspx)
│
└── ניהול משתמשים
    │
    ├── הרשמה (SignUp.aspx)
    │
    └── התחברות (Signin.aspx)
                </pre>
            </div>
        </div>
    </div>
</asp:Content>