using System;
using System.ServiceModel.Activation;
using System.Web;
using System.Web.Routing;

namespace iMortacciService
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            RegisterRoutes();
        }

        private void RegisterRoutes()
        {
            // Edit the base address of Service by replacing the "Service" string below
            RouteTable.Routes.Add(new ServiceRoute("imortacci", new WebServiceHostFactory(), typeof(Service)));
        }
    }
}
