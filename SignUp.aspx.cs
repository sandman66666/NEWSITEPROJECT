using System;
using System.Web.UI;
using System.Text.RegularExpressions;
using System.Security.Cryptography;
using System.Text;

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

            // Validate form inputs
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(email))
            {
                ShowErrorMessage("יש למלא את כל השדות הנדרשים");
                return;
            }

            // Username validation - at least 3 characters, alphanumeric
            if (username.Length < 3 || !Regex.IsMatch(username, @"^[a-zA-Z0-9_]+$"))
            {
                ShowErrorMessage("שם המשתמש חייב להכיל לפחות 3 תווים ורק אותיות באנגלית, מספרים וקו תחתון");
                return;
            }

            // Password validation - at least 6 characters, one digit, one letter
            if (password.Length < 6 || !Regex.IsMatch(password, @"^(?=.*[A-Za-z])(?=.*\d).+$"))
            {
                ShowErrorMessage("הסיסמה חייבת להכיל לפחות 6 תווים, אות אחת ומספר אחד");
                return;
            }

            // Email validation
            if (!Regex.IsMatch(email, @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"))
            {
                ShowErrorMessage("כתובת האימייל אינה תקינה");
                return;
            }

            // Check if username already exists
            if (DatabaseHelper.UsernameExists(username))
            {
                ShowErrorMessage("שם המשתמש כבר קיים במערכת, אנא בחר שם אחר");
                return;
            }

            // Register the user
            if (DatabaseHelper.RegisterUser(username, password, email))
            {
                // Show success message
                ClientScript.RegisterStartupScript(this.GetType(), "RegistrationSuccess",
                    "alert('ההרשמה הושלמה בהצלחה!'); window.location='SignIn.aspx';", true);
            }
            else
            {
                ShowErrorMessage("אירעה שגיאה במהלך ההרשמה, אנא נסה שנית מאוחר יותר");
            }
        }

        private void ShowErrorMessage(string message)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ErrorMessage",
                "alert('" + message + "');", true);
        }
    }
}