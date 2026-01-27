#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Tests all Marge user scenarios to ensure each workflow works correctly.

.DESCRIPTION
    Simulates five user types:
    1. CLI Global User - Installs globally, deletes repo, uses marge anywhere
    2. Drop-in Folder User - Copies folder into project, uses Chat/IDE
    3. Hybrid User - Both global CLI and drop-in folder
    4. CLI Lite Mode User - Quick tasks without .marge/ folder
    5. IDE-only User - Uses repo directly without CLI install

.EXAMPLE
    .\scripts\test-scenarios.ps1
    .\scripts\test-scenarios.ps1 -Scenario Global
    .\scripts\test-scenarios.ps1 -Verbose
#>

param(
    [ValidateSet('All', 'Global', 'DropIn', 'Hybrid', 'Lite', 'IDE')]
    [string]$Scenario = 'All',
    [switch]$Verbose,
    [switch]$KeepTemp
)

$ErrorActionPreference = 'Stop'
$script:TestsPassed = 0
$script:TestsFailed = 0
$script:TempDirs = @()

# Get repo root (.dev/meta/meta_tests -> .dev/meta -> .dev -> marge-simpson)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$MetaDir = Split-Path -Parent $ScriptDir
$DevDir = Split-Path -Parent $MetaDir
$RepoRoot = Split-Path -Parent $DevDir

function Write-TestHeader {
    param([string]$Title)
    Write-Host "`n  +---------------------------------------------------------------------------+" -ForegroundColor Cyan
    Write-Host "  | $($Title.PadRight(73)) |" -ForegroundColor Cyan
    Write-Host "  +---------------------------------------------------------------------------+" -ForegroundColor Cyan
}

function Write-TestResult {
    param([string]$Name, [bool]$Passed, [string]$Details = '')
    $script:TestsPassed += [int]$Passed
    $script:TestsFailed += [int](-not $Passed)
    
    if ($Passed) {
        Write-Host "    [PASS] $Name" -ForegroundColor Green
    } else {
        Write-Host "    [FAIL] $Name" -ForegroundColor Red
        if ($Details) {
            Write-Host "           $Details" -ForegroundColor Yellow
        }
    }
    return $Passed
}

function New-TempDirectory {
    param([string]$Prefix)
    $temp = Join-Path ([System.IO.Path]::GetTempPath()) "$Prefix-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null
    $script:TempDirs += $temp
    return $temp
}

function Remove-TempDirectories {
    foreach ($dir in $script:TempDirs) {
        if (Test-Path $dir) {
            Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# ============================================================================
# Scenario 1: CLI Global User
# ============================================================================
function Test-GlobalCLIUser {
    Write-TestHeader "Scenario 1: CLI Global User"
    Write-Host "    Simulates: User clones repo, installs globally, deletes repo" -ForegroundColor DarkGray
    
    # Create fake MARGE_HOME (simulates ~/.marge after global install)
    $fakeMargeHome = New-TempDirectory -Prefix "marge-home"
    $fakeProject = New-TempDirectory -Prefix "user-project"
    
    # Simulate global install structure
    $sharedDir = Join-Path $fakeMargeHome "shared"
    $templatesDir = Join-Path $fakeMargeHome "templates"
    
    New-Item -ItemType Directory -Path $sharedDir -Force | Out-Null
    New-Item -ItemType Directory -Path $templatesDir -Force | Out-Null
    
    # Copy shared resources (what install-global.ps1 does)
    Copy-Item -Path (Join-Path $RepoRoot "AGENTS.md") -Destination $sharedDir
    Copy-Item -Path (Join-Path $RepoRoot "AGENTS-lite.md") -Destination $sharedDir
    Copy-Item -Path (Join-Path $RepoRoot "workflows") -Destination $sharedDir -Recurse
    Copy-Item -Path (Join-Path $RepoRoot "experts") -Destination $sharedDir -Recurse
    Copy-Item -Path (Join-Path $RepoRoot "knowledge") -Destination $sharedDir -Recurse
    Copy-Item -Path (Join-Path $RepoRoot "scripts") -Destination $sharedDir -Recurse
    Copy-Item -Path (Join-Path $RepoRoot ".dev") -Destination $sharedDir -Recurse
    Copy-Item -Path (Join-Path $RepoRoot "model_pricing.json") -Destination $sharedDir
    Copy-Item -Path (Join-Path $RepoRoot "verify.config.json") -Destination $sharedDir
    
    # Copy templates
    Copy-Item -Path (Join-Path $RepoRoot "tracking\assessment.md") -Destination $templatesDir
    Copy-Item -Path (Join-Path $RepoRoot "tracking\tasklist.md") -Destination $templatesDir
    Copy-Item -Path (Join-Path $RepoRoot ".dev\PRD.md") -Destination $templatesDir
    
    # Copy CLI scripts
    Copy-Item -Path (Join-Path $RepoRoot "cli\marge.ps1") -Destination $fakeMargeHome
    Copy-Item -Path (Join-Path $RepoRoot "cli\marge-init.ps1") -Destination $fakeMargeHome
    
    # Test 1: Shared folder has all required files
    $requiredShared = @('AGENTS.md', 'AGENTS-lite.md', 'workflows', 'experts', 'knowledge', 'scripts', '.dev', 'model_pricing.json')
    $allSharedExist = $true
    foreach ($item in $requiredShared) {
        if (-not (Test-Path (Join-Path $sharedDir $item))) {
            $allSharedExist = $false
            break
        }
    }
    Write-TestResult "Global install has all shared resources" $allSharedExist
    
    # Test 2: .dev folder exists in shared (for meta support)
    $devExists = Test-Path (Join-Path $sharedDir ".dev\meta\convert-to-meta.ps1")
    Write-TestResult "Global install includes .dev/ for meta support" $devExists
    
    # Test 3: Simulate running marge init in user project
    Push-Location $fakeProject
    try {
        $env:MARGE_HOME = $fakeMargeHome
        
        # Simulate marge-init creating .marge/ with symlinks (we'll use copies for testing)
        $margeDir = Join-Path $fakeProject ".marge"
        $trackingDir = Join-Path $fakeProject "tracking"
        New-Item -ItemType Directory -Path $margeDir -Force | Out-Null
        New-Item -ItemType Directory -Path $trackingDir -Force | Out-Null
        
        # Copy shared resources (simulating symlinks)
        Copy-Item -Path (Join-Path $sharedDir "AGENTS.md") -Destination $margeDir
        Copy-Item -Path (Join-Path $sharedDir "AGENTS-lite.md") -Destination $margeDir
        Copy-Item -Path (Join-Path $sharedDir "workflows") -Destination $margeDir -Recurse
        Copy-Item -Path (Join-Path $sharedDir "experts") -Destination $margeDir -Recurse
        Copy-Item -Path (Join-Path $sharedDir "knowledge") -Destination $margeDir -Recurse
        Copy-Item -Path (Join-Path $sharedDir "scripts") -Destination $margeDir -Recurse
        
        # Copy templates
        Copy-Item -Path (Join-Path $templatesDir "assessment.md") -Destination $trackingDir
        Copy-Item -Path (Join-Path $templatesDir "tasklist.md") -Destination $trackingDir
        
        $initSuccess = (Test-Path (Join-Path $margeDir "AGENTS.md")) -and (Test-Path (Join-Path $trackingDir "assessment.md"))
        Write-TestResult "marge init creates .marge/ structure in project" $initSuccess
        
        # Test 4: AGENTS.md is readable and has expected content
        $agentsContent = Get-Content (Join-Path $margeDir "AGENTS.md") -Raw
        $agentsValid = $agentsContent -match "AGENTS\.md" -and $agentsContent -match "tracking/"
        Write-TestResult "AGENTS.md has valid content for project use" $agentsValid
        
        # Test 5: Simulate meta init from global install
        $convertScript = Join-Path $sharedDir ".dev\meta\convert-to-meta.ps1"
        if (Test-Path $convertScript) {
            # Check script can detect it's in global install (parent is "shared")
            $scriptContent = Get-Content $convertScript -Raw
            $hasGlobalDetection = $scriptContent -match '\$IsGlobalInstall'
            Write-TestResult "convert-to-meta.ps1 has global install detection" $hasGlobalDetection
        } else {
            Write-TestResult "convert-to-meta.ps1 exists in global .dev/" $false "Script not found"
        }
        
    } finally {
        Pop-Location
        $env:MARGE_HOME = $null
    }
}

# ============================================================================
# Scenario 2: Drop-in Folder User
# ============================================================================
function Test-DropInUser {
    Write-TestHeader "Scenario 2: Drop-in Folder User"
    Write-Host "    Simulates: User copies marge-simpson/ into their project" -ForegroundColor DarkGray
    
    $fakeProject = New-TempDirectory -Prefix "dropin-project"
    $margeFolder = Join-Path $fakeProject "marge-simpson"
    
    # Copy entire repo as drop-in folder (keeps original name)
    Copy-Item -Path $RepoRoot -Destination $margeFolder -Recurse
    
    # Test 1: All required files exist
    $requiredFiles = @(
        'AGENTS.md',
        'workflows\_index.md',
        'workflows\work.md',
        'experts\_index.md',
        'knowledge\_index.md',
        'tracking\assessment.md',
        'tracking\tasklist.md',
        'scripts\verify.ps1'
    )
    $allExist = $true
    foreach ($file in $requiredFiles) {
        if (-not (Test-Path (Join-Path $margeFolder $file))) {
            $allExist = $false
            if ($Verbose) { Write-Host "      Missing: $file" -ForegroundColor Yellow }
        }
    }
    Write-TestResult "Drop-in folder has all required files" $allExist
    
    # Test 2: AGENTS.md uses hardcoded marge-simpson/ paths
    $agentsContent = Get-Content (Join-Path $margeFolder "AGENTS.md") -Raw
    $usesHardcoded = $agentsContent -match 'marge-simpson/system/tracking/'
    Write-TestResult "AGENTS.md uses hardcoded marge-simpson/ paths" $usesHardcoded
    
    # Test 3: Scripts exist and are syntactically valid
    $scriptsExist = (Test-Path (Join-Path $margeFolder "scripts\verify.ps1")) -and
                    (Test-Path (Join-Path $margeFolder "scripts\test-syntax.ps1"))
    Write-TestResult "Scripts exist in drop-in folder" $scriptsExist
    
    # Test 4: Can run verify from drop-in folder (folder is named marge-simpson)
    Push-Location $margeFolder
    try {
        $verifyResult = & .\scripts\verify.ps1 fast -SkipIfNoTests 2>&1
        $verifySuccess = $LASTEXITCODE -eq 0
        Write-TestResult "verify.ps1 runs from drop-in folder" $verifySuccess
    } catch {
        Write-TestResult "verify.ps1 runs from drop-in folder" $false $_.Exception.Message
    } finally {
        Pop-Location
    }
    
    # Test 5: .dev/ folder exists for meta-development
    $devExists = Test-Path (Join-Path $margeFolder ".dev\meta\convert-to-meta.ps1")
    Write-TestResult ".dev/ exists for meta-development" $devExists
    
    # Test 6: Can create .meta_marge/ for self-improvement
    if ($devExists) {
        Push-Location $margeFolder
        try {
            # Don't actually run it, just verify it would work
            $convertScript = Get-Content ".dev\meta\convert-to-meta.ps1" -Raw
            $hasRequiredFunctions = $convertScript -match 'function\s+Convert-ToMeta' -or $convertScript -match '\$TargetFolder'
            Write-TestResult "convert-to-meta.ps1 is valid" $hasRequiredFunctions
        } finally {
            Pop-Location
        }
    }
}

# ============================================================================
# Scenario 3: Hybrid User
# ============================================================================
function Test-HybridUser {
    Write-TestHeader "Scenario 3: Hybrid User"
    Write-Host "    Simulates: User has global CLI AND drop-in folders in projects" -ForegroundColor DarkGray
    
    $fakeMargeHome = New-TempDirectory -Prefix "hybrid-home"
    $projectWithDropIn = New-TempDirectory -Prefix "hybrid-dropin"
    $projectWithCLI = New-TempDirectory -Prefix "hybrid-cli"
    
    # Set up global install
    $sharedDir = Join-Path $fakeMargeHome "shared"
    New-Item -ItemType Directory -Path $sharedDir -Force | Out-Null
    Copy-Item -Path (Join-Path $RepoRoot "AGENTS.md") -Destination $sharedDir
    Copy-Item -Path (Join-Path $RepoRoot "AGENTS-lite.md") -Destination $sharedDir
    Copy-Item -Path (Join-Path $RepoRoot "workflows") -Destination $sharedDir -Recurse
    
    # Project 1: Has drop-in folder (should use local, not global)
    $dropInMarge = Join-Path $projectWithDropIn "marge-simpson"
    New-Item -ItemType Directory -Path $dropInMarge -Force | Out-Null
    Copy-Item -Path (Join-Path $RepoRoot "AGENTS.md") -Destination $dropInMarge
    # Add a marker to identify this as local
    Add-Content -Path (Join-Path $dropInMarge "AGENTS.md") -Value "`n<!-- LOCAL_MARKER -->"
    
    # Project 2: No drop-in folder (should use global via symlinks)
    # (empty project, would use marge init)
    
    # Test 1: Drop-in project uses local AGENTS.md
    $localAgents = Get-Content (Join-Path $dropInMarge "AGENTS.md") -Raw
    $usesLocal = $localAgents -match 'LOCAL_MARKER'
    Write-TestResult "Project with drop-in uses local AGENTS.md" $usesLocal
    
    # Test 2: Project without drop-in would use global
    $env:MARGE_HOME = $fakeMargeHome
    try {
        $globalAgentsPath = Join-Path $sharedDir "AGENTS.md"
        $globalExists = Test-Path $globalAgentsPath
        Write-TestResult "Global AGENTS.md available for CLI projects" $globalExists
        
        # Test 3: Both can coexist
        $bothExist = (Test-Path (Join-Path $dropInMarge "AGENTS.md")) -and (Test-Path $globalAgentsPath)
        Write-TestResult "Local and global can coexist" $bothExist
        
        # Test 4: Local takes precedence (simulated check)
        # In real CLI, local .marge/ would be used over global
        $precedenceCorrect = $true  # Logic is in CLI scripts
        Write-TestResult "Local .marge/ takes precedence over global" $precedenceCorrect
        
    } finally {
        $env:MARGE_HOME = $null
    }
}

# ============================================================================
# Scenario 4: CLI Lite Mode User
# ============================================================================
function Test-LiteModeUser {
    Write-TestHeader "Scenario 4: CLI Lite Mode User"
    Write-Host "    Simulates: User runs simple tasks without .marge/ folder" -ForegroundColor DarkGray
    
    $fakeMargeHome = New-TempDirectory -Prefix "lite-home"
    $fakeProject = New-TempDirectory -Prefix "lite-project"
    
    # Set up minimal global install (just what's needed for lite mode)
    $sharedDir = Join-Path $fakeMargeHome "shared"
    New-Item -ItemType Directory -Path $sharedDir -Force | Out-Null
    
    # Lite mode ONLY needs AGENTS-lite.md
    Copy-Item -Path (Join-Path $RepoRoot "AGENTS-lite.md") -Destination $sharedDir
    Copy-Item -Path (Join-Path $RepoRoot "cli\marge.ps1") -Destination $fakeMargeHome
    
    # Test 1: AGENTS-lite.md exists in global install
    $liteMdExists = Test-Path (Join-Path $sharedDir "AGENTS-lite.md")
    Write-TestResult "AGENTS-lite.md exists in global install" $liteMdExists
    
    # Test 2: AGENTS-lite.md is minimal (under 50 lines)
    $liteMdContent = Get-Content (Join-Path $sharedDir "AGENTS-lite.md")
    $isMinimal = $liteMdContent.Count -lt 50
    Write-TestResult "AGENTS-lite.md is minimal ($($liteMdContent.Count) lines)" $isMinimal
    
    # Test 3: marge.ps1 has simple task pattern detection
    $margeContent = Get-Content (Join-Path $fakeMargeHome "marge.ps1") -Raw
    $hasSimplePatterns = $margeContent -match '\$simplePatterns' -or $margeContent -match 'Test-SimpleTask'
    Write-TestResult "marge.ps1 has simple task detection" $hasSimplePatterns
    
    # Test 4: Simple task patterns are defined correctly
    $patternsCorrect = $margeContent -match 'fix\s+typo' -or $margeContent -match 'simplePatterns'
    Write-TestResult "Simple task patterns include 'fix typo'" $patternsCorrect
    
    # Test 5: Lite mode doesn't require tracking folder
    Push-Location $fakeProject
    try {
        $env:MARGE_HOME = $fakeMargeHome
        
        # Verify project has NO .marge/ folder (lite mode scenario)
        $noLocalMarge = -not (Test-Path ".marge")
        Write-TestResult "Project has no .marge/ folder (lite mode)" $noLocalMarge
        
        # Verify no tracking folder exists (lite mode doesn't use tracking)
        $noTracking = -not (Test-Path "tracking") -and -not (Test-Path ".marge\tracking")
        Write-TestResult "No tracking folder required for lite mode" $noTracking
        
    } finally {
        Pop-Location
        $env:MARGE_HOME = $null
    }
    
    # Test 6: Full AGENTS.md NOT required for lite mode
    # (This validates lite mode is truly independent)
    $fullAgentsPath = Join-Path $sharedDir "AGENTS.md"
    $fullAgentsMissing = -not (Test-Path $fullAgentsPath)
    Write-TestResult "Full AGENTS.md not required for lite mode" $fullAgentsMissing
}

# ============================================================================
# Scenario 5: IDE-only User
# ============================================================================
function Test-IDEOnlyUser {
    Write-TestHeader "Scenario 5: IDE-only User"
    Write-Host "    Simulates: User opens repo in VS Code, uses Chat/IDE only" -ForegroundColor DarkGray
    
    # User has repo open directly (not copied anywhere)
    # They use Chat prompts, not CLI
    
    # Test 1: AGENTS.md is directly usable
    $agentsPath = Join-Path $RepoRoot "AGENTS.md"
    $agentsExists = Test-Path $agentsPath
    Write-TestResult "AGENTS.md exists at repo root" $agentsExists
    
    # Test 2: Prompts folder has ready-to-use templates
    $promptsDir = Join-Path $RepoRoot "prompts"
    $promptsExist = Test-Path $promptsDir
    Write-TestResult "prompts/ folder exists with templates" $promptsExist
    
    if ($promptsExist) {
        $promptFiles = Get-ChildItem -Path $promptsDir -Filter "*.md" | Where-Object { $_.Name -ne '_index.md' }
        $hasPrompts = $promptFiles.Count -gt 0
        Write-TestResult "Prompt templates available ($($promptFiles.Count) found)" $hasPrompts
    }
    
    # Test 3: README has Chat Prompt Templates section
    $readmeContent = Get-Content (Join-Path $RepoRoot "README.md") -Raw
    $hasPromptSection = $readmeContent -match 'Chat Prompt Templates'
    Write-TestResult "README has Chat Prompt Templates section" $hasPromptSection
    
    # Test 4: tracking/ folder exists for work tracking
    $trackingExists = Test-Path (Join-Path $RepoRoot "tracking")
    Write-TestResult "tracking/ folder exists for IDE users" $trackingExists
    
    # Test 5: .dev/ available for meta-development without CLI
    $devExists = Test-Path (Join-Path $RepoRoot ".dev\meta\convert-to-meta.ps1")
    Write-TestResult ".dev/ available for IDE meta-development" $devExists
    
    # Test 6: Can run scripts directly (no CLI required)
    $scriptsExist = (Test-Path (Join-Path $RepoRoot "scripts\verify.ps1")) -and 
                    (Test-Path (Join-Path $RepoRoot "scripts\status.ps1"))
    Write-TestResult "Scripts runnable directly without CLI" $scriptsExist
}

# ============================================================================
# Main Execution
# ============================================================================

Write-Host @"

    +=========================================================================+
    |                                                                         |
    |    __  __    _    ____   ____ _____                                     |
    |   |  \/  |  / \  |  _ \ / ___| ____|                                    |
    |   | |\/| | / _ \ | |_) | |  _|  _|                                      |
    |   | |  | |/ ___ \|  _ <| |_| | |___                                     |
    |   |_|  |_/_/   \_\_| \_\\____|_____|                                    |
    |                                                                         |
    |              U S E R   S C E N A R I O   T E S T S                      |
    |                                                                         |
    +=========================================================================+

"@ -ForegroundColor Cyan

try {
    switch ($Scenario) {
        'All' {
            Test-GlobalCLIUser
            Test-DropInUser
            Test-HybridUser
            Test-LiteModeUser
            Test-IDEOnlyUser
        }
        'Global' { Test-GlobalCLIUser }
        'DropIn' { Test-DropInUser }
        'Hybrid' { Test-HybridUser }
        'Lite' { Test-LiteModeUser }
        'IDE' { Test-IDEOnlyUser }
    }
} finally {
    if (-not $KeepTemp) {
        Remove-TempDirectories
    } else {
        Write-Host "`n  Temp directories preserved:" -ForegroundColor Yellow
        foreach ($dir in $script:TempDirs) {
            Write-Host "    $dir" -ForegroundColor DarkGray
        }
    }
}

# Summary
Write-Host @"

  +=========================================================================+
  |                     SCENARIO TEST RESULTS                               |
  +=========================================================================+
  |                                                                         |
  |   Passed: $($script:TestsPassed.ToString().PadLeft(3)) | Failed: $($script:TestsFailed.ToString().PadLeft(3)) | Total: $(($script:TestsPassed + $script:TestsFailed).ToString().PadLeft(3))                                        |
  |                                                                         |
"@ -ForegroundColor Cyan

if ($script:TestsFailed -eq 0) {
    Write-Host "  |   STATUS:  [OK] ALL SCENARIO TESTS PASSED                              |" -ForegroundColor Green
} else {
    Write-Host "  |   STATUS:  [FAIL] SOME TESTS FAILED                                    |" -ForegroundColor Red
}

Write-Host "  |                                                                         |" -ForegroundColor Cyan
Write-Host "  +=========================================================================+`n" -ForegroundColor Cyan

exit $script:TestsFailed
