# Create certificate and service principle
$cert = New-SelfSignedCertificate -CertStoreLocation "cert:\CurrentUser\My" -Subject "CN=exampleapp" -KeySpec KeyExchange
Login-AzureRmAccount
$keyValue = [System.Convert]::ToBase64String($cert.GetRawCertData())
$azureAdApplication = New-AzureRmADApplication -DisplayName "exampleapp" -HomePage "https://www.contoso.org" -IdentifierUris "https://www.contoso.org/example" -KeyValue $keyValue -KeyType AsymmetricX509Cert -EndDate $cert.NotAfter -StartDate $cert.NotBefore      

New-AzureRmADServicePrincipal -ApplicationId $azureAdApplication.ApplicationId

New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $azureAdApplication.ApplicationId.Guid

# Create Login script

# Get Application Id
$applicationId = $azureAdApplication.ApplicationId
$applicationId = (Get-AzureRmADApplication -IdentifierUri "https://www.contoso.org/example").ApplicationId

# Get thumbprint of certificate
$thumbprint = (Get-ChildItem -Path cert:\CurrentUser\My\* -DnsName exampleapp).Thumbprint
$thumbprint = $cert.Thumbprint

# Get the tenant 
$tenantId = (Get-AzureRmSubscription).TenantId

$loginCommand = "Add-AzureRmAccount -ServicePrincipal -CertificateThumbprint $thumbprint -ApplicationId $applicationId -TenantId $tenantId"
Add-Content 'c:\login.ps1' $loginCommand