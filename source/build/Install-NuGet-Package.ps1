Function Install-NuGet-Package(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $solutionFolder,
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $packageId,
    
    [boolean] $excludeVersion = $false,
    [string] $version)
{
    Write-Host "Checking if '$packageId' is installed..."

    $packages = Resolve-Path "$solutionFolder\packages"
    $nuGet = Resolve-Path "$packages\NuGet.exe"
    $nuGetConfig = Resolve-Path $solutionFolder\NuGet.config

    $options = "Install $packageId -OutputDirectory ""$packages"" -ConfigFile ""$nuGetConfig"""

    If ($excludeVersion)
    {
        $options += " -ExcludeVersion"

        If (Test-Path $packages\$packageId)
        {
            Write-Host "Package '$packageId' is already installed."
            return
        }
    }

    If (($version -ne $null) -and (Test-Path $packages\$packageId.$version))
    {
        Write-Host "Package '$packageId' is already installed."
        return
    }

    Invoke-Expression "&""$nuGet"" $options"

    If ($LASTEXITCODE -ne 0)
    {
        throw "Installing '$packageId' failed with ERRORLEVEL '$LASTEXITCODE'"
    }
}

