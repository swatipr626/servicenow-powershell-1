$mailboxName=$env:SNC_mailboxName;
$password=$env:SNC_password;
$name=$env:SNC_name;
$dc=$env:SNC_dc;
$manager=$env:SNC_manager;
$info=$env:SNC_info;
$description=$env:SNC_description;
$MIDUser=$env:SNC_MIDUser;
$MIDPassword=$env:SNC_MIDPassword;

$ou=$env:SNC_ou;
$strExchangeServer = "local_exchange_server";  


Get-PSSession | Remove-PSSession

$username = $MIDUser
$password = $MIDPassword | ConvertTo-SecureString -asPlainText -Force
$Ocred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username,$password

##Variables
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$strExchangeServer/PowerShell/ -Authentication Kerberos -Credential $Ocred

$upn = $mailboxname + "@domain.org.au";
$upn

##Connect to On-premise Exchange Server
Import-PSSession $Session -AllowClobber

##Create Shared Mailbox in On-premise Exchange 
New-RemoteMailbox -UserPrincipalName $upn -Password (ConvertTo-SecureString $password -AsPlainText -Force) -ResetPasswordOnNextLogon $false -Alias $mailboxname -Name $name -DisplayName $name -OnPremisesOrganizationalUnit $ou -DomainController $dc -Shared

## Set the manager, info and description of the mailbox...  Need to work get the manager username from sysid in variable
set-aduser -Identity $mailboxname -manager $manager -Replace @{Info=$info;description=$description} -server $dc -Credential $Ocred
