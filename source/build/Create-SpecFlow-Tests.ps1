Function Create-SpecFlow-Tests(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $specFlow,

    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $project)
{
    Write-Host "Creating SpecFlow test files for $project..."
    Write-Host

    Exec { Invoke-Expression "&""$specFlow"" generateall ""$project"" /force" }

    Write-Host
    Write-Host "Successfully created SpecFlow test files for $project."
    Write-Host
}
