<#
.Synopsis
   Write output with ANSI character set
.DESCRIPTION
   Write output with ANSI character set
.EXAMPLE
   Write-JenkinsAnsi - Message "Hello World" -Mt "Verbose"
.INPUTS
   Message - Message to output to the console
   MessageType - The type of message to be output
   ForegroundColor - The color of the text to be used when using 'host' message type
   JenkinsWkPath - Jenkins path to determine/evaluate if the function is being run on a Jenkins server workspace
.FUNCTIONALITY
    The cmdlet outputs the text prepended with the ANSI character codes to colour the output
    in the Jenkins Console Output. Requires Color ANSI Console Output plugin installed in Jenkins.
    If this function is not run on a Jenkins server then output will be sent to the appropriate "write-" cmdlet
#>
function Write-JenkinsAnsi 
{
    [CmdletBinding()]
    [OutputType([String])]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [AllowEmptyString()]
        [String]
        $Message,

        [Parameter()]
        [ValidateSet(
            'info'
            ,'host'
            ,'output'            
            ,'warning'
            ,'error'
            ,'debug'
            ,'verbose'
            ,'ok'
            ,'panic'
        )]
        [Alias('Mt')]
        [String]
        $MessageType='host',

        [Parameter()] 
        [ValidateSet(
             'black'
            ,'red'
            ,'green'
            ,'yellow'
            ,'blue'
            ,'magenta'
            ,'cyan'
            ,'white'
        )]
        [Alias('fgc')]   
        [String]
        $ForegroundColor='white',

        # Error params
        $ErrorID,
        $Category,
        $CategoryActivity,
        $CategoryReason,
        $CategoryTargetName,
        $CategoryTargetType,
        $TargetObject,
        $RecommendedAction,

        # Info params
        $Tags
    )

    Begin {
        $e = [char]27
        $fore = (Get-Variable "ForegroundColor").Attributes.ValidValues | ForEach-Object {$i=0} {@{$_=$i+30};$i++}

        # Check if we're called from a Write-* alias and set the messagetype appropriately if we are
        $Aliases = @("Write-Verbose", "Write-Info", "Write-Warning", "Write-Error", "Write-Debug")
        if($Aliases -contains $MyInvocation.InvocationName){
            $MessageType = $MyInvocation.InvocationName -replace 'Write-',''
        }

        switch($MessageType)
        {
            'info'{$ForegroundColor='white'}
            'output'{$ForegroundColor='white'}  
            'warning'{$ForegroundColor='yellow'}
            'error'{$ForegroundColor='red'}
            'debug'{$ForegroundColor='cyan'}
            'verbose'{$ForegroundColor='blue'}
            'ok'{$ForegroundColor='green'}
            'panic'{$ForegroundColor='magenta'}            
        }
        $Message = "$e[$($fore.$ForegroundColor)m$Message$e[$($fore.white)m"
    }

    Process {
        switch($MessageType)
        {            
            'info'{Microsoft.PowerShell.Utility\Write-Information $Message}
            'host'{Microsoft.PowerShell.Utility\Write-Host $Message}
            'output'{Microsoft.PowerShell.Utility\Write-Output $Message}                                
            'warning'{Microsoft.PowerShell.Utility\Write-warning $Message}
            'error'{Microsoft.PowerShell.Utility\Write-error $Message}
            'debug'{Microsoft.PowerShell.Utility\Write-debug $Message}
            'verbose'{Microsoft.PowerShell.Utility\Write-verbose $Message}
            'ok'{Microsoft.PowerShell.Utility\Write-host $Message}
            'panic'{Microsoft.PowerShell.Utility\Write-error $Message}  
        }    
    }
}