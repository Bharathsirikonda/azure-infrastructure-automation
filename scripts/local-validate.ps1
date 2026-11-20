<#
.SYNOPSIS
    Local Validation Script for Azure Infrastructure Automation.
.DESCRIPTION
    Executes automated checks across all Terraform modules and environments:
    - Code formatting verification (terraform fmt -check)
    - Syntax and schema validation (terraform validate) across bootstrap, dev, and prod
#>

[CmdletBinding()]
param(
    [string]$TerraformPath = "terraform"
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Azure Infrastructure Automation - Local Validation Suite " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Verify Terraform executable
try {
    $tfVersion = & $TerraformPath -version
    Write-Host "[OK] Terraform available:`n$($tfVersion | Select-Object -First 1)" -ForegroundColor Green
} catch {
    Write-Error "Terraform executable not found at '$TerraformPath'. Please verify your PATH or pass -TerraformPath."
    exit 1
}

$rootDir = Split-Path -Parent $PSScriptRoot
Write-Host "`nProject Root: $rootDir" -ForegroundColor Gray

# 2. Format Check
Write-Host "`n[*] Step 1: Checking code formatting across entire repository..." -ForegroundColor Yellow
Push-Location $rootDir
try {
    & $TerraformPath fmt -check -recursive
    Write-Host "[PASS] All Terraform files are formatted correctly." -ForegroundColor Green
} catch {
    Write-Warning "[FAIL] Formatting issues detected. Run 'terraform fmt -recursive' to auto-fix."
    exit 1
} finally {
    Pop-Location
}

# 3. Environment Validation Targets
$targets = @(
    "bootstrap",
    "environments/dev",
    "environments/prod"
)

foreach ($target in $targets) {
    $targetDir = Join-Path $rootDir $target
    Write-Host "`n[*] Step 2: Validating $target..." -ForegroundColor Yellow

    if (-not (Test-Path $targetDir)) {
        Write-Error "Target directory not found: $targetDir"
        exit 1
    }

    Push-Location $targetDir
    try {
        Write-Host "  -> Initializing without backend..." -ForegroundColor Gray
        $null = & $TerraformPath init -backend=false -input=false

        Write-Host "  -> Validating syntax & resource schema..." -ForegroundColor Gray
        $validateResult = & $TerraformPath validate
        Write-Host "[PASS] $target is valid: $validateResult" -ForegroundColor Green
    } catch {
        Write-Error "[FAIL] Validation failed in ${target}. Error: $_"
        exit 1
    } finally {
        Pop-Location
    }
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host " [SUCCESS] All Local Terraform Validations Passed!       " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
