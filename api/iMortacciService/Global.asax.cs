namespace iMortacci
{
    using System;
    using System.ServiceModel.Activation;
    using System.Web;
    using System.Web.Routing;

    public class Global : HttpApplication
    {
        public void Application_Start(object sender, EventArgs e)
        {
            HttpContext.Current.Application["api_config_cache"] = new APIConfiguration_v2();
            
            this.RegisterRoutes();
        }

        private void RegisterRoutes()
        {
            WebServiceHostFactory factory = new WebServiceHostFactory();

            RouteTable.Routes.Add(new ServiceRoute("api/v1", factory, typeof(Service_v1)));
            RouteTable.Routes.Add(new ServiceRoute("api/v2", factory, typeof(Service_v2)));
        }
    }
}
