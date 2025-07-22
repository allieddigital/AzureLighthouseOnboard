@description('Specify the tenant id of the Managed Service Provider')
@export()
var managedByTenantId = '2f46c040-48e3-4eb8-8fbf-418417f64401'

@export()
var principalMap = {
  Monitor: 'd3b6d7a8-aeff-4940-88fc-546e7b90360e'
  RelationshipAdmins: 'def1935f-89ea-473b-aa1d-c6d4b3462f03'
  Tier1: '11a729de-38fb-4056-81d0-b17d37d9a66a'
  Tier2: '1a3c024d-2ce5-43e7-9c7c-26b17a604755'
  Tier3: 'da160a40-d824-4e0c-9bc1-9f1e21986790'
}

@export()
var roleMap = {
  SupportRequestContributor: 'cfd33db0-3dd1-45e3-aa9d-cdbdf3b6f24e'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  DeploymentStackContributor: 'bf7f8882-3383-422a-806a-6526c631a88a'
  ManagedServicesDeleteRole: '91c1777a-f3dc-4fae-b103-61d183457e46'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  MonitoringContributor: '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  MetricsPublisher: '3913510d-42f4-4e42-8a64-420c390055eb'
  LogAnalyticsContributor: '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
}

@export()
var assess = [
  {
    principalId: principalMap.Monitor
    principalIdDisplayName: 'Onboarding and Monitoring Service'
    roleDefinitionId: roleMap.Reader
  }
  {
    principalId: principalMap.Monitor
    principalIdDisplayName: 'Onboarding and Monitoring Service'
    roleDefinitionId: roleMap.SupportRequestContributor
  }
  {
    principalId: principalMap.RelationshipAdmins
    principalIdDisplayName: 'Relationship Admins'
    roleDefinitionId: roleMap.ManagedServicesDeleteRole
  }
]

@export()
var tier1 = [
  {
    principalId: principalMap.Monitor
    principalIdDisplayName: 'Onboarding and Monitoring Service'
    roleDefinitionId: roleMap.DeploymentStackContributor
  }
  {
    principalId: principalMap.Monitor
    principalIdDisplayName: 'Onboarding and Monitoring Service'
    roleDefinitionId: roleMap.MonitoringContributor
  }
  {
    principalId: principalMap.Monitor
    principalIdDisplayName: 'Onboarding and Monitoring Service'
    roleDefinitionId: roleMap.MetricsPublisher
  }
  {
    principalId: principalMap.Monitor
    principalIdDisplayName: 'Onboarding and Monitoring Service'
    roleDefinitionId: roleMap.LogAnalyticsContributor
  }
  {
    principalId: principalMap.Tier1
    principalIdDisplayName: 'Tier 1 Read-Only Support Access'
    roleDefinitionId: roleMap.Reader
  }
  {
    principalId: principalMap.Tier1
    principalIdDisplayName: 'Tier 1 Read-Only Support Access'
    roleDefinitionId: roleMap.SupportRequestContributor
  }
]

@export()
var tier2 = [
  {
    principalId: principalMap.Tier2
    principalIdDisplayName: 'Tier 2 PIM Controlled Support Access'
    roleDefinitionId: roleMap.Contributor
  }
]
