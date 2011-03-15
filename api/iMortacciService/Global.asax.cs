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
            HttpContext.Current.Application["api_config"] = new APIConfiguration();
            this.RegisterRoutes();
        }

        private void RegisterRoutes()
        {
            // Edit the base address of ServiceV1 by replacing the "ServiceV1" string below
            RouteTable.Routes.Add(new ServiceRoute("api/v1", new WebServiceHostFactory(), typeof(Service_v1)));
        }
    }
}
