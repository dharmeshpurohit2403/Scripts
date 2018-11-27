param(
[Parameter(Mandatory=$True,Position=0)]
[string]$Env,

[Parameter(Mandatory=$True,Position=1)]
[String]$SlnFile,

[Parameter(Mandatory=$True,Position=2)]
[string]$ProjectName,

[Parameter(Mandatory=$True,Position=3)]
[string]$Sources,

[Parameter(Mandatory=$True,Position=4)]
[String]$Type,

[Parameter(Mandatory=$True,Position=5)]
[String]$BackupFileName,

[Parameter(Mandatory=$True,Position=6)]
[String]$FromBranch,

[Parameter(Mandatory=$True,Position=7)]
[String]$RequestedBy,

[Parameter(Mandatory=$True,Position=8)]
[String]$ControllerUsed,

[Parameter(Mandatory=$True,Position=9)]
[String]$AgentName,

[Parameter(Position=10)]
[String]$UserName_OnP,

[Parameter(Position=11)]
[String]$Password_OnP
)
Import-Module $Sources\Common\PowerShellScripts\modules\utility.psm1 -Force

$obj = (Get-Content -Path $Sources\Common\PowerShellScripts\ConfigStacks\$Env.json -Raw) | ConvertFrom-Json

### script variables
$AutoDeploymentComments=""

#### Modified Variables
$MSBuildLog = $Sources+"\MSBuild.Log"
$MSBuildErrLog = $Sources+"\MSBuildErr.Log"
$DeployedFilesLog = $Sources+"\MSDeploy.Log"
$DeployedFilesErrLog = $Sources+"\MSDeployErr.Log"

### Read From Json Environments branch independent
$UserName = $obj.$Type.$ProjectName.UserName
$Password = $obj.$Type.$ProjectName.Password
$RemoteServer = $obj.$Type.$ProjectName.DeployServer
$MailRecepients = $obj.$Type.$ProjectName.MailRecepients

### Read From Json Environments branch dependent
$DeployFromLocation = $obj.$Type.$ProjectName.$FromBranch.DeployFromLocation
$currentSiteLocation = $obj.$Type.$ProjectName.$FromBranch.DeployToLocation
$MSBuildCompileArgument = $obj.$Type.$ProjectName.$FromBranch.MSBuildCompileArgument
$MSBuildArgument = $obj.$Type.$ProjectName.$FromBranch.MSBuildArgument
$MSDeployExtraArguments = $obj.$Type.$ProjectName.$FromBranch.MSDeployExtraArguments
$DeleteExtraFolders = $obj.$Type.$ProjectName.$FromBranch.DeleteExtraFolders
$BackupLocation = $obj.$Type.$ProjectName.$FromBranch.BackupLocation
$IsBuildRequired = $obj.$Type.$ProjectName.$FromBranch.IsBuildRequired

### *** ONLY  If Type is service
$ServiceName = $obj.$Type.$ProjectName.ServiceName

#### change if run time password and user name is given
if($UserName_OnP -ne "" -and $Password_OnP -ne "")
{
    Write-Host "Replacing username and password with runtime"
    $UserName = $UserName_OnP
    $Password = $Password_OnP
}

try{
    try{
     &  $Sources\Common\PowerShellScripts\RemoveReadOnly.ps1 -Sources $Sources
     }
     catch{
     $_ | Out-File -FilePath $Sources\RemoveReadOnly.log
     }
    ### Nuget Restore
    try{
        get-childitem $Sources -recurse | where {$_.extension -eq ".sln"} | % {
         Write-Host $_.FullName
         nuget restore $_.FullName 
        }
        "nuget completed" | Out-File -FilePath $Sources\CurrentRunningStatus.log
    }
    catch{
        Write-Warning "Some nuget restore falied"
        "nuget failed" | Out-File -FilePath $Sources\CurrentRunningStatus.log
    }
    ###  Compiling the changes
    if($IsBuildRequired.ToUpper() -eq "TRUE")
    {
        Write-Host "msbuild $SlnFile $MSBuildCompileArgument > $MSBuildLog 2> $MSBuildErrLog"
        $MSBuildCompileRun = "msbuild $SlnFile $MSBuildCompileArgument > $MSBuildLog 2> $MSBuildErrLog"
        try
        {
            $er = (invoke-expression $MSBuildCompileRun) 2>&1 
            if ($lastexitcode) {throw $er}
            "MSBuild compile complete" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
        }
        catch
        {
            "MSbuild compile failed" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
            $MSBuildCompileRun |  Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
            throw "1"
        }
    } 
    
    ### get remote session from utility module
    $PSSession = GetRemoteSession -UserName $UserName -Password $Password -ComputerName $RemoteServer        
    if($PSSession -eq 0)
    {
        "session can not creted" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
        throw "8"
    }
    #### Execute backup step from utility module and return
    #### 1 for success or 2 for failure
    $PSVersion = GetPowershellVersion -PSSession $PSSession
    if($PSVersion -ge "5")
    {
        Write-Host "Powershell step to create backup"
        $BackupStatus = CreateBackup -PSSession $PSSession -BackUpWebsitePath $currentSiteLocation -BackUpLocation $BackupLocation -BackUpFileName $BackupFileName
    }
    else
    {
        $BackupStatus = CreateBackupUsingMSDeploy -PSSession $PSSession -UserName $UserName -Password $Password -ComputerName $RemoteServer -BackUpWebsitePath $currentSiteLocation -BackUpLocation $BackupLocation -BackUpFileName $BackupFileName
    }

    #### If backup failed
    if($BackupStatus -eq "0")
    {
    "Backup Failed" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
        throw "2"
    }
    "Backup Completed" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append

    if($IsBuildRequired.ToUpper() -eq "TRUE")
    {
        #### If msbuild compile and backup step completed then msbuild for deploy. it will reflect the files which going to be changed in deployment
        $MSBuildRun = "msbuild $SlnFile $MSBuildArgument > $MSBuildLog 2> $MSBuildErrLog"
        try
        {
            $er = (invoke-expression $MSBuildRun) 2>&1 
            if ($lastexitcode) {throw $er}
            "MSbuild for deploy pass" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
        }
        catch
        {
        "MSbuild for deploy failed" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
        $MSBuildRun |  Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
        $_ |  Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
            throw "3"
        }
    }

    ##Deleting extra folders
    if($DeleteExtraFolders -ne "")
    {
    try{
            foreach($Folder in $DeleteExtraFolders.Split(","))
            {
                Write-Host $Folder
                Remove-Item  $Folder -Recurse -Force
            }
        }
        catch{
        Write-Host "No folder Deleted some error is there"
        }
    }
    

    #### Stopping Service if its a service type
    if($Type -eq "Services")
    {
        $ServiceStartStatus = ChangeServiceState -PSSession $PSSession -ServiceName $ServiceName -ServiceState Stop
        if($ServiceStartStatus -eq "0")
        {
            throw "4"
            "Stopping service failed" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
        }
        "Service Stopped" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
    }

    #### MSDeploy deploy on changed files to remote server at given location
    $MsDeployStatus = MSDeployToRemote -UserName $UserName -Password $Password -ComputerName $RemoteServer -DeployedFilesLog $DeployedFilesLog -DeployedFilesErrLog $DeployedFilesErrLog -FromDir $DeployFromLocation -DestinationDir $currentSiteLocation -ExtraParameters $MSDeployExtraArguments
    if($MsDeployStatus -eq "0")
    {
        throw "5"
        "files deployment failed" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
    }
    "files deployed" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append

    #### Starting Service if its a service type
    if($Type -eq "Services")
    {
            $ServiceStartStatus = ChangeServiceState -PSSession $PSSession -ServiceName $ServiceName -ServiceState Start
            if($ServiceStartStatus -eq "0")
            {
                "Starting service failed" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
                throw "6"
            }
            "Service started" | Out-File -FilePath $Sources\CurrentRunningStatus.log -Append
    }
    $Status = "Succeeded"
}
catch{
    switch($_)
    {
        1{ Write-Host "MSBuild Compilation failed"
           $AutoDeploymentComments = "MSBuild Compilation failed"
         }
        2{ Write-Host "Backup Failed" 
           $AutoDeploymentComments = "Backup Failed"
        }
        3{ Write-Host "MsBuild for Deploy Failed"
           $AutoDeploymentComments = "MsBuild for Deploy Failed"
        }
        4{ Write-Host "Service stopped failed"
           $AutoDeploymentComments = "Service stopped failed"
        }
        5{ Write-Host "MSDeploy Failed"
           $AutoDeploymentComments = "MSDeploy Failed"
        }
        6{ Write-Host "Service start failed"
           $AutoDeploymentComments = "Service start failed"
        }
        7{ Write-Host "Service can not start due to some version missmatch please check the deployed server for error logs"
           $AutoDeploymentComments = "Service Start Failed, Service can not start due to some version missmatch please check the deployed server for error logs."
        }
        8{
            Write-Host "Can not create remote session, Please Check credential or Is Machine in running State ?"
            $AutoDeploymentComments = "Can not create remote session, Please Check credential or Is Machine in running State ?"
        }
        default{Write-Warning "Something failed"
            $AutoDeploymentComments = "Something failed, please re-run the build in diagnostic mode and see the error."
        }
    }
    $Status = "Failed"

}
finally{
    if($PSSession -ne $null)
    {
        Remove-PSSession $PSSession
    }
    &  $Sources\Common\PowerShellScripts\SendEmail.ps1 -EmailTo $MailRecepients -Status $Status -BuildName $BackupFileName -RequestedBy $RequestedBy -Buildlog $MSBuildLog -ControllerUsed $ControllerUsed -BackupLocation $BackupLocation"\"$BackupFileName -ServerIP $RemoteServer -DeployLocation $currentSiteLocation -DeployedFilesLog $DeployedFilesLog -DeployedFilesErrLog $DeployedFilesErrLog -AgentName $AgentName -BuildComment $AutoDeploymentComments
}