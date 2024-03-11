targetScope = 'subscription'

@description('Specify a unique name for your offer')
var mspOfferName = 'Security Operations Center - Azure Sentinel Management'
var mspOfferDescription = 'Enables Allied Digital SOC operations to manage and monitor your Azure Sentinel environment'

@description('Specify the tenant id of the Managed Service Provider')
var managedByTenantId = '2f46c040-48e3-4eb8-8fbf-418417f64401'

var groupMap = {
  L1SocOperators: 'a2b7313e-013c-4242-bfa5-bee22442a262'
  L2SocOperators: 'b933b7fa-b3b5-47d8-a0cb-1b92b952d0eb'
}

var roleMap = {
  MicrosoftSentinelReader: '8d289c81-5878-46d4-8554-54e1e3d8b5cb'
  MicrosoftSentinelResponder: '3e150937-b8fe-4cfb-8069-0eaf05ecd056'
  MicrosoftSentinelContributor: 'ab8e14d6-4a74-4a29-9ba8-549422addade'
  MicrosoftSentinelPlaybookOperator: '51d6186e-6489-4900-b93f-92e23144cca5'
  SecurityReader: '39bc4728-0917-49c7-9d2c-d95423bc2eb4'
  SupportRequestContributor: 'cfd33db0-3dd1-45e3-aa9d-cdbdf3b6f24e'
  MonitoringContributor: '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
}

@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
var authorizations = [
  // SOC L1
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.SecurityReader
  }
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelReader
  }
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelResponder
  }
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.SupportRequestContributor
  }
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelPlaybookOperator
  }

  // SOC L2
  {
    principalId: groupMap.L2SocOperators
    principalIdDisplayName: 'SOC Level 2 Operators'
    roleDefinitionId: roleMap.MonitoringContributor
  }
  {
    principalId: groupMap.L2SocOperators
    principalIdDisplayName: 'SOC Level 2 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelContributor
  }
]

resource mspRegistration 'Microsoft.ManagedServices/registrationDefinitions@2022-10-01' = {
  name: guid(mspOfferName)
  properties: {
    registrationDefinitionName: mspOfferName
    description: mspOfferDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
  }
}

resource mspAssignment 'Microsoft.ManagedServices/registrationAssignments@2022-10-01' = {
  name: guid(mspOfferName)
  properties: {
    registrationDefinitionId: mspRegistration.id
  }
}

output mspOfferName string = 'Managed by ${mspOfferName}'
output authorizations array = authorizations
