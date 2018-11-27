param(
[Parameter(Mandatory=$True,Position=1)]
   [string]$computerName,

[Parameter(Mandatory=$True)]
   [string]$userName,

[Parameter(Mandatory=$True)]
   [string]$password,

[Parameter(Mandatory=$True)]
   [string]$serviceName,

[Parameter(Mandatory=$True)]
[ValidateSet("Start","Stop")] 
   [string]$serviceState
)
$PSpassword = ConvertTo-SecureString -String $password  -AsPlainText -Force -verbose
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $PSpassword -verbose
Write-Host "Powershell credential created"
$PSSession = New-PSSession -ComputerName $computerName -Credential $cred -verbose
Write-Host "Powershell Session created"
Invoke-Command -Session $PSSession -ScriptBlock {
param($serviceName,$serviceState)
if($serviceState -eq "Start")
    {
        Get-Service -Name $serviceName | Start-Service -verbose
        while((get-service -ServiceName $serviceName).Status -ne "Running")
        {
            Write-host "Starting the service"
            sleep 2
        }
		Write-Host "Service Started"
    }
else
    {
        Get-Service -Name $serviceName | Stop-Service -verbose
         while((get-service -ServiceName $serviceName).Status -ne "Stopped")
        {
            Write-host "Stopping the service"
            sleep 2
        }
		Write-Host "Service Stopped"
        sleep 60
    }
} -ArgumentList $serviceName, $serviceState
Write-Host "Server Status Changed"
Remove-PSSession $PSSession -verbose
Write-Host "Powershell session removed"