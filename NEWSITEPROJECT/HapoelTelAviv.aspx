<%@ Page Title="הפועל תל אביב" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="HapoelTelAviv.aspx.cs" Inherits="HapoelTelAviv" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .team-info {
            margin: 20px;
            padding: 15px;
        }
        h2 {
            color: #FF0000;
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
        <h2>הפועל תל אביב</h2>
        
        <div class="section">
            <h3>היסטוריה</h3>
            <p>הפועל תל אביב נוסדה בשנת 1923 ומייצגת את העיר תל אביב.</p>
            <p>הקבוצה משחקת את משחקי הבית שלה באצטדיון בלומפילד.</p>
        </div>

        <div class="section">
            <h3>הישגים</h3>
            <p>• מספר אליפויות: 13</p>
            <p>• דירוג נוכחי בליגה: 2</p>
        </div>

        <div class="section">
            <h3>שחקני עבר מפורסמים</h3>
            <p>• שייע גלזר - מהשחקנים הגדולים בתולדות הקבוצה</p>
            <p>• רפי לוי - קפטן מיתולוגי</p>
        </div>
    </div>
</asp:Content>