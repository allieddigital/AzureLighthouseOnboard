targetScope = 'subscription'

@description('Specify a unique name for your offer')
var mspOfferName = 'Remote Infrastructure Management - Full Azure Management'

var mspOfferDescription = 'Enables Allied Digital Remote Infrastructure Management to manage your entire subscription except for permissions assignment.'

@description('Specify the tenant id of the Managed Service Provider')
var managedByTenantId = '2f46c040-48e3-4eb8-8fbf-418417f64401'

var groupMap = {
  L1RimmOperators: '11a729de-38fb-4056-81d0-b17d37d9a66a'
  L2RimmOperators: '1a3c024d-2ce5-43e7-9c7c-26b17a604755'
}

var roleMap = {
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
}

@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
var authorizations = [
  {
    principalId: groupMap.L1RimmOperators
    principalIdDisplayName: 'RIMM Level 1 Operators'
    roleDefinitionId: roleMap.Contributor
  }
  {
    principalId: groupMap.L2RimmOperators
    principalIdDisplayName: 'RIMM Level 2 Operators'
    roleDefinitionId: roleMap.Contributor
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
