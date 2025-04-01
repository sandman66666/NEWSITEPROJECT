<%@ Page Title="הרשמה" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="NEWSITEPROJECT.SignUp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="margin: 20px auto; max-width: 500px; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 3px 10px rgba(0,0,0,0.1); text-align: center;">
        <h2 style="color: #2c3e50; font-size: 28px; margin-bottom: 30px; text-align: center;">הרשמה לאתר</h2>
        
        <table style="width: 100%; margin: 0 auto; text-align: center;">
            <tr>
                <td style="padding: 10px; text-align: right; font-weight: bold; color: #555;">שם משתמש:</td>
                <td><asp:TextBox ID="UserNameTextBox" runat="server" CssClass="input-field" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="padding: 10px; text-align: right; font-weight: bold; color: #555;">סיסמה:</td>
                <td><asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" CssClass="input-field" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="padding: 10px; text-align: right; font-weight: bold; color: #555;">אימייל:</td>
                <td><asp:TextBox ID="EmailTextBox" runat="server" CssClass="input-field" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; padding-top: 30px;">
                    <asp:Button ID="SignUpButton" runat="server" Text="הרשמה" OnClick="SignUpButton_Click" 
                              style="background-color: #4CAF50; color: white; padding: 12px 30px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);" />
                </td>
            </tr>
        </table>
        
        <div style="text-align: center; margin-top: 20px;">
            <p>כבר רשום? <a href="SignIn.aspx">התחבר כאן</a></p>
        </div>
    </div>
</asp:Content>