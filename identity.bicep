var uamiName = 'uami${uniqueString(resourceGroup().id)}'

resource symbolicname 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: uamiName
  location: resourceGroup().location
}
