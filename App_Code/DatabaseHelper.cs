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

namespace NEWSITEPROJECT
{
    public static class DatabaseHelper
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["TeamsConnectionString"].ConnectionString;
        private static string teamsXmlPath = HttpContext.Current.Server.MapPath("~/App_Data/Teams.xml");
        private static string usersXmlPath = HttpContext.Current.Server.MapPath("~/App_Data/Users.xml");

        public static DataTable GetTeams()
        {
            DataTable teamsTable = new DataTable();
            teamsTable.Columns.Add("TeamName");
            teamsTable.Columns.Add("Championships");
            teamsTable.Columns.Add("Stars");
            teamsTable.Columns.Add("CurrentStanding");

            try
            {
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
            
            SaveTeamsToXml(teams);
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
        
        public static bool AddTeam(string teamName, string championships, string stars, string currentStanding)
        {
            try {
                SaveTeam(teamName, championships, stars, currentStanding);
                return true;
            }
            catch {
                return false;
            }
        }
        
        public static bool UpdateTeam(string teamName, string championships, string stars, string currentStanding)
        {
            try {
                SaveTeam(teamName, championships, stars, currentStanding);
                return true;
            }
            catch {
                return false;
            }
        }
        
        public static bool DeleteTeam(string teamName)
        {
            try {
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
                return true;
            }
            catch {
                return false;
            }
        }
        
        public static bool UsernameExists(string username)
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
                return userNode != null;
            }
            catch
            {
                return false;
            }
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
                
                XmlElement roleElement = doc.CreateElement("UserRole");
                roleElement.InnerText = "user"; // Default role
                userElement.AppendChild(roleElement);
                
                doc.DocumentElement.AppendChild(userElement);
                doc.Save(usersXmlPath);
                
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        
        public static bool AuthenticateUser(string username, string password, out string userRole)
        {
            userRole = "";
            
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
                
                if (username == "eli" && password == "eli")
                {
                    userRole = "admin";
                    return true;
                }
                else if (username == "oudi" && password == "5040")
                {
                    userRole = "user";
                    return true;
                }
                
                if (storedPassword == password)
                {
                    XmlNode roleNode = userNode.SelectSingleNode("UserRole");
                    userRole = (roleNode != null) ? roleNode.InnerText : "user";
                    return true;
                }
                
                return false;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}