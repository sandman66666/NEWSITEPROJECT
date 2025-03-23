<%@ Page Title="בית''ר ירושלים" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="BeitarJerusalem.aspx.cs" Inherits="BeitarJerusalem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .team-info {
            margin: 20px;
            padding: 15px;
        }
        h2 {
            color: #000000;
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
        <h2>בית''ר ירושלים</h2>
        
        <div class="section">
            <h3>היסטוריה</h3>
            <p>בית''ר ירושלים נוסדה בשנת 1936 ומייצגת את העיר ירושלים.</p>
            <p>הקבוצה משחקת את משחקי הבית שלה באצטדיון טדי.</p>
        </div>

        <div class="section">
            <h3>הישגים</h3>
            <p>• מספר אליפויות: 6</p>
            <p>• דירוג נוכחי בליגה: 4</p>
        </div>

        <div class="section">
            <h3>שחקני עבר מפורסמים</h3>
            <p>• אורי מלמיליאן - מגדולי השחקנים בתולדות המועדון</p>
            <p>• דני נוימן - חלוץ מיתולוגי</p>
        </div>
    </div>
</asp:Content>