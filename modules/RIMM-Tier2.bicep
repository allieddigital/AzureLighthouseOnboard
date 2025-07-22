targetScope = 'subscription'
import { managedByTenantId, assess, tier1, tier2 } from 'common.bicep'

var mspOfferName = '[Azure Deploy Link] Remote Infrastructure Monitoring and Management - Tier 2/3'

var mspOfferDescription = 'Provisions access for Tier 2/3 Management of your Azure environment by Allied Digital.'

var authorizations = [...assess, ...tier1]

resource mspRegistration 'Microsoft.ManagedServices/registrationDefinitions@2022-10-01' = {
  name: guid(mspOfferName)
  properties: {
    registrationDefinitionName: mspOfferName
    description: mspOfferDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
    eligibleAuthorizations: tier2
  }
}

output mspOfferName string = 'Managed by ${mspOfferName}'
output mspRegistrationId string = mspRegistration.id
output authorizations array = authorizations
