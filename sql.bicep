param sqlAdmins string

var sqlServerName = 'SQLServer${uniqueString(resourceGroup().id)}'
var sqlDatabaseName = 'SQLDatabase${uniqueString(resourceGroup().id)}'

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: 'SQL Admins' // Has to match even if not changing else stupid thing errors out, else child out the /administrators property to another resource
      principalType: 'Group'
      sid: sqlAdmins
    }
    isIPv6Enabled: 'Disabled'
    publicNetworkAccess: 'Enabled'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  name: sqlDatabaseName
  location: resourceGroup().location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  parent: sqlServer
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    isLedgerOn: false
    maxSizeBytes: 1073741824
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Local'
    zoneRedundant: false
  }
}

resource allowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2021-02-01-preview' = {
  parent: sqlServer
  name: 'AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

output sqlServerName string = sqlServer.name
output sqlDatabaseName string = sqlDatabase.name
output sqlPrincipalId string = sqlServer.identity.principalId
