# Jenkins-Helpers [![Build status](https://ci.appveyor.com/api/projects/status/50pw9dvc6f2h452i/branch/master?svg=true)](https://ci.appveyor.com/project/Oliver-Lii/jenkins-helpers/branch/master)
This module was written to support colour coding the output from a Jenkins Powershell step to enable improved legibility. Additional functionality may be added later and I will use this as a generic module to house Powershell functions specific to Jenkins jobs.

![wirte-jenkinsansiexample](https://user-images.githubusercontent.com/30263630/29353178-3898b282-8261-11e7-8967-06346f36f5b0.PNG)

# Pre-requisites
Requires [Color ANSI Console Output plugin](https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin) installed in Jenkins.

# Usage
This module can be installed from the PowerShell Gallery using the command below.
```
Install-Module Jenkins-Helpers -Repository PSGallery
```
## Write-JenkinsAnsi
The cmdlet outputs the text prepended with the ANSI character codes to colour the output in the Jenkins Console Output. If this function is not run on a Jenkins server then output will be sent to the appropriate "write-" cmdlet

```
Write-JenkinsAnsi - Message "Hello World" -Mt "Verbose"
```

# Authors
- Oliver Li
