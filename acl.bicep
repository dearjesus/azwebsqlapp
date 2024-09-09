param sqlServerName string
param sqlPrincipalId string

resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: sqlServerName
}

@description('This is the built-in Entra Directory Reader role.')
resource directoryReader 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '88d8e3e3-8f55-4a1e-953a-9b9898b8876b'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, sqlPrincipalId, directoryReader.id)
  scope: sqlServer
  properties: {
    roleDefinitionId: directoryReader.id
    principalId: sqlPrincipalId
    principalType: 'ServicePrincipal'
  }
}
