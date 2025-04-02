using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NEWSITEPROJECT
{
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

                    ScriptManager.RegisterStartupScript(this, GetType(), "alertScript",
                        "alert('התנתקת בהצלחה');", true);

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

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ShowMessage("נא למלא שם משתמש וסיסמה");
                return;
            }

            if (DatabaseHelper.AuthenticateUser(username, password, out userRole))
            {
                Session["LoggedIn"] = true;
                Session["Username"] = username;
                Session["UserRole"] = userRole;

                ShowMessage("התחברת בהצלחה");
                Response.Redirect("Default.aspx");
            }
            else
            {
                ShowMessage("שם משתמש או סיסמה לא נכונים");
            }
        }

        private void ShowMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alertScript",
                string.Format("alert('{0}');", message), true);
        }
    }
}