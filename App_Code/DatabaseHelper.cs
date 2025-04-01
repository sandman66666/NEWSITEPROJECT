using System;
using System.Data;
using System.Data.OleDb;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Xml;
using System.Data.SqlClient;
using System.Configuration;

namespace NEWSITEPROJECT
{
    public static class DatabaseHelper
    {
        private static string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TeamsConnectionString"].ConnectionString;
        private static string teamsXmlPath = HttpContext.Current.Server.MapPath("~/App_Data/teams.xml");
        private static string usersXmlPath = HttpContext.Current.Server.MapPath("~/App_Data/users.xml");
        private static bool? oleDbAvailable = null;

        private static bool IsOleDbAvailable()
        {
            if (oleDbAvailable.HasValue)
                return oleDbAvailable.Value;

            try
            {
                using (OleDbConnection conn = new OleDbConnection(connectionString))
                {
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
                catch
                {
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
            AddTeamToXml(teamName, championships, stars, currentStanding);
            if (IsOleDbAvailable())
            {
                try
                {
                    OleDbConnection connection = new OleDbConnection(connectionString);
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
                catch
                {
                }
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
            bool xmlSuccess = UpdateTeamInXml(teamName, championships, stars, currentStanding);
            if (IsOleDbAvailable())
            {
                try
                {
                    OleDbConnection connection = new OleDbConnection(connectionString);
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
                catch
                {
                }
            }

            return xmlSuccess;
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
            catch
            {
                return false;
            }
        }

        public static bool DeleteTeam(string teamName)
        {
            bool xmlSuccess = DeleteTeamFromXml(teamName);
            if (IsOleDbAvailable())
            {
                try
                {
                    OleDbConnection connection = new OleDbConnection(connectionString);
                    string query = "DELETE FROM Teams WHERE TeamName = ?";
                    OleDbCommand command = new OleDbCommand(query, connection);

                    command.Parameters.AddWithValue("@TeamName", teamName);

                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
                catch
                {
                }
            }

            return xmlSuccess;
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
            catch
            {
                return false;
            }
        }

        private static void AddTeamToXml(string teamName, string championships, string stars, string currentStanding)
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
            doc.Save(teamsXmlPath);
        }

        public static bool AuthenticateUser(string username, string password, out string userRole)
        {
            userRole = "";

            // Try XML authentication first
            if (File.Exists(usersXmlPath))
            {
                try
                {
                    XmlDocument doc = new XmlDocument();
                    doc.Load(usersXmlPath);

                    XmlNode userNode = doc.SelectSingleNode("//User[Username='" + username + "' and Password='" + password + "']");
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
                catch
                {
                    // Continue to database check if XML fails
                }
            }

            // Try database authentication
            try
            {
                using (OleDbConnection conn = new OleDbConnection(connectionString))
                {
                    conn.Open();
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
                }
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Debug.WriteLine(string.Format("Authentication error: {0}", ex.Message));
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
                catch
                {
                }
            }

            if (IsOleDbAvailable())
            {
                try
                {
                    OleDbConnection connection = new OleDbConnection(connectionString);
                    string query = "SELECT COUNT(*) FROM Users WHERE Username = ?";
                    OleDbCommand command = new OleDbCommand(query, connection);

                    command.Parameters.AddWithValue("@Username", username);

                    connection.Open();
                    int count = (int)command.ExecuteScalar();
                    connection.Close();

                    return count > 0;
                }
                catch
                {
                }
            }

            return false;
        }

        public static bool RegisterUser(string username, string password, string email)
        {
            try
            {
                using (OleDbConnection conn = new OleDbConnection(connectionString))
                {
                    conn.Open();
                    string query = "INSERT INTO Users (Username, Password, Email, Role) VALUES (?, ?, ?, 'User')";
                    using (OleDbCommand cmd = new OleDbCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", password); // Note: In production, use proper password hashing
                        cmd.Parameters.AddWithValue("@Email", email);

                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Debug.WriteLine(string.Format("Registration error: {0}", ex.Message));
                return false;
            }
        }

        private static bool AddUserToXml(string username, string password, string userRole)
        {
            try
            {
                XmlDocument doc = new XmlDocument();

                if (File.Exists(usersXmlPath))
                {
                    doc.Load(usersXmlPath);
                }
                else
                {
                    XmlDeclaration declaration = doc.CreateXmlDeclaration("1.0", "utf-8", null);
                    doc.AppendChild(declaration);

                    XmlElement usersRoot = doc.CreateElement("Users");
                    doc.AppendChild(usersRoot);
                }

                XmlElement root = doc.DocumentElement;

                XmlElement userElement = doc.CreateElement("User");
                XmlElement usernameElement = doc.CreateElement("Username");
                usernameElement.InnerText = username;
                userElement.AppendChild(usernameElement);

                XmlElement passwordElement = doc.CreateElement("Password");
                passwordElement.InnerText = password;
                userElement.AppendChild(passwordElement);

                XmlElement roleElement = doc.CreateElement("UserRole");
                roleElement.InnerText = userRole;
                userElement.AppendChild(roleElement);

                XmlElement dateElement = doc.CreateElement("RegistrationDate");
                dateElement.InnerText = DateTime.Now.ToString("yyyy-MM-dd");
                userElement.AppendChild(dateElement);

                root.AppendChild(userElement);
                doc.Save(usersXmlPath);
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}