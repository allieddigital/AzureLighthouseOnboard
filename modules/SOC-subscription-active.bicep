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
  MicrosoftSentinelResponder: '3e150937-b8fe-4cfb-8069-0eaf05ecd056'
  MicrosoftSentinelContributor: 'ab8e14d6-4a74-4a29-9ba8-549422addade'
  MicrosoftSentinelAutomationContributor: 'f4c81013-99ee-4d62-a7ee-b3f1f648599a'
}

@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
var authorizations = [
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelResponder
  }
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 2 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelContributor
  }
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 2 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelAutomationContributor
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

resource mspAssignment 'Microsoft.ManagedServices/registrationAssignments@2019-06-01' = {
  name: guid(mspOfferName)
  properties: {
    registrationDefinitionId: mspRegistration.id
  }
}

output mspOfferName string = 'Managed by ${mspOfferName}'
output authorizations array = authorizations
