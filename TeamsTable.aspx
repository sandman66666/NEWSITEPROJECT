<%@ Page Title="טבלת קבוצות" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadTeams();
            SetAdminControls();
        }
    }
    
    private void SetAdminControls()
    {
        bool isAdmin = false;
        
        if (Session["UserRole"] != null && Session["UserRole"].ToString().ToLower() == "admin")
        {
            isAdmin = true;
        }
        
        AdminNoticePanel.Visible = !isAdmin;
        AddTeamLink.Visible = isAdmin;
    }
    
    private void LoadTeams()
    {
        try
        {
            System.Data.DataTable teamsTable = new System.Data.DataTable();
            teamsTable.Columns.Add("TeamName");
            teamsTable.Columns.Add("Championships");
            teamsTable.Columns.Add("Stars");
            teamsTable.Columns.Add("CurrentStanding");

            string xmlPath = Server.MapPath("~/App_Data/Teams.xml");
            
            if (System.IO.File.Exists(xmlPath))
            {
                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.Load(xmlPath);

                System.Xml.XmlNodeList teams = doc.SelectNodes("//Team");
                if (teams != null)
                {
                    foreach (System.Xml.XmlNode team in teams)
                    {
                        string name = "";
                        string champs = "0";
                        string stars = "0";
                        string standing = "0";
                        
                        System.Xml.XmlNode nameNode = team.SelectSingleNode("TeamName");
                        if (nameNode != null)
                        {
                            name = nameNode.InnerText;
                        }
                        
                        System.Xml.XmlNode champsNode = team.SelectSingleNode("Championships");
                        if (champsNode != null)
                        {
                            champs = champsNode.InnerText;
                        }
                        
                        System.Xml.XmlNode starsNode = team.SelectSingleNode("Stars");
                        if (starsNode != null)
                        {
                            stars = starsNode.InnerText;
                        }
                        
                        System.Xml.XmlNode standingNode = team.SelectSingleNode("CurrentStanding");
                        if (standingNode != null)
                        {
                            standing = standingNode.InnerText;
                        }

                        teamsTable.Rows.Add(name, champs, stars, standing);
                    }
                }
            }
            else
            {
                teamsTable.Rows.Add("מכבי חיפה", "12", "5", "1");
                teamsTable.Rows.Add("הפועל תל אביב", "8", "4", "2");
                teamsTable.Rows.Add("בית''ר ירושלים", "6", "3", "3");
            }
            
            GridViewTeams.DataSource = teamsTable;
            GridViewTeams.DataBind();
        }
        catch (System.Exception)
        {
            System.Data.DataTable defaultTable = new System.Data.DataTable();
            defaultTable.Columns.Add("TeamName");
            defaultTable.Columns.Add("Championships");
            defaultTable.Columns.Add("Stars");
            defaultTable.Columns.Add("CurrentStanding");
            
            defaultTable.Rows.Add("מכבי חיפה", "12", "5", "1");
            defaultTable.Rows.Add("הפועל תל אביב", "8", "4", "2");
            defaultTable.Rows.Add("בית''ר ירושלים", "6", "3", "3");
            
            GridViewTeams.DataSource = defaultTable;
            GridViewTeams.DataBind();
        }
    }
    
    protected bool IsAdminUser()
    {
        if (Session["UserRole"] != null && Session["UserRole"].ToString().ToLower() == "admin")
        {
            return true;
        }
        return false;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .teams-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            direction: rtl;
        }
        
        .teams-table th {
            background-color: #3498db;
            color: white;
            padding: 10px;
            text-align: right;
        }
        
        .teams-table td {
            padding: 8px;
            border-bottom: 1px solid #ddd;
            text-align: right;
        }
        
        .teams-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .action-link {
            display: inline-block;
            padding: 5px 10px;
            margin: 0 5px;
            border-radius: 3px;
            text-decoration: none;
            color: white;
        }
        
        .edit-link {
            background-color: #2ecc71;
        }
        
        .delete-link {
            background-color: #e74c3c;
        }
        
        .admin-notice {
            background-color: #fcf8e3;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            color: #8a6d3b;
            text-align: center;
        }
        
        .add-team-button {
            display: inline-block;
            padding: 10px 15px;
            background-color: #3498db;
            color: white;
            border-radius: 5px;
            margin-top: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="text-align: center; padding: 20px;">
        <h2 style="color: #2c3e50; font-size: 28px; margin-bottom: 30px; text-align: center;">קבוצות הכדורגל המובילות בישראל</h2>
        
        <asp:Panel ID="AdminNoticePanel" runat="server" Visible="false" CssClass="admin-notice">
            <p>רק מנהל מערכת יכול להוסיף, לערוך או למחוק קבוצות.</p>
        </asp:Panel>
        
        <div style="margin: 20px auto; max-width: 800px;">
            <asp:GridView ID="GridViewTeams" runat="server" AutoGenerateColumns="False" 
                         CssClass="teams-table" GridLines="None" Width="100%">
                <Columns>
                    <asp:BoundField DataField="TeamName" HeaderText="שם הקבוצה" />
                    <asp:BoundField DataField="Championships" HeaderText="מספר אליפויות" />
                    <asp:TemplateField HeaderText="פעולות" ItemStyle-Width="120px">
                        <ItemTemplate>
                            <div style="display:flex; justify-content: center;">
                                <asp:HyperLink ID="EditLink" runat="server" 
                                    NavigateUrl='<%# "EditTeam.aspx?mode=edit&team=" + Eval("TeamName") %>' 
                                    CssClass="action-link edit-link" Visible='<%# IsAdminUser() %>'>
                                    עריכה
                                </asp:HyperLink>
                                
                                <asp:HyperLink ID="DeleteLink" runat="server" 
                                    NavigateUrl='<%# "DeleteTeam.aspx?team=" + Eval("TeamName") %>' 
                                    CssClass="action-link delete-link" Visible='<%# IsAdminUser() %>'>
                                    מחיקה
                                </asp:HyperLink>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Stars" HeaderText="כוכבים" />
                    <asp:BoundField DataField="CurrentStanding" HeaderText="דירוג עכשווי" />
                </Columns>
            </asp:GridView>
            
            <div style="margin-top: 20px; text-align: center;">
                <asp:HyperLink ID="AddTeamLink" runat="server" NavigateUrl="EditTeam.aspx?mode=add" 
                             CssClass="add-team-button" style="text-decoration: none; color: white;"
                             Visible="false">
                    הוסף קבוצה חדשה
                </asp:HyperLink>
            </div>
        </div>
    </div>
</asp:Content>