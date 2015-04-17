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

    Get-ChildItem -Path $testsFolder -Directory |
        ForEach-Object {

            $fullFolder = $_.FullName
            $folderName = $_.Name
            $testAssembly = "$fullFolder\bin\$configuration\$folderName.dll"

            Write-Host "Running tests in $folderName..."
            Write-Host "----------------------------------------------------------------------"
            Write-Host

            Exec { Invoke-Expression "&""$xUnit"" ""$testAssembly""" }
            
            Write-Host
            Write-Host "Successfully ran all tests in $folderName."
            Write-Host
        }
}
