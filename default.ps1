Task Default -Depends Deploy

Task Init {
    $script:Repository = "PSGallery"

    $script:ModuleName = Get-ChildItem | ?{$_.PSIsContainer -and $_.Name -notlike 'test*'} | Select -ExpandProperty Name
    if($script:ModuleName.GetType().BaseType.name -eq 'Array'){
        throw "More than one candidate for Module name!"
    }
    
    $script:ModuleRoot = ".\$script:ModuleName"
    $script:ModuleManifestPath = ".\$script:ModuleName\$script:ModuleName.psd1"
}

Task Test -depends Init{

    Remove-Module $script:ModuleName -Force -ErrorAction SilentlyContinue
    Import-Module $script:ModuleManifestPath -Force -ErrorAction Stop

    Push-Location .\tests
    $Params = @{
        Verbose = $False
    }

    # If we're in Jenkins, exit on build failure
    if( $env:APPVEYOR_BUILD_VERSION){
        $Params.add('EnableExit',$true)
    }
    
    Invoke-Pester @Params
    Pop-Location
}

Task UpdateManifest -depends Test {
    $Manifest = Test-ModuleManifest -Path $ModuleManifestPath
    [System.Version]$Version = $Manifest.Version
    if( $env:APPVEYOR_BUILD_VERSION){
        [string]$script:NewVersion = [version]::new($version.Major,$Version.Minor,  $env:APPVEYOR_BUILD_VERSION)
    }else{
        [string]$script:NewVersion = [version]::new($version.Major,$Version.Minor, $Version.Build+1)
    }

    Write-Host "New Version: $NewVersion"
    
    $FunctionList = @( Get-ChildItem -Path $ModuleRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue ).BaseName

    Update-ModuleManifest -Path $ModuleManifestPath -ModuleVersion $script:NewVersion -FunctionsToExport $functionList
}


Task Deploy -depends UpdateManifest {

    if(! $env:APPVEYOR_BUILD_VERSION){
        Write-Verbose "Not running in Jenkins, exiting"
        return
    }

    if(Find-Module -Name $script:ModuleName -Repository $script:Repository -MinimumVersion $script:NewVersion -ErrorAction SilentlyContinue){
        Write-Verbose "`tModule already published at this version [$NewVersion]"
        return
    }else{
        Write-Verbose "`tModule not published at [$NewVersion], proceeding with publishing"
    }
    
    if($env:APPVEYOR_REPO_BRANCH -eq 'master'){
        Remove-Module $script:ModuleName -Force -ErrorAction SilentlyContinue
        Publish-Module -Path $script:ModuleRoot -Repository $script:Repository -Verbose -NuGetApiKey $env:NugetAPIKey -Force
    }else{
        Write-Verbose "`tModule not publishing because we're not in the Master branch"
    }

}