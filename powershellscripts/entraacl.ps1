# Get Parameters from 
param(
    [Parameter(Mandatory)]
    [string]$sqlServerName
)
# Get Access Token and use to connect to Graph
$accessToken = ConvertTo-SecureString (az account get-access-token --scope https://graph.microsoft.com/.default --query accessToken --output tsv) -AsPlainText
Connect-MgGraph -AccessToken $accessToken
# Create New Group for Directory Readers
$group = New-MgGroup -DisplayName "DirectoryReaderGroup" -Description "Directory Reader Group" -SecurityEnabled:$true -IsAssignableToRole:$true -MailEnabled:$false -MailNickname "DirRead"
$group
# Displays the Directory Readers role information
$roleDefinition = Get-MgRoleManagementDirectoryRoleDefinition -Filter "DisplayName eq 'Directory Readers'"
$roleDefinition
# Assigns the Directory Readers role to the group
$roleAssignment = New-MgRoleManagementDirectoryRoleAssignment -DirectoryScopeId '/' -RoleDefinitionId $roleDefinition.Id -PrincipalId $group.Id
$roleAssignment
# Returns the service principal of your Azure SQL resource
$managedIdentity = Get-MgServicePrincipal -Filter "displayName eq '$sqlServerName'"
$managedIdentity
# Adds the service principal to the group
New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $managedIdentity.Id
Get-MgGroupMember -GroupId $group.Id -Filter "Id eq '$($managedIdentity.Id)'"