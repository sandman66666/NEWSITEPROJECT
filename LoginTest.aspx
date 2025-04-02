<%@ Page Language="C#" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.IO" %>

<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Check if App_Data directory exists
            string appDataPath = Server.MapPath("~/App_Data");
            DirectoryInfo.Text = "App_Data path: " + appDataPath;
            
            if (Directory.Exists(appDataPath))
            {
                DirectoryInfo.Text += "<br>Directory exists";
                
                // Check if Users.xml exists
                string usersXmlPath = Path.Combine(appDataPath, "Users.xml");
                if (File.Exists(usersXmlPath))
                {
                    DirectoryInfo.Text += "<br>Users.xml exists";
                    
                    try
                    {
                        XmlDocument doc = new XmlDocument();
                        doc.Load(usersXmlPath);
                        XmlNodeList users = doc.SelectNodes("//User");
                        
                        DirectoryInfo.Text += "<br>Users found: " + users.Count;
                        
                        foreach (XmlNode user in users)
                        {
                            XmlNode usernameNode = user.SelectSingleNode("Username");
                            XmlNode roleNode = user.SelectSingleNode("UserRole");
                            
                            if (usernameNode != null)
                            {
                                DirectoryInfo.Text += "<br>- User: " + usernameNode.InnerText;
                                if (roleNode != null)
                                {
                                    DirectoryInfo.Text += " (Role: " + roleNode.InnerText + ")";
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        DirectoryInfo.Text += "<br>Error loading XML: " + ex.Message;
                    }
                }
                else
                {
                    DirectoryInfo.Text += "<br>Users.xml does not exist";
                }
            }
            else
            {
                DirectoryInfo.Text += "<br>Directory does not exist";
            }
        }
    }
    
    protected void TestButton_Click(object sender, EventArgs e)
    {
        string username = UserNameTextBox.Text.Trim();
        string password = PasswordTextBox.Text.Trim();
        
        ResultPanel.Visible = true;
        
        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            ResultLabel.Text = "Please enter both username and password";
            return;
        }
        
        ResultLabel.Text = "Testing login for: " + username + "<br>";
        
        if ((username == "eli" && password == "eli") || 
            (username == "oudi" && password == "5040"))
        {
            string role = (username == "eli") ? "admin" : "user";
            ResultLabel.Text += "Hardcoded match found! Role: " + role;
            return;
        }
        
        try
        {
            string usersXmlPath = Server.MapPath("~/App_Data/Users.xml");
            
            if (File.Exists(usersXmlPath))
            {
                ResultLabel.Text += "XML file exists, checking credentials...<br>";
                
                XmlDocument doc = new XmlDocument();
                doc.Load(usersXmlPath);
                
                XmlNodeList users = doc.SelectNodes("//User");
                ResultLabel.Text += "Found " + users.Count + " users in XML<br>";
                
                bool found = false;
                
                foreach (XmlNode user in users)
                {
                    XmlNode usernameNode = user.SelectSingleNode("Username");
                    XmlNode passwordNode = user.SelectSingleNode("Password");
                    
                    if (usernameNode != null && passwordNode != null)
                    {
                        ResultLabel.Text += "Checking user: " + usernameNode.InnerText + "<br>";
                        
                        if (usernameNode.InnerText == username && 
                            passwordNode.InnerText == password)
                        {
                            found = true;
                            string role = "user";
                            XmlNode roleNode = user.SelectSingleNode("UserRole");
                            if (roleNode != null)
                            {
                                role = roleNode.InnerText;
                            }
                            
                            ResultLabel.Text += "Match found! Role: " + role;
                            break;
                        }
                    }
                }
                
                if (!found)
                {
                    ResultLabel.Text += "No matching user found in XML file.";
                }
            }
            else
            {
                ResultLabel.Text += "Users.xml does not exist!";
            }
        }
        catch (Exception ex)
        {
            ResultLabel.Text += "Error: " + ex.Message;
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login Test Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        h1 {
            color: #333;
        }
        .info-panel {
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .result-panel {
            margin-top: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>Login Test Page</h1>
            
            <div class="info-panel">
                <h3>System Information</h3>
                <asp:Literal ID="DirectoryInfo" runat="server"></asp:Literal>
            </div>
            
            <h3>Test Login</h3>
            <div class="form-group">
                <label for="UserNameTextBox">Username:</label>
                <asp:TextBox ID="UserNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="PasswordTextBox">Password:</label>
                <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
            </div>
            
            <asp:Button ID="TestButton" runat="server" Text="Test Login" OnClick="TestButton_Click" CssClass="btn" />
            
            <div style="margin-top: 15px; padding: 10px; background-color: #f0f0f0; border: 1px solid #ddd; border-radius: 4px;">
                <h4 style="margin-top: 0;">Login Credentials</h4>
                <p><strong>Admin:</strong> Username: eli, Password: eli</p>
                <p><strong>Regular User:</strong> Username: oudi, Password: 5040</p>
                <p>Or <a href="#">create your account</a></p>
            </div>
            
            <asp:Panel ID="ResultPanel" runat="server" CssClass="result-panel" Visible="false">
                <h3>Test Results</h3>
                <asp:Literal ID="ResultLabel" runat="server"></asp:Literal>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
