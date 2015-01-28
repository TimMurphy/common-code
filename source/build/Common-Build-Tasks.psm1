Function Clean-Solution(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $sln,

    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $configuration)
{
    Delete-Bin-And-Obj-Folders $configuration
    Write-Host

    If (Test-Path .\artifacts)
    {
        Write-Host "Removing \artifacts folder..."
        Remove-Item .\artifacts -Recurse -Force
        Write-Host "Successfully removed \artifacts folder."
    }

    Write-Host "Running msbuild clean task..."
    Write-Host
    Exec { msbuild $sln /verbosity:minimal /property:Configuration=$configuration /target:Clean }

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
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $packageId,
    
    [boolean]
    $excludeVersion = $false) 
{
    Write-Host "Checking if '$packageId' is installed..."

    $options = "Install $packageId -OutputDirectory .\packages -ConfigFile .\NuGet.config"

    If ($excludeVersion)
    {
        $options += " -ExcludeVersion"

        If (Test-Path .\packages\$packageId)
        {
            Write-Host "Package '$packageId' is already installed."
            return
        }
    }

    # Beats me with Invoke-Expression is required. '& .\packages\NuGet.exe $options' does not work.
    Invoke-Expression "&.\packages\NuGet.exe $options"
}

Function Restore-NuGet-Packages(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $sln)
{
    Write-Host "Restoring any missing NuGet packages..."
    Write-Host

    Exec { & .\packages\NuGet.exe install xunit.runners -OutputDirectory .\packages -Verbosity normal -ConfigFile .\NuGet.config -ExcludeVersion -NonInteractive }
    Exec { & .\packages\NuGet.exe restore $sln -PackagesDirectory .\packages -Verbosity normal -ConfigFile .\NuGet.config -NonInteractive }

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

    Get-ChildItem -Path .\tests -Directory |
        ForEach-Object {

            $fullFolder = $_.FullName
            $folderName = $_.Name
            $testAssembly = "$fullFolder\bin\$configuration\$folderName.dll"

            Write-Host "Running tests in $folderName..."
            Write-Host "----------------------------------------------------------------------"
            Write-Host

            Exec { .$xUnit $testAssembly }
            
            Write-Host
            Write-Host "Successfully ran all tests in $folderName."
            Write-Host
        }
}