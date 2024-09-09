param sqlAdmins string

var uniqueSqlServerName = 'SQLServer${uniqueString(resourceGroup().id)}'
var uniqueSqlDatabaseName = 'SQLDatabase${uniqueString(resourceGroup().id)}'

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: uniqueSqlServerName
  location: resourceGroup().location
  identity: {
    type: 'None'
  }
  properties: {
    // administratorLogin: 'string'
    // administratorLoginPassword: 'string'
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: 'string'
      principalType: 'Group'
      sid: sqlAdmins
      // tenantId: 'string'
    }
    // federatedClientId: 'string'
    isIPv6Enabled: 'Disabled'
    // keyId: 'string'
    minimalTlsVersion: '1.3'
    // primaryUserAssignedIdentityId: 'string'
    publicNetworkAccess: 'Enabled'
    // restrictOutboundNetworkAccess: 'string'
    // version: 'string'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  name: uniqueSqlDatabaseName
  location: resourceGroup().location
  // tags: {
  //   tagName1: 'tagValue1'
  //   tagName2: 'tagValue2'
  // }
  sku: {
    // capacity: int
    // family: 'string'
    name: 'Basic'
    // size: 'string'
    // tier: 'string'
  }
  parent: sqlServer
  // identity: {
  //   type: 'string'
  //   userAssignedIdentities: {
  //     {customized property}: {}
  //   }
  // }
  properties: {
    // autoPauseDelay: int
    // availabilityZone: 'string'
    // catalogCollation: 'string'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    // createMode: 'string'
    // elasticPoolId: 'string'
    // encryptionProtector: 'string'
    // encryptionProtectorAutoRotation: bool
    // federatedClientId: 'string'
    // freeLimitExhaustionBehavior: 'string'
    // highAvailabilityReplicaCount: int
    // isLedgerOn: bool
    // keys: {
    //   {customized property}: {}
    // }
    // licenseType: 'string'
    // longTermRetentionBackupResourceId: 'string'
    // maintenanceConfigurationId: 'string'
    // manualCutover: bool
    maxSizeBytes: 1073741824
    // minCapacity: json('decimal-as-string')
    // performCutover: bool
    // preferredEnclaveType: 'string'
    // readScale: 'string'
    // recoverableDatabaseId: 'string'
    // recoveryServicesRecoveryPointId: 'string'
    // requestedBackupStorageRedundancy: 'string'
    // restorableDroppedDatabaseId: 'string'
    // restorePointInTime: 'string'
    // sampleName: 'string'
    // secondaryType: 'string'
    // sourceDatabaseDeletionDate: 'string'
    // sourceDatabaseId: 'string'
    // sourceResourceId: 'string'
    // useFreeLimit: bool
    // zoneRedundant: bool
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
