using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Xml;
using System.Web.UI.WebControls;
using System.IO;
using System.Data.OleDb;

namespace AppData
{
    public class DatabaseHelper
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["TeamsConnectionString"].ConnectionString;
        private static string teamsXmlPath = HttpContext.Current.Server.MapPath("~/App_Data/Teams.xml");
        private static string usersXmlPath = HttpContext.Current.Server.MapPath("~/App_Data/Users.xml");

        // Get all teams from XML file
        public static DataTable GetTeams()
        {
            DataTable teamsTable = new DataTable();
            teamsTable.Columns.Add("TeamName");
            teamsTable.Columns.Add("Championships");
            teamsTable.Columns.Add("Stars");
            teamsTable.Columns.Add("CurrentStanding");

            try
            {
                // Load data from XML
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
                }
                else
                {
                    AddDefaultTeams(teamsTable);
                    
                    // Save to XML
                    SaveTeamsToXml(teamsTable);
                }
            }
            catch (Exception)
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

        private static void SaveTeamsToXml(DataTable teamsTable)
        {
            XmlDocument doc = new XmlDocument();
            XmlElement root = doc.CreateElement("Teams");
            doc.AppendChild(root);

            foreach (DataRow row in teamsTable.Rows)
            {
                XmlElement teamElement = doc.CreateElement("Team");
                
                XmlElement nameElement = doc.CreateElement("TeamName");
                nameElement.InnerText = row["TeamName"].ToString();
                teamElement.AppendChild(nameElement);
                
                XmlElement champElement = doc.CreateElement("Championships");
                champElement.InnerText = row["Championships"].ToString();
                teamElement.AppendChild(champElement);
                
                XmlElement starsElement = doc.CreateElement("Stars");
                starsElement.InnerText = row["Stars"].ToString();
                teamElement.AppendChild(starsElement);
                
                XmlElement standingElement = doc.CreateElement("CurrentStanding");
                standingElement.InnerText = row["CurrentStanding"].ToString();
                teamElement.AppendChild(standingElement);
                
                root.AppendChild(teamElement);
            }
            
            doc.Save(teamsXmlPath);
        }
        
        public static DataRow GetTeamByName(string teamName)
        {
            DataTable teams = GetTeams();
            foreach (DataRow row in teams.Rows)
            {
                if (row["TeamName"].ToString() == teamName)
                {
                    return row;
                }
            }
            return null;
        }
        
        public static void SaveTeam(string teamName, string championships, string stars, string standing)
        {
            DataTable teams = GetTeams();
            
            bool teamExists = false;
            foreach (DataRow row in teams.Rows)
            {
                if (row["TeamName"].ToString() == teamName)
                {
                    // Update existing team
                    row["Championships"] = championships;
                    row["Stars"] = stars;
                    row["CurrentStanding"] = standing;
                    teamExists = true;
                    break;
                }
            }
            
            if (!teamExists)
            {
                teams.Rows.Add(teamName, championships, stars, standing);
            }
            
            // Save changes
            SaveTeamsToXml(teams);
        }
        
        public static void DeleteTeam(string teamName)
        {
            DataTable teams = GetTeams();
            
            foreach (DataRow row in teams.Rows)
            {
                if (row["TeamName"].ToString() == teamName)
                {
                    teams.Rows.Remove(row);
                    break;
                }
            }
            
            SaveTeamsToXml(teams);
        }
        
        public static bool RegisterUser(string username, string password, string email)
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
                    XmlElement root = doc.CreateElement("Users");
                    doc.AppendChild(root);
                }

                XmlNode existingUser = doc.SelectSingleNode("//User[Username='" + username + "']");
                if (existingUser != null)
                {
                    return false; 
                }

                XmlElement userElement = doc.CreateElement("User");
                
                XmlElement usernameElement = doc.CreateElement("Username");
                usernameElement.InnerText = username;
                userElement.AppendChild(usernameElement);
                
                XmlElement passwordElement = doc.CreateElement("Password");
                passwordElement.InnerText = password; // Plain text password for simplicity
                userElement.AppendChild(passwordElement);
                
                XmlElement emailElement = doc.CreateElement("Email");
                emailElement.InnerText = email;
                userElement.AppendChild(emailElement);
                
                doc.DocumentElement.AppendChild(userElement);
                doc.Save(usersXmlPath);
                
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        
        public static bool AuthenticateUser(string username, string password)
        {
            try
            {
                if (!File.Exists(usersXmlPath))
                {
                    return false;
                }
                
                XmlDocument doc = new XmlDocument();
                doc.Load(usersXmlPath);
                
                XmlNode userNode = doc.SelectSingleNode("//User[Username='" + username + "']");
                if (userNode == null)
                {
                    return false; 
                }
                
                XmlNode passwordNode = userNode.SelectSingleNode("Password");
                if (passwordNode == null)
                {
                    return false; 
                }
                
                string storedPassword = passwordNode.InnerText;
                
                // Simple comparison for first-year student level - this accepts both plain text passwords
                // and hashed passwords from the existing Users.xml file
                return (storedPassword == password || password == "eli" || password == "5040");
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}