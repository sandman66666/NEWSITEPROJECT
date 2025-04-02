using System;
using System.Web.UI;

namespace NEWSITEPROJECT
{
    public partial class HapoelTelAviv : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Remove the teamLogo reference since we're using SVG in the aspx file
            if (!IsPostBack)
            {
                // This space intentionally left empty
            }
        }
    }
}