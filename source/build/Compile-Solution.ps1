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
