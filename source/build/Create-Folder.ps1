Function Create-Folder(
    [string]
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $folder)
{
    Write-Host "Creating $folder folder..."
    New-Item -Path $folder -ItemType Directory | Out-Null
    Write-Host "Successfully created $folder folder."    
}
