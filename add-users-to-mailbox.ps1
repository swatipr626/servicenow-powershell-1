$MIDUser=$env:SNC_MIDUser;
$MIDPassword=$env:SNC_MIDPassword;
$mailboxName=$env:SNC_mailboxName;
$userList=$env:SNC_accessUserList;

Get-PSSession | Remove-PSSession

$username = $MIDUser
$password = $MIDPassword | ConvertTo-SecureString -asPlainText -Force
$Ocred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username,$password

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Ocred -Authentication Basic -AllowRedirection -Verbose
Import-PSSession $Session -AllowClobber

Set-Mailbox $mailboxName -MessageCopyForSentAsEnabled $True;

$userListString = $userList -replace '[][]','';
$userListClean = $userListString -replace '"', "";
$userListClean.Split(",") | ForEach { Add-MailboxPermission -Identity $mailboxName -User $_ -AccessRights FullAccess -InheritanceType All -Confirm:$false -Automapping $true;
Add-RecipientPermission -Identity $mailboxName -AccessRights SendAs -Trustee $_ -Confirm:$false;
}


Write-Output ("Mailbox is : " + $mailboxName);
Write-Output ("User list clean is : " + $userListClean);
