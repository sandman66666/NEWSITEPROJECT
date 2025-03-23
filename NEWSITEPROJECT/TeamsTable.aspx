<%@ Page Title="טבלת קבוצות" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="TeamsTable.aspx.cs" Inherits="TeamsTable" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="teams-section" style="text-align: center; padding: 20px;">
        <h2 style="color: #2c3e50; font-size: 28px; margin-bottom: 30px; text-align: center;">קבוצות הכדורגל המובילות בישראל</h2>
        
        <div style="max-width: 900px; margin: 0 auto; background-color: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            <!-- Search Panel -->
            <div class="search-panel" style="margin-bottom: 20px; background-color: #f5f5f5; padding: 15px; border-radius: 5px; text-align: right;">
                <h3 style="margin-top: 0; margin-bottom: 10px; color: #336699;">חיפוש קבוצות</h3>
                <table style="width: 100%;">
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
                        DataKeyNames="TeamName">
            <Columns>
                <asp:BoundField DataField="TeamName" HeaderText="שם הקבוצה" ReadOnly="true" />
                <asp:BoundField DataField="Championships" HeaderText="מספר אליפויות" />
                <asp:BoundField DataField="Stars" HeaderText="שחקני עבר מפורסמים" />
                <asp:BoundField DataField="CurrentStanding" HeaderText="דירוג נוכחי" />
                <asp:CommandField ButtonType="Button" ShowEditButton="True" EditText="ערוך" UpdateText="שמור" CancelText="בטל" />
                <asp:CommandField ButtonType="Button" ShowDeleteButton="True" DeleteText="מחק" />
            </Columns>
        </asp:GridView>
        </div>
    </div>
</asp:Content>