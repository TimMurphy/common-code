# Creates specflow.exe.config so specflow.exe will run with .net 4.0.
Function Create-SpecFlow-Config(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $specFlowToolsFolder)
{
    $specFlowConfig = "$specFlowToolsFolder\specflow.exe.config"

    Write-Host "Creating $specFlowConfig..."

    Remove-Item $specFlowConfig -ErrorAction SilentlyContinue
    Add-Content $specFlowConfig "<?xml version=""1.0"" encoding=""utf-8"" ?>"
    Add-Content $specFlowConfig "<configuration>"
    Add-Content $specFlowConfig "<startup>"
    Add-Content $specFlowConfig "<supportedRuntime version=""v4.0.30319"" />"
    Add-Content $specFlowConfig "</startup>"
    Add-Content $specFlowConfig "</configuration>"

    Write-Host "Successfully created $specFlowConfig."
    Write-Host
}
