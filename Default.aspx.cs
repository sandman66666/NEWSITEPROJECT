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
                try
                {
                    string imagePath = ResolveUrl("~/images1/schoolLogo.png");
                    if (schoolLogo != null)
                    {
                        schoolLogo.ImageUrl = imagePath;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error loading school logo: " + ex.Message);
                }
            }
        }
    }
}