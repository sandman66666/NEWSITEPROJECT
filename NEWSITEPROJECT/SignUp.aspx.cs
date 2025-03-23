using System;

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
            Response.Write("<script>alert('אנא מלא את כל השדות הנדרשים');</script>");
            return;
        }

        if (DatabaseHelper.UsernameExists(username))
        {
            Response.Write("<script>alert('שם המשתמש כבר קיים במערכת, אנא בחר שם אחר');</script>");
            return;
        }

        if (DatabaseHelper.RegisterUser(username, password))
        {
            Response.Write("<script>alert('ההרשמה בוצעה בהצלחה!');</script>");
            Response.Redirect("SignIn.aspx");
        }
        else
        {
            Response.Write("<script>alert('אירעה שגיאה בתהליך ההרשמה, אנא נסה שנית');</script>");
        }
    }
}