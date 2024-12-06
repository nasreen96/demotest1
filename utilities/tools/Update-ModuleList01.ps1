<#
.SYNOPSIS
    This script performs a specific task (provide a brief description of what the script does).

.DESCRIPTION
    This script is designed to (provide a detailed description of the script's functionality and purpose).
    It takes (mention any inputs or parameters) and produces (mention any outputs or results).

.PARAMETER <ParameterName>
    Description of the parameter and its purpose.

.EXAMPLE
    Provide an example of how to use the script.
    PS> .\YourScript.ps1 -ParameterName value

.NOTES
    Author: Your Name
    Date: Date of creation or modification
    Version: Version of the script
    Additional notes or information

#>
param (
    [Parameter(Mandatory = $false)]
    [string] $yamlFilePath = '.github\workflows\onboarding-workflow.yml',
    [Parameter(Mandatory = $true)]
    [array] $newOptions
)

# Load YAML module if not installed
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml -Force
}

# Import YAML module
Import-Module powershell-yaml

# Validate parameters
if (-not $yamlFilePath) {
    Write-Error 'YAML file path is required.'
    exit 1
}

if (-not $newOptions) {
    Write-Error 'New options are required.'
    exit 1
}

# Load the YAML content
Write-Output "Provided new options: $newOptions"
$yamlContent = Get-Content -Raw -Path "$yamlFilePath" | ConvertFrom-Yaml

# Check if the YAML content contains the required structure
if ($yamlContent -and $yamlContent.on.workflow_dispatch.inputs.module_path.options) {
    # Combine existing options with new options, ensuring uniqueness
    $updatedOptions = $yamlContent.on.workflow_dispatch.inputs.module_path.options + $newOptions | Select-Object -Unique

    # Reformat the options so each entry is on a new line
    $yamlContent.on.workflow_dispatch.inputs.module_path.options = $updatedOptions

    # Convert the YAML back to a string and ensure proper indentation for the array
    $yamlString = $yamlContent | ConvertTo-Yaml
    $yamlString = $yamlString -replace 'options: \[', "options:" # Start new line for 'options'
    $yamlString = $yamlString -replace '\],', ""                # Remove ending array brackets
    $yamlString = $yamlString -replace '\s*"(.*?)"', "- `$1"    # Format each option properly

    # Save the reformatted YAML back to the file
    Set-Content -Path $yamlFilePath -Value $yamlString

    Write-Host 'YAML file updated successfully!'
} else {
    Write-Error "Invalid YAML structure or missing 'options' key."
    exit 1
}
