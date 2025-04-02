<%@ Page Title="הרשמה" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            UserNameTextBox.Text = "";
            PasswordTextBox.Text = "";
            EmailTextBox.Text = "";
        }
    }

    protected void SignUpButton_Click(object sender, EventArgs e)
    {
        string username = UserNameTextBox.Text.Trim();
        string password = PasswordTextBox.Text.Trim();
        string email = EmailTextBox.Text.Trim();

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(email))
        {
            ShowMessage("יש למלא את כל השדות");
            return;
        }

        if (username.Length < 3)
        {
            ShowMessage("שם המשתמש צריך להכיל לפחות 3 תווים");
            return;
        }

        if (password.Length < 6)
        {
            ShowMessage("הסיסמה צריכה להכיל לפחות 6 תווים");
            return;
        }

        if (!email.Contains("@") || !email.Contains("."))
        {
            ShowMessage("כתובת אימייל לא חוקית");
            return;
        }

        try
        {
            if (DatabaseHelper.UsernameExists(username))
            {
                ShowMessage("שם המשתמש כבר קיים במערכת, נא לבחור שם אחר");
                return;
            }

            if (DatabaseHelper.RegisterUser(username, password, email))
            {
                ShowMessage("ההרשמה הושלמה בהצלחה!", true);
                
                string script = "setTimeout(function() { window.location = 'SignIn.aspx'; }, 2000);";
                ScriptManager.RegisterStartupScript(this, GetType(), "RedirectScript", script, true);
            }
            else
            {
                ShowMessage("אירעה שגיאה במהלך ההרשמה, נא לנסות שוב מאוחר יותר");
            }
        }
        catch (Exception ex)
        {
            ShowMessage("אירעה שגיאה: " + ex.Message);
        }
    }

    private void ShowMessage(string message, bool isSuccess = false)
    {
        ResultLabel.Text = message;
        
        ResultLabel.CssClass = isSuccess ? "result-message success" : "result-message error";
        
        ResultLabel.Visible = true;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .signup-container {
            max-width: 500px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        .page-title {
            color: #2c3e50;
            font-size: 28px;
            margin-bottom: 30px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
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
        .btn-signup {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            margin-top: 10px;
        }
        .btn-signup:hover {
            background-color: #45a049;
        }
        .result-message {
            margin-top: 20px;
            padding: 10px;
            border-radius: 4px;
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
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        .login-link a {
            color: #4CAF50;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="signup-container">
        <h2 class="page-title">הרשמה לאתר</h2>
        
        <div class="form-group">
            <label for="UserNameTextBox">שם משתמש:</label>
            <asp:TextBox ID="UserNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
            <asp:RequiredFieldValidator ID="UserNameValidator" runat="server" 
                ControlToValidate="UserNameTextBox" 
                ErrorMessage="שם משתמש הוא שדה חובה" 
                ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>
        
        <div class="form-group">
            <label for="PasswordTextBox">סיסמה:</label>
            <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
            <asp:RequiredFieldValidator ID="PasswordValidator" runat="server" 
                ControlToValidate="PasswordTextBox" 
                ErrorMessage="סיסמה היא שדה חובה" 
                ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>
        
        <div class="form-group">
            <label for="EmailTextBox">אימייל:</label>
            <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control"></asp:TextBox>
            <asp:RequiredFieldValidator ID="EmailValidator" runat="server" 
                ControlToValidate="EmailTextBox" 
                ErrorMessage="אימייל הוא שדה חובה" 
                ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="EmailFormatValidator" runat="server" 
                ControlToValidate="EmailTextBox" 
                ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" 
                ErrorMessage="כתובת אימייל לא חוקית" 
                ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
        </div>
        
        <asp:Button ID="SignUpButton" runat="server" Text="הרשמה" 
                     OnClick="SignUpButton_Click" CssClass="btn-signup" />
        
        <asp:Label ID="ResultLabel" runat="server" CssClass="result-message" Visible="false"></asp:Label>
        
        <div class="login-link">
            <p>כבר רשום? <a href="SignIn.aspx">התחבר כאן</a></p>
        </div>
    </div>
</asp:Content>