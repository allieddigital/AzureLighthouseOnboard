param resourceId_Microsoft_ManagedServices_registrationDefinitions_variables_mspRegistrationName string
param variables_mspAssignmentName ? /* TODO: fill in correct type */

resource variables_mspAssignment 'Microsoft.ManagedServices/registrationAssignments@2019-06-01' = {
  name: variables_mspAssignmentName
  properties: {
    registrationDefinitionId: resourceId_Microsoft_ManagedServices_registrationDefinitions_variables_mspRegistrationName
  }
}