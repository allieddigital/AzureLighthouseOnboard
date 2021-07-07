// This must be done first for the Microsoft.ManagedServices namespace
// https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/error-register-resource-provider#solution-3---azure-portal
targetScope = 'subscription'

@description('Specify a unique name for your offer')
param mspOfferName string = 'Allied Digital Services LLC Remote Infrastructure Management and Monitoring (RIMM)'

@description('Name of the Managed Service Provider offering')
param mspOfferDescription string = 'Provides access to an Azure Subscription via Azure Lighthouse. All access must be reviewed and approved by a Privileged Identity Management manager and only lasts for 4 hours.'

@description('Specify the tenant id of the Managed Service Provider')
param managedByTenantId string = '2f46c040-48e3-4eb8-8fbf-418417f64401'

var defaultGroup = '7c442b20-3d20-4881-b6cd-26e6cc2bbc12'
var managersGroup = '6cf7f962-2ff0-4fa1-a11e-e37a7cd9f24d'
var contributorRole = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
var accessGroup = '809f9e90-2459-4568-9545-075bb1584a0e'

var authorizations = [
  {
    principalId: defaultGroup
    roleDefinitionId: contributorRole
    principalIdDisplayName: 'Allied Digital NANDPS Partner Admin Link - Never Used Directly'
  }
]

var eligibleAuthorizations = [
  {
    justInTimeAccessPolicy: {
      multiFactorAuthProvider: 'Azure'
      maximumActivationDuration: 'PT4H'
      managedByTenantApprovers: [
        {
          principalId: managersGroup
          principalIdDisplayName: 'Allied Digital NANDPS Access Managers'
        }
      ]
    }
    principalId: accessGroup
    principalIdDisplayName: 'Allied Digital NANDPS PIM Eligible Access'
    roleDefinitionId: contributorRole
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
