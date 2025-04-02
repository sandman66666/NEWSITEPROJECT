<%@ Page Title="מחיקת קבוצה" Language="C#" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .delete-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border: 1px solid #ddd;
            text-align: center;
        }
        
        .warning-icon {
            color: #e74c3c;
            font-size: 48px;
            margin-bottom: 20px;
        }
        
        .delete-title {
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
        }
        
        .delete-message {
            font-size: 18px;
            margin-bottom: 30px;
        }
        
        .team-name {
            font-weight: bold;
            color: #e74c3c;
        }
        
        .button-container {
            margin-top: 30px;
        }
        
        .delete-button, .cancel-button {
            padding: 10px 20px;
            margin: 0 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .delete-button {
            background-color: #e74c3c;
            color: white;
        }
        
        .cancel-button {
            background-color: #3498db;
            color: white;
        }
        
        .result-message {
            padding: 10px;
            margin-top: 20px;
            border-radius: 4px;
        }
        
        .success {
            background-color: #2ecc71;
            color: white;
        }
        
        .error {
            background-color: #e74c3c;
            color: white;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="delete-container">
        <div class="warning-icon">⚠️</div>
        <h2 class="delete-title">מחיקת קבוצה</h2>
        
        <p class="delete-message">
            האם אתה בטוח שברצונך למחוק את הקבוצה 
            <span class="team-name"><asp:Label ID="TeamNameLabel" runat="server"></asp:Label></span>?
            <br />
            פעולה זו לא ניתנת לביטול.
        </p>
        
        <asp:Label ID="ResultLabel" runat="server" Visible="false"></asp:Label>
        
        <div class="button-container">
            <asp:Button ID="ConfirmButton" runat="server" Text="כן, מחק את הקבוצה" 
                       CssClass="delete-button" OnClick="ConfirmButton_Click" />
            <asp:Button ID="CancelButton" runat="server" Text="ביטול" 
                       CssClass="cancel-button" OnClick="CancelButton_Click" />
        </div>
    </div>

    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string teamName = Request.QueryString["team"];
                
                if (Session["UserRole"] == null || Session["UserRole"].ToString().ToLower() != "admin")
                {
                    Response.Redirect("TeamsTable.aspx");
                    return;
                }
                
                if (!string.IsNullOrEmpty(teamName))
                {
                    TeamNameLabel.Text = teamName;
                }
                else
                {
                    Response.Redirect("TeamsTable.aspx");
                }
            }
        }
        
        protected void ConfirmButton_Click(object sender, EventArgs e)
        {
            string teamName = Request.QueryString["team"];
            if (!string.IsNullOrEmpty(teamName))
            {
                try
                {
                    string teamsXmlPath = Server.MapPath("~/App_Data/Teams.xml");
                    
                    if (System.IO.File.Exists(teamsXmlPath))
                    {
                        System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                        doc.Load(teamsXmlPath);
                        
                        System.Xml.XmlNode teamNode = doc.SelectSingleNode("//Team[TeamName='" + teamName + "']");
                        
                        if (teamNode != null && teamNode.ParentNode != null)
                        {
                            teamNode.ParentNode.RemoveChild(teamNode);
                            doc.Save(teamsXmlPath);
                            
                            ResultLabel.Text = "הקבוצה " + teamName + " נמחקה בהצלחה";
                            ResultLabel.CssClass = "result-message success";
                            ResultLabel.Visible = true;
                            ConfirmButton.Visible = false;
                            CancelButton.Text = "חזרה לרשימת הקבוצות";
                        }
                        else
                        {
                            ResultLabel.Text = "הקבוצה לא נמצאה";
                            ResultLabel.CssClass = "result-message error";
                            ResultLabel.Visible = true;
                        }
                    }
                    else
                    {
                        ResultLabel.Text = "קובץ הקבוצות לא נמצא";
                        ResultLabel.CssClass = "result-message error";
                        ResultLabel.Visible = true;
                    }
                }
                catch (System.Exception ex)
                {
                    ResultLabel.Text = "שגיאה: " + ex.Message;
                    ResultLabel.CssClass = "result-message error";
                    ResultLabel.Visible = true;
                }
            }
        }
        
        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("TeamsTable.aspx");
        }
    </script>
</asp:Content>
