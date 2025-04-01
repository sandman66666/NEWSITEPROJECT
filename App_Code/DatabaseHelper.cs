using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;
using System.Xml;
using System.Web.UI.WebControls;
using System.IO;
using System.Data.OleDb;

/// <summary>
/// Summary description for DatabaseHelper
/// </summary>
public class DatabaseHelper
{
    public static string ConnectionString = ConfigurationManager.ConnectionStrings["LocalSqlServer"].ConnectionString;
    private static string connectionString = ConfigurationManager.ConnectionStrings["TeamsConnectionString"].ConnectionString;
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
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("OleDb not available: " + ex.Message);
            oleDbAvailable = false;
        }

        return oleDbAvailable.Value;
    }

    // Get all teams - primarily from database, with XML as backup
    public static DataTable GetTeams()
    {
        DataTable teamsTable = new DataTable();
        teamsTable.Columns.Add("TeamName");
        teamsTable.Columns.Add("Championships");
        teamsTable.Columns.Add("Stars");
        teamsTable.Columns.Add("CurrentStanding");

        try
        {
            // Try to get teams from database first
            if (IsOleDbAvailable())
            {
                bool dataFromDb = false;
                
                using (OleDbConnection connection = new OleDbConnection(connectionString))
                {
                    try
                    {
                        // First check if Teams table exists
                        connection.Open();
                        DataTable schemaTables = connection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, 
                                              new object[] { null, null, null, "TABLE" });
                        
                        bool tableExists = false;
                        foreach (DataRow row in schemaTables.Rows)
                        {
                            if (row["TABLE_NAME"].ToString() == "Teams")
                            {
                                tableExists = true;
                                break;
                            }
                        }
                        
                        // If table exists, try to get data
                        if (tableExists)
                        {
                            string query = "SELECT * FROM Teams";
                            OleDbCommand command = new OleDbCommand(query, connection);
                            OleDbDataAdapter adapter = new OleDbDataAdapter(command);
                            adapter.Fill(teamsTable);
                            
                            // If we got data from DB
                            if (teamsTable.Rows.Count > 0)
                            {
                                dataFromDb = true;
                                System.Diagnostics.Debug.WriteLine("Teams loaded from database: " + teamsTable.Rows.Count);
                            }
                        }
                        connection.Close();
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error loading teams from database: " + ex.Message);
                        // We'll fall back to XML
                    }
                }
                
                // If we couldn't get data from the database, try to sync from XML
                if (!dataFromDb && File.Exists(teamsXmlPath))
                {
                    // Clear any partial data
                    teamsTable.Clear();
                    
                    try
                    {
                        // Load data from XML
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
                        
                        // Synchronize database with XML
                        SyncTeamsDbFromXml(teamsTable);
                        
                        System.Diagnostics.Debug.WriteLine("Teams loaded from XML and synced to database: " + teamsTable.Rows.Count);
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error syncing teams from XML to database: " + ex.Message);
                    }
                }
            }
            else
            {
                // Database not available, use XML as fallback
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
                    
                    System.Diagnostics.Debug.WriteLine("Teams loaded from XML (database not available): " + teamsTable.Rows.Count);
                }
            }
            
            // If we still have no data, add default teams
            if (teamsTable.Rows.Count == 0)
            {
                AddDefaultTeams(teamsTable);
                
                // Save to XML
                SaveTeamsToXml(teamsTable);
                
                // And try to save to database if available
                if (IsOleDbAvailable())
                {
                    SyncTeamsDbFromXml(teamsTable);
                }
                
                System.Diagnostics.Debug.WriteLine("Added default teams: " + teamsTable.Rows.Count);
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error in GetTeams: " + ex.Message);
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

    // Creates a new XML file from the DataTable
    private static void SaveTeamsToXml(DataTable teamsTable)
    {
        try
        {
            XmlDocument doc = new XmlDocument();
            XmlDeclaration dec = doc.CreateXmlDeclaration("1.0", "utf-8", null);
            doc.AppendChild(dec);
            
            XmlElement root = doc.CreateElement("Teams");
            doc.AppendChild(root);

            foreach (DataRow row in teamsTable.Rows)
            {
                XmlElement teamElement = doc.CreateElement("Team");

                XmlElement nameElement = doc.CreateElement("TeamName");
                nameElement.InnerText = row["TeamName"].ToString();
                teamElement.AppendChild(nameElement);

                XmlElement championshipsElement = doc.CreateElement("Championships");
                championshipsElement.InnerText = row["Championships"].ToString();
                teamElement.AppendChild(championshipsElement);

                XmlElement starsElement = doc.CreateElement("Stars");
                starsElement.InnerText = row["Stars"].ToString();
                teamElement.AppendChild(starsElement);

                XmlElement standingElement = doc.CreateElement("CurrentStanding");
                standingElement.InnerText = row["CurrentStanding"].ToString();
                teamElement.AppendChild(standingElement);

                root.AppendChild(teamElement);
            }

            // Ensure the directory exists
            string directory = Path.GetDirectoryName(teamsXmlPath);
            if (!Directory.Exists(directory))
            {
                Directory.CreateDirectory(directory);
            }

            // Save the XML document
            doc.Save(teamsXmlPath);
            System.Diagnostics.Debug.WriteLine("Teams saved to XML successfully");
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error in SaveTeamsToXml: " + ex.Message);
            throw new Exception("Failed to save teams to XML: " + ex.Message);
        }
    }

    // Sync the database with data from XML
    private static void SyncTeamsDbFromXml(DataTable teamsTable)
    {
        if (!IsOleDbAvailable())
        {
            System.Diagnostics.Debug.WriteLine("Database not available for sync");
            return;
        }

        try
        {
            using (OleDbConnection connection = new OleDbConnection(connectionString))
            {
                connection.Open();

                // First check if Teams table exists, if not, create it
                DataTable schemaTable = connection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, 
                                            new object[] { null, null, null, "TABLE" });
                
                bool tableExists = false;
                foreach (DataRow row in schemaTable.Rows)
                {
                    if (row["TABLE_NAME"].ToString() == "Teams")
                    {
                        tableExists = true;
                        break;
                    }
                }

                if (!tableExists)
                {
                    // Create Teams table - using TEXT instead of MEMO for compatibility
                    string createTableQuery = @"CREATE TABLE Teams (
                        TeamName TEXT(255) PRIMARY KEY,
                        Championships TEXT(50),
                        Stars TEXT(255),
                        CurrentStanding TEXT(50)
                    )";
                    
                    using (OleDbCommand createCommand = new OleDbCommand(createTableQuery, connection))
                    {
                        createCommand.ExecuteNonQuery();
                        System.Diagnostics.Debug.WriteLine("Teams table created successfully");
                    }
                }

                // Clear existing Teams table
                string deleteQuery = "DELETE FROM Teams";
                using (OleDbCommand deleteCommand = new OleDbCommand(deleteQuery, connection))
                {
                    deleteCommand.ExecuteNonQuery();
                }

                // Insert teams from the data table to database
                foreach (DataRow row in teamsTable.Rows)
                {
                    try
                    {
                        string insertQuery = "INSERT INTO Teams (TeamName, Championships, Stars, CurrentStanding) VALUES (?, ?, ?, ?)";
                        using (OleDbCommand insertCommand = new OleDbCommand(insertQuery, connection))
                        {
                            insertCommand.Parameters.AddWithValue("@TeamName", row["TeamName"].ToString());
                            insertCommand.Parameters.AddWithValue("@Championships", row["Championships"].ToString());
                            insertCommand.Parameters.AddWithValue("@Stars", row["Stars"].ToString());
                            insertCommand.Parameters.AddWithValue("@CurrentStanding", row["CurrentStanding"].ToString());
                            insertCommand.ExecuteNonQuery();
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error inserting team " + row["TeamName"] + ": " + ex.Message);
                        // Continue with other teams
                    }
                }

                connection.Close();
                System.Diagnostics.Debug.WriteLine("Database synced successfully with " + teamsTable.Rows.Count + " teams");
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error in SyncTeamsDbFromXml: " + ex.Message);
        }
    }

    // Add a new team (to both database and XML)
    public static bool AddTeam(string teamName, string championships, string stars, string currentStanding)
    {
        try
        {
            // Load existing teams
            DataTable teamsTable = GetTeams();
            
            // Add new team
            teamsTable.Rows.Add(teamName, championships, stars, currentStanding);

            // Save to XML for backup
            SaveTeamsToXml(teamsTable);
            
            // Add to database if available
            if (IsOleDbAvailable())
            {
                try
                {
                    using (OleDbConnection connection = new OleDbConnection(connectionString))
                    {
                        connection.Open();
                        string insertQuery = "INSERT INTO Teams (TeamName, Championships, Stars, CurrentStanding) VALUES (?, ?, ?, ?)";
                        using (OleDbCommand command = new OleDbCommand(insertQuery, connection))
                        {
                            command.Parameters.AddWithValue("@TeamName", teamName);
                            command.Parameters.AddWithValue("@Championships", championships);
                            command.Parameters.AddWithValue("@Stars", stars);
                            command.Parameters.AddWithValue("@CurrentStanding", currentStanding);
                            command.ExecuteNonQuery();
                        }
                        connection.Close();
                        System.Diagnostics.Debug.WriteLine("Team added to database: " + teamName);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error adding team to database: " + ex.Message);
                    // Continue since XML is our backup
                }
            }
            
            System.Diagnostics.Debug.WriteLine("Team added successfully: " + teamName);
            return true;
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error in AddTeam: " + ex.Message);
            throw new Exception("Failed to add team: " + ex.Message);
        }
    }

    // Search for teams based on name and/or minimum championships
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

    // Update an existing team
    public static bool UpdateTeam(string teamName, string championships, string stars, string currentStanding)
    {
        try 
        {
            bool updated = false;
            
            // Update in database if available
            if (IsOleDbAvailable())
            {
                try
                {
                    using (OleDbConnection connection = new OleDbConnection(connectionString))
                    {
                        connection.Open();
                        
                        // Check if team exists
                        string checkQuery = "SELECT COUNT(*) FROM Teams WHERE TeamName = ?";
                        using (OleDbCommand checkCommand = new OleDbCommand(checkQuery, connection))
                        {
                            checkCommand.Parameters.AddWithValue("@TeamName", teamName);
                            
                            int count = Convert.ToInt32(checkCommand.ExecuteScalar());
                            
                            if (count > 0)
                            {
                                // Team exists, update it
                                string updateQuery = "UPDATE Teams SET Championships = ?, Stars = ?, CurrentStanding = ? WHERE TeamName = ?";
                                using (OleDbCommand updateCommand = new OleDbCommand(updateQuery, connection))
                                {
                                    updateCommand.Parameters.AddWithValue("@Championships", championships);
                                    updateCommand.Parameters.AddWithValue("@Stars", stars);
                                    updateCommand.Parameters.AddWithValue("@CurrentStanding", currentStanding);
                                    updateCommand.Parameters.AddWithValue("@TeamName", teamName);
                                    
                                    int rowsAffected = updateCommand.ExecuteNonQuery();
                                    updated = rowsAffected > 0;
                                    System.Diagnostics.Debug.WriteLine("Team updated in database, rows: " + rowsAffected);
                                }
                            }
                        }
                        
                        connection.Close();
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error updating team in database: " + ex.Message);
                    // Continue updating XML as backup
                }
            }
            
            // Update in XML (always do this as backup)
            DataTable teamsTable = GetTeams();
            bool teamFound = false;

            // Find and update the team in our local data
            foreach (DataRow row in teamsTable.Rows)
            {
                if (row["TeamName"].ToString() == teamName)
                {
                    row["Championships"] = championships;
                    row["Stars"] = stars;
                    row["CurrentStanding"] = currentStanding;
                    teamFound = true;
                    updated = true;
                    break;
                }
            }

            if (teamFound)
            {
                // Save changes to XML
                SaveTeamsToXml(teamsTable);
                System.Diagnostics.Debug.WriteLine("Team updated in XML: " + teamName);
            }
            
            return updated;
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error in UpdateTeam: " + ex.Message);
            throw new Exception("Failed to update team: " + ex.Message);
        }
    }

    // Delete a team
    public static bool DeleteTeam(string teamName)
    {
        try
        {
            bool deleted = false;
            
            // Delete from database if available
            if (IsOleDbAvailable())
            {
                try
                {
                    using (OleDbConnection connection = new OleDbConnection(connectionString))
                    {
                        connection.Open();
                        string deleteQuery = "DELETE FROM Teams WHERE TeamName = ?";
                        using (OleDbCommand command = new OleDbCommand(deleteQuery, connection))
                        {
                            command.Parameters.AddWithValue("@TeamName", teamName);
                            int rowsAffected = command.ExecuteNonQuery();
                            deleted = rowsAffected > 0;
                            System.Diagnostics.Debug.WriteLine("Team deleted from database, rows: " + rowsAffected);
                        }
                        connection.Close();
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error deleting team from database: " + ex.Message);
                    // Continue deleting from XML
                }
            }
            
            // Delete from XML (always do this as backup)
            DataTable teamsTable = GetTeams();
            DataRow rowToDelete = null;

            // Find the team to delete
            foreach (DataRow row in teamsTable.Rows)
            {
                if (row["TeamName"].ToString() == teamName)
                {
                    rowToDelete = row;
                    break;
                }
            }

            if (rowToDelete != null)
            {
                // Remove the team
                teamsTable.Rows.Remove(rowToDelete);
                deleted = true;

                // Save remaining teams back to XML
                SaveTeamsToXml(teamsTable);
                System.Diagnostics.Debug.WriteLine("Team deleted from XML: " + teamName);
            }
            
            return deleted;
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error in DeleteTeam: " + ex.Message);
            throw new Exception("Failed to delete team: " + ex.Message);
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
            }
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
            }
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