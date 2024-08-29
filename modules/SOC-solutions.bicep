targetScope = 'subscription'

param managedByTenantId string

param resourceGroupName string

@description('The group that performs management of the RG')
param socManagementGroupId string

@description('The customer Azure Security Insights ID required for multi-tenant playbook automation.')
param managedByTenantSecurityInsightsObjectId string

var mspOfferName = 'Security Operations Center - Azure Sentinel Management - Solutions'
var mspOfferDescription = 'Enables SOC operations to deploy solutions to a particular resource group'

var roleMap = {
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  MicrosoftSentinelAutomationContributor: 'f4c81013-99ee-4d62-a7ee-b3f1f648599a'
  UserAccessAdministrator: '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  // Used to grant access to a managed identity to publish to a DCR
  MonitoringMetricsPublisher: '3913510d-42f4-4e42-8a64-420c390055eb'
  // For legacy apps that cannot use managed identity
  StorageAccountContributor: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
  StorageBlobDataContributor: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  StorageBlobDataOwner: 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b'
}

@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
var authorizations = [
  {
    principalId: socManagementGroupId
    principalIdDisplayName: 'SOC Level 2 Operators'
    roleDefinitionId: roleMap.Contributor
  }
  {
    principalId: socManagementGroupId
    principalIdDisplayName: 'SOC Level 2 Operators'
    roleDefinitionId: roleMap.UserAccessAdministrator
    delegatedRoleDefinitionIds: [
      roleMap.Contributor
      roleMap.MonitoringMetricsPublisher
      roleMap.StorageAccountContributor
      roleMap.StorageBlobDataContributor
      roleMap.StorageBlobDataOwner
    ]
  }
  {
    principalId: managedByTenantSecurityInsightsObjectId
    roleDefinitionId: roleMap.MicrosoftSentinelAutomationContributor
    principalIdDisplayName: 'Managed Service Provider Azure Security Insights App'
  }
]

// Registers the SOC offer at subscription scope. We cannot register this at resource group scope
resource mspRegistration 'Microsoft.ManagedServices/registrationDefinitions@2022-10-01' = {
  name: guid(mspOfferName)
  properties: {
    registrationDefinitionName: mspOfferName
    description: mspOfferDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
  }
}

// Creates the actual assignment. Must be done as a separate module since it is resource group scoped
module socRgAssignment 'SOC-solutions-rg.bicep' = {
  name: 'SOC_Playbook_Management_Access'
  scope: resourceGroup(resourceGroupName)
  params: {
    mspRegistrationId: mspRegistration.id
  }
}
