# Import all *.ps1 files in this folder.
Get-Item -Path $PSScriptRoot\*.ps1 |
    ForEach-Object {
        Write-Verbose "Importing $($_.Name)..."
        . $_.FullName
    }