targetScope = 'resourceGroup'

@description('The registration ID to assign')
param mspRegistrationId string

// Associates the SOC Playbook Management registration with the resource group
resource mspAssignment 'Microsoft.ManagedServices/registrationAssignments@2022-10-01' = {
  name: guid(mspRegistrationId)
  properties: {
    registrationDefinitionId: mspRegistrationId
  }
}

output assignment object = mspAssignment
