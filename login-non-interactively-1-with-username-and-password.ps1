Import-Module AzureRm
Login-AzureRmAccount

$app = New-AzureRmADApplication –DisplayName "ANewApp" –HomePage "<http://YourApplicationHomePage>" –IdentifierUris "<http://YourApplicationUri>" –Password "MyPassword"

New-AzureRmADServicePrincipal –ApplicationId $app.ApplicationId

New-AzureRmRoleAssignment –RoleDefinitionName Reader –ServicePrincipalName $app.ApplicationId

$pass = ConvertTo-SecureString "<Your Password>" -AsPlainText –Force

$cred = New-Object -TypeName pscredential –ArgumentList "<Your UserName>", $pass

$tenantId = (Get-AzureRmSubscription).TenantId

Login-AzureRmAccount -Credential $cred -ServicePrincipal –TenantId $tenantId