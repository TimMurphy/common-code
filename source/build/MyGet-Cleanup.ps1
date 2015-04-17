Function MyGet-Cleanup(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $packages)
{
    $buildRunner = $env:BuildRunner

    if ($buildRunner -eq "MyGet")
    {
        Write-Host
        Write-Host "Removing packages folder so MyGet doesn't publish any of them..."
        Remove-Item $packages -Recurse -Force
        Write-Host "Successfully removed packages folder."
    }
}
