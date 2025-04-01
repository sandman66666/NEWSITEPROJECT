<%@ Page Title="התחברות" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Signin.aspx.cs" Inherits="NEWSITEPROJECT.SignIn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style>
    .login-container {
        margin: 20px auto;
        max-width: 450px;
        background: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        text-align: center;
    }
    .form-group {
        margin-bottom: 20px;
        text-align: right;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
        color: #555;
    }
    .form-group input {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
    }
    .login-btn {
        background-color: #4CAF50;
        color: white;
        padding: 12px 30px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .login-btn:hover {
        background-color: #45a049;
    }
    .signup-link {
        text-align: center;
        margin-top: 20px;
    }
    .signup-link a {
        color: #4CAF50;
        text-decoration: none;
    }
    .signup-link a:hover {
        text-decoration: underline;
    }
    h2 {
        color: #2c3e50;
        font-size: 28px;
        margin-bottom: 30px;
    }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="login-container">
        <h2>התחברות</h2>
        <div class="form-group">
            <asp:Label ID="UserNameLabel" runat="server" Text="שם משתמש:"></asp:Label>
            <asp:TextBox ID="UserNameTextBox" runat="server" CssClass="input-field"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Label ID="PasswordLabel" runat="server" Text="סיסמה:"></asp:Label>
            <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" CssClass="input-field"></asp:TextBox>
        </div>
        <asp:Button ID="SignInButton" runat="server" Text="התחבר" CssClass="login-btn" OnClick="SignInButton_Click" />
        <div class="signup-link">
            <p>אין לך חשבון? <a href="SignUp.aspx">הירשם כאן</a></p>
        </div>
    </div>
</asp:Content>