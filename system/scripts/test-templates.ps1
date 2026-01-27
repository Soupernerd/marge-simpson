<#
.SYNOPSIS
    Template Pollution Test - ensures marge-simpson templates stay pristine
.DESCRIPTION
    Validates that template files in marge-simpson/ remain in their default state.
    
    This script lives in marge-simpson/system/scripts/ but is ONLY called from
    .meta_marge/ context via a trigger wrapper. Regular users don't run this.
    
    IMPORTANT: Always checks marge-simpson/ (source), not .meta_marge/.
.PARAMETER MargeRoot
    Path to marge-simpson/ folder. If not provided, auto-detects from script location.
#>
param([string]$MargeRoot)

$ErrorActionPreference = "Stop"

# Auto-detect marge root if not provided
if (-not $MargeRoot) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    # Script is at marge-simpson/system/scripts/ - go up 2 levels
    $MargeRoot = (Get-Item "$scriptDir\..\..").FullName
}

# Verify we're checking the RIGHT folder (not .meta_marge)
$folderName = Split-Path -Leaf $MargeRoot
if ($folderName -eq ".meta_marge") {
    Write-Host "ERROR: Test is checking .meta_marge/ instead of marge-simpson/!" -ForegroundColor Red
    exit 1
}

Write-Host "`n============================================================"
Write-Host " Template Pollution Tests (Meta-Development Guard)"
Write-Host " Checking: $MargeRoot"
Write-Host "============================================================`n"

$passed = 0; $failed = 0

function Test-TemplateClean {
    param([string]$FilePath, [string]$MustNotContain, [string]$Description)
    $fullPath = Join-Path $MargeRoot $FilePath
    if (-not (Test-Path $fullPath)) { 
        Write-Host "  [SKIP] $Description - file not found"
        return $true 
    }
    $content = Get-Content $fullPath -Raw
    # Strip HTML comments to avoid false positives from template instructions
    $contentNoComments = $content -replace '(?s)<!--.*?-->', ''
    if ($contentNoComments -match $MustNotContain) {
        Write-Host "  [FAIL] $Description"
        Write-Host "         Found prohibited pattern: $MustNotContain"
        return $false
    }
    Write-Host "  [PASS] $Description"
    return $true
}

Write-Host "[1/4] Checking system/tracking/assessment.md..."
if (Test-TemplateClean -FilePath "system\tracking\assessment.md" -MustNotContain "### \[MS-\d{4}\]" -Description "No real MS-#### entries") { 
    $passed++ 
} else { 
    $failed++ 
}

# Check Next ID is still at MS-0001 (pristine template state)
$assessmentPath = Join-Path $MargeRoot "system\tracking\assessment.md"
if (Test-Path $assessmentPath) {
    $content = Get-Content $assessmentPath -Raw
    if ($content -match "Next ID:\*{0,2}\s*MS-0001") { 
        Write-Host "  [PASS] Pristine Next ID (MS-0001)"
        $passed++ 
    } else { 
        Write-Host "  [FAIL] Next ID incremented (should be MS-0001)"
        $failed++ 
    }
}

Write-Host "`n[2/4] Checking system/tracking/tasklist.md..."
if (Test-TemplateClean -FilePath "system\tracking\tasklist.md" -MustNotContain "- \[x\] \*\*MS-\d{4}" -Description "No completed MS-#### items") { 
    $passed++ 
} else { 
    $failed++ 
}

Write-Host "`n[3/4] Checking system/knowledge/decisions.md..."
if (Test-TemplateClean -FilePath "system\knowledge\decisions.md" -MustNotContain "### \[D-\d{3}\]" -Description "No real D-### entries") { 
    $passed++ 
} else { 
    $failed++ 
}

Write-Host "`n[4/4] Checking system/knowledge/ other files..."
if (Test-TemplateClean -FilePath "system\knowledge\patterns.md" -MustNotContain "### \[P-\d{3}\]" -Description "No real P-### entries") { 
    $passed++ 
} else { 
    $failed++ 
}
if (Test-TemplateClean -FilePath "system\knowledge\insights.md" -MustNotContain "### \[I-\d{3}\]" -Description "No real I-### entries") { 
    $passed++ 
} else { 
    $failed++ 
}
if (Test-TemplateClean -FilePath "system\knowledge\preferences.md" -MustNotContain "### \[PR-\d{3}\]" -Description "No real PR-### entries") { 
    $passed++ 
} else { 
    $failed++ 
}

Write-Host "`n============================================================"
Write-Host " Summary: Passed=$passed Failed=$failed"
Write-Host "============================================================`n"

if ($failed -gt 0) {
    Write-Host "TEMPLATE POLLUTION DETECTED!" -ForegroundColor Red
    Write-Host "Template files in marge-simpson/ must remain pristine." -ForegroundColor Yellow
    Write-Host "Users download this expecting clean templates." -ForegroundColor Yellow
    exit 1
}
Write-Host "All template pollution tests passed!" -ForegroundColor Green
exit 0
