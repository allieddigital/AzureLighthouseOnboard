param (
	[Parameter(Mandatory)]
	[string]$armTemplateUrl,
	[string]$uiDefinitionUrl = [String]::Empty
)

function New-AzureDeployLink {
	param (
		[Parameter(Mandatory)]
		[string]$armTemplateUrl,
		[string]$definitionUrl = [String]::Empty,
		[switch]$Stack
	)
	$armTemplateUrl = [System.Web.HttpUtility]::UrlEncode($armTemplateUrl)
	$definitionUrl = if ($definitionUrl) { [System.Web.HttpUtility]::UrlEncode($definitionUrl) } else { $null }
	$deployBase = $Stack ? '#view/Microsoft_Azure_CreateUIDef/DeploymentStackBlade' : '#create/Microsoft.Template'
	$link = "https://portal.azure.com/$deployBase/uri/$armTemplateUrl"
	if (-not [string]::IsNullOrEmpty($definitionUrl)) {
		$link += "/uiFormDefinitionUri/$definitionUrl"
	}
	return $link
}

return @{
	DeployLink = New-AzureDeployLink -armTemplateUrl $armTemplateUrl -definitionUrl $uiDefinitionUrl
	StackLink  = New-AzureDeployLink -armTemplateUrl $armTemplateUrl -definitionUrl $uiDefinitionUrl -Stack
}
