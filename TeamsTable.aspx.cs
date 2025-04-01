using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NEWSITEPROJECT
{
    public partial class TeamsTable : System.Web.UI.Page
    {
        private DataTable teamsTable;
        private bool isAdmin = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in and has admin rights
            if (Session["Username"] != null)
            {
                string username = Session["Username"].ToString();
                string userRole = "";
                if (Session["UserRole"] != null)
                {
                    userRole = Session["UserRole"].ToString();
                }
                isAdmin = userRole.ToLower() == "admin";

                // Show/hide add button and controls based on role
                AddTeamButton.Visible = isAdmin;
            }
            else
            {
                // Hide editing controls for non-logged-in users
                AddTeamButton.Visible = false;
            }

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

            // Hide edit/delete buttons for non-admin users
            if (!isAdmin)
            {
                foreach (GridViewRow row in TeamsGridView.Rows)
                {
                    if (row.RowType == DataControlRowType.DataRow)
                    {
                        // Find all the command buttons
                        LinkButton editButton = row.Cells[4].Controls[0] as LinkButton;
                        LinkButton deleteButton = row.Cells[4].Controls[2] as LinkButton;

                        // Hide them for non-admin users
                        if (editButton != null) editButton.Visible = false;
                        if (deleteButton != null) deleteButton.Visible = false;
                    }
                }
            }
        }

        protected void AddTeamButton_Click(object sender, EventArgs e)
        {
            // Only allow admins to add teams
            if (!isAdmin)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Only administrators can add or edit teams.');", true);
                return;
            }

            if (Session["Username"] == null)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please log in first.');", true);
                return;
            }

            if (teamsTable != null)
            {
                // Add a new blank row for editing
                DataRow newRow = teamsTable.NewRow();
                newRow["TeamName"] = "שם הקבוצה"; // Default text that will be editable
                newRow["Championships"] = "0";
                newRow["Stars"] = "";
                newRow["CurrentStanding"] = "0";

                teamsTable.Rows.Add(newRow);

                // Set ViewState to indicate this is a new team
                ViewState["OriginalTeamName"] = "";
                ViewState["IsNewTeam"] = "true";

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

        protected void TeamsGridView_RowEditing(object sender, GridViewEditEventArgs e)
        {
            // Only allow admins to edit teams
            if (!isAdmin)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Only administrators can edit teams.');", true);
                return;
            }

            // Store the original team name for later use in updating
            string teamName = TeamsGridView.DataKeys[e.NewEditIndex].Value.ToString();
            ViewState["OriginalTeamName"] = teamName;
            ViewState["IsNewTeam"] = "false";

            TeamsGridView.EditIndex = e.NewEditIndex;
            TeamsGridView.DataSource = teamsTable;
            TeamsGridView.DataBind();
        }

        protected void TeamsGridView_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            // Clear any ViewState variables we set
            ViewState["OriginalTeamName"] = null;
            ViewState["IsNewTeam"] = null;

            TeamsGridView.EditIndex = -1;
            LoadTeams();
        }

        protected void TeamsGridView_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Only allow admins to update teams
            if (!isAdmin)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Only administrators can update teams.');", true);
                TeamsGridView.EditIndex = -1;
                LoadTeams();
                return;
            }

            GridViewRow row = TeamsGridView.Rows[e.RowIndex];

            // Get team name and validate it's not empty
            string teamName = "";
            if (((TextBox)row.FindControl("TextBoxTeamName")) != null)
            {
                teamName = ((TextBox)row.FindControl("TextBoxTeamName")).Text;
            }

            if (string.IsNullOrWhiteSpace(teamName))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Team name cannot be empty.');", true);
                return;
            }

            int championships = 0;
            string championshipsText = "";
            if (((TextBox)row.FindControl("TextBoxChampionships")) != null)
            {
                championshipsText = ((TextBox)row.FindControl("TextBoxChampionships")).Text;
            }

            if (!int.TryParse(championshipsText, out championships))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Championships must be a number.');", true);
                return;
            }

            string stars = "";
            if (((TextBox)row.FindControl("TextBoxStars")) != null)
            {
                stars = ((TextBox)row.FindControl("TextBoxStars")).Text;
            }

            int currentStanding = 0;
            string currentStandingText = "";
            if (((TextBox)row.FindControl("TextBoxCurrentStanding")) != null)
            {
                currentStandingText = ((TextBox)row.FindControl("TextBoxCurrentStanding")).Text;
            }

            if (!int.TryParse(currentStandingText, out currentStanding))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Current standing must be a number.');", true);
                return;
            }

            // Determine if this is a new team or an update
            bool isNewTeam = false;
            string originalTeamName = "";

            if (ViewState["IsNewTeam"] != null && ViewState["IsNewTeam"].ToString() == "true")
            {
                isNewTeam = true;
            }
            else if (ViewState["OriginalTeamName"] != null)
            {
                originalTeamName = ViewState["OriginalTeamName"].ToString();
                isNewTeam = string.IsNullOrWhiteSpace(originalTeamName);
            }
            else
            {
                isNewTeam = true;
            }

            bool success = false;

            if (isNewTeam)
            {
                // Adding a new team
                try
                {
                    DatabaseHelper.AddTeam(teamName, championshipsText, stars, currentStandingText);
                    success = true;
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                        "alert('Error adding team: " + ex.Message.Replace("'", "\\'") + "');", true);
                    return;
                }
            }
            else
            {
                // Updating existing team
                try
                {
                    success = DatabaseHelper.UpdateTeam(originalTeamName, championshipsText, stars, currentStandingText);
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                        "alert('Error updating team: " + ex.Message.Replace("'", "\\'") + "');", true);
                    return;
                }
            }

            if (success)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Team saved successfully.');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error saving team.');", true);
            }

            // Clear ViewState variables
            ViewState["OriginalTeamName"] = null;
            ViewState["IsNewTeam"] = null;

            TeamsGridView.EditIndex = -1;
            LoadTeams();
        }

        protected void TeamsGridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Only allow admins to delete teams
            if (!isAdmin)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Only administrators can delete teams.');", true);
                return;
            }

            string teamName = TeamsGridView.DataKeys[e.RowIndex].Value.ToString();
            bool success = DatabaseHelper.DeleteTeam(teamName);
            if (success)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Team deleted successfully.');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error deleting team.');", true);
            }
            LoadTeams();
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            string teamName = SearchNameTextBox.Text;
            string minChampionships = MinChampionshipsTextBox.Text;
            teamsTable = DatabaseHelper.SearchTeams(teamName, minChampionships);
            TeamsGridView.DataSource = teamsTable;
            TeamsGridView.DataBind();
        }

        protected void ClearButton_Click(object sender, EventArgs e)
        {
            SearchNameTextBox.Text = "";
            MinChampionshipsTextBox.Text = "";
            LoadTeams();
        }

        protected void TeamsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Add confirmation dialog to the delete button in the command field
                LinkButton deleteButton = e.Row.Cells[4].Controls[2] as LinkButton;
                if (deleteButton != null)
                {
                    deleteButton.Attributes.Add("onclick", "return confirm('האם אתה בטוח שברצונך למחוק קבוצה זו?');");
                }
            }
        }
    }
}