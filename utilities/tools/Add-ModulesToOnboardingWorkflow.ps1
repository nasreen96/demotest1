# <#
# .SYNOPSIS
#     This script performs a specific task (provide a brief description of what the script does).

# .DESCRIPTION
#     This script is designed to (provide a detailed description of the script's functionality and purpose).
#     It takes (mention any inputs or parameters) and produces (mention any outputs or results).

# .PARAMETER <ParameterName>
#     Description of the parameter and its purpose.

# .EXAMPLE
#     Provide an example of how to use the script.
#     PS> .\YourScript.ps1 -ParameterName value

# .NOTES
#     Author: Your Name
#     Date: Date of creation or modification
#     Version: Version of the script
#     Additional notes or information

# #>
# param (
#     [Parameter(Mandatory = $false)]
#     [string] $yamlFilePath = '.github\workflows\onboarding-workflow.yml',
#     [Parameter(Mandatory = $true)]
#     [array] $newOptions
# )

# # Load YAML module if not installed
# if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
#     Install-Module -Name powershell-yaml -Force
# }

# # Import YAML module
# Import-Module powershell-yaml

# # Validate parameters
# if (-not $yamlFilePath) {
#     Write-Error 'YAML file path is required.'
#     exit 1
# }

# if (-not $newOptions) {
#     Write-Error 'New options are required.'
#     exit 1
# }

# # Load the YAML content
# $yamlContent = Get-Content -Raw -Path "$yamlFilePath" | ConvertFrom-Yaml

# if ($yamlContent -and $yamlContent.on.workflow_dispatch.inputs.module.options) {
#     # Append Module list to existing options without duplicates
#     $yamlContent.on.workflow_dispatch.inputs.module.options = $yamlContent.on.workflow_dispatch.inputs.module.options + $newOptions | Select-Object -Unique
#     # Convert the content back to YAML and save
#     $yamlContent | ConvertTo-Yaml | Set-Content -Path $yamlFilePath

#     Write-Host 'YAML file updated successfully!'
# } else {
#     Write-Error "Invalid YAML structure or missing 'options' key."
#     exit 1
# }
# param (
#     [string]$yamlFilePath,
#     [string]$newOptions
# )

# # Load the YAML file
# $yaml = Get-Content $yamlFilePath -Raw | ConvertFrom-Yaml

# # Convert the new options string into an array
# $newOptionsArray = $newOptions -split ","

# # Ensure all new options are appended to the existing list of options under "module"
# if ($yaml.on.workflow_dispatch.inputs.module.options -is [array]) {
#     $yaml.on.workflow_dispatch.inputs.module.options = $yaml.on.workflow_dispatch.inputs.module.options + $newOptionsArray
# } else {
#     $yaml.on.workflow_dispatch.inputs.module.options = $newOptionsArray
# }

# # Remove duplicate options to avoid redundancy
# $yaml.on.workflow_dispatch.inputs.module.options = $yaml.on.workflow_dispatch.inputs.module.options | Sort-Object -Unique

# # Save the updated YAML file back
# $yaml | ConvertTo-Yaml | Set-Content $yamlFilePath
# Write-Host "Updated om.yml successfully!"

﻿<#
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
$yamlContent = Get-Content -Raw -Path "$yamlFilePath" | ConvertFrom-Yaml

if ($yamlContent -and $yamlContent.on.workflow_dispatch.inputs.module.options) {
    # Append Module list to existing options without duplicates
    $yamlContent.on.workflow_dispatch.inputs.module.options = $yamlContent.on.workflow_dispatch.inputs.module.options + $newOptions | Select-Object -Unique
    # Convert the content back to YAML and save
    $yamlContent | ConvertTo-Yaml | Set-Content -Path $yamlFilePath

    Write-Host 'YAML file updated successfully!'
} else {
    Write-Error "Invalid YAML structure or missing 'options' key."
    exit 1
}
