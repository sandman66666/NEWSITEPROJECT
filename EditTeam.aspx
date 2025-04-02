<%@ Page Title="עריכת קבוצה" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    string mode = "add";
    string teamName = "";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserRole"] == null || Session["UserRole"].ToString().ToLower() != "admin")
        {
            Response.Redirect("TeamsTable.aspx");
            return;
        }
        
        if (Request.QueryString["mode"] != null)
        {
            mode = Request.QueryString["mode"];
        }
        
        if (mode == "edit" && Request.QueryString["team"] != null)
        {
            teamName = Request.QueryString["team"];
            PageTitle.Text = "עריכת קבוצה: " + teamName;
            SubmitButton.Text = "עדכן קבוצה";
            
            if (!IsPostBack)
            {
                LoadTeamData();
            }
        }
        else
        {
            PageTitle.Text = "הוספת קבוצה חדשה";
            SubmitButton.Text = "הוסף קבוצה";
        }
    }
    
    private void LoadTeamData()
    {
        string teamsXmlPath = Server.MapPath("~/App_Data/Teams.xml");
        
        if (System.IO.File.Exists(teamsXmlPath))
        {
            System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
            doc.Load(teamsXmlPath);
            
            System.Xml.XmlNode teamNode = doc.SelectSingleNode("//Team[TeamName='" + teamName + "']");
            
            if (teamNode != null)
            {
                System.Xml.XmlNode nameNode = teamNode.SelectSingleNode("TeamName");
                if (nameNode != null)
                {
                    TeamNameTextBox.Text = nameNode.InnerText;
                }
                
                System.Xml.XmlNode champsNode = teamNode.SelectSingleNode("Championships");
                if (champsNode != null)
                {
                    ChampionshipsTextBox.Text = champsNode.InnerText;
                }
                
                System.Xml.XmlNode starsNode = teamNode.SelectSingleNode("Stars");
                if (starsNode != null)
                {
                    StarsTextBox.Text = starsNode.InnerText;
                }
                
                System.Xml.XmlNode standingNode = teamNode.SelectSingleNode("CurrentStanding");
                if (standingNode != null)
                {
                    CurrentStandingTextBox.Text = standingNode.InnerText;
                }
            }
        }
    }
    
    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        string newTeamName = TeamNameTextBox.Text.Trim();
        string championships = ChampionshipsTextBox.Text.Trim();
        string stars = StarsTextBox.Text.Trim();
        string currentStanding = CurrentStandingTextBox.Text.Trim();
        
        if (string.IsNullOrEmpty(newTeamName))
        {
            ErrorLabel.Text = "חובה למלא את שם הקבוצה";
            ErrorLabel.Visible = true;
            return;
        }
        
        try
        {
            string teamsXmlPath = Server.MapPath("~/App_Data/Teams.xml");
            System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
            
            if (System.IO.File.Exists(teamsXmlPath))
            {
                doc.Load(teamsXmlPath);
            }
            else
            {
                System.Xml.XmlElement root = doc.CreateElement("Teams");
                doc.AppendChild(root);
            }
            
            if (mode == "edit")
            {
                System.Xml.XmlNode existingTeam = doc.SelectSingleNode("//Team[TeamName='" + teamName + "']");
                if (existingTeam != null && existingTeam.ParentNode != null)
                {
                    existingTeam.ParentNode.RemoveChild(existingTeam);
                }
            }
            else
            {
                System.Xml.XmlNode existingTeam = doc.SelectSingleNode("//Team[TeamName='" + newTeamName + "']");
                if (existingTeam != null)
                {
                    ErrorLabel.Text = "קבוצה בשם זה כבר קיימת";
                    ErrorLabel.Visible = true;
                    return;
                }
            }
            
            System.Xml.XmlElement teamElement = doc.CreateElement("Team");
            
            System.Xml.XmlElement nameElement = doc.CreateElement("TeamName");
            nameElement.InnerText = newTeamName;
            teamElement.AppendChild(nameElement);
            
            System.Xml.XmlElement champsElement = doc.CreateElement("Championships");
            champsElement.InnerText = championships;
            teamElement.AppendChild(champsElement);
            
            System.Xml.XmlElement starsElement = doc.CreateElement("Stars");
            starsElement.InnerText = stars;
            teamElement.AppendChild(starsElement);
            
            System.Xml.XmlElement standingElement = doc.CreateElement("CurrentStanding");
            standingElement.InnerText = currentStanding;
            teamElement.AppendChild(standingElement);
            
            doc.DocumentElement.AppendChild(teamElement);
            doc.Save(teamsXmlPath);
            
            Response.Redirect("TeamsTable.aspx");
        }
        catch (System.Exception ex)
        {
            ErrorLabel.Text = "שגיאה בשמירת הקבוצה: " + ex.Message;
            ErrorLabel.Visible = true;
        }
    }
    
    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("TeamsTable.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .form-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border: 1px solid #ddd;
        }
        .form-group {
            margin-bottom: 15px;
            direction: rtl;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
        }
        .button-group {
            text-align: center;
            margin-top: 20px;
        }
        .submit-btn {
            background-color: #4CAF50;
            color: white;
            padding: 8px 20px;
            border: none;
            cursor: pointer;
            margin-right: 10px;
        }
        .cancel-btn {
            background-color: #f44336;
            color: white;
            padding: 8px 20px;
            border: none;
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="form-container">
        <asp:Label ID="PageTitle" runat="server" Text="עריכת קבוצה" 
                 Style="display: block; font-size: 24px; color: #333; text-align: center; margin-bottom: 20px;"></asp:Label>
        
        <asp:Label ID="ErrorLabel" runat="server" ForeColor="Red" Visible="false" 
                 Style="display: block; text-align: center; margin-bottom: 15px;"></asp:Label>
        
        <div class="form-group">
            <asp:Label ID="TeamNameLabel" runat="server" Text="שם הקבוצה:"></asp:Label>
            <asp:TextBox ID="TeamNameTextBox" runat="server"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <asp:Label ID="ChampionshipsLabel" runat="server" Text="מספר אליפויות:"></asp:Label>
            <asp:TextBox ID="ChampionshipsTextBox" runat="server"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <asp:Label ID="StarsLabel" runat="server" Text="כוכבים:"></asp:Label>
            <asp:TextBox ID="StarsTextBox" runat="server"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <asp:Label ID="CurrentStandingLabel" runat="server" Text="דירוג נוכחי:"></asp:Label>
            <asp:TextBox ID="CurrentStandingTextBox" runat="server"></asp:TextBox>
        </div>
        
        <div class="button-group">
            <asp:Button ID="SubmitButton" runat="server" Text="שמור" 
                      CssClass="submit-btn" OnClick="SubmitButton_Click" />
            <asp:Button ID="CancelButton" runat="server" Text="ביטול" 
                      CssClass="cancel-btn" OnClick="CancelButton_Click" CausesValidation="false" />
        </div>
    </div>
</asp:Content>
