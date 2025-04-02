<%@ Page Title="מחיקת קבוצה" Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string teamName = Request.QueryString["team"];
            
            if (Session["Username"] == null || (Session["UserRole"] != null && Session["UserRole"].ToString().ToLower() != "admin"))
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
                bool success = DatabaseHelper.DeleteTeam(teamName);
                if (success)
                {
                    ResultLabel.Text = "הקבוצה " + teamName + " נמחקה בהצלחה";
                    ResultLabel.CssClass = "result-message success";
                    ConfirmButton.Visible = false;
                    CancelButton.Text = "חזרה לרשימת הקבוצות";
                }
                else
                {
                    ResultLabel.Text = "שגיאה במחיקת הקבוצה";
                    ResultLabel.CssClass = "result-message error";
                }
            }
            catch (Exception ex)
            {
                ResultLabel.Text = "שגיאה: " + ex.Message;
                ResultLabel.CssClass = "result-message error";
            }
        }
    }
    
    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("TeamsTable.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .delete-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
            color: #555;
            font-size: 16px;
            margin-bottom: 30px;
            line-height: 1.5;
        }
        
        .team-name {
            font-weight: bold;
            color: #e74c3c;
        }
        
        .delete-button {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
            transition: background-color 0.3s;
        }
        
        .delete-button:hover {
            background-color: #c0392b;
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
    <div style="text-align: center; padding: 40px 20px;">
        <div class="delete-container">
            <div class="warning-icon">⚠️</div>
            <h2 class="delete-title">מחיקת קבוצה</h2>
            
            <p class="delete-message">
                האם אתה בטוח שברצונך למחוק את הקבוצה <asp:Label ID="TeamNameLabel" runat="server" CssClass="team-name"></asp:Label>?
                <br />
                פעולה זו אינה ניתנת לביטול.
            </p>
            
            <div>
                <asp:Button ID="ConfirmButton" runat="server" Text="כן, מחק את הקבוצה" 
                    OnClick="ConfirmButton_Click" CssClass="delete-button" />
                
                <asp:Button ID="CancelButton" runat="server" Text="ביטול" 
                    OnClick="CancelButton_Click" CssClass="cancel-button" />
            </div>
            
            <asp:Label ID="ResultLabel" runat="server" CssClass="result-message"></asp:Label>
        </div>
    </div>
</asp:Content>