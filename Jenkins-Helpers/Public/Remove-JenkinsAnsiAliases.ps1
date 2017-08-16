<#
.Synopsis
   This cmdlet removes the monkeypatches of Write-Verbose, Warning, Error, Debug, and Info setup by Set-JenkinsAnsiAliases
.DESCRIPTION
   This cmdlet removes the monkeypatches of Write-Verbose, Warning, Error, Debug, and Info setup by Set-JenkinsAnsiAliases
.EXAMPLE
   Remove-JenkinsAnsiAliases
#>
Function Remove-JenkinsAnsiAliases{
    $Aliases = @("Write-Verbose", "Write-Info", "Write-Warning", "Write-Error", "Write-Debug")
    foreach($Alias in $Aliases){
        Write-Verbose "Removing $Alias"
        Remove-Item alias:\$Alias
    }
}