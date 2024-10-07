# Function to generate the .cab file
function Create-CabFile {
    param (
        [string]$sourceDir,
        [string]$outputDir,
        [string]$ddfTemplatePath
    )

    # Ensure output directory exists
    if (-Not (Test-Path $outputDir)) {
        New-Item -Path $outputDir -ItemType Directory
    }

    # Read the .ddf template file
    $ddfTemplate = Get-Content -Path $ddfTemplatePath

    # Replace the <SourceDir> and <OutputDir> placeholders in the .ddf template
    $ddfContent = $ddfTemplate -replace "<SourceDir>", $sourceDir
    $ddfContent = $ddfContent -replace "<OutputDir>", $outputDir

    # Path to the new .ddf file in the output directory
    $ddfFilePath = Join-Path $outputDir "DemoApp.ddf"

    # Write the updated .ddf file
    Set-Content -Path $ddfFilePath -Value $ddfContent

    # Call the MakeCab tool to create the .cab file and wait for it to finish
    Write-Host "Creating .cab file..."
    Start-Process -NoNewWindow -FilePath "makecab.exe" -ArgumentList "/f `"$ddfFilePath`"" -Wait

    # Verify if the .cab file was created
    $cabFilePath = Join-Path $outputDir "DemoApp.cab"
    if (Test-Path $cabFilePath) {
        Write-Host "CAB file created successfully: $cabFilePath"
    } else {
        Write-Host "Error: CAB file was not created."
    }
}

$sourceDir = "DemoApp\bin\Debug"   # Path to the directory containing your app's files
$outputDir = (Get-Location).Path   # Directory where the .cab file will be created
$ddfTemplatePath = "template.ddf"  # Path to the .ddf template

# Call the function to create the .cab file
Create-CabFile -sourceDir $sourceDir -outputDir $outputDir -ddfTemplatePath $ddfTemplatePath
