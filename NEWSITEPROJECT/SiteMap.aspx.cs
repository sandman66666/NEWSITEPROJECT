using System;

public partial class SiteMap : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // This page is just displaying static content
            // No special initialization needed
        }
    }
}