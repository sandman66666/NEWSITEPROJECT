using System;
using System.Web.UI;

namespace NEWSITEPROJECT
{
    public partial class BeitarJerusalem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                teamLogo.Src = ResolveClientUrl("~/images/beitarrjerusalem.png");
            }
        }
    }
}