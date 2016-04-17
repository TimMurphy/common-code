Function Restore-NuGet-Packages(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $nuGet,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $nuGetConfig,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $sln,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $packages)
{
    Write-Host "Restoring any missing NuGet packages..."
    Write-Host

    Exec { Invoke-Expression "&""$nuGet"" install xunit.runner.console -OutputDirectory ""$packages"" -Verbosity normal -ConfigFile ""$nuGetConfig"" -ExcludeVersion -NonInteractive -Version 2.0.0" }
    Exec { Invoke-Expression "&""$nuGet"" restore ""$sln"" -PackagesDirectory ""$packages"" -Verbosity normal -ConfigFile ""$nuGetConfig"" -NonInteractive" }

    Write-Host
    Write-Host "Successfully restored missing NuGet packages."
    Write-Host
}
