using System;
using System.Data;

public partial class TeamsTable : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadTeams();
        }
    }
    
    private void LoadTeams()
    {
        DataTable teamsTable = DatabaseHelper.GetTeams();
        TeamsGridView.DataSource = teamsTable;
        TeamsGridView.DataBind();
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
    
    protected void TeamsGridView_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
    {
        TeamsGridView.EditIndex = e.NewEditIndex;
        LoadTeams();
    }
    
    protected void TeamsGridView_RowCancelingEdit(object sender, System.Web.UI.WebControls.GridViewCancelEditEventArgs e)
    {
        TeamsGridView.EditIndex = -1;
        LoadTeams();
    }
    
    protected void TeamsGridView_RowUpdating(object sender, System.Web.UI.WebControls.GridViewUpdateEventArgs e)
    {
        string teamName = TeamsGridView.DataKeys[e.RowIndex].Value.ToString();
        
        string championships = e.NewValues["Championships"]?.ToString() ?? "";
        string stars = e.NewValues["Stars"]?.ToString() ?? "";
        string standing = e.NewValues["CurrentStanding"]?.ToString() ?? "";
        
        DatabaseHelper.UpdateTeam(teamName, championships, stars, standing);
        
        TeamsGridView.EditIndex = -1;
        LoadTeams();
    }
    
    protected void TeamsGridView_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
    {
        string teamName = TeamsGridView.DataKeys[e.RowIndex].Value.ToString();
        
        DatabaseHelper.DeleteTeam(teamName);
        LoadTeams();
    }
}