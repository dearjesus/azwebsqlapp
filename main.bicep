targetScope = 'subscription'
param resourceGroupName string
param sqlAdmins string
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

module webApp 'webapp.bicep' = {
  name: 'webApp'
  scope: newRG
  params: {
    sqlServer: sql.outputs.sqlServerName
    sqlDatabase: sql.outputs.sqlDatabaseName
  }
}

module acl 'acl.bicep' = {
  name: 'setACLonEntra'
  scope: newRG
  params: {
    sqlServerName: sql.outputs.sqlServerName
  }
}

output webServerName string = webApp.outputs.webServerName
output webSiteName string = webApp.outputs.webSiteName
output sqlServerName string = sql.outputs.sqlServerName
output sqlDatabaseName string = sql.outputs.sqlDatabaseName
