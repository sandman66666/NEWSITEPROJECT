using System;

public partial class SignIn : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["logout"] != null && Request.QueryString["logout"] == "true")
            {
                Session.Clear();
                Session.Abandon();
                
                Response.Write("<script>alert('התנתקת בהצלחה!');</script>");
                
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
        
        if (DatabaseHelper.AuthenticateUser(username, password, out userRole))
        {
            Session["LoggedIn"] = true;
            Session["Username"] = username;
            Session["UserRole"] = userRole;
            
            Response.Write("<script>alert('התחברת בהצלחה!');</script>");
            Response.Redirect("Default.aspx");
        }
        else
        {
            Response.Write("<script>alert('שם משתמש או סיסמה שגויים');</script>");
        }
    }
}