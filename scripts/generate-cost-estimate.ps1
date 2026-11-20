<#
.SYNOPSIS
    Azure Cloud Infrastructure Cost Estimation and Budget Breakdown.
.DESCRIPTION
    Provides monthly and annual cost estimates for Development and Production tiers,
    highlighting architectural cost-optimization strategies.
#>

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Azure Infrastructure Automation - Cost & Budget Analysis  " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$devCosts = [ordered]@{
    "App Service Plan (Linux B1 - 1 Core, 1.75 GB RAM)" = 12.41
    "Key Vault (Standard Tier - < 10,000 operations/mo)"  = 0.03
    "Storage Account (Standard LRS - 10 GB Data + Ops)"  = 0.22
    "Remote State Storage (Bootstrap LRS - 2 GB Data)"   = 0.05
    "Total Estimated Development Cost (Monthly)"         = 12.71
}

$prodCosts = [ordered]@{
    "App Service Plan (Linux S1 - 1 Core, 1.75 GB, Auto-scale, Custom Domains, Staging Slots)" = 73.00
    "Key Vault (Standard Tier - ~50,000 operations/mo)"                                          = 0.15
    "Storage Account (Standard GRS - 50 GB Geo-replicated Data + Ops)"                          = 2.10
    "Remote State Storage (Bootstrap LRS - 5 GB Data + Versioning)"                             = 0.12
    "Total Estimated Production Cost (Monthly)"                                                 = 75.37
}

Write-Host "`n--- Development Environment Sizing & Estimates ---" -ForegroundColor Yellow
foreach ($k in $devCosts.Keys) {
    if ($k.StartsWith("Total")) {
        Write-Host ("{0,-65}: `${1:N2}/month (`${2:N2}/year)" -f $k, $devCosts[$k], ($devCosts[$k] * 12)) -ForegroundColor Green
    } else {
        Write-Host ("{0,-65}: `${1:N2}/month" -f $k, $devCosts[$k]) -ForegroundColor Gray
    }
}

Write-Host "`n--- Production Environment Sizing & Estimates ---" -ForegroundColor Yellow
foreach ($k in $prodCosts.Keys) {
    if ($k.StartsWith("Total")) {
        Write-Host ("{0,-65}: `${1:N2}/month (`${2:N2}/year)" -f $k, $prodCosts[$k], ($prodCosts[$k] * 12)) -ForegroundColor Green
    } else {
        Write-Host ("{0,-65}: `${1:N2}/month" -f $k, $prodCosts[$k]) -ForegroundColor Gray
    }
}

Write-Host "`nCost Optimization Strategies:" -ForegroundColor Cyan
Write-Host "1. Scale Dev App Service Plan down to F1 (Free) when not running integration tests." -ForegroundColor White
Write-Host "2. Leverage Azure Hybrid Benefit and 1-Year / 3-Year Reserved Instances for up to 40% savings on S1/P1v3." -ForegroundColor White
Write-Host "3. Implement Azure Budget alerts at 80% and 100% threshold using az consumption budget." -ForegroundColor White
