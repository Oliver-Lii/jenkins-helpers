<#
.Synopsis
   This cmdlet monkeypatches Write-Verbose, Warning, Error, Debug, and Info to prepend them with the appropriate ANSI colors for use in Jenkins
.DESCRIPTION
   This cmdlet monkeypatches Write-Verbose, Warning, Error, Debug, and Info to prepend them with the appropriate ANSI colors for use in Jenkins
.EXAMPLE
   Set-JenkinsAnsiAliases
#>
Function Set-JenkinsAnsiAliases{
    $Aliases = @("Write-Verbose", "Write-Info", "Write-Warning", "Write-Error", "Write-Debug")
    foreach($Alias in $Aliases){
        Write-Verbose "Aliasing $Alias to Write-JenkinsAnsi"
        Set-Alias $Alias Write-JenkinsAnsi -Scope global
    }
}