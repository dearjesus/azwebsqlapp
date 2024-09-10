var storageAccountName = 'sto${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource storageBlob 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  name: 'default'
  parent: storageAccount
}

//create container
resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  parent: storageBlob
  name: 'webapplogs'
}

resource lifecycleManagementPolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2023-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    policy: {
      rules: [
        {
          definition: {
            actions: {
              baseBlob: {
                delete: {
                  daysAfterCreationGreaterThan: 3
                }
              }
            }
            filters: {
              blobTypes: ['blockBlob']
            }
          }
          enabled: true
          name: 'deleteBlobsAfter3Days'
          type: 'Lifecycle'
        }
      ]
    }
  }
}
