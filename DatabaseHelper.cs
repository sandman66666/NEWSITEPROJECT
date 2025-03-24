public static class DatabaseHelper
{
    // Your database helper methods here
}
< Project Sdk = "Microsoft.NET.Sdk.Web" >

  < PropertyGroup >
    < TargetFramework > net48 </ TargetFramework >
    < LangVersion > 6 </ LangVersion >
  </ PropertyGroup >

</ Project >
<%@ Page Title = "?? ????" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID = "Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content >

< asp:Content ID = "Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class= "welcome-section" style = "text-align: center; padding: 20px; max-width: 800px; margin: 0 auto;" >
        < h2 style = "color: #2c3e50; font-size: 28px; margin-bottom: 30px; text-align: center;" > ?????? ????? ???? ?????? ??????? ??????</h2>
        <p style="font-size: 18px; margin-bottom: 30px; line-height: 1.6; text-align: center;">???? ?? ????? ????? ???? ?? ?????? ??????? ???????? ??????.</p>
        
        <div class= "project-info" style = "background-color: white; padding: 30px; border-radius: 8px; margin-top: 30px; box-shadow: 0 3px 10px rgba(0,0,0,0.1); max-width: 600px; margin-left: auto; margin-right: auto; text-align: center;" >
            < h3 style = "color: #4CAF50; margin-bottom: 15px;" > ???? ???????:</ h3 >
            < ul style = "list-style-type: none; padding: 0; margin: 0 auto; display: inline-block; text-align: right;" >
                < li style = "margin-bottom: 10px; padding: 5px 0;" >< strong > ?? ??????:</ strong > ???? ????? </ li >
                < li style = "margin-bottom: 10px; padding: 5px 0;" >< strong > ????:</ strong > ?? 2 </ li >
                < li style = "margin-bottom: 10px; padding: 5px 0;" >< strong > ??? ???:</ strong > ????? ??? </ li >
                < li style = "margin-bottom: 10px; padding: 5px 0;" >< strong > ????? ????:</ strong > ??? 2025 </ li >
            </ ul >
        </ div >
    </ div >
    < asp:Label ID = "UserInfoLabel" runat="server" Text="User Info"></asp:Label >
    < asp:TextBox ID = "UserNameTextBox" runat="server"></asp:TextBox >
    < asp:TextBox ID = "PasswordTextBox" runat="server" TextMode="Password"></asp:TextBox >
    < asp:TextBox ID = "EmailTextBox" runat="server"></asp:TextBox >
    < asp:TextBox ID = "SearchNameTextBox" runat="server"></asp:TextBox >
    < asp:TextBox ID = "MinChampionshipsTextBox" runat="server"></asp:TextBox >
    < asp:PlaceHolder ID = "authLinks" runat="server"></asp:PlaceHolder >
</ asp:Content >
< PropertyGroup >
  < LangVersion > 6 </ LangVersion >
</ PropertyGroup >
< PropertyGroup >
  < LangVersion > 6 </ LangVersion >
</ PropertyGroup >
< asp:Label ID = "UserInfoLabel" runat="server" Text="User Info"></asp:Label >
< asp:TextBox ID = "UserNameTextBox" runat="server"></asp:TextBox >
< asp:TextBox ID = "PasswordTextBox" runat="server" TextMode="Password"></asp:TextBox >
< asp:TextBox ID = "EmailTextBox" runat="server"></asp:TextBox >
< asp:TextBox ID = "SearchNameTextBox" runat="server"></asp:TextBox >
< asp:TextBox ID = "MinChampionshipsTextBox" runat="server"></asp:TextBox >
< asp:PlaceHolder ID = "authLinks" runat="server"></asp:PlaceHolder >
<%@ Page Title = "?? ????" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID = "Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content >

< asp:Content ID = "Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class= "welcome-section" style = "text-align: center; padding: 20px; max-width: 800px; margin: 0 auto;" >
        < h2 style = "color: #2c3e50; font-size: 28px; margin-bottom: 30px; text-align: center;" > ?????? ????? ???? ?????? ??????? ??????</h2>
        <p style="font-size: 18px; margin-bottom: 30px; line-height: 1.6; text-align: center;">???? ?? ????? ????? ???? ?? ?????? ??????? ???????? ??????.</p>
        
        <div class= "project-info" style = "background-color: white; padding: 30px; border-radius: 8px; margin-top: 30px; box-shadow: 0 3px 10px rgba(0,0,0,0.1); max-width: 600px; margin-left: auto; margin-right: auto; text-align: center;" >
            < h3 style = "color: #4CAF50; margin-bottom: 15px;" > ???? ???????:</ h3 >
            < ul style = "list-style-type: none; padding: 0; margin: 0 auto; display: inline-block; text-align: right;" >
                < li style = "margin-bottom: 10px; padding: 5px 0;" >< strong > ?? ??????:</ strong > ???? ????? </ li >
                < li style = "margin-bottom: 10px; padding: 5px 0;" >< strong > ????:</ strong > ?? 2 </ li >
                < li style = "margin-bottom: 10px; padding: 5px 0;" >< strong > ??? ???:</ strong > ????? ??? </ li >
                < li style = "margin-bottom: 10px; padding: 5px 0;" >< strong > ????? ????:</ strong > ??? 2025 </ li >
            </ ul >
        </ div >
    </ div >
    < asp:Label ID = "UserInfoLabel" runat="server" Text="User Info"></asp:Label >
    < asp:TextBox ID = "UserNameTextBox" runat="server"></asp:TextBox >
    < asp:TextBox ID = "PasswordTextBox" runat="server" TextMode="Password"></asp:TextBox >
    < asp:TextBox ID = "EmailTextBox" runat="server"></asp:TextBox >
    < asp:TextBox ID = "SearchNameTextBox" runat="server"></asp:TextBox >
    < asp:TextBox ID = "MinChampionshipsTextBox" runat="server"></asp:TextBox >
    < asp:PlaceHolder ID = "authLinks" runat="server"></asp:PlaceHolder >
</ asp:Content >
