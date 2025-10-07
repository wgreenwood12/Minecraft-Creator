# UUID Generator and Pack Builder Script
# This script generates new UUIDs and builds the MCPACK
# Usage: .\generate_and_build.ps1 [pack_name]

param(
    [string]$PackName = "Angry_Cow_BP"
)

Write-Host "Generating new UUIDs and building pack..." -ForegroundColor Green

# Function to generate a new UUID
function New-UUID {
    return [System.Guid]::NewGuid().ToString()
}

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

# Update UUIDs
$manifest.header.uuid = $headerUUID
$manifest.modules[0].uuid = $moduleUUID

# Update pack name if different from default
if ($PackName -ne "Angry_Cow_BP") {
    $manifest.header.name = $PackName -replace "_", " "
    $manifest.header.description = "$PackName behavior pack - Makes cows aggressive!"
}

# Write updated manifest back to file
$manifest | ConvertTo-Json -Depth 10 | Set-Content $manifestPath

Write-Host "Updated manifest.json with new UUIDs" -ForegroundColor Yellow

# Define the output filename
$mcpackName = if ($PackName.EndsWith(".mcpack")) { $PackName } else { "$PackName.mcpack" }

# Remove existing mcpack file if it exists
if (Test-Path $mcpackName) {
    Write-Host "Removing existing $mcpackName..." -ForegroundColor Yellow
    Remove-Item $mcpackName -Force
}

# Define the files and folders to include in the pack
$packItems = @(
    "manifest.json",
    "entities",
    "loot_tables",
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

# Create temporary zip file
$tempZip = "temp_pack.zip"
Write-Host "Creating $mcpackName..." -ForegroundColor Cyan

try {
    Compress-Archive -Path $packItems -DestinationPath $tempZip -Force
    Rename-Item $tempZip $mcpackName
    
    Write-Host "SUCCESS! Created $mcpackName with unique UUIDs" -ForegroundColor Green
    Write-Host ""
    Write-Host "Pack Details:" -ForegroundColor Yellow
    Write-Host "  Name: $($manifest.header.name)" -ForegroundColor White
    Write-Host "  Header UUID: $headerUUID" -ForegroundColor White
    Write-Host "  Module UUID: $moduleUUID" -ForegroundColor White
    Write-Host ""
    Write-Host "This pack can now be installed alongside other versions!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to create pack - $($_.Exception.Message)" -ForegroundColor Red
    if (Test-Path $tempZip) {
        Remove-Item $tempZip -Force
    }
    exit 1
}