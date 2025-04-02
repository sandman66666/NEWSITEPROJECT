<%@ Page Title="הרשמה" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void SignUpButton_Click(object sender, EventArgs e)
    {
        string username = UserNameTextBox.Text;
        string password = PasswordTextBox.Text;
        string email = EmailTextBox.Text;
        
        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(email))
        {
            ErrorLabel.Text = "יש למלא את כל השדות";
            ErrorLabel.Visible = true;
            return;
        }
        
        try
        {
            string usersXmlPath = Server.MapPath("~/App_Data/Users.xml");
            
            System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
            if (System.IO.File.Exists(usersXmlPath))
            {
                doc.Load(usersXmlPath);
            }
            else
            {
                System.Xml.XmlElement root = doc.CreateElement("Users");
                doc.AppendChild(root);
            }

            System.Xml.XmlNode existingUser = doc.SelectSingleNode("//User[Username='" + username + "']");
            if (existingUser != null)
            {
                ErrorLabel.Text = "שם משתמש כבר קיים במערכת";
                ErrorLabel.Visible = true;
                return;
            }

            System.Xml.XmlElement userElement = doc.CreateElement("User");
            
            System.Xml.XmlElement usernameElement = doc.CreateElement("Username");
            usernameElement.InnerText = username;
            userElement.AppendChild(usernameElement);
            
            System.Xml.XmlElement passwordElement = doc.CreateElement("Password");
            passwordElement.InnerText = password; // Simple plain text password for first-year student level
            userElement.AppendChild(passwordElement);
            
            System.Xml.XmlElement emailElement = doc.CreateElement("Email");
            emailElement.InnerText = email;
            userElement.AppendChild(emailElement);
            
            System.Xml.XmlElement roleElement = doc.CreateElement("UserRole");
            roleElement.InnerText = "user"; // Default role is 'user'
            userElement.AppendChild(roleElement);
            
            doc.DocumentElement.AppendChild(userElement);
            doc.Save(usersXmlPath);
            
            Response.Redirect("SignIn.aspx");
        }
        catch (System.Exception ex)
        {
            ErrorLabel.Text = "שגיאה בהרשמה: " + ex.Message;
            ErrorLabel.Visible = true;
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .register-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            direction: rtl;
        }
        
        .form-title {
            font-size: 24px;
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
        
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .btn-signup {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 0;
            width: 100%;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
        
        .btn-signup:hover {
            background-color: #45a049;
        }
        
        .error-message {
            color: #e74c3c;
            background-color: #fadbd8;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
            text-align: center;
        }
        
        .login-link {
            text-align: center;
            margin-top: 15px;
        }
        
        .login-link a {
            color: #3498db;
            text-decoration: none;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="register-container">
        <h2 class="form-title">הרשמה</h2>
        
        <asp:Label ID="ErrorLabel" runat="server" CssClass="error-message" Visible="false"></asp:Label>
        
        <div class="form-group">
            <asp:Label ID="UserNameLabel" runat="server" Text="שם משתמש:"></asp:Label>
            <asp:TextBox ID="UserNameTextBox" runat="server"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <asp:Label ID="PasswordLabel" runat="server" Text="סיסמה:"></asp:Label>
            <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <asp:Label ID="EmailLabel" runat="server" Text="דואר אלקטרוני:"></asp:Label>
            <asp:TextBox ID="EmailTextBox" runat="server"></asp:TextBox>
        </div>
        
        <asp:Button ID="SignUpButton" runat="server" Text="הירשם" 
                    CssClass="btn-signup" OnClick="SignUpButton_Click" />
        
        <div class="login-link">
            <asp:HyperLink ID="LoginLink" runat="server" NavigateUrl="~/SignIn.aspx">
                כבר יש לך חשבון? התחבר כאן
            </asp:HyperLink>
        </div>
    </div>
</asp:Content>