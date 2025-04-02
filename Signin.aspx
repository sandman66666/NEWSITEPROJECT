<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["logout"] != null && Request.QueryString["logout"] == "true")
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("Signin.aspx");
                return;
            }
            
            if (Session["LoggedIn"] != null && (bool)Session["LoggedIn"] == true)
            {
                Response.Redirect("Default.aspx");
            }
            
            ErrorLabel.Visible = false;
        }
    }
    
    protected void LoginButton_Click(object sender, EventArgs e)
    {
        string username = UserNameTextBox.Text.Trim();
        string password = PasswordTextBox.Text.Trim();
        
        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            ErrorLabel.Text = "יש למלא שם משתמש וסיסמה";
            ErrorLabel.Visible = true;
            return;
        }
        
        bool authenticated = false;
        string userRole = "user";
        
        if (username == "eli" && password == "eli")
        {
            authenticated = true;
            userRole = "admin";
        }
        else if (username == "oudi" && password == "5040")
        {
            authenticated = true;
            userRole = "user";
        }
        
        if (authenticated)
        {
            Session["LoggedIn"] = true;
            Session["Username"] = username;
            Session["UserRole"] = userRole;
            
            Response.Redirect("Default.aspx");
        }
        else
        {
            ErrorLabel.Text = "שם משתמש או סיסמה שגויים";
            ErrorLabel.Visible = true;
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .login-container {
            max-width: 400px;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        .form-title {
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        
        .btn-login {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 15px;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        
        .hint-text {
            text-align: center;
            margin-top: 15px;
            color: #666;
            font-size: 0.9em;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="login-container">
        <h2 class="form-title">התחברות למערכת</h2>
        
        <asp:Label ID="ErrorLabel" runat="server" CssClass="error-message" Visible="false"></asp:Label>
        
        <div class="form-group">
            <label for="UserNameTextBox">שם משתמש:</label>
            <asp:TextBox ID="UserNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label for="PasswordTextBox">סיסמה:</label>
            <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <asp:Button ID="LoginButton" runat="server" Text="התחברות" CssClass="btn-login" OnClick="LoginButton_Click" />
        </div>
        
        <div class="hint-text">
            <p>ניתן להתחבר עם:</p>
            <p>שם משתמש: eli, סיסמה: eli (מנהל)</p>
            <p>שם משתמש: oudi, סיסמה: 5040 (משתמש)</p>
        </div>
    </div>
</asp:Content>