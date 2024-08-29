targetScope = 'subscription'

@description('Specify the name of the resource group where the SOC is permitted to deploy Sentinel supporting solutions. This is typically the same resource group as the Sentinel workspace but you may also opt for a separate resource group')
param ResourceGroupName string

@description('''We need your Azure Security Insights Enterprise Application Object ID to enable runbook access and restrictions prevent us from discovering this automatically for you. To find it, go to https://portal.azure.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview, remove the "Application Type == Enterprise Applications" filter, and then type "Azure Security Insights" into the filter box, and copy the Object ID (Not the Application ID) here. You can also run the following Azure PowerShell command: (Get-AzADServicePrincipal -Filter "DisplayName eq 'Azure Security Insights'").Id ''')
param customerAzureSecurityInsightsId string

var mspOfferName = 'Security Operations Center - Azure Sentinel Management'
var mspOfferDescription = 'Enables SOC operations to manage and monitor your Azure Sentinel environment'
var managedByTenantId = '2f46c040-48e3-4eb8-8fbf-418417f64401'

var groupMap = {
  L1SocOperators: 'a2b7313e-013c-4242-bfa5-bee22442a262'
  L2SocOperators: 'b933b7fa-b3b5-47d8-a0cb-1b92b952d0eb'
}

var roleMap = {
  MicrosoftSentinelReader: '8d289c81-5878-46d4-8554-54e1e3d8b5cb'
  MicrosoftSentinelResponder: '3e150937-b8fe-4cfb-8069-0eaf05ecd056'
  MicrosoftSentinelContributor: 'ab8e14d6-4a74-4a29-9ba8-549422addade'
  MicrosoftSentinelPlaybookOperator: '51d6186e-6489-4900-b93f-92e23144cca5'
  SecurityReader: '39bc4728-0917-49c7-9d2c-d95423bc2eb4'
  SupportRequestContributor: 'cfd33db0-3dd1-45e3-aa9d-cdbdf3b6f24e'
  MonitoringContributor: '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  ManagedServicesRegistrationAssignmentDeleteRole: '91c1777a-f3dc-4fae-b103-61d183457e46'
}

@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
var authorizations = [
  // SOC L1
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.SecurityReader
  }
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelReader
  }
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelResponder
  }
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.SupportRequestContributor
  }
  {
    principalId: groupMap.L1SocOperators
    principalIdDisplayName: 'SOC Level 1 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelPlaybookOperator
  }

  // SOC L2
  {
    principalId: groupMap.L2SocOperators
    principalIdDisplayName: 'SOC Level 2 Operators'
    roleDefinitionId: roleMap.MonitoringContributor
  }
  {
    principalId: groupMap.L2SocOperators
    principalIdDisplayName: 'SOC Level 2 Operators'
    roleDefinitionId: roleMap.MicrosoftSentinelContributor
  }
  {
    principalId: groupMap.L2SocOperators
    principalIdDisplayName: 'SOC Level 2 Operators'
    roleDefinitionId: roleMap.ManagedServicesRegistrationAssignmentDeleteRole
  }
]

resource mspRegistration 'Microsoft.ManagedServices/registrationDefinitions@2022-10-01' = {
  name: guid(mspOfferName)
  properties: {
    registrationDefinitionName: mspOfferName
    description: mspOfferDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
  }
}

resource mspAssignment 'Microsoft.ManagedServices/registrationAssignments@2022-10-01' = {
  name: guid(mspOfferName)
  properties: {
    registrationDefinitionId: mspRegistration.id
  }
}

module SOCSolutions 'SOC-solutions.bicep' = {
  name: '${deployment().name}-Solutions'
  params: {
    managedByTenantId: managedByTenantId
    customerAzureSecurityInsightsId: customerAzureSecurityInsightsId
    socManagementGroupId: groupMap.L2SocOperators
    resourceGroupName: ResourceGroupName
  }
}

output mspOfferName string = 'Managed by ${mspOfferName}'
output authorizations array = authorizations
