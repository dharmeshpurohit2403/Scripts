$Users = get-aduser -filter * -Properties Name, PasswordNeverExpires, PasswordExpired, PasswordLastSet, EmailAddress 
$Today = Get-Date
foreach($User in $Users)
{
    $ExpireOn = $User.PasswordLastSet.AddDays(60)
    $DaysToExpire = New-TimeSpan -Start $Today -End $ExpireOn
    $RemainingDaysToExpire = $DaysToExpire.Days
    if($RemainingDaysToExpire -lt 0)
    {
        $User | Add-Member -MemberType NoteProperty -Name "ExpireOn" -Value "Expired" -Force
        $User | Select-Object Name,EmailAddress,ExpireOn,PasswordLastSet,PasswordNeverExpires| Export-Csv -Append -Path "C:\Users\yashwant.mahawar\Desktop\Data.csv" -Force
    }
    elseif($RemainingDaysToExpire -ge 0 -and $RemainingDaysToExpire -le 7)
    {
        if($RemainingDaysToExpire -eq 0)
        {
            $User | Add-Member -MemberType NoteProperty -Name "ExpireOn" -Value "Expire Today" -Force
        }
        else
        {
            $User | Add-Member -MemberType NoteProperty -Name "ExpireOn" -Value "Expire in $RemainingDaysToExpire days" -Force
        }
        
        $User | Select-Object Name,EmailAddress,ExpireOn,PasswordLastSet,PasswordNeverExpires| Export-Csv -Append -Path "C:\Users\yashwant.mahawar\Desktop\Data.csv" -Force
    }
}