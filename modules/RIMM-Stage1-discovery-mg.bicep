targetScope = 'managementGroup'

@description('Provide the management subscription id')
param managementSubscriptionId string

module subscriptionOnboard 'RIMM-Stage1-discovery.bicep' = {
  scope: subscription(managementSubscriptionId)
  name: 'RIMM-Stage1-discovery'
}

var mspRegistrationId = subscriptionOnboard.outputs.mspRegistrationId

resource mspAssignment 'Microsoft.ManagedServices/registrationAssignments@2022-10-01' = {
  name: guid(managementSubscriptionId, managementGroup().id)
  properties: {
    registrationDefinitionId: mspRegistrationId
  }
}
