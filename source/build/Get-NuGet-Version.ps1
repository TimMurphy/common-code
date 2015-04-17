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
