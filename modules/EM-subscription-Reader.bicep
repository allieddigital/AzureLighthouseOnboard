targetScope = 'subscription'

@description('Specify a unique name for your offer')
var mspOfferName = 'Endpoint Management - Bastion VM Access'

var mspOfferDescription = 'Enables the Enpoint Management team to access VMs and workstations via Azure Bastion. Provides Reader access role.'

@description('Specify the tenant id of the Managed Service Provider')
var managedByTenantId = '2f46c040-48e3-4eb8-8fbf-418417f64401'

var groupMap = {
  EmOperators: '11a729de-38fb-4056-81d0-b17d37d9a66a'
}

var roleMap = {
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
}

@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
var authorizations = [
  {
    principalId: groupMap.EmOperators
    principalIdDisplayName: 'RIMM Level 1 Operators'
    roleDefinitionId: roleMap.Reader
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
