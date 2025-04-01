<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ Import Namespace="System.Web.UI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["logout"] != null && Request.QueryString["logout"] == "true")
            {
                Session.Clear();
                Session.Abandon();
                ScriptManager.RegisterStartupScript(this, GetType(), "alertScript", "alert('Logged out successfully!');", true);
                Response.Redirect("SignIn.aspx", true);
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
        string userRole = "";

        // Use the unqualified name since there's only one accessible version in this context
        if (DatabaseHelper.AuthenticateUser(username, password, out userRole))
        {
            Session["LoggedIn"] = true;
            Session["Username"] = username;
            Session["UserRole"] = userRole;

            ScriptManager.RegisterStartupScript(this, GetType(), "alertScript", "alert('Logged in successfully!');", true);
            Response.Redirect("Default.aspx");
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alertScript", "alert('Invalid username or password');", true);
        }
    }
</script>
<style>
    body {
        font-family: Arial, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        background-color: #f5f5f5;
    }
    .login-container {
        background-color: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        width: 350px;
    }
    .form-group {
        margin-bottom: 15px;
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
        border-radius: 4px;
        box-sizing: border-box;
    }
    .login-btn {
        background-color: #4CAF50;
        color: white;
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        width: 100%;
        font-size: 16px;
    }
    .login-btn:hover {
        background-color: #45a049;
    }
    .signup-link {
        text-align: center;
        margin-top: 15px;
    }
    .signup-link a {
        color: #4CAF50;
        text-decoration: none;
    }
    .signup-link a:hover {
        text-decoration: underline;
    }
    h2 {
        text-align: center;
        color: #333;
        margin-bottom: 20px;
    }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="login-container">
        <h2>Sign In</h2>
        <div class="form-group">
            <asp:Label ID="UserNameLabel" runat="server" Text="Username:"></asp:Label>
            <asp:TextBox ID="UserNameTextBox" runat="server"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Label ID="PasswordLabel" runat="server" Text="Password:"></asp:Label>
            <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password"></asp:TextBox>
        </div>
        <asp:Button ID="SignInButton" runat="server" Text="Sign In" CssClass="login-btn" OnClick="SignInButton_Click" />
        <div class="signup-link">
            <p>Don't have an account? <a href="SignUp.aspx">Sign Up</a></p>
        </div>
    </div>
</asp:Content>