Function Create-NuGet-Package(    
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $nuGet,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $nuSpec,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $nuPkg,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $outputDirectory,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $version)
{    
    Create-Folder -folder $outputDirectory

    Write-Host
    Write-Host "Creating $nuPkg..."
    Exec { Invoke-Expression "&""$nuGet"" pack ""$nuSpec"" -OutputDirectory ""$outputDirectory"" -Version $version" }
    Write-Host "Successfully created $nupkg."
}

