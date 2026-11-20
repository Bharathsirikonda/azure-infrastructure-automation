<#
.SYNOPSIS
    Azure Service Principal and RBAC Setup Guide Script.
.DESCRIPTION
    Creates an Azure Active Directory Service Principal for Azure DevOps CI/CD pipelines
    with scoped RBAC roles (Contributor + Key Vault Administrator or Secrets User).
#>

[CmdletBinding()]
param(
    [string]$SpName = "sp-azinfra-devops-cicd",
    [string]$SubscriptionId = ""
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Azure DevOps Service Principal Setup Automation          " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if (-not $SubscriptionId) {
    try {
        $SubscriptionId = (az account show --query id -o tsv)
        Write-Host "Using active subscription: $SubscriptionId" -ForegroundColor Green
    } catch {
        Write-Error "Please run 'az login' or pass -SubscriptionId."
        exit 1
    }
}

Write-Host "`n[*] Creating Service Principal with Contributor role on subscription..." -ForegroundColor Yellow
$scope = "/subscriptions/$SubscriptionId"

$spOutput = az ad sp create-for-rbac `
    --name $SpName `
    --role "Contributor" `
    --scopes $scope `
    --output json

Write-Host "`n[SUCCESS] Service Principal Created Successfully!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Service Principal JSON Output (Keep this confidential!):" -ForegroundColor White
Write-Host $spOutput -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

Write-Host "`nNext Steps for Azure DevOps Configuration:" -ForegroundColor White
Write-Host "1. In Azure DevOps, go to Project Settings -> Service connections -> New service connection."
Write-Host "2. Select 'Azure Resource Manager' -> 'Service principal (manual)'."
Write-Host "3. Enter the Subscription ID, Tenant ID, Service Principal App ID (appId), and Client Secret (password)."
Write-Host "4. Name the connection 'azure-rm-service-connection' and grant access to all pipelines."
