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

# Split and process each new option (split based on spaces, if applicable)
$processedOptions = @()
foreach ($option in $newOptions) {
    $option -split ' ' | ForEach-Object {
        $processedOptions += $_
    }
}

Write-Output "Processed Options: $processedOptions"

# Load the YAML content
Write-Output $newOptions
$yamlContent = Get-Content -Raw -Path "$yamlFilePath" | ConvertFrom-Yaml

if ($yamlContent -and $yamlContent.on.workflow_dispatch.inputs.module_path.options) {

    # Append Module list to existing options without duplicates
    $yamlContent.on.workflow_dispatch.inputs.module_path.options = $yamlContent.on.workflow_dispatch.inputs.module_path.options + $processedOptions | Select-Object -Unique
    # Convert the content back to YAML and save
    $yamlContent | ConvertTo-Yaml | Set-Content -Path $yamlFilePath

    Write-Host 'YAML file updated successfully!'
} else {
    Write-Error "Invalid YAML structure or missing 'options' key."
    exit 1
}
