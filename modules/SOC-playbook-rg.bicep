targetScope = 'resourceGroup'

@description('The registration ID to assign')
param mspRegistrationId string

@description('The customer Azure Security Insights ID required for multi-tenant playbook automation.')
param customerAzureSecurityInsightsId string

@description('The role used for Microsoft Sentinel Automation Contributor. This is usually a fixed value')
param MicrosoftSentinelAutomationContributorRoleId string = 'f4c81013-99ee-4d62-a7ee-b3f1f648599a'

var assignmentId = guid(mspRegistrationId, resourceGroup().id)

resource mspAssignment 'Microsoft.ManagedServices/registrationAssignments@2022-10-01' = {
  name: assignmentId
  properties: {
    registrationDefinitionId: mspRegistrationId
  }
}

resource asiAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(customerAzureSecurityInsightsId, MicrosoftSentinelAutomationContributorRoleId)
  properties: {
    principalId: customerAzureSecurityInsightsId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', MicrosoftSentinelAutomationContributorRoleId)
    principalType: 'ServicePrincipal'
  }
}

output assignment object = mspAssignment
