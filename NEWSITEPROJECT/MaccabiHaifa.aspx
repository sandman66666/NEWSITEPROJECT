<%@ Page Title="מכבי חיפה" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="MaccabiHaifa.aspx.cs" Inherits="MaccabiHaifa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .team-info {
            margin: 20px;
            padding: 15px;
        }
        h2 {
            color: #006400;
            margin-bottom: 15px;
        }
        .section {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f5f5f5;
            border-radius: 5px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="team-info">
        <h2>מכבי חיפה</h2>
        
        <div class="section">
            <h3>היסטוריה</h3>
            <p>מכבי חיפה נוסדה בשנת 1913 והיא אחת הקבוצות הוותיקות בישראל.</p>
            <p>הקבוצה מייצגת את העיר חיפה ומשחקת באצטדיון סמי עופר.</p>
        </div>

        <div class="section">
            <h3>הישגים</h3>
            <p>• מספר אליפויות: 14</p>
            <p>• דירוג נוכחי בליגה: 1</p>
        </div>

        <div class="section">
            <h3>שחקני עבר מפורסמים</h3>
            <p>• יעקב חודורוב - שוער אגדי של הקבוצה</p>
            <p>• רוני רוזנטל - חלוץ מצטיין</p>
        </div>
    </div>
</asp:Content>