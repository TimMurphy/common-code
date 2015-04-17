Function Delete-Bin-And-Obj-Folders(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $configuration)
{
    $deletedFolders = $false
    Write-Host "Deleting all bin\$configuration & obj\$configuration folders in $(Get-Location)..."
    Write-Host

    Get-ChildItem .\ -Include "bin","obj" -Recurse | 
        Get-ChildItem -Include $configuration |
        ForEach-Object { 

            $fullName = $_.FullName

            Write-Host "Deleting $fullName..."
            Remove-Item $fullName -Force -Recurse | Out-Null
            $deletedFolders = $true
        }

    If ($deletedFolders)
    {
        Write-Host
        Write-Host "Successfully deleted all bin & obj folders."
    }
    Else
    {
        Write-Host "No bin or obj folders to delete."
    }
}
