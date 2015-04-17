Function Create-Bin-Artifacts(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $bin,

    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $artifacts)
{
    Create-Folder -folder $artifacts

    Write-Host
    Write-Host "Copying artifacts to $artifacts..."
    Get-ChildItem -Path $bin |
        Copy-Item -Destination $artifacts
    Write-Host "Successfully copied artifacts to $artifacts."

    Write-Host
}
