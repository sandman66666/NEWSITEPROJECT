<%@ Page Title="טבלת קבוצות" Language="C#" MasterPageFile="~/MasterPage.master" %>

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
            <!-- Teams Display -->
            <asp:GridView ID="GridViewTeams" runat="server" AutoGenerateColumns="False" 
                    CssClass="teams-table" Width="100%" HorizontalAlign="Center"
                    DataKeyNames="TeamName" OnRowCommand="GridViewTeams_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="פעולות" ItemStyle-Width="150px">
                        <ItemTemplate>
                            <asp:Panel ID="AdminActionsPanel" runat="server" Visible='<%# IsAdmin %>'>
                                <a href='<%# "EditTeam.aspx?mode=edit&team=" + Server.UrlEncode(Eval("TeamName").ToString()) %>' class="action-link edit-link">ערוך</a>
                                <asp:LinkButton ID="DeleteButton" runat="server" CommandName="DeleteTeam" 
                                    CommandArgument='<%# Eval("TeamName") %>' 
                                    CssClass="action-link delete-link"
                                    OnClientClick="return confirm('האם אתה בטוח שברצונך למחוק קבוצה זו?');">מחק</asp:LinkButton>
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="TeamName" HeaderText="שם הקבוצה" />
                    <asp:BoundField DataField="Championships" HeaderText="אליפויות" />
                    <asp:BoundField DataField="Stars" HeaderText="כוכבים" />
                    <asp:BoundField DataField="CurrentStanding" HeaderText="דירוג עכשווי" />
                </Columns>
            </asp:GridView>
            
            <!-- Add Team Button (Admin only) -->
            <div style="margin-top: 20px; text-align: center;">
                <asp:HyperLink ID="AddTeamLink" runat="server" NavigateUrl="EditTeam.aspx?mode=add" 
                             CssClass="add-team-button" style="text-decoration: none; color: white;"
                             Visible="false">הוסף קבוצה חדשה</asp:HyperLink>
            </div>
        </div>
    </div>

    <script runat="server">
        private bool isAdmin = false;
        
        // Property to use in bindings
        protected bool IsAdmin 
        { 
            get { return isAdmin; } 
        }
        
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in and has admin privileges
            CheckAdminStatus();
            
            if (!IsPostBack)
            {
                // Load teams
                LoadTeams();
            }
        }
        
        private void CheckAdminStatus()
        {
            // Default to not admin
            isAdmin = false;
            
            // Check if user is logged in
            if (Session["Username"] != null)
            {
                // Check if user has admin role
                if (Session["UserRole"] != null && Session["UserRole"].ToString().ToLower() == "admin")
                {
                    isAdmin = true;
                    AdminNoticePanel.Visible = false;
                    AddTeamLink.Visible = true;
                }
                else
                {
                    // User is logged in but not admin
                    AdminNoticePanel.Visible = true;
                    AdminNoticePanel.CssClass = "admin-notice";
                    AddTeamLink.Visible = false;
                }
            }
            else
            {
                // User is not logged in
                AdminNoticePanel.Visible = true;
                AddTeamLink.Visible = false;
            }
        }
        
        private void LoadTeams()
        {
            GridViewTeams.DataSource = DatabaseHelper.GetTeams();
            GridViewTeams.DataBind();
        }
        
        protected void GridViewTeams_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteTeam")
            {
                // Double-check admin status before delete
                if (!isAdmin)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "NotAuthorized", 
                        "alert('אין לך הרשאות למחוק קבוצות');", true);
                    return;
                }
                
                string teamName = e.CommandArgument.ToString();
                bool success = DatabaseHelper.DeleteTeam(teamName);
                
                if (success)
                {
                    // Reload the teams grid
                    LoadTeams();
                }
                else
                {
                    // Display error message
                    ClientScript.RegisterStartupScript(this.GetType(), "DeleteError", 
                        "alert('שגיאה במחיקת הקבוצה');", true);
                }
            }
        }
    </script>
</asp:Content>