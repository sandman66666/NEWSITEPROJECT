<%@ Page Title="טבלת קבוצות" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="TeamsTable.aspx.cs" Inherits="NEWSITEPROJECT.TeamsTable" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="NEWSITEPROJECT" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .add-team-button {
            margin-top: 20px;
            padding: 6px 15px;
            background-color: #4caf50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .add-team-button:hover {
            background-color: #45a049;
        }
        
        .teams-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            direction: rtl;
        }
        
        .teams-table th {
            background-color: #3498db;
            color: white;
            padding: 10px;
            text-align: right;
        }
        
        .teams-table td {
            padding: 8px;
            border-bottom: 1px solid #ddd;
            text-align: right;
        }
        
        .teams-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .edit-btn, .delete-btn, .update-btn, .cancel-btn {
            padding: 4px 8px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            margin-right: 5px;
            color: white;
        }
        
        .edit-btn {
            background-color: #3498db;
        }
        
        .delete-btn {
            background-color: #e74c3c;
        }
        
        .update-btn {
            background-color: #2ecc71;
        }
        
        .cancel-btn {
            background-color: #95a5a6;
        }
        
        .search-panel {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            direction: rtl;
        }
        
        .search-table {
            width: 100%;
        }
        
        .search-table td {
            padding: 5px;
        }
        
        .submit-button {
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .submit-button:hover {
            background-color: #2980b9;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="teams-section" style="text-align: center; padding: 20px;">
        <h2 style="color: #2c3e50; font-size: 28px; margin-bottom: 30px; text-align: center;">קבוצות הכדורגל המובילות בישראל</h2>
        
        <!-- Login Warning for Non-Admin Users -->
        <% if (Session["Username"] == null) { %>
        <div style="background-color: #fcf8e3; border: 1px solid #faebcc; color: #8a6d3b; padding: 15px; margin-bottom: 20px; text-align: center; border-radius: 4px;">
            <p style="margin: 0;"><i class="fa fa-exclamation-triangle"></i> יש להתחבר למערכת כדי לערוך או להוסיף קבוצות.</p>
        </div>
        <% } else if (Session["UserRole"] != null && Session["UserRole"].ToString().ToLower() != "admin") { %>
        <div style="background-color: #fcf8e3; border: 1px solid #faebcc; color: #8a6d3b; padding: 15px; margin-bottom: 20px; text-align: center; border-radius: 4px;">
            <p style="margin: 0;"><i class="fa fa-exclamation-triangle"></i> רק מנהלים יכולים לערוך או להוסיף קבוצות.</p>
        </div>
        <% } %>

        <div style="max-width: 900px; margin: 0 auto; background-color: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            <!-- Add Team Button -->
            <div style="text-align: left; margin-bottom: 20px;">
                <asp:Button ID="AddTeamButton" runat="server" Text="הוסף קבוצה חדשה" OnClick="AddTeamButton_Click" CssClass="add-team-button" CausesValidation="false" />
            </div>
            
            <!-- Search Panel -->
            <div class="search-panel">
                <h3 style="color: #3498db; margin-top: 0; text-align: center;">חיפוש קבוצות</h3>
                <table class="search-table">
                    <tr>
                        <td style="width: 25%;">
                            <asp:Label ID="Label1" runat="server" Text="שם הקבוצה:"></asp:Label>
                        </td>
                        <td style="width: 75%;">
                            <asp:TextBox ID="SearchNameTextBox" runat="server" Width="80%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 25%;">
                            <asp:Label ID="Label2" runat="server" Text="מינימום אליפויות:"></asp:Label>
                        </td>
                        <td style="width: 75%;">
                            <asp:TextBox ID="MinChampionshipsTextBox" runat="server" Width="80%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center; padding-top: 10px;">
                            <asp:Button ID="SearchButton" runat="server" Text="חפש" OnClick="SearchButton_Click" 
                                CssClass="submit-button" style="padding: 5px 20px;" />
                            <asp:Button ID="ClearButton" runat="server" Text="נקה" OnClick="ClearButton_Click" 
                                CssClass="submit-button" style="padding: 5px 20px; margin-right: 10px;" />
                        </td>
                    </tr>
                </table>
            </div>
            
            <!-- Teams GridView -->
            <asp:GridView ID="TeamsGridView" runat="server" AutoGenerateColumns="False" 
                        CssClass="teams-table" Width="100%" HorizontalAlign="Center"
                        OnRowEditing="TeamsGridView_RowEditing"
                        OnRowCancelingEdit="TeamsGridView_RowCancelingEdit"
                        OnRowUpdating="TeamsGridView_RowUpdating"
                        OnRowDeleting="TeamsGridView_RowDeleting"
                        DataKeyNames="TeamName"
                        OnRowDataBound="TeamsGridView_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="שם הקבוצה">
                        <ItemTemplate>
                            <%# Eval("TeamName") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBoxTeamName" runat="server" Text='<%# Bind("TeamName") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="מספר אליפויות">
                        <ItemTemplate>
                            <%# Eval("Championships") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBoxChampionships" runat="server" Text='<%# Bind("Championships") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="כוכבים">
                        <ItemTemplate>
                            <%# Eval("Stars") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBoxStars" runat="server" Text='<%# Bind("Stars") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="דירוג נוכחי">
                        <ItemTemplate>
                            <%# Eval("CurrentStanding") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBoxCurrentStanding" runat="server" Text='<%# Bind("CurrentStanding") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField HeaderText="פעולות" ShowEditButton="true" ShowDeleteButton="true" DeleteText="מחק" EditText="ערוך" UpdateText="עדכן" CancelText="בטל" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>