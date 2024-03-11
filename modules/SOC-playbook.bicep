targetScope = 'subscription'

@description('Specify the name of the resource group where the SOC is permitted to deploy and manage playbooks and supporting Logic Apps')
param resourceGroupName string

@description('''We need your Azure Security Insights Enterprise Application Object ID to enable runbook access and restrictions prevent us from discovering this automatically for you. To find it, go to https://portal.azure.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview, remove the "Application Type == Enterprise Applications" filter, and then type "Azure Security Insights" into the filter box, and copy the Object ID (Not the Application ID) here. You can also run the following Azure PowerShell command: (Get-AzADServicePrincipal -Filter "DisplayName eq 'Azure Security Insights'").Id ''')
param customerAzureSecurityInsightsId string

@description('Specify a unique name for your offer')
var mspOfferName = 'Security Operations Center - Azure Sentinel Playbook Management'

var mspOfferDescription = 'Enables Allied Digital SOC operations to deploy and manage playbooks within a resource group'

@description('Specify the tenant id of the Managed Service Provider')
var managedByTenantId = '2f46c040-48e3-4eb8-8fbf-418417f64401'

@description('Specify the object id of the Managed Service Provider Azure Security Insights app')
var managedBySecurityInsightsAppId = '53769958-144f-4a47-9e8e-8dbc823fb622'

var groupMap = {
  L1SocOperators: 'a2b7313e-013c-4242-bfa5-bee22442a262'
  L2SocOperators: 'b933b7fa-b3b5-47d8-a0cb-1b92b952d0eb'
}

var roleMap = {
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  MicrosoftSentinelAutomationContributor: 'f4c81013-99ee-4d62-a7ee-b3f1f648599a'
}

@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
var authorizations = [
  {
    principalId: groupMap.L2SocOperators
    principalIdDisplayName: 'SOC Level 2 Operators'
    roleDefinitionId: roleMap.Contributor
  }
  {
    principalId: managedBySecurityInsightsAppId
    roleDefinitionId: roleMap.MicrosoftSentinelAutomationContributor
    principalIdDisplayName: 'Managed Service Provider Azure Security Insights App'
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

module socRgAssignment 'SOC-playbook-rg.bicep' = {
  name: 'SOC_Playbook_Management_Access'
  scope: resourceGroup(resourceGroupName)
  params: {
    mspRegistrationId: mspRegistration.id
    customerAzureSecurityInsightsId: customerAzureSecurityInsightsId
    MicrosoftSentinelAutomationContributorRoleId: roleMap.MicrosoftSentinelAutomationContributor
  }
}

output mspOfferName string = 'Managed by ${mspOfferName}'
output authorizations array = authorizations
