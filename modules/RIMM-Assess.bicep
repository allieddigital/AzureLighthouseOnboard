targetScope = 'subscription'
import { managedByTenantId, assess } from 'common.bicep'

var mspOfferName = '[Azure Deploy Link] Remote Infrastructure Monitoring and Management - Assess'

var mspOfferDescription = 'Enables Allied Digital to assess your Azure environment for Remote Infrastructure Monitoring and Management readiness.'

var authorizations = assess

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
