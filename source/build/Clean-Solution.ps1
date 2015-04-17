Function Clean-Solution(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $sln,
        
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $configuration,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $artifacts)
{
    Delete-Bin-And-Obj-Folders $configuration
    Write-Host

    If (Test-Path $artifacts)
    {
        Write-Host "Removing artifacts folder..."
        Remove-Item $artifacts -Recurse -Force
        Write-Host "Successfully removed artifacts folder."
    }

    Write-Host "Running msbuild clean task..."
    Write-Host
    Exec { msbuild ""$sln"" /verbosity:minimal /property:Configuration=$configuration /target:Clean }

    Write-Host "Successfully ran msbuild clean task."
    Write-Host
}
