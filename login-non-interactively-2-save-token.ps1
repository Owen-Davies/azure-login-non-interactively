# Login to your Azure Subscription
Login-AzureRMAccount

$tenantId = (Get-AzureRmSubscription).TenantId
$password = "your secure password"

# Create Application Directory Application 
$azureAdApplication = New-AzureRmADApplication -DisplayName "WebApp Display Name" -HomePage "http://yourapp.com" -IdentifierUris "http://yourapp.com" -Password $password
 
# Create the Service Principal
New-AzureRmADServicePrincipal -ApplicationId $azureAdApplication.ApplicationId
  
# Grant the Service Principal Contributor role
New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $azureAdApplication.ApplicationId
 
$pass = ConvertTo-SecureString $password -AsPlainText –Force

$cred = New-Object -TypeName pscredential –ArgumentList $azureAdApplication.ApplicationId, $pass

# Login using new service principal
Login-AzureRmAccount -Credential $cred -ServicePrincipal –TenantId $tenantId

# Save the token to login later, this expires typically around 12 hours
Save-AzureRmProfile -Path c:\AzureLoginToken.json

# Next time you want to login, just load the Profile
Select-AzureRmProfile -Path c:\AzureLoginToken.json