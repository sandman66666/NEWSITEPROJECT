using System;
using System.Web.UI;
using NEWSITEPROJECT; // Make sure this namespace is included

namespace NEWSITEPROJECT
{
    public partial class SignUp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["LoggedIn"] != null && (bool)Session["LoggedIn"] == true)
                {
                    Response.Redirect("Default.aspx");
                }
            }
        }

        protected void SignUpButton_Click(object sender, EventArgs e)
        {
            string username = UserNameTextBox.Text.Trim();
            string password = PasswordTextBox.Text.Trim();
            string email = EmailTextBox.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                Response.Write("<script>alert('Please fill in all required fields');</script>");
                return;
            }

            // Using the fully qualified name with namespace
            if (NEWSITEPROJECT.DatabaseHelper.UsernameExists(username))
            {
                Response.Write("<script>alert('Username already exists, please choose another one');</script>");
                return;
            }

            if (NEWSITEPROJECT.DatabaseHelper.RegisterUser(username, password, email))
            {
                Response.Write("<script>alert('Registration completed successfully!');</script>");
                Response.Redirect("SignIn.aspx");
            }
            else
            {
                Response.Write("<script>alert('An error occurred during registration, please try again');</script>");
            }
        }
    }
}