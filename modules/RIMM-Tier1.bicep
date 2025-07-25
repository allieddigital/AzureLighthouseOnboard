targetScope = 'subscription'
import { managedByTenantId, assess, tier1 } from 'common.bicep'

var mspOfferName = '[Azure Deploy Link] Remote Infrastructure Monitoring and Management - Tier 1'

var mspOfferDescription = 'Provisions access for Tier 1 Monitoring and Support of your Azure environment by Allied Digital.'

var authorizations = [...assess, ...tier1]

resource mspRegistration 'Microsoft.ManagedServices/registrationDefinitions@2022-10-01' = {
  name: guid(mspOfferName)
  properties: {
    registrationDefinitionName: mspOfferName
    description: mspOfferDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
  }
}

output mspOfferName string = 'Managed by ${mspOfferName}'
output mspRegistrationId string = mspRegistration.id
output authorizations array = authorizations
