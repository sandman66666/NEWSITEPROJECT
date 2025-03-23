using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        bool isLoggedIn = (Session["LoggedIn"] != null && (bool)Session["LoggedIn"]);
        
        if (isLoggedIn)
        {
            string username = Session["Username"] != null ? Session["Username"].ToString() : "";
            string role = Session["UserRole"] != null ? Session["UserRole"].ToString() : "";
            
            UserInfoLabel.Text = "שלום, " + username;
            
            if (role == "admin")
            {
                UserInfoLabel.Text += " (מנהל) ";
            }
            
            UserInfoLabel.Text += " | <a href='SignIn.aspx?logout=true' style='color: white;'>התנתק</a>";
            UserInfoLabel.Visible = true;
            
            authLinks.Visible = false;
        }
        else
        {
            UserInfoLabel.Visible = false;
            authLinks.Visible = true;
            
            string currentPage = System.IO.Path.GetFileName(Request.Path);
            
            if (!currentPage.Equals("SignIn.aspx", StringComparison.OrdinalIgnoreCase) && 
                !currentPage.Equals("SignUp.aspx", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("SignIn.aspx");
            }
        }
    }
}