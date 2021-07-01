targetScope = 'subscription'
var tenantId = '2f46c040-48e3-4eb8-8fbf-418417f64401'
var mspOfferName = 'Allied Digital RIMM - Tier 3 Administration'
var mspAssignmentName_var = guid(mspOfferName)
var mspRegistrationName_var = guid(mspOfferName)
var authorizations = [
  {
    principalId: 'def1935f-89ea-473b-aa1d-c6d4b3462f03'
    principalIdDisplayName: 'Azure Lighthouse Disabled Entrypoint'
    roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
]

resource mspRegistrationName 'Microsoft.ManagedServices/registrationDefinitions@2019-09-01' = {
  name: mspRegistrationName_var
  properties: {
    authorizations: authorizations
    description: 'Provides Tier 3 Administration Support https://www.allieddigital.net/us/?p=182'
    managedByTenantId: tenantId
    registrationDefinitionName: 'RIMM - Tier 3 Administration'
  }
}

resource mspAssignmentName 'Microsoft.ManagedServices/registrationAssignments@2019-09-01' = {
  name: mspAssignmentName_var
  properties: {
    registrationDefinitionId: mspRegistrationName.id
  }
}

output mspOfferName string = 'Managed by ${mspOfferName}'
output authorizations array = authorizations
