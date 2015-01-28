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

Function Compile-Solution(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $sln,

    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $configuration)
{
    Write-Host "Compiling the solution..."
    Write-Host
    Exec { msbuild $sln /verbosity:minimal /property:Configuration=$configuration /target:Build }

    Write-Host
    Write-Host "Successfully compiled the solution."
    Write-Host
}

Function Create-PackagesFolder()
{
    If (Test-Path .\packages)
    {
        Write-Host "\packages folder already exists."
    }
    Else
    {
        Write-Host "Creating \packages folder..."
        New-Item -ItemType Directory -Path .\packages -Force | Out-Null
        Write-Host "Successfully created \packages folder."
    }
}

Function Delete-Bin-And-Obj-Folders(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $configuration)
{
    Write-Host "Deleting all bin\$configuration & obj\$configuration folders in $(Get-Location)..."
    Write-Host

    Get-ChildItem .\ -Include "bin","obj" -Recurse | 
        Get-ChildItem -Include $configuration |
        ForEach-Object { 

            $fullName = $_.FullName

            Write-Host "Deleting $fullName..."
            Remove-Item $fullName -Force -Recurse | Out-Null
        }

    Write-Host
    Write-Host "Successfully deleted all bin & obj folders."
}

Function Get-NuGet-Version()
{
    # MyGet sets PackageVersion environment variable.
    $version = $env:PackageVersion

    If ([string]::IsNullOrWhitespace($version))
    {
        $version = "0.0.0"
        Write-Host "NuGet package version is $version because environment variable PackageVersion is empty."
    }
    Else
    {
        Write-Host "NuGet package version is $version because environment variable PackageVersion is not empty."
    }

    Write-Host

    Return $version
}

Function Install-NuGet()
{
    If (Test-Path .\packages\NuGet.exe)
    {
    Write-Host "NuGet.exe is already installed."
        return
    }

    Write-Host "Installating NuGet.exe..."
    Invoke-WebRequest http://www.nuget.org/NuGet.exe -OutFile .\packages\NuGet.exe
    Write-Host "Successfully installed NuGet."
}

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

    Exec { Invoke-Expression "&""$nuGet"" install xunit.runners -OutputDirectory ""$packages"" -Verbosity normal -ConfigFile ""$nuGetConfig"" -ExcludeVersion -NonInteractive" }
    Exec { Invoke-Expression "&""$nuGet"" restore ""$sln"" -PackagesDirectory ""$packages"" -Verbosity normal -ConfigFile ""$nuGetConfig"" -NonInteractive" }

    Write-Host
    Write-Host "Successfully restored missing NuGet packages."
    Write-Host
}

Function Run-xUnit-Tests(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $xUnit,

    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $testsFolder,

    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $configuration)
{
    Write-Host

    Get-ChildItem -Path $testsFolder -Directory |
        ForEach-Object {

            $fullFolder = $_.FullName
            $folderName = $_.Name
            $testAssembly = "$fullFolder\bin\$configuration\$folderName.dll"

            Write-Host "Running tests in $folderName..."
            Write-Host "----------------------------------------------------------------------"
            Write-Host

            Exec { Invoke-Expression "&""$xUnit"" ""$testAssembly""" }
            
            Write-Host
            Write-Host "Successfully ran all tests in $folderName."
            Write-Host
        }
}