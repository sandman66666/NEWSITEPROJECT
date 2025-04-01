<%@ Page Title="עריכת קבוצה" Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="NEWSITEPROJECT" %>

<script runat="server">
    private string mode = "add";
    private string teamName = "";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is admin
        if (Session["Username"] == null || (Session["UserRole"] != null && Session["UserRole"].ToString().ToLower() != "admin"))
        {
            // Redirect non-admin users
            Response.Redirect("TeamsTable.aspx");
            return;
        }
        
        // Get mode (add or edit)
        if (Request.QueryString["mode"] != null)
        {
            mode = Request.QueryString["mode"].ToLower();
            
            // Set page title based on mode
            if (mode == "add")
            {
                PageTitleLabel.Text = "הוספת קבוצה חדשה";
                SubmitButton.Text = "הוסף קבוצה";
            }
            else if (mode == "edit")
            {
                PageTitleLabel.Text = "עריכת קבוצה";
                SubmitButton.Text = "שמור שינויים";
                
                // Get team name for editing
                if (Request.QueryString["team"] != null)
                {
                    teamName = Request.QueryString["team"];
                }
                else
                {
                    // No team specified, redirect back to teams table
                    Response.Redirect("TeamsTable.aspx");
                }
            }
            else
            {
                // Invalid mode
                Response.Redirect("TeamsTable.aspx");
            }
        }
        else
        {
            // No mode specified, default to add
            mode = "add";
            PageTitleLabel.Text = "הוספת קבוצה חדשה";
            SubmitButton.Text = "הוסף קבוצה";
        }
        
        if (!IsPostBack)
        {
            // If editing, load team data
            if (mode == "edit" && !string.IsNullOrEmpty(teamName))
            {
                LoadTeamData(teamName);
            }
        }
    }
    
    private void LoadTeamData(string teamName)
    {
        // Get team data from database
        DataTable teams = DatabaseHelper.GetTeams();
        DataRow[] rows = teams.Select(string.Format("TeamName = '{0}'", teamName));
        
        if (rows.Length > 0)
        {
            // Populate form with team data
            TeamNameTextBox.Text = rows[0]["TeamName"].ToString();
            TeamNameTextBox.Enabled = false; // Can't change team name when editing
            ChampionshipsTextBox.Text = rows[0]["Championships"].ToString();
            StarsTextBox.Text = rows[0]["Stars"].ToString();
            CurrentStandingTextBox.Text = rows[0]["CurrentStanding"].ToString();
        }
        else
        {
            // Team not found
            ResultLabel.Text = "קבוצה לא נמצאה";
            ResultLabel.CssClass = "result-message error";
        }
    }
    
    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        try
        {
            string name = TeamNameTextBox.Text.Trim();
            string championships = ChampionshipsTextBox.Text.Trim();
            string stars = StarsTextBox.Text.Trim();
            string currentStanding = CurrentStandingTextBox.Text.Trim();
            
            // Validate input
            if (string.IsNullOrEmpty(name))
            {
                ResultLabel.Text = "נא להזין שם קבוצה";
                ResultLabel.CssClass = "result-message error";
                return;
            }
            
            // Check if championships is a number
            int champVal;
            if (!int.TryParse(championships, out champVal) || champVal < 0)
            {
                ResultLabel.Text = "מספר אליפויות חייב להיות מספר חיובי";
                ResultLabel.CssClass = "result-message error";
                return;
            }
            
            // Check if current standing is a number
            int standingVal;
            if (!int.TryParse(currentStanding, out standingVal) || standingVal < 0)
            {
                ResultLabel.Text = "דירוג נוכחי חייב להיות מספר חיובי";
                ResultLabel.CssClass = "result-message error";
                return;
            }
            
            bool success;
            if (mode == "add")
            {
                // Check if team already exists
                DataTable teams = DatabaseHelper.GetTeams();
                DataRow[] existingTeams = teams.Select(string.Format("TeamName = '{0}'", name));
                if (existingTeams.Length > 0)
                {
                    ResultLabel.Text = "קבוצה בשם זה כבר קיימת";
                    ResultLabel.CssClass = "result-message error";
                    return;
                }
                
                // Add new team
                success = DatabaseHelper.AddTeam(name, championships, stars, currentStanding);
                
                if (success)
                {
                    ResultLabel.Text = "הקבוצה נוספה בהצלחה";
                    ResultLabel.CssClass = "result-message success";
                    
                    // Clear form for adding another team
                    TeamNameTextBox.Text = "";
                    ChampionshipsTextBox.Text = "";
                    StarsTextBox.Text = "";
                    CurrentStandingTextBox.Text = "";
                }
                else
                {
                    ResultLabel.Text = "שגיאה בהוספת הקבוצה";
                    ResultLabel.CssClass = "result-message error";
                }
            }
            else // Edit mode
            {
                // Update existing team
                success = DatabaseHelper.UpdateTeam(name, championships, stars, currentStanding);
                
                if (success)
                {
                    ResultLabel.Text = "הקבוצה עודכנה בהצלחה";
                    ResultLabel.CssClass = "result-message success";
                }
                else
                {
                    ResultLabel.Text = "שגיאה בעדכון הקבוצה";
                    ResultLabel.CssClass = "result-message error";
                }
            }
        }
        catch (Exception ex)
        {
            ResultLabel.Text = "שגיאה: " + ex.Message;
            ResultLabel.CssClass = "result-message error";
        }
    }
    
    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("TeamsTable.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .edit-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .edit-title {
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .form-group {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        
        .form-control {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 100%;
            font-size: 16px;
        }
        
        .form-control:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.5);
        }
        
        .button-row {
            margin-top: 25px;
            text-align: center;
        }
        
        .submit-button {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
            transition: background-color 0.3s;
        }
        
        .submit-button:hover {
            background-color: #2980b9;
        }
        
        .cancel-button {
            background-color: #7f8c8d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .cancel-button:hover {
            background-color: #6c7a7d;
        }
        
        .result-message {
            margin-top: 20px;
            padding: 10px;
            border-radius: 4px;
            font-weight: bold;
            text-align: center;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div style="text-align: center; padding: 40px 20px; direction: rtl;">
        <div class="edit-container">
            <h2 class="edit-title"><asp:Label ID="PageTitleLabel" runat="server" Text="עריכת קבוצה"></asp:Label></h2>
            
            <div class="form-group">
                <label for="TeamNameTextBox">שם הקבוצה:</label>
                <asp:TextBox ID="TeamNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="TeamNameValidator" runat="server" 
                    ControlToValidate="TeamNameTextBox" 
                    ErrorMessage="שם קבוצה הוא שדה חובה" 
                    ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <label for="ChampionshipsTextBox">מספר אליפויות:</label>
                <asp:TextBox ID="ChampionshipsTextBox" runat="server" CssClass="form-control" type="number" min="0"></asp:TextBox>
                <asp:RegularExpressionValidator ID="ChampionshipsValidator" runat="server" 
                    ControlToValidate="ChampionshipsTextBox" 
                    ValidationExpression="^[0-9]+$"
                    ErrorMessage="יש להזין מספר חיובי" 
                    ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>
            
            <div class="form-group">
                <label for="StarsTextBox">כוכבים (שחקנים מובילים):</label>
                <asp:TextBox ID="StarsTextBox" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="CurrentStandingTextBox">דירוג נוכחי:</label>
                <asp:TextBox ID="CurrentStandingTextBox" runat="server" CssClass="form-control" type="number" min="0"></asp:TextBox>
                <asp:RegularExpressionValidator ID="CurrentStandingValidator" runat="server" 
                    ControlToValidate="CurrentStandingTextBox" 
                    ValidationExpression="^[0-9]+$"
                    ErrorMessage="יש להזין מספר חיובי" 
                    ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>
            
            <div class="button-row">
                <asp:Button ID="SubmitButton" runat="server" Text="שמור" 
                    OnClick="SubmitButton_Click" CssClass="submit-button" />
                
                <asp:Button ID="CancelButton" runat="server" Text="ביטול" 
                    OnClick="CancelButton_Click" CssClass="cancel-button" CausesValidation="false" />
            </div>
            
            <asp:Label ID="ResultLabel" runat="server" CssClass="result-message"></asp:Label>
        </div>
    </div>
</asp:Content>
