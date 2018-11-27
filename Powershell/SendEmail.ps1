param(
[Parameter(Mandatory=$true)][String]$EmailTo,
[Parameter(Mandatory=$true)][String]$Status,
[Parameter(Mandatory=$true)][String]$BuildName,
[Parameter(Mandatory=$true)][String]$RequestedBy,
[Parameter(Mandatory=$true)][String]$Buildlog,
[Parameter(Mandatory=$true)][String]$ControllerUsed,
[Parameter(Mandatory=$true)][String]$AgentName,
[String]$BuildComment,
[String]$BackupLocation,
[String]$ServerIP,
[String]$DeployLocation,
[String]$DeployedFilesLog,
[String]$DeployedFilesErrLog
)
$image="data:image/svg+xml;base64,PHN2ZyBpZD0iTGF5ZXJfMSIgZGF0YS1uYW1lPSJMYXllciAxIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2aWV3Qm94PSIwIDAgMTYyOS41NyAyNjEuOCI+PGRlZnM+PHN0eWxlPi5jbHMtMXtmaWxsOiMyMzFmMjA7fS5jbHMtMntmaWxsOnVybCgjbGluZWFyLWdyYWRpZW50KTt9LmNscy0ze2ZpbGwtcnVsZTpldmVub2RkO29wYWNpdHk6MC4zNTtmaWxsOnVybCgjbGluZWFyLWdyYWRpZW50LTIpO308L3N0eWxlPjxsaW5lYXJHcmFkaWVudCBpZD0ibGluZWFyLWdyYWRpZW50IiB4MT0iMTQxLjM1IiB5MT0iNy43MSIgeDI9IjEwNy41NiIgeTI9IjI0OC4xIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHN0b3Agb2Zmc2V0PSIwIiBzdG9wLWNvbG9yPSIjZmFhMzFhIi8+PHN0b3Agb2Zmc2V0PSIwIiBzdG9wLWNvbG9yPSIjZmJhZDE4Ii8+PHN0b3Agb2Zmc2V0PSIwLjM2IiBzdG9wLWNvbG9yPSIjZmJhZDE4Ii8+PHN0b3Agb2Zmc2V0PSIwLjQ0IiBzdG9wLWNvbG9yPSIjZmFhMjFhIi8+PHN0b3Agb2Zmc2V0PSIwLjY1IiBzdG9wLWNvbG9yPSIjZjc4YTFmIi8+PHN0b3Agb2Zmc2V0PSIwLjg0IiBzdG9wLWNvbG9yPSIjZjU3YjIyIi8+PHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjZjQ3NjIzIi8+PC9saW5lYXJHcmFkaWVudD48bGluZWFyR3JhZGllbnQgaWQ9ImxpbmVhci1ncmFkaWVudC0yIiB4MT0iNDEuNzMiIHkxPSI5MS40IiB4Mj0iMjMyLjcyIiB5Mj0iOTEuNCIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiPjxzdG9wIG9mZnNldD0iMCIgc3RvcC1jb2xvcj0iI2ZmZiIvPjxzdG9wIG9mZnNldD0iMSIgc3RvcC1jb2xvcj0iI2ZmZiIvPjwvbGluZWFyR3JhZGllbnQ+PC9kZWZzPjx0aXRsZT5JVFQtT3JpZ2luYWw8L3RpdGxlPjxwYXRoIGNsYXNzPSJjbHMtMSIgZD0iTTMwMS4zLDU2LjEzYy0yLjM2LDAtNS44MS45NS04LjYzLDUuOGEyNC4wNiwyNC4wNiwwLDAsMC0zLjE0LDEyLjM3bC0uMDgsMTA3LjEyYTI0LjA5LDI0LjA5LDAsMCwwLDMuMDcsMTIuNDZjMi44Miw0Ljg1LDYuMjgsNS44LDguNzEsNS44czUuODEtLjk1LDguNjQtNS44QTI0LjA2LDI0LjA2LDAsMCwwLDMxMywxODEuNTFsLjA4LTEwNy4yMUEyNCwyNCwwLDAsMCwzMTAsNjEuOTNDMzA3LjE5LDU3LjE3LDMwMy43NCw1Ni4xMywzMDEuMyw1Ni4xM1oiLz48cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Ik00NzUuMzUsNTYuMTNjLTIuMzUsMC01Ljg4LDEtOC42Myw1LjhhMjQuMTIsMjQuMTIsMCwwLDAtMy4xNCwxMi40NnY2MmExNDYuMDcsMTQ2LjA3LDAsMCwxLS43OSwxNi44NywxMS44OCwxMS44OCwwLDAsMS0uNzgsMy4zNyw3LjYsNy42LDAsMCwxLTIuMTItMS4zOWMtMS41Ny0xLjM4LTMuNDUtMy4xMS01LjczLTUuMzZMMzY4LjcxLDYxLjY3YTE4LjU1LDE4LjU1LDAsMCwwLTUuNDItNC4wN0ExMy4yNywxMy4yNywwLDAsMCwzNTcsNTZjLTYsMC0xMS4xNCwzLjQ2LTE1LjA3LDEwLjItMy43Nyw2LjQxLTUuNjUsMTQuMjgtNS42NSwyMy40NWwtLjA4LDkxLjcyYTI0LjUyLDI0LjUyLDAsMCwwLDMuMDcsMTIuNDVjMi44Miw0Ljc2LDYuMjgsNS44LDguNyw1LjhzNS44MS0xLDguNjQtNS44YTI0LjU4LDI0LjU4LDAsMCwwLDMuMTMtMTIuNDV2LTYyYTE1OS4yMSwxNTkuMjEsMCwwLDEsLjc5LTE3LDEyLDEyLDAsMCwxLC43OC0zLjI5Yy4xNiwwLC43OS4yNiwyLjEyLDEuMzgsMS40OSwxLjM5LDMuNDUsMy4xMiw1LjczLDUuMzdsODUuNDUsODguMjVBMjEsMjEsMCwwLDAsNDYwLDE5OC4yYTEzLjc3LDEzLjc3LDAsMCwwLDYuMjgsMS41NmguMDhjNiwwLDExLjE0LTMuNDYsMTUuMDctMTAuMjksMy43Ny02LjMyLDUuNjUtMTQuMTksNS42NS0yMy4zNmwuMDgtOTEuNzFhMjQuNTYsMjQuNTYsMCwwLDAtMy4wNi0xMi40NkM0ODEuMTYsNTcuMTcsNDc3Ljc4LDU2LjEzLDQ3NS4zNSw1Ni4xM1oiLz48cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Ik02NzIuNDcsNTYuMThsLTEyOC41NC0uMDljLTIuNDMsMC01Ljg5LDEtOC43MSw1LjhhMjQuMTYsMjQuMTYsMCwwLDAtMy4wNiwxMi40NiwyNCwyNCwwLDAsMCwzLjA2LDEyLjM3YzIuODIsNC44NSw2LjI4LDUuOCw4LjY0LDUuOGw1Ny40NC4wOWExMTYuNDUsMTE2LjQ1LDAsMCwwLTMuMzcsMTUuMTQsMTMzLjgxLDEzMy44MSwwLDAsMC0xLjUsMjAuMTZsLS4wOCw1My41NWEyMy42LDIzLjYsMCwwLDAsMy4wNiwxMi4zN2MyLjgzLDQuODUsNi4yOCw1Ljg5LDguNzEsNS44OXM1LjgxLTEsOC42My01LjhhMjMuODgsMjMuODgsMCwwLDAsMy4wNy0xMi40NmwuMDgtNTMuNTVhOTQsOTQsMCwwLDEsLjc4LTExLjYsNTAuODksNTAuODksMCwwLDEsMi41OS0xMS40MiwyNC4xMywyNC4xMywwLDAsMSw1LjEtOC41NywxMS40OCwxMS40OCwwLDAsMSw3LjMtMy43MmgzOC4wNmMzLS42MSw1LjU3LTIuNjksNy42MS02LjMyYTIzLjIxLDIzLjIxLDAsMCwwLDIuOS0xMS44NUEyNC4zLDI0LjMsMCwwLDAsNjgxLjE4LDYyQzY3OC45LDU4LjE2LDY3NS45Miw1Ni4xOCw2NzIuNDcsNTYuMThaIi8+PHBhdGggY2xhc3M9ImNscy0xIiBkPSJNNzA3LjU1LDU2LjA5Yy0yLjM1LDAtNS44OSwxLTguNjMsNS44YTIzLjU3LDIzLjU3LDAsMCwwLTMuMTQsMTIuNDVsLS4wOCwxMDcuMTJhMjQuMTIsMjQuMTIsMCwwLDAsMy4wNiwxMi40NmMyLjgyLDQuNzUsNi4yNyw1LjgsOC42Myw1LjhoLjA4YzIuMzUsMCw1LjgtMSw4LjYzLTUuOGEyNC4wOCwyNC4wOCwwLDAsMCwzLjA2LTEyLjQ2bC4xNi0xMDcuMTJhMjQuMzMsMjQuMzMsMCwwLDAtMy4xNC0xMi40NUM3MTMuMzYsNTcuMTMsNzA5LjksNTYuMDksNzA3LjU1LDU2LjA5WiIvPjxwYXRoIGNsYXNzPSJjbHMtMSIgZD0iTTg4My4wOSw1Ni4xM2ExNC40MSwxNC40MSwwLDAsMC0xMCw0LjE2QTI5LjE1LDI5LjE1LDAsMCwwLDg2Ni44NCw2OUw4MjMuMTMsMTUzYTIxLjc3LDIxLjc3LDAsMCwxLTIuMTIsMi45NGMtLjk0LDEuMjEtLjcxLDEuMTItMS42NSwwYTI0LjYzLDI0LjYzLDAsMCwxLTItMi43N0w3NzQuNDEsNzAuNDFhNDguMTgsNDguMTgsMCwwLDAtNy05Ljc4LDEzLjQ1LDEzLjQ1LDAsMCwwLTEwLTQuNTljLTYsMC0xMC43NSwzLjQ2LTE0LjIxLDEwLjM5LTMuMDUsNi4zMS00LjYzLDE0LjEtNC42MywyMi45MmwtLjA4LDkyYTIzLjkyLDIzLjkyLDAsMCwwLDMuMDUsMTIuNDZjMi44Myw0Ljg1LDYuMjgsNS44LDguNjMsNS44czUuODktMSw4LjcxLTUuOEEyMy43OCwyMy43OCwwLDAsMCw3NjIsMTgxLjQybC4wOC02OC43LjA4LTQuNjcuOTQsMS44MSw0MSw3OC44M2EyMS43NSwyMS43NSwwLDAsMCw3LDguMTMsMTYuMzksMTYuMzksMCwwLDAsMTguMjEuMSwyMi44NiwyMi44NiwwLDAsMCw3LTguMjJMODc3LjQzLDExMGwuOTUtMS44MnY0LjY4bC0uMDgsNjguN0EyNC41NSwyNC41NSwwLDAsMCw4ODEuMzYsMTk0YzIuODIsNC43Niw2LjI4LDUuNzEsOC43MSw1LjhzNS44MS0xLDguNjMtNS44OWEyMy4yNCwyMy4yNCwwLDAsMCwzLjE1LTEyLjM3bC4wOC05MmMwLTguOTEtMS41Ny0xNi42MS00LjYzLTIyLjkzQzg5My4xMyw1Ny45NSw4ODcuMjQsNTYuMTMsODgzLjA5LDU2LjEzWiIvPjxwYXRoIGNsYXNzPSJjbHMtMSIgZD0iTTEwNjguMzcsMTYzLjMzbC0xMTcuNzgtLjE4YTIuMTIsMi4xMiwwLDAsMS0yLTEsNi4zNiw2LjM2LDAsMCwxLTEtMy43MlYxNDYuMTFsMTE2LjY4LjA5YzIuMzYsMCw1LjgxLTEsOC42NC01LjhhMjQuMDgsMjQuMDgsMCwwLDAsMy4xNC0xMi40NiwyMy43OSwyMy43OSwwLDAsMC0zLjE0LTEyLjM4Yy0yLjgyLTQuODQtNi4yOC01LjgtOC42NC01LjhsLTEyNS40Ny0uMTdxLTcuMTcsMC0xMC44MywzLjY0Yy0yLjU5LDIuNTEtMy44NSw3LTMuODUsMTMuNjdsLS4wOCwyOC4zOGE2Ny4zOCw2Ny4zOCwwLDAsMCwyLjE5LDE3LjkxLDU3LjEsNTcuMSwwLDAsMCw1LjU3LDEzLjc2LDI5LjA1LDI5LjA1LDAsMCwwLDguMDgsOS4xOCwxNi4zMSwxNi4zMSwwLDAsMCw5LjcyLDMuNTRsMTE4LjY1LjA5YzIuNDMsMCw1LjgtMSw4LjcxLTUuOGEyNi43NCwyNi43NCwwLDAsMCwwLTI0LjgzQzEwNzQuMTgsMTY0LjI4LDEwNzAuNzMsMTYzLjMzLDEwNjguMzcsMTYzLjMzWiIvPjxwYXRoIGNsYXNzPSJjbHMtMSIgZD0iTTEwNjguMzQsNTYuMTMsOTM1LjgsNTZjLTIuMzUsMC01LjgsMS04LjYzLDUuOEEyNC4zOCwyNC4zOCwwLDAsMCw5MjQsNzQuM2EyNC4yNiwyNC4yNiwwLDAsMCwzLjA2LDEyLjQ1YzIuOTEsNC43Niw2LjI4LDUuOCw4LjcxLDUuOGwxMzIuNTQuMDljMi4zNSwwLDUuOC0xLDguNjMtNS44YTI0LjEzLDI0LjEzLDAsMCwwLDMuMTQtMTIuNDZBMjMuMjgsMjMuMjgsMCwwLDAsMTA3Nyw2MkMxMDc0LjE0LDU3LjE3LDEwNzAuNjksNTYuMTMsMTA2OC4zNCw1Ni4xM1oiLz48cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Ik0xMjY4LjIyLDU2LjE4bC0xMjguNjEtLjA5Yy0yLjQ0LDAtNS44OSwxLTguNzEsNS44YTI0LjEsMjQuMSwwLDAsMC0zLjA2LDEyLjQ2LDIzLjU3LDIzLjU3LDAsMCwwLDMuMDYsMTIuMzdjMi44Miw0Ljg1LDYuMjcsNS44OSw4LjYzLDUuODlIMTE5N2ExMjIuNTEsMTIyLjUxLDAsMCwwLTMuMzcsMTUuMTQsMTM2LDEzNiwwLDAsMC0xLjQ5LDIwLjE2bC0uMDgsNTMuNTVhMjQuMTIsMjQuMTIsMCwwLDAsMy4wNSwxMi40NmMyLjgzLDQuNzYsNi4yOCw1LjgsOC42Myw1LjhzNS44OS0xLDguNzEtNS44YTI0LDI0LDAsMCwwLDMuMTQtMTIuMzdWMTI4YTg5LjA5LDg5LjA5LDAsMCwxLC43OC0xMS41OSw0OS4wNyw0OS4wNywwLDAsMSwyLjU5LTExLjUxLDI0Ljg2LDI0Ljg2LDAsMCwxLDUtOC41NywxMS44OSwxMS44OSwwLDAsMSw3LjM4LTMuNzJoMzguMDZjMy0uNTIsNS41Ny0yLjY4LDcuNjEtNi4yM2EyMy4zNywyMy4zNywwLDAsMCwyLjktMTEuOTQsMjMuNzUsMjMuNzUsMCwwLDAtMy4wNi0xMi4zN0MxMjc0LDU3LjIyLDEyNzAuNTcsNTYuMTgsMTI2OC4yMiw1Ni4xOFoiLz48cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Ik0xNDM2LjYyLDE2My4yOWwtMTE3Ljc5LS4wOWEyLjIxLDIuMjEsMCwwLDEtMi0xLjEyLDYuMzEsNi4zMSwwLDAsMS0xLTMuNjNWMTQ2LjA3bDExNi42OS4wOWMyLjM1LDAsNS44LTEsOC42My01LjhhMjQsMjQsMCwwLDAsMy4wNi0xMi4zNywyNC4wOSwyNC4wOSwwLDAsMC0zLjA2LTEyLjQ2Yy0yLjgzLTQuNzYtNi4yOC01LjgtOC42My01LjhsLTEyNS40OC0uMDhjLTQuNzksMC04LjM5LDEuMjEtMTAuODMsMy41NC0yLjU5LDIuNi0zLjg1LDctMy44NSwxMy42N2wtLjA4LDI4LjM4YTY5LjE5LDY5LjE5LDAsMCwwLDIuMiwxNy45MSw1NC40LDU0LjQsMCwwLDAsNS41NywxMy43NiwyOS4zNiwyOS4zNiwwLDAsMCw4LjA4LDkuMjYsMTYuNzMsMTYuNzMsMCwwLDAsOS43MywzLjQ2bDExOC42NS4wOWMzLjUzLDAsNi40NC0xLjkxLDguNzEtNS44YTIzLjU3LDIzLjU3LDAsMCwwLDMuMDYtMTIuMzcsMjQuMTIsMjQuMTIsMCwwLDAtMy4wNi0xMi40NkMxNDQyLjQyLDE2NC4zMywxNDM5LDE2My4yOSwxNDM2LjYyLDE2My4yOVoiLz48cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Ik0xNDM2LjU4LDU2LjE3LDEzMDQsNTYuMDljLTIuMzUsMC01LjgsMS04LjYzLDUuNzFhMjQuMzEsMjQuMzEsMCwwLDAtMy4xNSwxMi40NiwyNC4xNCwyNC4xNCwwLDAsMCwzLjA2LDEyLjQ2YzIuODIsNC43Niw2LjI4LDUuOCw4LjcxLDUuOGwxMzIuNTQuMDljMi4zNiwwLDUuODEtMSw4LjYzLTUuOGEyNC4xMiwyNC4xMiwwLDAsMCwzLjE0LTEyLjQ1QTI0LDI0LDAsMCwwLDE0NDUuMjksNjJDMTQ0Mi45Myw1OC4wOCwxNDQwLDU2LjE3LDE0MzYuNTgsNTYuMTdaIi8+PHBhdGggY2xhc3M9ImNscy0xIiBkPSJNMTYwOC4yNCwxNjMuMjVoLTEwNWMtMy42OCwwLTYuNTktMS04Ljc5LTMuMmEyNi4yNCwyNi4yNCwwLDAsMS01LjY1LTguNTcsNDUuNzIsNDUuNzIsMCwwLDEtMi45LTExLjU5LDkzLjg5LDkzLjg5LDAsMCwxLS43OC0xMiw5NS44Niw5NS44NiwwLDAsMSwuNzgtMTIsNDYuNzMsNDYuNzMsMCwwLDEsMy0xMS41OSwyNS45LDI1LjksMCwwLDEsNS42NS04LjU3LDEyLDEyLDAsMCwxLDguNzEtMy4xMWwxMDUuMDcuMDljMi4zNSwwLDUuODEtMSw4LjYzLTUuOGEyNC4xNywyNC4xNywwLDAsMCwzLjEzLTEyLjQ2QTIzLjc4LDIzLjc4LDAsMCwwLDE2MTcsNjJjLTIuODItNC44NC02LjI4LTUuODgtOC43MS01Ljg4TDE0OTkuNCw1NmMtNiwwLTExLjU0LDIuNDMtMTYuMjUsNy4xYTU4LjY2LDU4LjY2LDAsMCwwLTExLjUzLDE3LjEzLDEwNy4xOCwxMDcuMTgsMCwwLDAtNy4wNiwyMi44NCwxMzMsMTMzLDAsMCwwLTIuNDMsMjQuNzQsMTQxLjcxLDE0MS43MSwwLDAsMCwyLjI3LDI0LjU4LDEwOC4xMSwxMDguMTEsMCwwLDAsNi42NywyMi45Miw1NS41Niw1NS41NiwwLDAsMCwxMC43NSwxNy4xM2M0LjU1LDQuNzYsOS43Myw3LjE4LDE1LjU0LDcuMThsMTEwLjg4LjA4YzIuMzUsMCw1LjgtMSw4LjYzLTUuOEEyNC4xMSwyNC4xMSwwLDAsMCwxNjIwLDE4MS41YTIzLjU1LDIzLjU1LDAsMCwwLTMuMTQtMTIuMzdDMTYxNC4xMiwxNjQuMjgsMTYxMC42NiwxNjMuMjUsMTYwOC4yNCwxNjMuMjVaIi8+PGNpcmNsZSBjbGFzcz0iY2xzLTIiIGN4PSIxMjQuNDYiIGN5PSIxMjcuOSIgcj0iMTIxLjM2Ii8+PHBhdGggY2xhc3M9ImNscy0zIiBkPSJNMjI0Ljc3LDE2NC44M2ExMDkuMiwxMDkuMiwwLDAsMCw1LjgyLTE5LjU1QzI0Mi4xNSw4Ny42MywyMDUuMzEsMzIsMTQ4LjUxLDIwLjJjLTQxLjM0LTguNTgtODIuNCw4LjI2LTEwNi43OCw0MGEyMDIuMjgsMjAyLjI4LDAsMCwxLDQ4LjcsNC4wOEMxNTAuNzksNzYuNzUsMTk4LjksMTE1LjA3LDIyNC43NywxNjQuODNaIi8+PC9zdmc+"
$logs = @()
[string[]]$BuildCommentList = $BuildComment.Split(",")
[string[]]$EmailTo = $EmailTo.Split(",")
$RequestedBy = $RequestedBy.ToUpper()
# called on base of priority
Function sendMail([String]$priority,[String]$body)
{
send-MailMessage -SmtpServer $smtp -To $EmailTo -From $from -Subject $subject -Body $body -BodyAsHtml -Priority $priority -Attachment $logs
}

$smtp = ("192.168.3.254");
 
$from = "CIIAutobuild@intimetec.com"
 
$subject = $Status+" Build $BuildName "

$priority = "Normal"
if((Test-Path -Path $DeployedFilesErrLog) -and (Get-Content -Path $DeployedFilesErrLog) -ne $null)
{
    $Status = "Failed"
    $BuildComment = "Failed at Deployment check the attached log files."
    $logs+=$DeployedFilesErrLog
}
if($Status -eq "Succeeded")
{
    $body = "Hi Team,<br><br>
    <table>

    <tr>
    <b><td width: '200px'>Build Triggered By </td></b>
    <td>:</td>
    <td width: '200px'>$RequestedBy</td>
    </tr>

    <tr>
    <b><td width: '200px'>Build Name </td></b>
    <td>:</td>
    <td width: '200px'>$BuildName</td>
    </tr>

    <tr>
    <b><td width: '200px'>Build Status </td></b>
    <td>:</td>
    <td width: '200px'><b><font color=Green> $Status.</font></b></td>
    </tr>

    <tr>
    <b><td width: '200px'>Backup Location </td></b>
    <td>:</td>
    <td width: '200px'>$ServerIP : $BackupLocation</td>
    </tr>

    
    <tr>
    <b><td width: '200px'>Deployment Location</td></b>
    <td>:</td>
    <td width: '200px'>$DeployLocation</td>
    </tr>

    
    <tr>
    <b><td width: '200px'>Deployed On </td></b>
    <td>:</td>
    <td width: '200px'>$ServerIP</td>
    </tr>

    
    <tr>
    <b><td width: '200px'>Build Controller </td></b>
    <td>:</td>
    <td width: '200px'>$ControllerUsed</td>
    </tr>

    
    <tr>
    <b><td width: '200px'>Build Agent </td></b>
    <td>:</td>
    <td width: '200px'>$AgentName</td>
    </tr>

    </table>
    <br><b>Deployed files Find in the attached log file.</b>."
    $priority = "Normal"

    $logs+=$DeployedFilesLog
}
else
{
$body = "Hi Team,<br><br>
    <table>

    <tr>
    <b><td width: '200px'>Build Triggered By </td></b>
    <td>:</td>
    <td width: '200px'>$RequestedBy</td>
    </tr>

    <tr>
    <b><td width: '200px'>Build Name </td></b>
    <td>:</td>
    <td width: '200px'>$BuildName</td>
    </tr>

    <tr>
    <b><td width: '200px'>Build Status </td></b>
    <td>:</td>
    <td width: '200px'><b><font color=Red> $Status.</font></b></td>
    </tr>

        
    <tr>
    <b><td width: '200px'>Build Controller </td></b>
    <td>:</td>
    <td width: '200px'>$ControllerUsed</td>
    </tr>

    
    <tr>
    <b><td width: '200px'>Build Agent </td></b>
    <td>:</td>
    <td width: '200px'>$AgentName</td>
    </tr>

    </table>"
   
    $body += "<br> Build Failed at <b>$BuildComment</b>"
    $priority = "High"
}
$logs+=$Buildlog

$body += "<br><br><br>Thanks,<br> CIIAutobuild@intimetec.com"

sendMail -priority $priority -body $body
#if(Test-Path -Path $DeployedFilesErrLog)
#{
#    Remove-Item -Path $DeployedFilesErrLog
#}