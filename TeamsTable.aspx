<%@ Page Title="טבלת קבוצות" Language="C#" MasterPageFile="~/MasterPage.master" CodeFile="TeamsTable.aspx.cs" Inherits="TeamsTable" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
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
        
        .action-link {
            display: inline-block;
            margin: 0 5px;
            padding: 3px 8px;
            border-radius: 3px;
            text-decoration: none;
            color: white;
        }
        
        .edit-link {
            background-color: #3498db;
        }
        
        .delete-link {
            background-color: #e74c3c;
        }
        
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
        
        .admin-notice {
            background-color: #fcf8e3;
            border: 1px solid #faebcc;
            color: #8a6d3b;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div style="text-align: center; padding: 20px;">
        <h2 style="color: #2c3e50; font-size: 28px; margin-bottom: 30px; text-align: center;">קבוצות הכדורגל המובילות בישראל</h2>
        
        <asp:Panel ID="AdminNoticePanel" runat="server" CssClass="admin-notice" Visible="false">
            <p>אתה לא מחובר כמנהל. רק מנהלים יכולים להוסיף, לערוך או למחוק קבוצות.</p>
            <p><a href="Signin.aspx" style="color: #8a6d3b; font-weight: bold;">התחבר כמנהל</a> כדי לקבל גישה מלאה.</p>
        </asp:Panel>
        
        <div style="max-width: 900px; margin: 0 auto; background-color: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            <!-- Search Panel -->
            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; text-align: right;">
                <h3 style="margin-top: 0; color: #333; font-size: 18px; margin-bottom: 10px;">חיפוש קבוצות</h3>
                <div style="display: flex; flex-wrap: wrap; justify-content: space-between;">
                    <div style="flex: 1; min-width: 200px; margin-left: 15px; margin-bottom: 10px;">
                        <label for="SearchNameTextBox" style="display: block; margin-bottom: 5px; font-weight: bold;">שם קבוצה:</label>
                        <asp:TextBox ID="SearchNameTextBox" runat="server" CssClass="form-control" style="width: 100%; padding: 6px; border: 1px solid #ccc; border-radius: 4px;"></asp:TextBox>
                    </div>
                    <div style="flex: 1; min-width: 200px; margin-bottom: 10px;">
                        <label for="MinChampionshipsTextBox" style="display: block; margin-bottom: 5px; font-weight: bold;">מינימום אליפויות:</label>
                        <asp:TextBox ID="MinChampionshipsTextBox" runat="server" CssClass="form-control" style="width: 100%; padding: 6px; border: 1px solid #ccc; border-radius: 4px;"></asp:TextBox>
                    </div>
                </div>
                <div style="margin-top: 10px; text-align: left;">
                    <asp:Button ID="SearchButton" runat="server" Text="חפש" OnClick="SearchButton_Click" 
                        style="background-color: #4CAF50; color: white; padding: 6px 15px; border: none; border-radius: 4px; cursor: pointer; margin-right: 5px;" />
                    <asp:Button ID="ClearButton" runat="server" Text="נקה" OnClick="ClearButton_Click" 
                        style="background-color: #f8f9fa; color: #333; padding: 6px 15px; border: 1px solid #ccc; border-radius: 4px; cursor: pointer;" />
                </div>
            </div>
            
            <asp:GridView ID="TeamsGridView" runat="server" AutoGenerateColumns="False" 
                    CssClass="teams-table" Width="100%" HorizontalAlign="Center"
                    DataKeyNames="TeamName" OnRowCommand="GridView1_RowCommand" 
                    OnRowDataBound="GridView1_RowDataBound"
                    OnRowEditing="GridView1_RowEditing"
                    OnRowCancelingEdit="GridView1_RowCancelingEdit"
                    OnRowUpdating="GridView1_RowUpdating">
                <Columns>
                    <asp:TemplateField HeaderText="פעולות" ItemStyle-Width="150px">
                        <ItemTemplate>
                            <asp:Panel ID="AdminActionsPanel" runat="server">
                                <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" 
                                    CssClass="action-link edit-link">ערוך</asp:LinkButton>
                                <asp:LinkButton ID="DeleteButton" runat="server" CommandName="DeleteTeam" 
                                    CommandArgument='<%# Eval("TeamName") %>' 
                                    CssClass="action-link delete-link"
                                    OnClientClick="return confirm('האם אתה בטוח שברצונך למחוק קבוצה זו?');">מחק</asp:LinkButton>
                            </asp:Panel>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton ID="UpdateButton" runat="server" CommandName="Update" 
                                CssClass="action-link edit-link">שמור</asp:LinkButton>
                            <asp:LinkButton ID="CancelButton" runat="server" CommandName="Cancel" 
                                CssClass="action-link delete-link">בטל</asp:LinkButton>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="שם הקבוצה">
                        <ItemTemplate>
                            <%# Eval("TeamName") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtTeamName" runat="server" Text='<%# Bind("TeamName") %>' Width="95%" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="אליפויות">
                        <ItemTemplate>
                            <%# Eval("Championships") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtChampionships" runat="server" Text='<%# Bind("Championships") %>' Width="95%" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="שחקנים בולטים">
                        <ItemTemplate>
                            <%# Eval("Stars") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtStars" runat="server" Text='<%# Bind("Stars") %>' Width="95%" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="דירוג עכשווי">
                        <ItemTemplate>
                            <%# Eval("CurrentStanding") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtCurrentStanding" runat="server" Text='<%# Bind("CurrentStanding") %>' Width="95%" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            
            <div style="margin-top: 20px; text-align: center;">
                <asp:Button ID="AddTeamButton" runat="server" Text="הוסף קבוצה חדשה" 
                             CssClass="add-team-button" OnClick="AddTeamButton_Click"
                             Visible="false" />
            </div>
        </div>
    </div>
</asp:Content>