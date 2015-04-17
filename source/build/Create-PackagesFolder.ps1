Function Create-PackagesFolder(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $packages)
{
    If (Test-Path $packages)
    {
        Write-Host "packages folder already exists."
    }
    Else
    {
        Write-Host "Creating packages folder..."
        New-Item -ItemType Directory -Path $packages -Force | Out-Null
        Write-Host "Successfully created packages folder."
    }
}

