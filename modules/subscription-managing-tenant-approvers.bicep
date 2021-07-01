targetScope = 'subscription'

@description('Specify a unique name for your offer')
param mspOfferName string = '<to be filled out by MSP> Specify a title for your offer'

@description('Name of the Managed Service Provider offering')
param mspOfferDescription string = '<to be filled out by MSP> Provide a brief description of your offer'

@description('Specify the tenant id of the Managed Service Provider')
param managedByTenantId string = '<to be filled out by MSP> Provide your tenant id'


@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
param authorizations array = [
  {
    principalId: '00000000-0000-0000-0000-000000000000'
    roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
    principalIdDisplayName: 'PIM_Group'
  }
  {
    principalId: '00000000-0000-0000-0000-000000000000'
    roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
    principalIdDisplayName: 'PIM_Group'
  }
]

@description('Provide the auhtorizations that will have just-in-time role assignments on customer environments with support for approvals from the managing tenant')
param eligibleAuthorizations array = [
  {
    justInTimeAccessPolicy: {
      multiFactorAuthProvider: 'Azure'
      maximumActivationDuration: 'PT8H'
      managedByTenantApprovers: [
        {
          principalId: 'ae3a5392-a2ec-4cc7-89cd-db23ac756900'
          principalIdDisplayName: 'PIM-Approvers'
        }
      ]
    }
    principalId: '00000000-0000-0000-0000-000000000000'
    principalIdDisplayName: 'PIM_Group'
    roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
]


var mspRegistrationName_var = guid(mspOfferName)
var mspAssignmentName_var = guid(mspOfferName)

resource mspRegistration 'Microsoft.ManagedServices/registrationDefinitions@2020-02-01-preview' = {
  name: mspRegistrationName_var
  properties: {
    registrationDefinitionName: mspOfferName
    description: mspOfferDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
    eligibleAuthorizations: eligibleAuthorizations
  }
}

resource mspAssignment 'Microsoft.ManagedServices/registrationAssignments@2020-02-01-preview' = {
  name: mspAssignmentName_var
  properties: {
    registrationDefinitionId: mspRegistration.id
  }
}

output mspOfferName string = 'Managed by ${mspOfferName}'
output authorizations array = authorizations
output eligibleAuthorizations array = eligibleAuthorizations
