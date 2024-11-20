targetScope = 'subscription'

@description('Specify a unique name for your offer')
var mspOfferName = 'Remote Infrastructure Monitoring and Management - Initial Onboarding and Discovery'

var mspOfferDescription = 'Provides access for Remote Infrastructure Monitoring and Management to discover and monitor resources in your subscription.'

@description('Specify the tenant id of the Managed Service Provider')
var managedByTenantId = '2f46c040-48e3-4eb8-8fbf-418417f64401'

var principalMap = {
  Onboard: 'd3b6d7a8-aeff-4940-88fc-546e7b90360e'
  RelationshipAdmins: 'def1935f-89ea-473b-aa1d-c6d4b3462f03'
}

var roleMap = {
  SupportRequestContributor: 'cfd33db0-3dd1-45e3-aa9d-cdbdf3b6f24e'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  ManagedServicesDeleteRole: '91c1777a-f3dc-4fae-b103-61d183457e46'
}

@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
var authorizations = [
  {
    principalId: principalMap.Onboard
    principalIdDisplayName: 'RIMM Monitoring Access'
    roleDefinitionId: roleMap.SupportRequestContributor
  }
  {
    principalId: principalMap.Onboard
    principalIdDisplayName: 'RIMM Monitoring Access'
    roleDefinitionId: roleMap.Reader
  }
  {
    principalId: principalMap.RelationshipAdmins
    principalIdDisplayName: 'RIMM Relationship Admins'
    roleDefinitionId: roleMap.ManagedServicesDeleteRole
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
