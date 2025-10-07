# UUID Generator and Pack Builder Script
# This script generates new UUIDs and builds the MCPACK
# Usage: .\generate_and_build.ps1 [pack_name]

param(
    [Parameter(Position=0)] [string]$Version = "1.0.0",
    [Parameter(Position=1)] [string]$PackName = "Angry_Cow_BP"
)

Write-Host "Generating new UUIDs and building pack..." -ForegroundColor Green

# Function to generate a new UUID
function New-UUID {
    return [System.Guid]::NewGuid().ToString()
}

$PackVersion = $Version

# Generate two new UUIDs
$headerUUID = New-UUID
$moduleUUID = New-UUID

Write-Host "Generated Header UUID: $headerUUID" -ForegroundColor Cyan
Write-Host "Generated Module UUID: $moduleUUID" -ForegroundColor Cyan

# Read the current manifest.json
$manifestPath = "manifest.json"
if (-not (Test-Path $manifestPath)) {
    Write-Host "ERROR: manifest.json not found!" -ForegroundColor Red
    exit 1
}


$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json

Write-Host "Using manifest: $manifestPath" -ForegroundColor Magenta

# Backup the manifest before modifying
$backupPath = "$manifestPath.bak"
Copy-Item -Path $manifestPath -Destination $backupPath -Force
Write-Host "Backed up original manifest to: $backupPath" -ForegroundColor DarkCyan

# Update UUIDs
$manifest.header.uuid = $headerUUID
$manifest.modules[0].uuid = $moduleUUID

# Parse version string into 3 integers (pad/truncate as necessary)
function Convert-VersionToArray($v) {
    $parts = $v -split '\.'
    $nums = @()
    for ($i = 0; $i -lt 3; $i++) {
        if ($i -lt $parts.Length) {
            $n = 0
            if ([int]::TryParse($parts[$i], [ref]$n)) { $nums += $n } else { $nums += 0 }
        } else {
            $nums += 0
        }
    }
    return ,$nums
}

$versionArray = Convert-VersionToArray $PackVersion

# Update pack name if different from default
if ($PackName -ne "Angry_Cow_BP") {
    $manifest.header.name = $PackName -replace "_", " "
    $manifest.header.description = "$PackName behavior pack - Makes cows aggressive!"
}

# Update version arrays in manifest
$manifest.header.version = $versionArray
$manifest.modules[0].version = $versionArray

# Write updated manifest back to file
$manifest | ConvertTo-Json -Depth 10 | Set-Content $manifestPath

Write-Host "Updated manifest.json with new UUIDs" -ForegroundColor Yellow

# Define the output filename and worlds directory
$mcpackName = if ($PackName.EndsWith(".mcpack")) { $PackName } else { "$PackName.mcpack" }
$outputDir = "worlds"

# Ensure output directory exists
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Remove existing mcpack file in the output directory if it exists
$destPath = Join-Path -Path $outputDir -ChildPath $mcpackName
if (Test-Path $destPath) {
    Write-Host "Removing existing $destPath..." -ForegroundColor Yellow
    Remove-Item $destPath -Force
}

# Define the files and folders to include in the pack
$packItems = @(
    "manifest.json",
    "entities",
    "spawn_rules",
    "items",
    "recipes"
)

# Check if all required files exist
$missingItems = @()
foreach ($item in $packItems) {
    if (-not (Test-Path $item)) {
        $missingItems += $item
    }
}

if ($missingItems.Count -gt 0) {
    Write-Host "ERROR: Missing required files/folders:" -ForegroundColor Red
    foreach ($missing in $missingItems) {
        Write-Host "  - $missing" -ForegroundColor Red
    }
    exit 1
}

# Create temporary zip file and move it to outputDir as .mcpack
$tempZip = "temp_pack.zip"
Write-Host "Creating $mcpackName in $outputDir..." -ForegroundColor Cyan

try {
    Compress-Archive -Path $packItems -DestinationPath $tempZip -Force
    # Move and rename to the worlds folder with .mcpack extension
    Move-Item -Path $tempZip -Destination $destPath -Force

    Write-Host "SUCCESS! Created $destPath with unique UUIDs" -ForegroundColor Green
    Write-Host ""
    Write-Host "Pack Details:" -ForegroundColor Yellow
    Write-Host "  Name: $($manifest.header.name)" -ForegroundColor White
    Write-Host "  Version: $PackVersion" -ForegroundColor White
    Write-Host "  Header UUID: $headerUUID" -ForegroundColor White
    Write-Host "  Module UUID: $moduleUUID" -ForegroundColor White
    Write-Host ""
    Write-Host "The pack has been output to the 'worlds' folder." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to create pack - $($_.Exception.Message)" -ForegroundColor Red
    if (Test-Path $tempZip) {
        Remove-Item $tempZip -Force
    }
    exit 1
}

# End of script