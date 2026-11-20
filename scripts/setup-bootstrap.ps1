<#
.SYNOPSIS
    Automated Azure Remote State Storage Bootstrapper.
.DESCRIPTION
    Provisions or validates the isolated Azure Resource Group and Storage Account
    required to host Terraform remote state files securely.
#>

[CmdletBinding()]
param(
    [string]$SubscriptionId = "",
    [string]$Location = "eastus",
    [string]$ProjectName = "azinfra",
    [string]$Environment = "bootstrap"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Azure Remote State Backend Bootstrap Initializer         " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Check Azure CLI
try {
    $azAccount = az account show --output json | ConvertFrom-Json
    Write-Host "[OK] Connected to Azure Subscription: $($azAccount.name) ($($azAccount.id))" -ForegroundColor Green
} catch {
    Write-Warning "Azure CLI is not logged in. Please run 'az login' before running bootstrap against Azure."
    Write-Host "For offline local dry-run, you can inspect bootstrap/main.tf directly." -ForegroundColor Yellow
    exit 0
}

if ($SubscriptionId) {
    az account set --subscription $SubscriptionId
}

$rootDir = Split-Path -Parent $PSScriptRoot
$bootstrapDir = Join-Path $rootDir "bootstrap"

Push-Location $bootstrapDir
try {
    Write-Host "`n[*] Initializing bootstrap Terraform configuration..." -ForegroundColor Yellow
    terraform init

    Write-Host "`n[*] Generating bootstrap deployment plan..." -ForegroundColor Yellow
    terraform plan -out=bootstrap.tfplan

    Write-Host "`n[NOTICE] To apply the bootstrap storage deployment, run:" -ForegroundColor Cyan
    Write-Host "    terraform apply bootstrap.tfplan" -ForegroundColor White
} finally {
    Pop-Location
}
