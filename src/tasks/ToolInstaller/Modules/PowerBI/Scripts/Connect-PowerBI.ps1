[string]$EndpointUrl = $null

Function Connect-PowerBI
{
	Param
	(
        [Parameter(Mandatory = $true)]$Endpoint
    )

	$module = Get-Module MicrosoftPowerBIMgmt.Profile
	If (-not $module)
	{
		Install-Module MicrosoftPowerBIMgmt.Profile -Scope CurrentUser -Force
	}
	Import-Module MicrosoftPowerBIMgmt.Profile
	
	$script:EndpointUrl = $Endpoint.Url

	$authScheme = $Endpoint.Auth.Scheme
	$environment = $Endpoint.Data.Environment

	Try
	{
		If ($authScheme -eq "UsernamePassword")
		{
			$username = $Endpoint.Auth.Parameters.Username
			$password = ConvertTo-SecureString $Endpoint.Auth.Parameters.Password -AsPlainText -Force
			$credential = New-Object System.Management.Automation.PSCredential $username, $password

			$Connection = Connect-PowerBIServiceAccount -Environment $environment -Credential $credential
		}
		Else
		{
			$tenantId = $Endpoint.Auth.Parameters.TenantId	
			$clientId = $Endpoint.Auth.Parameters.ClientId
			$clientSecret = ConvertTo-SecureString $Endpoint.Auth.Parameters.ClientSecret -AsPlainText -Force
			$credential = New-Object System.Management.Automation.PSCredential $clientId, $clientSecret

			$Connection = Connect-PowerBIServiceAccount -Environment $environment -Tenant $tenantId -Credential $credential -ServicePrincipal
		}
	}
	Finally
	{
		If ($Connection)
		{
			Write-Host "Connected to $($script:EndpointUrl)"
		}
		Else
		{
			Write-Error "Unable to connect to Power BI"
		}
	}
}