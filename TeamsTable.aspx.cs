using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NEWSITEPROJECT
{
    public partial class TeamsTable : System.Web.UI.Page
    {
        private DataTable teamsTable;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTeams();
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
            // Create a new row with empty values
            DataRow newRow = teamsTable.NewRow();
            newRow["TeamName"] = "";
            newRow["Championships"] = "0";
            newRow["Stars"] = "";
            newRow["CurrentStanding"] = "0";

            // Add the row to the table
            teamsTable.Rows.Add(newRow);

            // Set the GridView to edit mode for the new row
            TeamsGridView.EditIndex = teamsTable.Rows.Count - 1;
            TeamsGridView.DataSource = teamsTable;
            TeamsGridView.DataBind();
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
    }
}