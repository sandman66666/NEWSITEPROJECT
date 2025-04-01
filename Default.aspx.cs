using System;
using System.Web.UI;

namespace NEWSITEPROJECT
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string imagePath = ResolveUrl("~/images1/schoolLogo.png");
                schoolLogo.ImageUrl = imagePath;
            }
        }
    }
}https://localhost:44321/Default.aspx.cs