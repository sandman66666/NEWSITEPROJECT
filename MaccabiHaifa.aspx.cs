using System;
using System.Web.UI;

namespace NEWSITEPROJECT
{
    public partial class MaccabiHaifa : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string imagePath = ResolveUrl("~/images/macabiHJaifa.jpeg");
                teamLogo.ImageUrl = imagePath;
            }
        }
    }
}