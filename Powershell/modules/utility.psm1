function CreateBackup{
    param(
    [Parameter(Mandatory=$True,Position=0)]
       $PSSession,

    [Parameter(Mandatory=$True,Position=1)]
       [string]$BackUpWebsitePath,

    [Parameter(Mandatory=$True,Position=2)]
       [string]$BackUpLocation,

    [Parameter(Mandatory=$True,Position=3)]
       [string]$BackUpFileName
    )
    try{
        $lastExitCode = Invoke-Command -Session $PSSession -ScriptBlock {
        param($BackUpWebsitePath, $BackUpFileName, $BackUpLocation)

                ## check is backup location exist
                if(!(Test-Path -Path $BackUpLocation))
                {
                    New-Item -ItemType Directory -path $BackUpLocation
                }
		        Compress-Archive -Path "$BackUpWebsitePath\*" -DestinationPath $BackUpLocation"\"$BackUpFileName -Force -Verbose
        } -ArgumentList $BackUpWebsitePath,$BackUpFileName,$BackUpLocation
        return 1
    }
    catch{
        return 0
    }
}

function CreateBackupUsingMSDeploy{
    param(
    [Parameter(Mandatory=$True,Position=0)]
    [String]$UserName,

    [Parameter(Mandatory=$True,Position=1)]
    [String]$Password,

    [Parameter(Mandatory=$True,Position=2)]
    [String]$ComputerName,

    [Parameter(Mandatory=$True,Position=3)]
    $PSSession,

    [Parameter(Mandatory=$True,Position=4)]
    [string]$BackUpWebsitePath,

    [Parameter(Mandatory=$True,Position=5)]
    [string]$BackUpLocation,

    [Parameter(Mandatory=$True,Position=6)]
    [string]$BackUpFileName
    )
    try{
        $FileCreated = Invoke-Command -Session $PSSession -ScriptBlock {
        param($BackUpLocation)
                ## check is backup location exist
                if(!(Test-Path -Path $BackUpLocation))
                {
                    New-Item -ItemType Directory -path $BackUpLocation
                }
                return Test-Path -Path $BackUpLocation
        } -ArgumentList $BackUpLocation

        if($FileCreated -eq $true)
        {
            msdeploy -verb:sync -source:dirPath=`"$BackUpWebsitePath`",computername=$ComputerName,username=$UserName,password=$Password -dest:dirPath=`"$BackUpLocation"\"$BackUpFileName.zip`",computername=$ComputerName,username=$UserName,password=$Password
        }

        return 1
    }
    catch{
        return 0
    }
}

function MSDeployToRemote{
    param(
    [Parameter(Mandatory=$True,Position=0)]
    [String]$UserName,

    [Parameter(Mandatory=$True,Position=1)]
    [String]$Password,

    [Parameter(Mandatory=$True,Position=2)]
    [String]$ComputerName,

    [Parameter(Mandatory=$True,Position=3)]
    [String]$DeployedFilesLog,

    [Parameter(Mandatory=$True,Position=4)]
    [String]$DeployedFilesErrLog,

    [Parameter(Mandatory=$True,Position=5)]
    [String]$DestinationDir,

    [Parameter(Mandatory=$True,Position=6)]
    [String]$FromDir,

    [String]$ExtraParameters
    )
    $Extra = $ExtraParameters.Split(" ")

    msdeploy  -verb:sync -source:dirPath=`"$FromDir`" -enableRule:DoNotDeleteRule -dest:dirPath=`"$DestinationDir`",computername=$ComputerName,username=$UserName,password=$Password $Extra > $DeployedFilesLog 2> $DeployedFilesErrLog
    if((Get-Content -Path $DeployedFilesErrLog) -ne $null)
    {
        return 0;
    } 
    return 1;
}

function GetRemoteSession{
    param
    (
    [Parameter(Mandatory=$True,Position=0)]
    [String]$UserName,

    [Parameter(Mandatory=$True,Position=1)]
    [String]$Password,

    [Parameter(Mandatory=$True,Position=2)]
    [String]$ComputerName
    )
    try{
        $PSPassword = ConvertTo-SecureString -String $Password  -AsPlainText -Force -verbose
        $Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $UserName, $PSPassword -verbose
        $PSSession = New-PSSession -ComputerName $ComputerName -Credential $Cred -verbose
        Write-Host "Powershell session created and returned"
        if($PSSession -ne $null)
        {
            return $PSSession
        }
        else
        {
            return 0
        }
    }
    catch{
    return 0
    }

}

function ChangeServiceState{
    param(
    [Parameter(Mandatory=$True,Position=0)]
    $PSSession,

    [Parameter(Mandatory=$True,Position=1)]
    [string]$ServiceName,

    [Parameter(Mandatory=$True,Position=2)]
    [ValidateSet("Start","Stop")] 
       [string]$ServiceState
    )
    try{
            Invoke-Command -Session $PSSession -ScriptBlock {
            param($ServiceName,$ServiceState)
            if($ServiceState -eq "Start")
            {
                Get-Service -Name $ServiceName | Start-Service -verbose
                while((get-service -ServiceName $ServiceName).Status -ne "Running")
                {
                    Write-host "Starting the service"
                    sleep 2
                }
	            Write-Host "Service Started"
            }
            else
            {
                Get-Service -Name $ServiceName | Stop-Service -verbose
                while((get-service -ServiceName $ServiceName).Status -ne "Stopped")
                {
                    Write-host "Stopping the service"
                    sleep 2
                }
		        Write-Host "Service Stopped"
                sleep 60
            }
            } -ArgumentList $ServiceName, $ServiceState
            return 1
        }
        catch{
        return 0
        }
}

function GetPowershellVersion{
    param(
    [Parameter(Mandatory=$True,Position=1)]
    $PSSession
    )
    $Version
    try{
            $Version = Invoke-Command -Session $PSSession -ScriptBlock {
             $Version = $PSVersionTable.PSVersion.Major
             return $Version
            }
            return $Version
        }
        catch
        {
        Write-Host $_
        }
}

Export-ModuleMember *