[CmdletBinding()]

param()

Trace-VstsEnteringInvocation $MyInvocation

try
{
	$toolsPath = Get-VstsTaskVariable -Name "PowerBI_Tools_Path"
	Import-Module -Name "$toolsPath/Modules/MicrosoftPowerBIMgmt.Profile"

	# Connection
	$endpointName     = Get-VstsInput -Name ServiceEndpoint
	$endpoint         = Get-VstsEndpoint -Name $endpointName
	$authScheme       = $endpoint.Auth.Scheme
	$environment      = $endpoint.Data.Environment

	If ($authScheme -eq "UsernamePassword")
	{
		$username     = $endpoint.Auth.Parameters.Username
		$password     = ConvertTo-SecureString $endpoint.Auth.Parameters.Password -AsPlainText -Force
		$credential   = New-Object System.Management.Automation.PSCredential $username, $password

		Connect-PowerBIServiceAccount -Environment $environment -Credential $credential
	}
	Else
	{
		$tenantId     = $endpoint.Auth.Parameters.TenantId	
		$clientId     = $endpoint.Auth.Parameters.ClientId
		$clientSecret = ConvertTo-SecureString $endpoint.Auth.Parameters.ClientSecret -AsPlainText -Force
		$credential   = New-Object System.Management.Automation.PSCredential $clientId, $clientSecret

		Connect-PowerBIServiceAccount -Environment $environment -Tenant $tenantId -Credential $credential -ServicePrincipal
	}
}
finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}