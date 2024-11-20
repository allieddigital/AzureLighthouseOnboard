targetScope = 'managementGroup'

@description('Provide the MSP Registration full resource ID')
param mspRegistrationResourceId string

resource mspAssignment 'Microsoft.ManagedServices/registrationAssignments@2022-10-01' = {
  name: guid(mspRegistrationResourceId)
  properties: {
    registrationDefinitionId: mspRegistrationResourceId
  }
}
