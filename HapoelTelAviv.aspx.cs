using System;
using System.Web.UI;

namespace NEWSITEPROJECT
{
    public partial class HapoelTelAviv : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (teamLogo != null)
                {
                    teamLogo.Src = ResolveClientUrl("~/images/hapoelTelvaviv.png");
                }
            }
        }
    }
}