<%@ Page Title="הפועל פתח תקווה" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="HapoelPetahTikva.aspx.cs" Inherits="HapoelPetahTikva" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .team-info {
            margin: 20px;
            padding: 15px;
        }
        h2 {
            color: #0000CD;   
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
        <h2>הפועל פתח תקווה</h2>
        
        <div class="section">
            <h3>היסטוריה</h3>
            <p>הפועל פתח תקווה נוסדה בשנת 1934 ומייצגת את העיר פתח תקווה.</p>
            <p>הקבוצה ידועה בכינוי "המייסדים" היות והייתה מהקבוצות הראשונות בכדורגל הישראלי.</p>
        </div>

        <div class="section">
            <h3>הישגים</h3>
            <p>• מספר אליפויות: 6</p>
            <p>• דירוג נוכחי בליגה: 3</p>
            <p>• זכייה בגביע המדינה: 2 פעמים</p>
        </div>

        <div class="section">
            <h3>שחקני עבר מפורסמים</h3>
            <p>• נחום סטלמך - מגדולי השחקנים בתולדות הכדורגל הישראלי</p>
            <p>• שלום תקווה - כוכב הקבוצה בשנות ה-80</p>
        </div>
        
        <div class="section">
            <h3>אצטדיון</h3>
            <p>הקבוצה משחקת את משחקי הבית שלה באצטדיון האצטדיון העירוני בפתח תקווה.</p>
        </div>
    </div>
</asp:Content>