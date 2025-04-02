<%@ Page Title="התחברות" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["logout"] != null && Request.QueryString["logout"] == "true")
            {
                Session.Clear();
                Session.Abandon();
                
                ResultLabel.Text = "התנתקת בהצלחה";
                ResultLabel.CssClass = "result-message success";
                ResultLabel.Visible = true;
                return;
            }

            if (Session["LoggedIn"] != null && (bool)Session["LoggedIn"] == true)
            {
                Response.Redirect("Default.aspx");
            }
        }
    }

    protected void SignInButton_Click(object sender, EventArgs e)
    {
        string username = UserNameTextBox.Text.Trim();
        string password = PasswordTextBox.Text.Trim();

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            ShowMessage("נא למלא שם משתמש וסיסמה", false);
            return;
        }

        try
        {
            bool isAuthenticated = false;
            string userRole = "";
            
            if (username == "eli" && password == "eli") 
            {
                isAuthenticated = true;
                userRole = "admin";
            }
            
            if (username == "oudi" && password == "5040")
            {
                isAuthenticated = true;
                userRole = "user";
            }
            
            if (isAuthenticated)
            {
                Session["LoggedIn"] = true;
                Session["Username"] = username;
                Session["UserRole"] = userRole;

                ShowMessage("התחברת בהצלחה", true);
                
                string script = "setTimeout(function() { window.location = 'Default.aspx'; }, 1500);";
                ScriptManager.RegisterStartupScript(this, GetType(), "RedirectScript", script, true);
            }
            else
            {
                ShowMessage("שם משתמש או סיסמה לא נכונים", false);
            }
        }
        catch
        {
            ShowMessage("שגיאה בהתחברות", false);
        }
    }

    private void ShowMessage(string message, bool isSuccess)
    {
        ResultLabel.Text = message;
        ResultLabel.CssClass = isSuccess ? "result-message success" : "result-message error";
        ResultLabel.Visible = true;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style>
    .login-container {
        margin: 40px auto;
        max-width: 450px;
        background: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    }
    .form-group {
        margin-bottom: 20px;
        text-align: right;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
        color: #555;
    }
    .form-control {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
        font-size: 16px;
    }
    .form-control:focus {
        border-color: #4CAF50;
        outline: none;
        box-shadow: 0 0 5px rgba(76, 175, 80, 0.3);
    }
    .login-btn {
        background-color: #4CAF50;
        color: white;
        padding: 12px 30px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
        width: 100%;
        margin-top: 10px;
    }
    .login-btn:hover {
        background-color: #45a049;
    }
    .signup-link {
        text-align: center;
        margin-top: 20px;
    }
    .signup-link a {
        color: #4CAF50;
        text-decoration: none;
    }
    .signup-link a:hover {
        text-decoration: underline;
    }
    h2 {
        color: #2c3e50;
        font-size: 28px;
        margin-bottom: 30px;
        text-align: center;
    }
    .result-message {
        margin-top: 20px;
        padding: 10px;
        border-radius: 4px;
        text-align: center;
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
    <div class="login-container">
        <h2>התחברות</h2>
        
        <div class="form-group">
            <asp:Label ID="UserNameLabel" runat="server" Text="שם משתמש:"></asp:Label>
            <asp:TextBox ID="UserNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
            <asp:RequiredFieldValidator ID="UserNameValidator" runat="server" 
                ControlToValidate="UserNameTextBox" 
                ErrorMessage="שם משתמש הוא שדה חובה" 
                ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>
        
        <div class="form-group">
            <asp:Label ID="PasswordLabel" runat="server" Text="סיסמה:"></asp:Label>
            <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
            <asp:RequiredFieldValidator ID="PasswordValidator" runat="server" 
                ControlToValidate="PasswordTextBox" 
                ErrorMessage="סיסמה היא שדה חובה" 
                ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>
        
        <asp:Button ID="SignInButton" runat="server" Text="התחבר" CssClass="login-btn" OnClick="SignInButton_Click" />
        
        <div style="margin-top: 15px; padding: 10px; background-color: #f0f0f0; border: 1px solid #ddd; border-radius: 4px; text-align: center;">
            <h4 style="margin-top: 0; color: #4CAF50;">פרטי התחברות לדוגמה</h4>
            <p><strong>מנהל:</strong> שם משתמש: eli, סיסמה: eli</p>
            <p><strong>משתמש רגיל:</strong> שם משתמש: oudi, סיסמה: 5040</p>
            <p>או <a href="SignUp.aspx">צור חשבון חדש</a></p>
        </div>
        
        <asp:Label ID="ResultLabel" runat="server" CssClass="result-message" Visible="false"></asp:Label>
        
        <div class="signup-link">
            <p>אין לך חשבון? <a href="SignUp.aspx">הירשם כאן</a></p>
        </div>
    </div>
</asp:Content>