<%@ Page Title="טבלת קבוצות" Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script runat="server">
        private DataTable teamsTable;

        protected void Page_Load(object sender, EventArgs e)
        {
            LoadTeams();
            
            if (!IsPostBack)
            {
                // First-time initialization code can go here
            }
        }

        private void LoadTeams()
        {
            teamsTable = DatabaseHelper.GetTeams();
            TeamsGridView.DataSource = teamsTable;
            TeamsGridView.DataBind();
        }

        public void AddTeamButton_Click(object sender, EventArgs e)
        {
            if (teamsTable != null)
            {
                DataRow newRow = teamsTable.NewRow();
                newRow["TeamName"] = "";
                newRow["Championships"] = "0";
                newRow["Stars"] = "";
                newRow["CurrentStanding"] = "0";

                teamsTable.Rows.Add(newRow);

                TeamsGridView.EditIndex = teamsTable.Rows.Count - 1;
                TeamsGridView.DataSource = teamsTable;
                TeamsGridView.DataBind();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Could not create team. Please try again.');", true);
                LoadTeams(); 
            }
        }

        protected void TeamsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Insert")
            {
                GridViewRow row = TeamsGridView.FooterRow;
                string teamName = ((TextBox)row.FindControl("NewTeamName")).Text;
                string championships = ((TextBox)row.FindControl("NewChampionships")).Text;
                string stars = ((TextBox)row.FindControl("NewStars")).Text;
                string standing = ((TextBox)row.FindControl("NewStanding")).Text;

                if (!string.IsNullOrEmpty(teamName))
                {
                    DatabaseHelper.AddTeam(teamName, championships, stars, standing);
                    LoadTeams();
                }
            }
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            string teamName = SearchNameTextBox.Text.Trim();
            string minChampionships = MinChampionshipsTextBox.Text.Trim();

            DataTable filteredTeams = DatabaseHelper.SearchTeams(teamName, minChampionships);
            TeamsGridView.DataSource = filteredTeams;
            TeamsGridView.DataBind();
        }

        protected void ClearButton_Click(object sender, EventArgs e)
        {
            SearchNameTextBox.Text = "";
            MinChampionshipsTextBox.Text = "";
            LoadTeams();
        }

        protected void TeamsGridView_RowEditing(object sender, GridViewEditEventArgs e)
        {
            TeamsGridView.EditIndex = e.NewEditIndex;
            LoadTeams();
        }

        protected void TeamsGridView_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            TeamsGridView.EditIndex = -1;
            LoadTeams();
        }

        protected void TeamsGridView_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            string teamName = TeamsGridView.DataKeys[e.RowIndex].Value.ToString();
            string championships = e.NewValues["Championships"] != null ? e.NewValues["Championships"].ToString() : "";
            string stars = e.NewValues["Stars"] != null ? e.NewValues["Stars"].ToString() : "";
            string standing = e.NewValues["CurrentStanding"] != null ? e.NewValues["CurrentStanding"].ToString() : "";

            DatabaseHelper.UpdateTeam(teamName, championships, stars, standing);
            TeamsGridView.EditIndex = -1;
            LoadTeams();
        }

        protected void TeamsGridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string teamName = TeamsGridView.DataKeys[e.RowIndex].Value.ToString();
            DatabaseHelper.DeleteTeam(teamName);
            LoadTeams();
        }
    </script>

    <style>
        .add-team-button {
            background-color: #27ae60;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        .add-team-button:hover {
            background-color: #219a52;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="teams-section" style="text-align: center; padding: 20px;">
        <h2 style="color: #2c3e50; font-size: 28px; margin-bottom: 30px; text-align: center;">קבוצות הכדורגל המובילות בישראל</h2>
        
        <div style="max-width: 900px; margin: 0 auto; background-color: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            <!-- Add Team Button -->
            <div style="text-align: left; margin-bottom: 20px;">
                <asp:Button ID="AddTeamButton" runat="server" Text="הוסף קבוצה חדשה" OnClick="AddTeamButton_Click" CssClass="add-team-button" CausesValidation="false" />
            </div>

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
                        OnRowCommand="TeamsGridView_RowCommand"
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