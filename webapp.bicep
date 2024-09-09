@description('Describes plan\'s pricing tier and instance size. Check details at https://azure.microsoft.com/en-us/pricing/details/app-service/')
@allowed([
  'F1'
])
param skuName string = 'F1'

@description('Describes plan\'s instance count')
@minValue(1)
@maxValue(3)
param skuCapacity int = 1
var hostingPlanName = 'ASP${uniqueString(resourceGroup().id)}'
var websiteName = 'WebApp${uniqueString(resourceGroup().id)}'

param sqlServer string
param sqlDatabase string

resource hostingPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: hostingPlanName
  location: resourceGroup().location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
}

resource website 'Microsoft.Web/sites@2020-12-01' = {
  name: websiteName
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: hostingPlan.id
  }
}

resource diagnosticLogs 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: appServicePlan.name
  scope: appServicePlan
  properties: {
    workspaceId: logAnalytics.id
    logs: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 30
          enabled: true 
        }
      }
    ]
  }
}

resource webSiteConnectionStrings 'Microsoft.Web/sites/config@2020-12-01' = {
  parent: website
  name: 'connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'Data Source=tcp:${sqlServer}.database.windows.net,1433;Initial Catalog=${sqlDatabase};Authentication=Active Directory Default;TrustServerCertificate=True;'
      type: 'SQLAzure'
    }
  }
}

output webSiteName string = website.name
