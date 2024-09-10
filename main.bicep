metadata description = 'Creates a web app and SQL server, then assigns some rights to allow passwordless authentication for the web app'

targetScope = 'subscription'
param resourceGroupName string
param sqlAdmins string
param repositoryUrl string
param storageAccountName string
param resourceGroupLocation string = 'uksouth'

resource newRG 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

module sql 'sql.bicep' = {
  name: 'sqlServer'
  scope: newRG
  params: {
    sqlAdmins: sqlAdmins
  }
}

module storage 'storage.bicep' = {
  name: 'storageAccount'
  scope: newRG
}

module webApp 'webapp.bicep' = {
  name: 'webApp'
  scope: newRG
  params: {
    sqlServer: sql.outputs.sqlServerName
    sqlDatabase: sql.outputs.sqlDatabaseName
    repositoryUrl: repositoryUrl
    storageAccountName: storageAccountName
  }
}

output webSiteName string = webApp.outputs.webSiteName
output sqlServerName string = sql.outputs.sqlServerName
output sqlDatabaseName string = sql.outputs.sqlDatabaseName
