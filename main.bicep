targetScope = 'subscription'
param resourceGroupName string = 'EntraEventHub'
param resourceGroupLocation string = 'uksouth'

resource newRG 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

module eventHub 'eventhub.bicep' = {
    name: 'eventHubModule'
    scope: newRG
    params: {
      eventHubNamespaceName: 'entraEventHub'
      eventHubName: 'userEvents'
    }
  }

output eventHubNamespaceName string = eventHub.outputs.eventHubNamespaceName
output eventHubName string = eventHub.outputs.eventHubName
