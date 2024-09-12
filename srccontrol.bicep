param websiteName string
param repositoryUrl string
param branch string = 'main'

resource website 'Microsoft.Web/sites@2020-12-01' existing = {
  name: websiteName
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
  parent: website
  name: 'web'
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}
