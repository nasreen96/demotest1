<#
.SYNOPSIS
    Retrieves a list of modules from the Microsoft Container Registry (MCR).

.DESCRIPTION
    This script fetches and displays a list of available modules from the Microsoft Container Registry (MCR).
    It is useful for identifying and managing modules that can be used in various Azure projects.

.PARAMETER None
    This script does not take any parameters.

.EXAMPLE
    .\Get-ModuleListFromMcr.ps1
    Retrieves and displays the list of modules from MCR.

.NOTES
    Author: Savishwa
    FilePath: /c:/Users/savishwa/OneDrive - Microsoft/Project_Related/Proximus/Repo/azure_avm_iac_elements/utilities/tools/Get-ModuleListFromMcr.ps1
    Requires: PowerShell 5.1 or later

#>
param (
    [Parameter(Mandatory = $false)]
    [string] $RegistryUrl = 'https://mcr.microsoft.com/v2',
    [Parameter(Mandatory = $false)]
    [string] $ModuleRepoPath = 'bicep/avm/res'
)
# Construct the URL to fetch the catalog of repositories from the registry
$catalogUrl = "$($RegistryUrl)/_catalog"

# Initialize an ArrayList to store the module versions
$moduleListOutput = [System.Collections.ArrayList]::new()

# Write a verbose message indicating the URL being queried
# Write-Verbose "starting the process to fetch modules and versions from [$($catalogUrl)]" -Verbose

try {
    # Fetch the raw content of the catalog from the registry
    $catalogContentRaw = (Invoke-WebRequest -Uri $catalogUrl -UseBasicParsing).Content

    # Convert the raw JSON content to a PowerShell object and filter repositories by the module name
    $bicepCatalogContent = ($catalogContentRaw | ConvertFrom-Json).repositories | Select-String $ModuleRepoPath | Select-Object -Unique

    # If there are matching modules in the catalog
    if ($bicepCatalogContent) {
        # Iterate over each matching module
        foreach ($module in $bicepCatalogContent) {
            if ($module) {
                # Construct the URL to fetch the list of tags (versions) for the module
                $moduleVersionUrl = "$($RegistryUrl)/$($module)/tags/list"

                # Fetch the raw content of the module versions from the registry
                $moduleVersions = Invoke-WebRequest -Uri $moduleVersionUrl

                # # Convert the raw JSON content to a PowerShell object, sort tags in descending order, and select the latest tag
                # $moduleVersions | ConvertFrom-Json | Select-Object -ExpandProperty tags | Sort-Object -Descending | Select-Object -First 1 | ForEach-Object {
                #     # Construct the version tag with '-latest' suffix and add it to the output list
                #     $versionTag = "$($module)/$($_)-latest"
                #     $moduleListOutput.Add($versionTag) | Out-Null
                # }

                # Convert the raw JSON content to a PowerShell object and iterate over each tag
                $moduleVersions | ConvertFrom-Json | Select-Object -ExpandProperty tags | ForEach-Object {
                    # Construct the version tag and add it to the output list
                    $versionTag = "$($module)/$($_)"
                    $versionTag = $versionTag.ToString().Replace('bicep/avm/res/', '')
                    $moduleListOutput.Add($versionTag) | Out-Null
                }
            }

        }
        # Return the list of module versions
        return $moduleListOutput
    }
} catch {
    # Write a warning message if the web request fails
    Write-Warning ('Unable to fetch the modulets: {0}' -f $_.Exception.Message)
}
