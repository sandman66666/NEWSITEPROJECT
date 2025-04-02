using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class TeamsTable : System.Web.UI.Page
{
    private DataTable teamsTable;
    private bool isAdmin = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Username"] != null)
        {
            string username = Session["Username"].ToString();
            string userRole = "";
            if (Session["UserRole"] != null)
            {
                userRole = Session["UserRole"].ToString();
            }
            isAdmin = userRole.ToLower() == "admin";

            AddTeamButton.Visible = isAdmin;
        }
        else
        {
            AddTeamButton.Visible = false;
        }

        if (!IsPostBack)
        {
            LoadTeams();
        }
        else
        {
            if (Session["TeamsData"] != null)
            {
                teamsTable = (DataTable)Session["TeamsData"];
            }
            else
            {
                LoadTeams();
            }
        }
    }

    private void LoadTeams()
    {
        try
        {
            teamsTable = new DataTable();
            teamsTable.Columns.Add("TeamName", typeof(string));
            teamsTable.Columns.Add("Championships", typeof(string));
            teamsTable.Columns.Add("Stars", typeof(string));
            teamsTable.Columns.Add("CurrentStanding", typeof(string));
            
            teamsTable.Rows.Add("מכבי חיפה", "14", "יניב קטן, אלי אוחנה, דדי בן דיין", "1");
            teamsTable.Rows.Add("מכבי תל אביב", "23", "אבי נמני, איציק שום, ג׳ורדי קרויף", "2");
            teamsTable.Rows.Add("הפועל באר שבע", "5", "אלון מזרחי, עטר אליאס", "3");
            teamsTable.Rows.Add("הפועל תל אביב", "7", "יוסי אבוקסיס, שלומי ארביב, גיל ורמוט", "4");
            
            Session["TeamsData"] = teamsTable;
            
            BindGrid();
        }
        catch
        {
        }
    }

    private void BindGrid()
    {
        GridView1.DataSource = teamsTable;
        GridView1.DataBind();

        foreach (GridViewRow row in GridView1.Rows)
        {
            if (row.RowType == DataControlRowType.DataRow)
            {
                Panel adminPanel = row.FindControl("AdminActionsPanel") as Panel;
                if (adminPanel != null)
                {
                    adminPanel.Visible = isAdmin;
                }
            }
        }
    }

    protected void AddTeamButton_Click(object sender, EventArgs e)
    {
        if (!isAdmin) return;

        DataRow newRow = teamsTable.NewRow();
        newRow["TeamName"] = "קבוצה חדשה";
        newRow["Championships"] = "0";
        newRow["Stars"] = "שחקנים חדשים";
        newRow["CurrentStanding"] = "0";
        teamsTable.Rows.Add(newRow);
        
        Session["TeamsData"] = teamsTable;
        
        BindGrid();
        
        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('קבוצה חדשה נוספה בהצלחה! עריכה את הפרטים לפי הצורך.');", true);
    }
    
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteTeam" && isAdmin)
        {
            string teamName = e.CommandArgument.ToString();
            try 
            {
                foreach (DataRow row in teamsTable.Rows)
                {
                    if (row["TeamName"].ToString() == teamName)
                    {
                        row.Delete();
                        break;
                    }
                }
                teamsTable.AcceptChanges();
                
                Session["TeamsData"] = teamsTable;
                
                BindGrid();
                
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('הקבוצה נמחקה בהצלחה');", true);
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('שגיאה במחיקת הקבוצה');", true);
            }
        }
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Panel adminPanel = e.Row.FindControl("AdminActionsPanel") as Panel;
            if (adminPanel != null)
            {
                adminPanel.Visible = isAdmin;
            }
        }
    }
    
    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = e.NewEditIndex;
        BindGrid();
    }
    
    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView1.EditIndex = -1;
        BindGrid();
    }
    
    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            GridViewRow row = GridView1.Rows[e.RowIndex];
            
            string originalTeamName = GridView1.DataKeys[e.RowIndex].Value.ToString();
            
            TextBox txtTeamName = (TextBox)row.FindControl("txtTeamName");
            TextBox txtChampionships = (TextBox)row.FindControl("txtChampionships");
            TextBox txtStars = (TextBox)row.FindControl("txtStars");
            TextBox txtCurrentStanding = (TextBox)row.FindControl("txtCurrentStanding");
            
            foreach (DataRow dataRow in teamsTable.Rows)
            {
                if (dataRow["TeamName"].ToString() == originalTeamName)
                {
                    // Update the values
                    dataRow["TeamName"] = txtTeamName.Text;
                    dataRow["Championships"] = txtChampionships.Text;
                    dataRow["Stars"] = txtStars.Text;
                    dataRow["CurrentStanding"] = txtCurrentStanding.Text;
                    break;
                }
            }
            
            teamsTable.AcceptChanges();
            
            Session["TeamsData"] = teamsTable;
            
            GridView1.EditIndex = -1;
            
            BindGrid();
            
            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage", "alert('הקבוצה עודכנה בהצלחה');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage", "alert('שגיאה בעדכון הקבוצה: " + ex.Message + "');", true);
        }
    }
    
    protected void SearchButton_Click(object sender, EventArgs e)
    {
        string teamName = SearchNameTextBox.Text.Trim();
        string minChampionships = MinChampionshipsTextBox.Text.Trim();
        
        try
        {
            DataTable filteredTable = teamsTable.Clone();
            
            foreach (DataRow row in teamsTable.Rows)
            {
                bool nameMatch = string.IsNullOrEmpty(teamName) || 
                                row["TeamName"].ToString().Contains(teamName);
                
                bool championshipsMatch = true;
                if (!string.IsNullOrEmpty(minChampionships))
                {
                    int minChamp;
                    if (int.TryParse(minChampionships, out minChamp))
                    {
                        int championships;
                        int.TryParse(row["Championships"].ToString(), out championships);
                        championshipsMatch = championships >= minChamp;
                    }
                }
                
                if (nameMatch && championshipsMatch)
                {
                    filteredTable.ImportRow(row);
                }
            }
            
            GridView1.DataSource = filteredTable;
            GridView1.DataBind();
            
            foreach (GridViewRow row in GridView1.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    Panel adminPanel = row.FindControl("AdminActionsPanel") as Panel;
                    if (adminPanel != null)
                    {
                        adminPanel.Visible = isAdmin;
                    }
                }
            }
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('שגיאה בחיפוש קבוצות');", true);
        }
    }

    protected void ClearButton_Click(object sender, EventArgs e)
    {
        SearchNameTextBox.Text = "";
        MinChampionshipsTextBox.Text = "";
        
        BindGrid();
    }
}