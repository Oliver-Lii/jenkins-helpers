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

        [Parameter()]     
        [String]
        $JenkinsWkPath = '.*jenkins\\workspace.*'
    )

    Begin {
        $e = [char]27
        $fore = (Get-Variable "ForegroundColor").Attributes.ValidValues | ForEach-Object {$i=0} {@{$_=$i+30};$i++}
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
    }

    Process {
        $workingPath = $(Resolve-path -Path ".\")
        if($workingPath -match $JenkinsWkPath)
        {
            switch($MessageType)
            {            
                'info'{Write-Information "$e[$($fore.$ForegroundColor)m$Message$e[$($fore.white)m"}
                'host'{Write-Host "$e[$($fore.$ForegroundColor)m$Message$e[$($fore.white)m"}
                'output'{Write-Output "$e[$($fore.$ForegroundColor)m$Message$e[$($fore.white)m"}                                
                'warning'{Write-warning "$e[$($fore.$ForegroundColor)m$Message$e[$($fore.white)m"}
                'error'{Write-error "$e[$($fore.$ForegroundColor)m$Message$e[$($fore.white)m"}
                'debug'{Write-debug "$e[$($fore.$ForegroundColor)m$Message$e[$($fore.white)m"}
                'verbose'{Write-verbose "$e[$($fore.$ForegroundColor)m$Message$e[$($fore.white)m"}
                'ok'{Write-host "$e[$($fore.$ForegroundColor)m$Message$e[$($fore.white)m"}
                'panic'{Write-error "$e[$($fore.$ForegroundColor)m$Message$e[$($fore.white)m"}  
            }    
        }
        else 
        {
            switch($MessageType)
            {               
                'info'{Write-Information $Message}
                'host'{Write-Host $Message -ForegroundColor $ForegroundColor}
                'output'{Write-Output $Message}                              
                'warning'{Write-warning $Message}
                'error'{Write-error $Message}
                'debug'{Write-debug $Message}
                'verbose'{Write-verbose $Message}
                'ok'{Write-host $Message -ForegroundColor Green}
                'panic'{Write-error $Message}    
            } 
        }
    }
}