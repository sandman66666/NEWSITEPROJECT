using System.Web.Optimization;

namespace NEWSITEPROJECT
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new StyleBundle("~/Content/css").Include(
                "~/styles.css"
            ));
        }
    }
}