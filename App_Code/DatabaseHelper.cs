using System;
using System.Data;
using System.Data.OleDb;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Xml;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace NEWSITEPROJECT
{
    public static class DatabaseHelper
    {
        private static string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TeamsConnectionString"].ConnectionString;
        private static string teamsXmlPath = HttpContext.Current.Server.MapPath("~/App_Data/Teams.xml");
        private static string usersXmlPath = HttpContext.Current.Server.MapPath("~/App_Data/Users.xml");
        private static bool? oleDbAvailable = null;

        private static bool IsOleDbAvailable()
        {
            if (oleDbAvailable.HasValue)
                return oleDbAvailable.Value;

            try
            {
                using (OleDbConnection conn = new OleDbConnection(connectionString))
                {
                    conn.Open();
                    conn.Close();
                    oleDbAvailable = true;
                }
            }
            catch
            {
                oleDbAvailable = false;
            }

            return oleDbAvailable.Value;
        }

        public static DataTable GetTeams()
        {
            DataTable teamsTable = new DataTable();
            teamsTable.Columns.Add("TeamName");
            teamsTable.Columns.Add("Championships");
            teamsTable.Columns.Add("Stars");
            teamsTable.Columns.Add("CurrentStanding");

            if (File.Exists(teamsXmlPath))
            {
                try
                {
                    XmlDocument doc = new XmlDocument();
                    doc.Load(teamsXmlPath);

                    XmlNodeList teamNodes = doc.SelectNodes("//Team");
                    foreach (XmlNode teamNode in teamNodes)
                    {
                        string teamName = teamNode.SelectSingleNode("TeamName").InnerText;
                        string championships = teamNode.SelectSingleNode("Championships").InnerText;
                        string stars = teamNode.SelectSingleNode("Stars").InnerText;
                        string standing = teamNode.SelectSingleNode("CurrentStanding").InnerText;

                        teamsTable.Rows.Add(teamName, championships, stars, standing);
                    }

                    return teamsTable;
                }
                catch (Exception ex)
                {
                    // Log the error for debugging
                    System.Diagnostics.Debug.WriteLine("Error loading teams XML: " + ex.Message);
                    // Continue to try database or add default teams
                }
            }

            if (IsOleDbAvailable())
            {
                try
                {
                    OleDbConnection connection = new OleDbConnection(connectionString);
                    OleDbCommand command = new OleDbCommand("SELECT * FROM Teams", connection);
                    OleDbDataAdapter adapter = new OleDbDataAdapter(command);
                    connection.Open();
                    adapter.Fill(teamsTable);
                    connection.Close();

                    return teamsTable;
                }
                catch (Exception ex)
                {
                    // Log the error for debugging
                    System.Diagnostics.Debug.WriteLine("Error loading teams from database: " + ex.Message);
                    AddDefaultTeams(teamsTable);
                }
            }
            else
            {
                AddDefaultTeams(teamsTable);
            }

            return teamsTable;
        }

        private static void AddDefaultTeams(DataTable teamsTable)
        {
            teamsTable.Rows.Add("מכבי חיפה", "14", "יעקב חודורוב, רוני רוזנטל", "1");
            teamsTable.Rows.Add("הפועל תל אביב", "13", "שייע גלזר, רפי לוי", "2");
            teamsTable.Rows.Add("מכבי תל אביב", "23", "אבי נימני, איל בן זקן", "3");
            teamsTable.Rows.Add("בית''ר ירושלים", "6", "אורי מלמיליאן, דני נוימן", "4");
        }

        public static void AddTeam(string teamName, string championships, string stars, string currentStanding)
        {
            try
            {
                // First make sure the team is added to XML - this is our primary storage
                AddTeamToXml(teamName, championships, stars, currentStanding);

                // Then try to add it to the database if available
                if (IsOleDbAvailable())
                {
                    try
                    {
                        using (OleDbConnection connection = new OleDbConnection(connectionString))
                        {
                            string query = "INSERT INTO Teams (TeamName, Championships, Stars, CurrentStanding) VALUES (?, ?, ?, ?)";
                            OleDbCommand command = new OleDbCommand(query, connection);

                            command.Parameters.AddWithValue("@TeamName", teamName);
                            command.Parameters.AddWithValue("@Championships", championships);
                            command.Parameters.AddWithValue("@Stars", stars);
                            command.Parameters.AddWithValue("@CurrentStanding", currentStanding);

                            connection.Open();
                            command.ExecuteNonQuery();
                            connection.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                        // Log database error but continue since XML is our primary storage
                        System.Diagnostics.Debug.WriteLine("Error adding team to database: " + ex.Message);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Debug.WriteLine("Error in AddTeam: " + ex.Message);
                throw new Exception("Failed to add team: " + ex.Message);
            }
        }

        public static DataTable SearchTeams(string teamName, string minChampionships)
        {
            DataTable allTeams = GetTeams();
            if (string.IsNullOrEmpty(teamName) && string.IsNullOrEmpty(minChampionships))
            {
                return allTeams;
            }

            DataTable filteredTeams = allTeams.Clone();
            int minChamps = 0;
            if (!string.IsNullOrEmpty(minChampionships))
            {
                int.TryParse(minChampionships, out minChamps);
            }

            foreach (DataRow row in allTeams.Rows)
            {
                bool nameMatch = true;
                bool champsMatch = true;
                if (!string.IsNullOrEmpty(teamName))
                {
                    nameMatch = row["TeamName"].ToString().Contains(teamName);
                }

                if (!string.IsNullOrEmpty(minChampionships))
                {
                    int teamChamps = 0;
                    int.TryParse(row["Championships"].ToString(), out teamChamps);
                    champsMatch = teamChamps >= minChamps;
                }

                if (nameMatch && champsMatch)
                {
                    filteredTeams.ImportRow(row);
                }
            }

            return filteredTeams;
        }

        public static bool UpdateTeam(string teamName, string championships, string stars, string currentStanding)
        {
            try 
            {
                bool xmlSuccess = UpdateTeamInXml(teamName, championships, stars, currentStanding);
                
                if (IsOleDbAvailable())
                {
                    try
                    {
                        using (OleDbConnection connection = new OleDbConnection(connectionString))
                        {
                            string query = "UPDATE Teams SET Championships = ?, Stars = ?, CurrentStanding = ? WHERE TeamName = ?";
                            OleDbCommand command = new OleDbCommand(query, connection);

                            command.Parameters.AddWithValue("@Championships", championships);
                            command.Parameters.AddWithValue("@Stars", stars);
                            command.Parameters.AddWithValue("@CurrentStanding", currentStanding);
                            command.Parameters.AddWithValue("@TeamName", teamName);

                            connection.Open();
                            command.ExecuteNonQuery();
                            connection.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                        // Log database error but continue since XML is our primary storage
                        System.Diagnostics.Debug.WriteLine("Error updating team in database: " + ex.Message);
                    }
                }

                return xmlSuccess;
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Debug.WriteLine("Error in UpdateTeam: " + ex.Message);
                throw new Exception("Failed to update team: " + ex.Message);
            }
        }

        private static bool UpdateTeamInXml(string teamName, string championships, string stars, string currentStanding)
        {
            if (!File.Exists(teamsXmlPath))
                return false;

            try
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(teamsXmlPath);

                XmlNode teamNode = doc.SelectSingleNode("//Team[TeamName='" + teamName + "']");
                if (teamNode != null)
                {
                    teamNode.SelectSingleNode("Championships").InnerText = championships;
                    teamNode.SelectSingleNode("Stars").InnerText = stars;
                    teamNode.SelectSingleNode("CurrentStanding").InnerText = currentStanding;

                    doc.Save(teamsXmlPath);
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error updating team in XML: " + ex.Message);
                return false;
            }
        }

        public static bool DeleteTeam(string teamName)
        {
            try
            {
                bool xmlSuccess = DeleteTeamFromXml(teamName);
                
                if (IsOleDbAvailable())
                {
                    try
                    {
                        using (OleDbConnection connection = new OleDbConnection(connectionString))
                        {
                            string query = "DELETE FROM Teams WHERE TeamName = ?";
                            OleDbCommand command = new OleDbCommand(query, connection);

                            command.Parameters.AddWithValue("@TeamName", teamName);

                            connection.Open();
                            command.ExecuteNonQuery();
                            connection.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                        // Log database error but continue since XML is our primary storage
                        System.Diagnostics.Debug.WriteLine("Error deleting team from database: " + ex.Message);
                    }
                }

                return xmlSuccess;
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Debug.WriteLine("Error in DeleteTeam: " + ex.Message);
                throw new Exception("Failed to delete team: " + ex.Message);
            }
        }

        private static bool DeleteTeamFromXml(string teamName)
        {
            if (!File.Exists(teamsXmlPath))
                return false;

            try
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(teamsXmlPath);

                XmlNode teamNode = doc.SelectSingleNode("//Team[TeamName='" + teamName + "']");
                if (teamNode != null)
                {
                    teamNode.ParentNode.RemoveChild(teamNode);
                    doc.Save(teamsXmlPath);
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error deleting team from XML: " + ex.Message);
                return false;
            }
        }

        private static void AddTeamToXml(string teamName, string championships, string stars, string currentStanding)
        {
            try
            {
                XmlDocument doc;
                if (File.Exists(teamsXmlPath))
                {
                    doc = new XmlDocument();
                    doc.Load(teamsXmlPath);
                }
                else
                {
                    doc = new XmlDocument();
                    XmlDeclaration dec = doc.CreateXmlDeclaration("1.0", "utf-8", null);
                    doc.AppendChild(dec);
                    XmlElement root = doc.CreateElement("Teams");
                    doc.AppendChild(root);
                }

                // Check if team already exists - if so, just update it
                XmlNode existingTeam = doc.SelectSingleNode("//Team[TeamName='" + teamName + "']");
                if (existingTeam != null)
                {
                    // Team already exists - update it
                    existingTeam.SelectSingleNode("Championships").InnerText = championships;
                    existingTeam.SelectSingleNode("Stars").InnerText = stars;
                    existingTeam.SelectSingleNode("CurrentStanding").InnerText = currentStanding;
                }
                else
                {
                    // Create new team element
                    XmlElement teamElement = doc.CreateElement("Team");

                    XmlElement nameElement = doc.CreateElement("TeamName");
                    nameElement.InnerText = teamName;
                    teamElement.AppendChild(nameElement);

                    XmlElement championshipsElement = doc.CreateElement("Championships");
                    championshipsElement.InnerText = championships;
                    teamElement.AppendChild(championshipsElement);

                    XmlElement starsElement = doc.CreateElement("Stars");
                    starsElement.InnerText = stars;
                    teamElement.AppendChild(starsElement);

                    XmlElement standingElement = doc.CreateElement("CurrentStanding");
                    standingElement.InnerText = currentStanding;
                    teamElement.AppendChild(standingElement);

                    doc.DocumentElement.AppendChild(teamElement);
                }

                // Ensure the directory exists
                string directory = Path.GetDirectoryName(teamsXmlPath);
                if (!Directory.Exists(directory))
                {
                    Directory.CreateDirectory(directory);
                }

                // Save the XML document
                doc.Save(teamsXmlPath);
                
                // Verify the file was saved
                if (!File.Exists(teamsXmlPath))
                {
                    throw new Exception("XML file could not be created after save operation");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in AddTeamToXml: " + ex.Message);
                throw new Exception("Failed to save team to XML: " + ex.Message);
            }
        }

        public static bool AuthenticateUser(string username, string password, out string userRole)
        {
            userRole = "";
            string hashedPassword = HashPassword(password);

            // Try XML authentication first with both hashed and plaintext passwords
            if (File.Exists(usersXmlPath))
            {
                try
                {
                    XmlDocument doc = new XmlDocument();
                    doc.Load(usersXmlPath);

                    // First try with plain password (for backward compatibility)
                    XmlNode userNode = doc.SelectSingleNode("//User[Username='" + username + "' and Password='" + password + "']");
                    
                    // If not found, try with hashed password
                    if (userNode == null)
                    {
                        userNode = doc.SelectSingleNode("//User[Username='" + username + "' and Password='" + hashedPassword + "']");
                    }
                    
                    if (userNode != null)
                    {
                        XmlNode roleNode = userNode.SelectSingleNode("UserRole");
                        if (roleNode != null)
                        {
                            userRole = roleNode.InnerText;
                            return true;
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("XML Authentication error: " + ex.Message);
                    // Continue to database check if XML fails
                }
            }

            // Try database authentication with both plaintext and hashed passwords
            try
            {
                using (OleDbConnection conn = new OleDbConnection(connectionString))
                {
                    conn.Open();
                    
                    // First try with plaintext password
                    string query = "SELECT Role FROM Users WHERE Username = ? AND Password = ?";
                    using (OleDbCommand cmd = new OleDbCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", password);

                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            userRole = result.ToString();
                            return true;
                        }
                    }
                    
                    // If not found, try with hashed password
                    query = "SELECT Role FROM Users WHERE Username = ? AND Password = ?";
                    using (OleDbCommand cmd = new OleDbCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", hashedPassword);

                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            userRole = result.ToString();
                            return true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Debug.WriteLine("Database Authentication error: " + ex.Message);
            }

            return false;
        }

        public static bool UsernameExists(string username)
        {
            if (File.Exists(usersXmlPath))
            {
                try
                {
                    XmlDocument doc = new XmlDocument();
                    doc.Load(usersXmlPath);

                    string xpathQuery = "//User[Username='" + username + "']";
                    XmlNode userNode = doc.SelectSingleNode(xpathQuery);
                    if (userNode != null)
                        return true;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error checking username in XML: " + ex.Message);
                    // Continue to database check if XML fails
                }
            }

            try
            {
                using (OleDbConnection conn = new OleDbConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT COUNT(*) FROM Users WHERE Username = ?";
                    using (OleDbCommand cmd = new OleDbCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error checking username in database: " + ex.Message);
            }
            
            return false;
        }

        public static bool RegisterUser(string username, string password, string email)
        {
            // Check if username already exists
            if (UsernameExists(username))
                return false;

            string hashedPassword = HashPassword(password);

            try
            {
                // Save to XML
                AddUserToXml(username, hashedPassword, email, "user"); // Default role is 'user'

                // Try to save to database
                if (IsOleDbAvailable())
                {
                    try
                    {
                        using (OleDbConnection conn = new OleDbConnection(connectionString))
                        {
                            conn.Open();
                            string query = "INSERT INTO Users (Username, Password, Email, Role) VALUES (?, ?, ?, ?)";
                            using (OleDbCommand cmd = new OleDbCommand(query, conn))
                            {
                                cmd.Parameters.AddWithValue("@Username", username);
                                cmd.Parameters.AddWithValue("@Password", hashedPassword);
                                cmd.Parameters.AddWithValue("@Email", email);
                                cmd.Parameters.AddWithValue("@Role", "user"); // Default role

                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error registering user in database: " + ex.Message);
                        // Continue since XML is our primary storage
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error registering user: " + ex.Message);
                return false;
            }
        }

        private static void AddUserToXml(string username, string password, string email, string role)
        {
            XmlDocument doc;
            if (File.Exists(usersXmlPath))
            {
                doc = new XmlDocument();
                doc.Load(usersXmlPath);
            }
            else
            {
                doc = new XmlDocument();
                XmlDeclaration dec = doc.CreateXmlDeclaration("1.0", "utf-8", null);
                doc.AppendChild(dec);
                XmlElement root = doc.CreateElement("Users");
                doc.AppendChild(root);
            }

            XmlElement userElement = doc.CreateElement("User");

            XmlElement usernameElement = doc.CreateElement("Username");
            usernameElement.InnerText = username;
            userElement.AppendChild(usernameElement);

            XmlElement passwordElement = doc.CreateElement("Password");
            passwordElement.InnerText = password;
            userElement.AppendChild(passwordElement);

            XmlElement emailElement = doc.CreateElement("Email");
            emailElement.InnerText = email;
            userElement.AppendChild(emailElement);

            XmlElement roleElement = doc.CreateElement("UserRole");
            roleElement.InnerText = role;
            userElement.AppendChild(roleElement);

            doc.DocumentElement.AppendChild(userElement);
            doc.Save(usersXmlPath);
        }

        public static string HashPassword(string password)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                // Convert the input string to a byte array and compute the hash
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password));

                // Convert byte array to a string
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}