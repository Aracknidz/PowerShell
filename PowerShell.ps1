#Livre Scription avancé avec Windows PowerShell
#Fonctions
#Modules
#l'infrastructure WMI et CIM
#Gérer les services
#Les logs
#Gérer les bases de registre
#PowerShell et COM(
#Accès à distance
#Workflows
#Active Directory
#Framework .Net
#PowerShell Studio | Sapien
#PowerShell Linux

#Livre WIndows PowerSHell FOnctionnalités avancées
#DevOps
#Création de modules
#Fonctions avancées
#Objets personnalisés
#Personnalisation des types standards
#Background Job
#Signature des scripts 
#Manipulation des objets COM 
#WorkFlows 
#Configuration avec DSC
#Web Access 
#Manipulation d'objet annuaire avec ADSI
#Administration d'un annuaire Active Directory 
#Collecte de données de performance

#envoyer commande à distance
#faire une fonction
#faire un fichier
#faire un module
#regarder les modules de base contenu dans: $env:PSModulePath

#.ps1 = powershell script
#.psm1 = module
#.psd1 = <language>.<pays> (?manifeste)
#.format.ps1xml = formatage objet personnalisé
#.types.ps1xml = type personnalisé
#.MOF => fichier de configuration pour dsc ou .meta.mof

& { Get-Process }
@(get-command get-net*) | %{Invoke-Expression $_.Name -ErrorAction SilentlyContinue}

#Fonctions de base
Get-Host
Get-Date
Set-Date -Adjust 01:00:00 -Display HintTime
Get-TimeZone
Set-TimeZone -Id "Atlantic Standard Time"
Get-ComputerInfo
Get-Disk
Get-History
Rename-Computer
Get-Content -path file.txt
(Get-Location).ProviderPath
Get-ItemProperty .

### Variable ###
Get-Variable
New-Variable
Set-Variable
Clear-Variable
Remove-Variable
#type
[int][int32] #32-bit signed integer
[long] #64-bit signed integer
[char] #Unicode 16-bit character
[string] #Fixed-length string of Unicode characters
[single][float] #Single-precision 32-bit floating point number
[double] #Double-precision 64-bit floating point number
[decimal] #128-bit decimal value
[bool] #True/false value
[byte] #8-bit unsigned integer
[array] #Array of values
[hashtable] #Hashtable object (similar to a Dictionary object)
[xml][XmlDocument] #Xmldocument object
[DateTime] #Date & time object.
[TimeSpan] #Time interval.
[PsObject] #PowerShell object.
[Switch] #PowerShell Switch parameter.
[SctiptBlock] #PowerShell Script object.
[RegEx] #Regular expression.
[GUID] #Globally unique 32-byte identifier.
#constant
Set-Variable test -option Constant -value 100
Set-Variable test -option ReadOnly -value 100 -Scope global
#prédéfini
$$ #deniere ligne de commande
$^ #premier jetons
$? #état de la dernière opération
$_ #objet actif traité par le pipeline
$Args #liste de paramètre
$home
$PSHome
$host
$PID
$Profile
$Pwd
$PSVersionTable
$PSCmdlet
$PSItem #$_
$True
$False
$NULL
$Input
$Matches
$LastExitCode
$Error
gci env:* | sort-object name
#préférence
$ConfirmPreference
$ErrorActionPreference
$DebugPreference
$VerbosePreference
$WarningPreference
$WhatIfPreference
$PSEmailServer
$PSDefaultParameterValues
$FormatEnumerationLimit
$ErrorView
### arrays ###
$Global:GlobalVariable = abc
[int32[]]$Tableau = 1,2,3,4,5
$myArray = (1..7)
$myArray = @()
$countries = New-Object System.Collections.ArrayList
$countries.Add('India') > $null
$myArray[4..9]
Get-Member -inputObject $MyArray
$a[-3..-1]
$a[0,2+4..6]
$myArray[-1]
[int32[][]]$multi = @(
(64, 12, 24),
(65, 14, 48)
) 
@("1/1/2017", "2/1/2017", "3/1/2017").ForEach([datetime])
$a = @(
  @(0,1),
  @("b", "c"),
  @(Get-Process)
)
$disk = (Get-WmiObject Win32_LogicalDisk | where-Object {$_.Size -ne $null})[0]
$obj1 = [PSCustomObject]@{ #ordered
	'ID' = $disk.DeviceId;
	'FreeSpace(Go)' = [math]::Round(($disk.FreeSpace)/1GB,2);
	'FreeSpace(%)' = [int](($disk.FreeSpace)*100/($disk.Size));
}
$obj1 | add-Member -Name "e" -Value "5" -MemberType noteproperty
$obj = [Ordered]@{#not ordered
	p1 = 'prop1';
	p2 = 'prop2';
	p3 = 'prop3';
}
#advanced formating
$values = @(
    "Kevin"
    "Marquette"
)
'Hello, {0} {1}.' -f $values
#truly multi arrays
[int[,]]$rank2 = [int[,]]::new(5,5)
$Tableau.GetType()
#hash table
$Hash = @{dc2012src = "10.0.0.123" ; DC2008SRV = "10.0.0.122"}
$Hash.Keys
$Hash.Values
$hash.Add("Time", "Now")
$hash.Set("Time", "Yesterday")
$hashsvc = Get-Service | ForEach-Object -Begin { $hash = @{} } -Process { $hash = $hash + @{$_.Name $_.Status } -End {$hash}
$hashsvc.GetEnumerator()
# Set all LastAccessTime properties of files to the current date.
(dir 'C:\Temp').ForEach('LastAccessTime', (Get-Date))
# View the newly set LastAccessTime of all items, and find Unique entries.
(dir 'C:\Temp').ForEach('LastAccessTime') | Get-Unique
("one", "two", "three").ForEach("ToUpper")
(0..9).Where{ $_ % 2 }
# Get the zip files in the current users profile, sorted by LastAccessTime.
$Zips = dir $env:userprofile -Recurse '*.zip' | Sort-Object LastAccessTime
# Get the least accessed file over 100MB
$Zips.Where({$_.Length -gt 100MB}, 'Default', 1)

###### STRING #######
#https://powershellexplained.com/2017-01-13-powershell-variable-substitution-in-strings/
[string]::Concat('server1','server2','server3')
$message = 'Hello, $Name!'
$name = 'Kevin Marquette'    
$string = $ExecutionContext.InvokeCommand.ExpandString($message)

###### NAMESPACE #######
using namespace System

Get-ItemProperty -Path HKCU:\Network\* | ForEach-Object {Set-ItemProperty -Path $_.PSPath -Name RemotePath -Value $_.RemotePath.ToUpper();}

Write-Output "ici quelques ligne du fichier" >> file.txt
Write-Warning "here is a warning"
Read-Host [Int32]
[DateTime]::Today
New-Item 'c:\Parent-Directory\Sub-Directory' -ItemType Directory
Get-Alias -Definition 'sort-object'
Set-Alias -Name 'sobj' -Value 'Sort-Object' -Option 'readonly'
Get-Alias -Name 'sobj'
Get-Culture
Get-Verb
Get-ExecutionPolicy -List
Get-PSProvider
Get-PSDrive -PSProvider Registry

Get-Command -CommandType Alias
Get-Command -CommandType Function
Get-Command -CommandType Script
Get-Command -CommandType cmdlet
Get-Command -ParameterType (((Get-Service)[0]).PSTypeNames)
Get-Command | more

#mise en forme
Get-Command -Verb Format -Module Microsoft.PowerShell.Utility
Get-Command -Verb Format | Format-Wide -Property Noun -Column 3
Get-Command -Noun Net*
Show-Command Get-NetIPAddress

Get-Help CommandName -Detailed
Get-Help CommandName -Full
Get-Help CommandName -Examples
Get-Help CommandName -Online
Get-Help CommandName -ShowWindow
Get-Help CommandName -Parameter *
Update-Help
Update-Help -Module * -Force

#Object type
$service = Get-Service
$service.GetType()
$service[0].GetType()

#Formatage de l'object
Format-List
Select-Object -ExpandProperty
Select-String
Measure-Object
Where-Object {$_.WorkingSet -lt 10}
Sort-Object
Group-Object -Property 'ProcessName'
Get-Unique
Format-Table
1,2,3,4,5 | Foreach-Object { $_ }
Out-GridView
Get-Process | Where-Object -FilterScript { -not ($_.ProcessName -match '^svc*') -and ($_.WS -gt (5MB)) | Sort-Object -Property 'WS' -Desending }
### MODULE ###
$env:PSModulePath
$env:PSModulePath -split ";" | clip
Get-Module -ListAvailable | Select-Object -property Name
Get-Command -Module SMBShare | Select Name, Module
Microsoft.PowerShell.Core\Export-ModuleMember -Function 'Get-AppxLastError'
[Microsoft.Management.Infrastructure.CimInstance] $NetAdapter
New-Module -ScriptBlock { function Get-PSVersion {Write-Host "La version actuel de PowerShell: $($PSVersionTable.PSVersion)"};Get-PSVersion} -returnResult
New-ModuleManifest .\module.psd1
Update-FormatData -Prepend .\custom.format.ps1xml #.format.ps1xml
Update-TypeData -AppendPath .\custom.types.ps1xml
(Get-Item .\licence.bat).GetAccessControl() | fl #ne fonctionne pas dans pscore 6

#Download file
Start-BitsTransfer https://notepad-plus-plus.org/repository/7.x/7.8/npp.7.8.Installer.x64.exe

#Protocol de partage SMB
New-SMBShare –Name SharedFolder `
             –Path C:\Parent-Directory `
             –FullAccess Administrators `
             -ChangeAccess 'Server Operators' `
             -ReadAccess Users
			 
Get-FileShare
Get-SMBShare
Grant-SmbShareAccess -Name "VMFiles" -AccountName "Contoso\Contoso-HV2$" -AccessRight Full
Get-SmbServerConfiguration
### LOGS ###
Get-WinEvent -ListLog *
Get-WinEvent -LogName Windows PowerShell|Setup|System|Application|Security|Hardware Event|Internet Explorer|Key Management Service
Get-EventLog -List
Get-EventLog -LogName 'Windows PowerShell' -Newest 10
Get-Eventlog -LogName Application -Source PSService | select -First 10
Limit-EventLog -LogName 'Windows PowerShell' -MaximumSize 7mb -OverFlowAction OverwriteOlder -RetentionDays 15
[wmi]$Pslog = Get-WmiObject -query "Select * from Win32_NTEventLogFile where LogFileName='Application'" -EnableAllPrivileges
$BackupName = $((Get-Date -Format yyyyMMdd)+"_") + $Pslog.LogfileName
$Pslog.BackupEventLog("Z:\EventLogBackups\$BackupName")
Clear-EventLog -LogName 'Windows PowerShell' -ComputerName MLSRV19
Remove-EventLog -LogName 'Spec_Logs'
### DRIVERS ###
Get-WindowsDriver -Online -All
Get-CimInstance -ClassName Win32_PnpEntity -ComputerName localhost -Namespace Root\CIMV2 | Where-Object {$_.ConfigManagerErrorCode -gt 0 } | Format-Table $result -AutoSize

### COUNT LINE OF ALL FILES ###
Get-ChildItem -Recurse *.csv | Get-Content | Measure-Object -Line

### CHANGE PASSWORD ###
$Password = Read-Host -AsSecureString
$UserAccount = Get-LocalUser -Name "User02"
$UserAccount | Set-LocalUser -Password $Password

### Application ###
New-PSDrive -Name Uninstall -PSProvider Registry -Root HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
$UninstallableApplications = Get-ChildItem -Path Uninstall:
$UninstallableApplications | ForEach-Object -Process { $_.GetValue('DisplayName') }
$UninstallableApplications | Where-Object -FilterScript { $_.GetValue("DisplayName") -eq "Windows Media Encoder 9 Series"}
Get-ChildItem -Path Uninstall: | ForEach-Object -Process { $_.GetValue('UninstallString') }
#upgrade windows installer
Get-CimInstance -Class Win32_Product -Filter "Name='OldAppName'" | Invoke-CimMethod -MethodName Upgrade -Arguments @{PackageLocation='\\AppSrv\dsp\OldAppUpgrade.msi'}

### FIREWALL ###
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
New-NetFirewallRule -DisplayName "Block 80" -Direction Outbound -LocalPort 80 -Protocol TCP -Action Block
Get-NetFirewallRule
Get-NetFirewallPortFilter
Disable-NetFirewallRule -DisplayName "Network Discovery" -Description "Allow ICMPv4" -Profile Any -Direction Inbound -Action Allow -Protocol ICMPv4 -Program Any -LOocalAddress Any
Set-NetFirewallRule -DisplayName "Name" -Action Allow
#multiple port @(443,80) @(0-63000)

### FEATURE ###
Get-WindowsOptionalFeature -Online

### KEYBOARD ###
Get-WinUserLanguageList
Set-WinUserLanguageList
New-WinUserLanguageList
##2
Add-Type -AssemblyName 'System.Windows.Forms'
[System.Windows.Forms.InputLanguage]::CurrentInputLanguage = [System.Windows.Forms.InputLanguage]::InstalledInputLanguages | ? { $_.Culture -eq 'ru-RU' }
##3
$psdrive = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
Set-ItemProperty -Path "HKU:\.DEFAULT\Keyboard Layout\Preload\" -Name 1 -Value 00000407
$psdrive | Remove-PSDrive
##4
$key = New-WinUserLanguageList fr-ca
$key[0].InputMethodTips.Clean()
$key[0].InputMethodTips.Add('0C0C:00001009')
Set-WinUserLanguageList $key
control intl.cpl

### USER ###

Get-LocalGroup
Add-LocalGroupMember -Group "Administrateurs Hyper-V" -Member "Admin"

### ACTIVE DIRECTORY ###
Install-WindowsFeature AD-DomainServices -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -DomainName zone51.ko -InstallDns
Uninstall-ADDSForest -DomainName zone51.ko -ForceRemovale -DemoteOperationMasterRole
New-ADUser -Name "Xavier Lafontaine" -Surname "xav" -SAMAccountName "X.Lafontaine" -AccountPassword(Read-Host -AsSecureString "input password") -Enabled $True
Remove-ADUser -Identity "X.Lafontaine"
ADD-Computer -DomainName Domain01 -Restart
Get-ADUser -Filter *
Get-ADUser -Filter {name -eq 'X.Lafontaine'} -Properties *
Set-ADAccountPassword -Identity "X.Lafontaine" -Reset -NewPassword(ConvertTo-SecureString -AsPlainText "password:") -Force
Enable-ADAccount -Identity "X.Lafontaine"
Add-LocalGroupMember -Group "Administrators" -member "X.Lafontaine"
Get-AdGroup -filter * -properties groupcategory
ADD-ADGroupMember -Identity Administrators -members "X.Lafontaine"
Get-ADPrincipalGroupMembership "X.Lafontaine" | select name
dcpromo.exe
??ZONE DNS Inversée??


### SERVICE / PROCESS ###
Get-Service -name winrm | Foreach-Object {$_}
Get-Service | Where-Object -FilterScript { $_.Status -eq 'Stopped' }
"notepad" | Get-Process
Get-Process | Get-Member
Get-Process | Sort-Object -Property CPU -Descending | Select-Object -Property ProcessName,CPU -First 10
Get-Process -Name powershell | Select-Object -ExpandProperty Modules | Select-Object -Property ModuleName
Get-Service | Where-Object {$_.Status -eq "Running"}
Get-Help Get-Service
Get-Service -Name WinRM | Start-Service
Get-Service | Get-Member
Get-Help -Category cmdlet | measure-object
[Diagnostics.Process[]]$zz = Get-Process
#executer commande à distance
Invoke-Command -ComputerName Server02 -ScriptBlock {$p = Get-Process PowerShell}
$version = Invoke-Command -ComputerName (Get-Content Machines.txt) -ScriptBlock {(Get-Host).Version}
$process = Get-Process notepad
$process | Get-Member
$process.kill()

#obtien l'object wmi (deprecated)
Get-WmiObject -List
Get-WmiObject -Class Win32_Process | Get-Member
Get-WmiObject -Class Win32_LogicalDisk -Computername "WILD" -Credential "WILD\user1"
$calc = Get-WmiObject -query "select * from win32_process where name='calc.exe'"
Get-WmiObject -Class Win32_Service -ComputerName 10.1.4.62
Get-WmiObject -Query "select * from win32_service where name='WinRM'" -ComputerName Server01, Server02 |
  Format-List -Property PSComputerName, Name, ExitCode, Name, ProcessID, StartMode, State, Status
(Get-WmiObject -Class Win32_Service -Filter "name='WinRM'" -ComputerName Server01).StopService()
Get-WmiObject -Class Win32_Bios | Format-List -Property *
Get-WmiObject Win32_Service -Credential FABRIKAM\administrator -ComputerName Fabrikam

#GET windows build version
Reg Query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ReleaseId
(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
systeminfo /fo csv | ConvertFrom-Csv | select OS*, System*, Hotfix* | Format-List #get all important system data
(Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.FileVersion
((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name BuildLabEx).BuildLabEx -split '\.') | % {  $_[0..1] -join '.' }
(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabEx -match '^[0-9]+\.[0-9]+' |  % { $matches.Values }

Win32_OperatingSystem
Win32_Process
Win32_ComputerSystem
Win32_BIOS
Win32_NetworkAdapter
Win32_DiskDrive
Win32_DiskPartition
Win32_Directory
Win32_Processor
Win32_LogicalDisk
Win32_Service
Win32_LogonSession
Win32_LocalTime
Win32_Group
Win32_Account
Win32_UserAccount
Win32_SystemAccount
Win32_Environment
Win32_BaseBoard
Win32_Property
Win32_ComClass
Win32_SID
Win32_ProcessStartup
Win32_PhysicalMemory
Win32_ComputerSystemProduct
Win32_Share
Win32_Thread
(Get-WmiObject -List -ComputerName . | Where-Object -FilterScript {$_.Name -eq 'Win32_Share'}).Create('C:\temp','TempShare',0,25,'test share of the temp folder')
(Get-WmiObject -Class Win32_Share -ComputerName . -Filter "Name='TempShare'").Delete()

################# NETWORK ######################
Get-NetTCPConnection -State Established
$signature = @" 
[DllImport("iphlpapi.dll", ExactSpelling=true)] 
   public static extern int SendARP(  
       uint DestIP, uint SrcIP, byte[] pMacAddr, ref int PhyAddrLen); 
"@ 
 
Add-Type -MemberDefinition $signature -Name Utils -Namespace Network 
[System.Net.IPAddress]
[System.BitConverter]
[Network.Utils]::SendARP($DstIp, $SrcIp, $MacAddress, [ref]$MacAddressLength) 
### WMI remplacer par CIM ###
Get-CimClass -ClassName Win32_LogicalDisk
Get-CimInstance -Query "SELECT * from Win32_Process WHERE name LIKE 'p%'"
Invoke-CimMethod -ClassName Win32_Process -MethodName "Create" -Arguments @{commandline = "calc.exe"}
$CimSession = New-CimSession -ComputerName 'SRV2012DC'
Get-CIMInstance -Classname Win32_OperatingSystem | Invoke-CimMethod -MethodName Shutdown
#configuration imprimante
(New-Object -ComObject WScript.Network).EnumPrinterConnections()
(Get-WmiObject -ComputerName . -Class Win32_Printer -Filter "Name='HP LaserJet 5Si'").SetDefaultPrinter()
(New-Object -ComObject WScript.Network).SetDefaultPrinter('HP LaserJet 5Si')
(New-Object -ComObject WScript.Network).RemovePrinterConnection("\\Printserver01\Xerox5")
#proprietes interfaces network/réseaux
(Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName .).IPAddress[1]
#network ping
Get-WmiObject -Class Win32_PingStatus -Filter "Address='127.0.0.1'" -ComputerName .
1..254| ForEach-Object -Process {Get-CimInstance -ClassName Win32_PingStatus -Filter ("Address='192.168.1." + $_ + "'") -ComputerName .}
$ips = 1..254 | ForEach-Object -Process {'192.168.1.' + $_}
#network dns
Get-CimObject -ClassName Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName . | ForEach-Object -Process { $_. SetDNSDomain('fabrikam.com') }
#dhcp enabled card
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true" -ComputerName .
#dhcp enabled & carte up
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=$true and DHCPEnabled=$true" -ComputerName .
#activer dhcp sur toutes les cartes
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName . | ForEach-Object -Process {$_.EnableDHCP()}
#release dhcp
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=$true and DHCPEnabled=$true" -ComputerName . | Where-Object -FilterScript {$_.DHCPServer -contains '192.168.1.254'} | ForEach-Object -Process {$_.ReleaseDHCPLease()}
Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq 'Win32_NetworkAdapterConfiguration'} ).ReleaseDHCPLeaseAll()
#renew dhcp
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=$true and DHCPEnabled=$true" -ComputerName . | Where-Object -FilterScript {$_.DHCPServer -contains '192.168.1.254'} | ForEach-Object -Process {$_.RenewDHCPLease()}
( Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq 'Win32_NetworkAdapterConfiguration'} ).RenewDHCPLeaseAll()
Get-WmiObject -Namespace "root/default" -List

#WQL
$query = “Select * from Win32_Bios”
$bios = [wmisearcher]$query
$bios.Get()
([wmisearcher]"Select name from win32_bios").get()
gwmi -Query "SELECT * from Win32_DiskPartition WHERE Bootable = TRUE"

#Services
Get-Service -Name WinRM -RequiredServices
Get-Service -Name Winmgmt -DepedentServices
Start-Service -Name eventlog
Stop-Service -Name eventlog
Restart-Service -Name eventlog
Suspend-Service -Name eventlog
Resume-Service -Name eventlog
Set-Service -Name LanmanServer -StartupType Automatic -PassThru
Set-Service -Name LanmanServer -StartupType Disabled -Status Stopped -PassThru -ComputerName 'cpu1', 'cpu2', 'cpu3'
Get-NetTCPConnection -State Established | foreach {Stop-Process -Id $_.OwningProcess -Force}
Get-NetTCPConnection -State Established | foreach {($_.RemoteAddress).Dispose()}

#Download internet file
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#COM OBJECT (Vieux .Net)
$ComObject = New-Object -ComObject 'WScript.Shell'
$ComObject.Popup("hello")
$ComObject.RegRead("HKLM:")
$ComObject.RegWrite("HKLM:")
$ComObject | Get-Member
$ComObject.Exec("notepad")
$ComObject = New-Object -ComObject 'Word.Application'
$ComObject = New-Object -ComObject 'PowerpointApplication'
$ie = new-object -com "InternetExplorer.Application.1"
$ie | gm
$ie.navigate("www.microsoft.com")
$ie.visible = $true
$ie.Width = 400
$ie.Height = 300
#authentification automatique sur un site
$url = "http:#gmail.com"
$username = "effective.ps@gmail.com"
$password "dfg_kx12"
$ie = new-object -com internetexplorer.application
$ie.navigate($url)
$ie.visible = $true
$ie.Document.getElementByID("email").value = $username
$ie.Document.getElementByID("passwd").value = $password
$ie.Document.getElementById("signin").Click()
#Mapper un lecteur réseau
$netmap = new-object -comobject "WScript.Network"
$netmap | get-member
$netmap.MapNetworkDriver('Z', "WILD\Share", $false, "domain\user", "password")
Get-WmiObject -Class Win32_LogicalDisk
$netmap.RemoveNetworkDriver('Z')
New-PSDrive -Name P -PSProvider FileSystem -Root \\server\share -Credential domain\user
New-PSDrive -Name cvkey -PSProvider Registry -Root HKLM\Software\Microsoft\Windows\CurrentVersion
#Utiliser l'objet fileSystem
$Fso = New-Object -ComObject "Scripting.FileSystemObject"
$Fso | gm
$Wfso = $Fso.CreateTextFile("devesp.txt")
Get-Item .\devesp.txt
$Wfso.WriteLine("This is PowerShell")
$GetFile = $Fso.OpenTextFile("devesp.txt")
$GetFile.ReadALL()
GetFile.Close()

#registre
(New-Object -ComObject WScript.Shell).RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DevicePath")

#Configurer l'accès à distance
Enable-PSRemoting
$Session = New-PSSession -ComputerName DCK12ML
Enter-PSSession -Session $Session
Get-WmiObject -Class win32_bios
$env:COMPUTERNAME
Exit-PSSession
Get-PSSession
Remove-PSSession -Session $Session -Verbose
Disconnect-PSSession -Name Session1
Connect-PSSession -Id 1
help Invoke-Command
Invoke-Command -ComputerName DCK12ML -ScriptBlock {get-process | sort ws -Descending | select -first 10 -Property ProcessName,Id,WS,CPU,PSComputerName}
Invoke-Command -ComputerName DCK12ML -ScriptBlock -ScriptBlock {Get-EventLog -log "Windows PowerShell" | where {$_.Message -like "*fileSystem*"}} -Credential NTDEV\Administrator
Invoke-Command -ComputerName DCK12ML -InDisconnectedSession -ScriptBlock {Get-WinEvent -LogName "Windows Powershell"}
Receive-PSSession -Id 3

#MBR|FAT32
Write-Output "$((get-disk -Number 1).PartitionStyle) `n$((get-volume -DriveLetter D).FileSystem)"

#Règle d'exécution: 
Set-ExecutionPolicy -Scope "CurrentUser" -ExecutionPolicy "Unrestricted"
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope LocalMachine
##AllSigned
##Bypass
##Default
##RemoteSigned
##Restricted
##Undefined
##Unrestricted

### WORKFLOW ###
Get-Command -CommandType WorkFlow

workflow wtest {
	InlineScript {Get-Alias}
}
workflow paralleltest {
 parallel {
	Sequence {
	   Get-CimInstance –ClassName Win32_OperatingSystem
	   Get-Process –Name PowerShell* -PSPersist $true
	   Checkpoint-Workflow
	   Get-CimInstance –ClassName Win32_ComputerSystem
	   $PSPersistPreference = $True
	   Get-Service –Name s*
	   Suspend-Workflow
	   Restart-Computer
   }
  }
}

Resume-Job -Id 1
Get-Command paralleltest | Get-Member
(Get-Command paralleltest).XamlDefinition

workflow foreachpstest {
   param([string[]]$computers)
   foreach –parallel ($computer in $computers){
    sequence {
      Get-WmiObject -Class Win32_ComputerSystem -PSComputerName $computer
      Get-WmiObject –Class Win32_OperatingSystem –PSComputerName $computer
    }
  }
}
foreachpstest -AsJob -PSComputerName ComputerName
(Get-Command foreachstest).parameters
workflow Ping-Computer
{
	$ips = 1..255 | foreach-object {"192.168.5.$_"}
	Foreach -Parallel ($ip in $ips)
	{
		Test-Connection $ip
	}
}
#.NET compile C# en DLL
Add-Type -typedef @"
public class MyComputer
{
    public string UserName
    {
        get { return _userName; }
        set { _userName = value; }
    }
    string _userName;

    public string DeviceName
    {
        get { return _deviceName; }
        set { _deviceName = value; }
    }
    string _deviceName;
}
"@
$Object = New-Object -TypeName MyComputer
$Object | Get-Member
$Object | Get-Member -Static
$Object.Username;
Add-Type -TypeDefinition $Source -OutputType Library -OutputAssembly ".\CodeDefinition.dll"
Add-Type -Path .\CodeDefinition.dll -PassThru
[MyComputer]::UserName()
#sendmail
$email = new-object system.net.mail.mailmessage
$email | Get-Member
$from = new-object system.net.mail.mailaddress("")
$to = new-object system.net.mail.mailaddress("")
$email.From = $from
$email.to.add($to)
$email.Subject = "asdasd"
$email.Body = "asdasd"
$smtp = new-object system.net.mail.smtpclient("CPUNAME")
$smtp.Send($email)

(Get-WmiObject -class Win32_OperatingSystem).Caption
[System.Environment]::OSVersion.Version
Get-WmiObject -List | Where-Object {$_.Name -like "win32_*"} | Select Name -first 100 | foreach {Get-WmiObject $_.Name} | Out-File {xyz.txt}
(Get-WmiObject win32_PhysicalMemory | Measure-Object -property Capacity -Sum).sum

$EmailFrom = "xavier.lafontaine42@gmail.com"
$EmailTo = "xavier.lafontaine42@gmail.com"
$Subject = "Notification from XYZ"
$Body = "this is a notification from XYZ Notifications.."
$SMTPServer = "smtp.gmail.com"
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) #$SMTPServer = "gmail-smtp-in.l.google.com"  $SMTPPort = "25"
#gmail SSL: 587 TLS: 465
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("xavier.lafontaine42", "D32IKLNNEa=");
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)

powershell -command {
    $cli = New-Object System.Net.WebClient;
    $cli.Headers['User-Agent'] = 'myUserAgentString';
    $cli.DownloadFile('https:#domain.name/file.name', 'C:\file.name')
}

#-eq
#-ne
#-gt
#-ge
#-lt
#-le
#-like
#-notlike
#-match
#-nomatch
#-contains
#-notcontains
#-replace
#-in
#-notin

#microsoft.powershell_profile.ps1
### SAVE HISTORY ###
$HistoryFilePath = Join-Path ([Environment]::GetFolderPath($env:USERPROFILE)) .ps_history
Register-EngineEvent PowerShell.Exiting -Action { Get-History | Export-Clixml $HistoryFilePath } | out-null
if (Test-path $HistoryFilePath) { Import-Clixml $HistoryFilePath | Add-History }
# if you don't already have this configured...
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
#get all folder recursivly
Get-ChildItem -Recurse | ?{ $_.PSIsContainer } | % { $_.FullName }
#https:#www.powershellmagazine.com
Get-ChildItem HKLM:\Software\Classes -ErrorAction SilentlyContinue | Where-Object {$_.PSChildName -match '^\w+\.\w+$' -and (Test-Path -Path "$($_.PSPath)\CLSID") } | Select-Object -ExpandProperty PSChildName
[appdomain]::CurrentDomain.GetAssemblies() | foreach {$_.FullName.Split(",")[0]} | sort
[System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location |Sort-Object -Property FullName |Select-Object -Property Name, Location, Version |Out-GridView

###### .NET classes ######
[Enum]::GetNames('System.Environment+SpecialFolder')

[System.Management.Automation.PSCommand]
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
[System.Environment]
[System.IO.Path]
[Microsoft.Win32.RegistryKey]
[System.Math]
[System.Convert]::FromBase64String
[System.Text.Encoding]::Unicode
[System.Security.Principal.NTAccount]
[System.Management.Automation]
[System.IO.File]::Exists()
$compressionLevelFormat = [System.IO.Compression.CompressionLevel]::Optimal
[System.IO.DirectoryInfo]
[System.IO.Path]
[System.IO.BinaryReader]
[System.IO.Compression.ZipFileExtensions]::ExtractToFile
[System.Net.IPAddress] $RemoteAddress
[System.Net.NetworkInformation.PingReply]
[System.Net.Sockets.Socket] $TcpClientSocket
$AdminPrincipal = [System.Security.Principal.WindowsBuiltInRole]::Administrator
#.NET NETWORK
[System.Net.Dns] | gm -Static
[System.Net.Dns]::GetHostAddresses('CPUNAME')
[System.Net.Dns]::GetHostByName('CPUNAME')
[System.Net.Dns]::GetHostByName('CPUNAME').AddressList.IPAddressToString
[System.Net.Dns]::GetHostEntry('192.168.0.3').Hostname
$Ping = [System.Net.NetworkInformation.Ping]::new()
$PingReplyDetails = $Ping.SendPingAsync($TargetIPAddress).GetAwaiter().Getresult()
$fileMode = [System.IO.FileMode]::Open
$zipArchiveArgs = @($archiveFileStream, [System.IO.Compression.ZipArchiveMode]::Read, $false)
$zipArchive = New-Object -TypeName System.IO.Compression.ZipArchive -ArgumentList $zipArchiveArgs
$relativeFilePath = [System.IO.Path]::GetFileName($currentFilePath)
$IPConfig = [NetIPConfiguration]::New()
            $IPConfig.ComputerName = $ComputerName
            $IPConfig.InterfaceIndex = $IfIndex
            $IPConfig.Detailed = $Detailed
            #
            # Link up the NetAdapter and NetIPInterface objects.
            #
            $IPConfig.NetAdapter = $Adapters | where InterfaceIndex -eq $IfIndex
            $IPConfig.NetIPv4Interface = $IPInterfaces | where {($_.InterfaceIndex -eq $IfIndex ) -and ($_.AddressFamily -eq "IPv4")}
            $IPConfig.NetIPv6Interface = $IPInterfaces | where {($_.InterfaceIndex -eq $IfIndex ) -and ($_.AddressFamily -eq "IPv6")}

#https:#blog.netwrix.com/2018/02/21/windows-powershell-scripting-tutorial-for-beginners/
$firewall = New-Object -com HNetCfg.FwMgr #objet com
$firewall.LocalPolicy.CurrentProfile
$sourceDirInfo = New-Object -TypeName System.IO.DirectoryInfo -ArgumentList $sourceDirPath #objet .NET
#certificate store
Set-Location cert:\CurrentUser\Root
Get-ChildItem

& 'C:\Program Files\Program\Program.exe'
#Invoke the command as a Job to have PowerShell run it in the background
Start-Job { while($true) { Get-Random; Start-Sleep 5 } } -Name Sleeper
Receive-Job Sleeper
Stop-Job Sleeper
[Console]::Beep(1000, 1000)

$job = Start-Job -Name TenSecondSleep { Start-Sleep 10 }
Register-TemporaryEvent $job StateChanged -Action {     
    [Console]::Beep(100,100)     
    Write-Host "Job #$($sender.Id) ($($sender.Name)) complete."
}


Get-NetAdapterHardwareInfo
Disable-NetAdapter -Name "Wireless Network Connection"
Enable-NetAdapter -Name "Wireless Network Connection" 
Rename-NetAdapter -Name "Wireless Network Connection" -NewName "Wireless" 
Get-NetAdapter -Name "Local Area Connection" | Get-NetIPAddress 
(Get-NetAdapter -Name "Local Area Connection" | Get-NetIPAddress).IPv4Address
Get-NetAdapter -Name "Local Area Connection" | Get-DnsClientServerAddress 
New-NetIPAddress -InterfaceAlias "Wireless" -IPv4Address 10.0.1.95 -PrefixLength "24" -DefaultGateway 10.0.1.1
Set-NetIPAddress -InterfaceAlias "Wireless" -IPv4Address 192.168.12.25 -PrefixLength "24"
Set-NetIPInterface -InterfaceAlias "Wireless" -Dhcp Enabled
Get-NetIPConfiguration
Set-ExecutionPolicy RemoteSigned

Get-NetAdapter
Restart-NetAdapter
Get-NetIPInterface
Get-NetIPAddress
Get-NetRoute
Get-NetConnectionProfile
Get-DNSClientCache
Get-DNSClientServerAddress
Register-DnsClient
Set-DnsClient
Set-DnsClientGlobalSetting
Set-DnsClientServerAddress
Set-NetIPAddress
Set-NetIPv4Protocol
Set-NetIPInterface
Test-Connection
Test-NetConnection
Resolve-Dnsname 


###### GET COMPUTER INFO 1 ######
$Computer = $env:computername
$Connection = Test-Connection $Computer -Count 1 -Quiet
if ($Connection -eq "True"){
   $ComputerHW = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer | select Manufacturer,Model | FT -AutoSize
   $ComputerCPU = Get-WmiObject win32_processor -ComputerName $Computer | select DeviceID,Name | FT -AutoSize
   $ComputerRam_Total = Get-WmiObject Win32_PhysicalMemoryArray -ComputerName $Computer | select MemoryDevices,MaxCapacity | FT -AutoSize
   $ComputerRAM = Get-WmiObject Win32_PhysicalMemory -ComputerName $Computer | select DeviceLocator,Manufacturer,PartNumber,Capacity,Speed | FT -AutoSize
   $ComputerDisks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $Computer | select DeviceID,VolumeName,Size,FreeSpace | FT -AutoSize
   $ComputerOS = (Get-WmiObject Win32_OperatingSystem -ComputerName $Computer).Version
   switch -Wildcard ($ComputerOS){
      "6.1.7600" {$OS = "Windows 7"; break}
      "6.1.7601" {$OS = "Windows 7 SP1"; break}
      "6.2.9200" {$OS = "Windows 8"; break}
      "6.3.9600" {$OS = "Windows 8.1"; break}
      "10.0.*" {$OS = "Windows 10"; break}
      default {$OS = "Unknown Operating System"; break}
   }

   Write-Host "Computer Name: $Computer"
   Write-Host "Operating System: $OS"
   Write-Output $ComputerHW
   Write-Output $ComputerCPU
   Write-Output $ComputerRam_Total
   Write-Output $ComputerRAM
   Write-Output $ComputerDisks
   }
  else {
   Write-Host -ForegroundColor Red @"

Computer is not reachable or does not exists.

"@
}

###### GET CPU USAGE ######

Get-Counter -ComputerName $env:computername '\Process(*)\% Processor Time' `
    | Select-Object -ExpandProperty countersamples `
    | Select-Object -Property instancename, cookedvalue `
    | Sort-Object -Property cookedvalue -Descending | Select-Object -First 20 `
    | ft InstanceName,@{L='CPU';E={($_.Cookedvalue/100).toString('P')}} -AutoSize


###### GET COMPUTER SPEC ######

$computerSystem = Get-CimInstance CIM_ComputerSystem
$computerBIOS = Get-CimInstance CIM_BIOSElement
$computerOS = Get-CimInstance CIM_OperatingSystem
$computerCPU = Get-CimInstance CIM_Processor
$computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"
Clear-Host

Write-Host "System Information for: " $computerSystem.Name -BackgroundColor DarkCyan
"Manufacturer: " + $computerSystem.Manufacturer
"Model: " + $computerSystem.Model
"Serial Number: " + $computerBIOS.SerialNumber
"CPU: " + $computerCPU.Name
"HDD Capacity: "  + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB"
"HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
"RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
"Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
"User logged In: " + $computerSystem.UserName
"Last Reboot: " + $computerOS.LastBootUpTime

###### GET COMPUTER RAM #######

$os = Get-Ciminstance Win32_OperatingSystem

$os | Select @{Name = "PctFree"; Expression = {$pctFree}},
@{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
@{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}

###### SHOW MEMORY USAGE #######
Function Test-MemoryUsage {
[cmdletbinding()]
Param()
 
$os = Get-Ciminstance Win32_OperatingSystem
$pctFree = [math]::Round(($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100,2)
 
if ($pctFree -ge 45) {
$Status = "OK"
}
elseif ($pctFree -ge 15 ) {
$Status = "Warning"
}
else {
$Status = "Critical"
}
 
$os | Select @{Name = "Status";Expression = {$Status}},
@{Name = "PctFree"; Expression = {$pctFree}},
@{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
@{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}
 
}
Set-Alias -Name tmu -Value Test-MemoryUsage
	
$data = Test-MemoryUsage
Switch ($data.Status) {
 "OK" { $color = "Green" }
 "Warning" { $color = "Yellow" }
 "Critical" { $color = "Red" }
}

Function Show-MemoryUsage {
 
[cmdletbinding()]
Param()
 
#get memory usage data
$data = Test-MemoryUsage
 
$title = @"
 
Memory Check
------------
"@
 
Write-Host $title -foregroundColor Cyan
$data | Format-Table -AutoSize | Out-String | Write-Host -ForegroundColor $color
}
 
set-alias -Name smu -Value Show-MemoryUsage

<####### NETWORK DISCOVERY #######>
#Installer le rôle SMB 1.0
#Démarrer services.msc
#Function Discovery Provider Host service | Hôte du fournisseur de découverte de fonction
#Function Discovery Resource Publication | Publication des ressources de découverte de fonctions
<####### Utiliser Hyper-v avec Windows 10 #######
Pour ceux qui ne le savent pas, Hyper-v est une fonctionnalité venant avec Windows 10 Professionnel et permet de gérer des machines virtuelles à distance, un peu comme VMware, VirtualBox ou Windows Virtual PC.  
Donc voici comment configurer correctement Hyper-V pour ne pas qu'il donne des tonnes d'erreurs, perso j'ai eu recours à de multiples sources et certaines d'entres elles ne fonctionnaient pas du tout. Cela a fonctionner sur plusieurs ordinateurs, c'est pourquoi, cette démarche semble être la bonne en toute circonstance.
########>
#Côté serveur, faire les mises à jour, puis, exécuter PowerShell:
Enable-PSRemoting
Enable-WSManCredSSP -Role server
#Ne pas oublier de renommer le serveur pour que ce soit plus facile pour les étapes suivantes

#Côté client Windows 10, faire toutes les mises à jour Windows et exécuter PowerShell en mode Admin
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Tools-All -All
Set-NetConnectionProfile -InterfaceAlias Ethernet -NetworkCategory Private
#Dans la commande précédente remplacer Ethernet par le nom de votre interface réseau. Elles peuvent être récupéré avec la commande: Get-NetConnectionProfile
Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value "`nIPSERVEUR`tNOMSERVEUR"
winrm quickconfig
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "NOMSERVEUR"
Enable-WSManCredSSP -Role client -DelegateComputer "NOMSERVEUR"
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\" -Name 'CredentialsDelegation'
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\" -Name 'AllowFreshCredentialsWhenNTLMOnly' -PropertyType DWord -Value "00000001"
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\" -Name 'ConcatenateDefaults_AllowFreshNTLMOnly' -PropertyType DWord -Value "00000001"
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\" -Name 'AllowFreshCredentialsWhenNTLMOnly'
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowFreshCredentialsWhenNTLMOnly\" -Name '1' -Value "wsman/ALPHACYBORG"
<# Mettre l'utilisateur dans le groupe Administrator Hyper-V
#Maintenant que tout est configuré, plus qu'à se connecter à l'hôte distant:
#-Clique droit sur "Connection au serveur" dans Hyper-V Manager
#-Selectionner Autre Ordinateur et inscrire NOMSERVEUR
#-Cocher Connecter avec un autre utilisateur, cliquer sur "Set User" et écrire les authentifiant du serveur distant.
#Comme ceci: 
#HOSTNAME\Administrator
#Password
https://timothygruber.com/tag/hyper-v/ #>

#signature
Set-AuthenticodeSignature somescript.ps1 @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0] -IncludeChain "All" -TimestampServer "http://timestamp.verisign.com/scripts/timstamp.dll"
#progressbar
$TotalSteps = 4
$Step = 1
$StepText = "Setting Initial Variables"
$StatusText = '"Step $($Step.ToString().PadLeft($TotalSteps.Count.ToString().Length)) of $TotalSteps | $StepText"'
$StatusBlock = [ScriptBlock]::Create($StatusText)
$Task = "Creating Progress Bar Script Block for Groups"
Write-Progress -Id $Id -Activity $Activity -Status (&amp; $StatusBlock) -CurrentOperation $Task -PercentComplete ($Step / $TotalSteps * 100)

##DOS##
net user /domain
net user /config
net localgroup
net user admin *
net user admin pass123 /add ou /del
hostname #nom ordinateur
whoami #nom ordinateur/utilisateur
nbtstat -A 192.168.0.1 #nom machines
nbtstat -a COMPUTER #ip machines
arp -a
netstat -o #pid
netstat -f #realipname
netstat -e -t 5 #interfaces statistique
getmac		#mac address
taskkill /f "name"
net use e: \\wds\update pass /user:user /samecred /p:yes
net share Downloads=Z:\Downloads /grand:everyone, full
net share Downloads /delete
net user username password /add /domain
msiexec
sfc /scannow
checkdisk
ipconfig /release
ipconfig /renew
slmgr /iph

azman.msc                  C:\Windows\system32\azman.msc
certlm.msc                 C:\Windows\system32\certlm.msc
certmgr.msc                C:\Windows\system32\certmgr.msc
comexp.msc                 C:\Windows\system32\comexp.msc
compmgmt.msc               C:\Windows\system32\compmgmt.msc
devmgmt.msc                #device drivers
DevModeRunAsUserConfig.msc C:\Windows\system32\DevModeRunAsUserConfig.msc
diskmgmt.msc               #open partition manager
eventvwr.msc               C:\Windows\system32\eventvwr.msc
fsmgmt.msc                 C:\Windows\system32\fsmgmt.msc
gpedit.msc                 #localgrsouppolicies
lusrmgr.msc                C:\Windows\system32\lusrmgr.msc
perfmon.msc                C:\Windows\system32\perfmon.msc
printmanagement.msc        C:\Windows\system32\printmanagement.msc
rsop.msc                   C:\Windows\system32\rsop.msc
secpol.msc                 C:\Windows\system32\secpol.msc
services.msc               C:\Windows\system32\services.msc
taskschd.msc               C:\Windows\system32\taskschd.msc
tpm.msc                    C:\Windows\system32\tpm.msc
WF.msc                     C:\Windows\system32\WF.msc
WmiMgmt.msc                C:\Windows\system32\WmiMgmt.msc

### WINDOWS SERVER 2016 ###
DSA.MSC						# Active Directory Users and Computers
DSSITE.MSC					#Active Directory Sites and Services
DNSMGMT.MSC					#DNS Manager
GPEDIT.MSC					#Local Group Policy Editor
GPMC.MSC					#Group Policy Management Console
CERTSRV.MSC					#Certification Authority Management
CERTTMPL.MSC				#Certificate Template Management
CERTLM.MSC					#Local Computer Certificates Store
COMPMGMT.MSC				#Computer Management
DEVMGMT.MSC					#Device Manager
DHCPMGMT.MSC				#DHCP Manager
DISKMGMT.MSC				#Disk Management
EVENTVWR.MSC				#Event Viewer
PERFMON.MSC					#Performance Monitor
SECPOL.MSC					#Local Security Policy Console
FSMGMT.MSC					#Shared Folders
WF.MSC 						#Windows Firewall with Advanced Security


secpol			
sysprep			#netsh advfirewall set allprofiles state off
lusr
lusrmgr
msconfig
attrib
runas
icacls
cipher
mmc
wmic /?
wmic diskdrive get model,name,size
winrm quickconfig
net share tempshare=c:\temp /users:25 /remark:"test share of the temp folder"
net use B: \\FPS01\users
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion /v DevicePath
reg add HKCU\Environment /v Path /d $newpath /f
GPResult
gpupdate /force #groupe rule update
Secedit /RefreshPolicy machine_policy /ENFORCE #pour les GPO s'appliquant aux ordinateurs
Secedit /RefreshPolicy user_policy /ENFORCE #pour les GPO s'appliquant aux utilisateurs
$TraceResults = netsh trace start tracefile=$LogFile provider=Microsoft-Windows-TCPIP keywords=ut:TcpipRoute report=di perfmerge=no correlation=di
whoami /groups
subst m: c:\foo #mount folder as drive

#Operating System
$IsLinuxEnv = (Get-Variable -Name "IsLinux" -ErrorAction Ignore) -and $IsLinux
$IsMacOSEnv = (Get-Variable -Name "IsMacOS" -ErrorAction Ignore) -and $IsMacOS
$IsWinEnv = !$IsLinuxEnv -and !$IsMacOSEnv
#Architecture (x86, x64)
if (-not $IsWinEnv) {
    $architecture = "x64"
} else {
    switch ($env:PROCESSOR_ARCHITECTURE) {
        "AMD64" { $architecture = "x64" }
        "x86" { $architecture = "x86" }
        default { throw "PowerShell package for OS architecture '$_' is not supported." }
    }
}

### Exemple Interface graphique ###
#Add a .NET Framework type to a PowerShell session. If a .NET Framework class is added to your PowerShell session with Add-Type, 
#those objects may then be instantiated (with New-Object ), just like any .NET Framework object.
Add-Type -AssemblyName System.Windows.Forms 
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton


$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter the information in the space below:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $textBox.Text
    $x
}

############## REMOTE POWERSHELL ###############
$Username = 'Administrator'
$Password = 'Test123'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass
Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceAlias Wi-Fi -NetworkCategory Private
Set-WSManQuickConfig
Enable-PSRemoting -SkipNetworkProfileCheck -Force #client
Set-Item -Path wsman:\localhost\Client\TrustedHosts -value "COMPUTER"
Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'machineC' -Concatenate
Add-Content C:\Windows\System32\drivers\etc\hosts "`n192.168.0.120`tMASTER"
Restart-Service WinRM
Test-WSMan NOMORDINATEUR
Invoke-Command -ComputerName "COMPUTER" -ScriptBlock { COMMAND } -Credential $cred
Enter-PSSession -ComputerName COMPUTER -Credential USER #Starts an interactive session with a remote computer
Exit-PSSession
New-PSSession -ComputerName COMPUTER -Credential USER #Creates a persistent PSSession on a local or remote compute
Disconnect-PSSession -Name NOMSESSION
Remove-PSSession
################################################
# FUNCTION 
################################################
#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-6
#function 1
function full_param{
	Param(
		[Parameter(Mandatory=$true,
		Position=0,
		HelpMessage="Enter one or more computer names separated by commas.",
		ValueFromPipeline=$true,
		ValueFromPipelineByPropertyName=$true,
		ParameterSetName="nomParamètre",
		ValueFromRemainingArguments=$true
		)]
		[AllowNull()]
		[AllowEmptyString()]
		[AllowEmptyCollection()]
		[ValidateCount(1,5)]
		[ValidateLength(1,10)]
		[ValidatePattern("[0-9][0-9][0-9][0-9]")]
		[ValidateRange(0,10)]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[Alias("CN","MachineName")]
		[ValidateSet("Low", "Average", "High")]
		[ValidateScript({SCRIPT BLOX})]
		[String[]]
		$ComputerName
	)
	begin{
	} 
	process {
	} 
	end {
	}
}
#function multiple parameter
Param(
    [Parameter(Mandatory=$true,
    ParameterSetName="Computer")]
    [String[]]
    $ComputerName,

    [Parameter(Mandatory=$true,
    ParameterSetName="User")]
    [String[]]
    $UserName,

    [Parameter(Mandatory=$false, ParameterSetName="Computer")]
    [Parameter(Mandatory=$true, ParameterSetName="User")]
    [Switch]
    $Summary
)
#function remaining elements
function Test-Remainder
{
     param(
         [string]
         [Parameter(Mandatory = $true, Position=0)]
         $Value,
         [string[]]
         [Parameter(Position=1, ValueFromRemainingArguments)]
         $Remaining)
     "Found $($Remaining.Count) elements"
     for ($i = 0; $i -lt $Remaining.Count; $i++)
     {
        "${i}: $($Remaining[$i])"
     }
}
Test-Remainder first one,two

#function date
Param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({$_ -ge (Get-Date)})]
    [DateTime]
    $EventDate
)

#function set
Param(
    [ValidateSet("hello", "world")]
    [String]$Message
)

$Message = "bye"

#function validate drivers
Param(
    [ValidateDrive("C", "D", "Variable", "Function")]
    [String]$Path
)

Param(
    [ValidateUserDrive()]
    [String]$Path
)

#param switch
Param(
    [Parameter(Mandatory=$false)]
    [Switch]
    $<ParameterName>
)

#function argument completer
Param(
    [Parameter(Mandatory)]
    [ArgumentCompleter({
        param ( $commandName,
                $parameterName,
                $wordToComplete,
                $commandAst,
                $fakeBoundParameters )
        # Perform calculation of tab completed values here.
    })]
)

#function dynamic param
function Get-Sample {
  [CmdletBinding()]
  Param([String]$Name, [String]$Path)

  DynamicParam
  {
    if ($Path.StartsWith("HKLM:"))
    {
      $attributes = New-Object -Type `
      System.Management.Automation.ParameterAttribute
      $attributes.ParameterSetName = "PSet1"
      $attributes.Mandatory = $false
      $attributeCollection = New-Object `
        -Type System.Collections.ObjectModel.Collection[System.Attribute]
      $attributeCollection.Add($attributes)

      $dynParam1 = New-Object -Type `
        System.Management.Automation.RuntimeDefinedParameter("DP1", [Int32],
          $attributeCollection)

      $paramDictionary = New-Object `
        -Type System.Management.Automation.RuntimeDefinedParameterDictionary
      $paramDictionary.Add("DP1", $dynParam1)
      return $paramDictionary
    }
  }
}

#function argument completer
Param(
    [Parameter(Mandatory)]
    [ArgumentCompleter({
        param ( $commandName,
                $parameterName,
                $wordToComplete,
                $commandAst,
                $fakeBoundParameters )
        # Perform calculation of tab completed values here.
    })]
)
###############################################################
# Class
################################################################
Class SoundNames : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        $SoundPaths = '/System/Library/Sounds/',
            '/Library/Sounds','~/Library/Sounds'
        $SoundNames = ForEach ($SoundPath in $SoundPaths) {
            If (Test-Path $SoundPath) {
                (Get-ChildItem $SoundPath).BaseName
            }
        }
        return [String[]] $SoundNames
    }
}
Param(
    [ValidateSet([SoundNames])]
    [String]$Sound
)

class test_class {
    [int]return_what() {
        Write-Output "Hello, World!"
        return 808979
    }
}
$tc = New-Object -TypeName test_class
$tc.return_what()
################################################################
# SNIPPET
################################################################
$snippet = @"
<?xml version='1.0' encoding='utf-8' ?>
    <Snippets  xmlns='http://schemas.microsoft.com/PowerShell/Snippets'>
        <Snippet Version='1.0.0'>
            <Header>
                <Title>$([System.Security.SecurityElement]::Escape($Title))</Title>
                <Description>$([System.Security.SecurityElement]::Escape($Description))</Description>
                <Author>$([System.Security.SecurityElement]::Escape($Author))</Author>
                <SnippetTypes>
                    <SnippetType>Expansion</SnippetType>
                </SnippetTypes>
            </Header>

            <Code>
                <Script Language='PowerShell' CaretOffset='$CaretOffset'>
                    <![CDATA[$Text]]>
                </Script>
            </Code>

    </Snippet>
</Snippets>

"@

        $pathCharacters = '/\`*?[]:><"|.';
        $fileName=new-object text.stringBuilder
        for($ix=0; $ix -lt $Title.Length; $ix++)
        {
            $titleChar=$Title[$ix]
            if($pathCharacters.IndexOf($titleChar) -ne -1)
            {
                $titleChar = "_"
            }

            $null = $fileName.Append($titleChar)
        }
        $params = @{
            FilePath = "$snippetPath\$fileName.snippets.ps1xml";
            Encoding = "UTF8"
        }

        if ($Force)
        {
            $params["Force"] = $true
        }
        else
        {
            $params["NoClobber"] = $true
        }
        $snippet | Out-File @params
        $psise.CurrentPowerShellTab.Snippets.Load($params["FilePath"])
### CHOCO ###
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

###	Repair USB key ###
#https://www.malekal.com/tutoriel-diskpart/
diskpart
list disk
select disk n$
detail diskdrive
clean #one partition
clean all #two partition
create partition primary
select partition 1
format fs=fat32 quick #usb
format fs=ntfs quick #hd
assign letter z

###	Fiber Channel ###
Get-InitiatorPort

### Get Windows Key ###
powershell "(Get-WmiObject -query ‘select * from SoftwareLicensingService’).OA3xOriginalProductKey"

##################################################
#	Job
##################################################
$job = {Invoke-Command -ScriptBlock {Get-Process | Where-Object {$_.cpu -gt 1} | select name, cpu} -ComputerName TV-HYBRID}
$credential = New-Object System.Management.Automation.PSCredential("Administrator",("Test123" | ConvertTo-SecureString -asPlainText -Force))
Get-Command *-job
Start-Job -ScriptBlock { $job }
Get-Job -name Job3
Receive-Job Job3 -keep
Get-Job | Remove-Job -Force
Register-ScheduledJob -ScriptBlock $job -Name 'Process Checkup' #create job
Get-ScheduledJob | fl *
Unregister-ScheduledJob -id 1
$t = New-JobTrigger -Daily -Ad "00:00:00" -RandomDelay "00:30:00" #create job trigger
Add-JobTrigger -Name 'Process Checkup' -Trigger $t
(Get-ScheduledJob -Name 'Process Checkup').jobtriggers
Get-ScheduledJob -Name 'Process Checkup' | Get-JobTrigger | Disable-JobTrigger
$options = New-ScheduledJobOption -RunElevated -WakeToRun #scheduled job options
Get-ScheduledJob -Name "Process Checkup" | Set-ScheduledJob -ScheduledJobOption $options 
#workflow job
workflow menage {
	Get-Process
}
menage -AsJob
### EXECUTION POLICY ####
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6

#HKLM:\SYSTEM\ControlSet001\Control\Session Manager\
#%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\Windows Live\Shared;C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\x64;C:\Users\Xalloc\AppData\Local\Microsoft\WindowsApps;C:\Users\Xalloc\AppData\Local\Programs\Microsoft VS Code\bin;

### CONVERT ###
ConvertTo-Html
Get-Alias | ConvertTo-Html | Out-File aliases.html
Invoke-Item aliases.html #perform default action on a specific item
ConvertTo-Json
ConvertTo-SecureString
ConvertTo-XML
ConvertTo-Csv

### CERTIFICATION ###
#SDK du framework .Net
#https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk
#setx /M PATH "%PATH%;C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\arm64"
mmc #nouvelle fenêtre -> Certificates
makecert.exe -n "CN=Certificat Racine PowerShell" -a sha1 -eku 1.3.6.1.5.5.7.3.3 -r -sv root.pvk root.cer -ss Root -sr localMachine
makecert.exe -pe -n "CN=Mon Entreprise" -ss MY -a sha1 -eku 1.3.6.1.5.5.7.3.3 -iv root.pvk -ic root.cer
Get-ChildItem cert: -r -CodeSigningCert
$cert = Get-ChildItem cert:\CurrentUser\My -CodeSigningCert
Set-AuthenticodeSignature .\SendARP.ps1 -cert $cert
#se mettre en mode AllSigned pour tester les certificats
Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope LocalMachine
#Exporter son certificat .cer puis importer le certificat sur toutes les machines
gpmc.msc
#Create GPO domain and link it here
#Computer Configuration -> Policies -> Windows Setting -> Security Setting -> Public Key Policies -> Trusted Root Certification Autorities -> Import 
#Computer Configuration -> Policies -> Windows Setting -> Security Setting -> Software Restriction Policies -> New Software Restriction Policies -> Additional Rules -> New Certificate Rules -> Security Level:Unrestricted

### OBJET ANNUAIRE AVEC ADSI ###
#get-localgroup.ps1
[cmdletbinding()]
param(
 [Parameter(Mandatory=$false)]
 [String]$Computer=$env:COMPUTERNAME
)
$connection = [ADSI]"WinNT://$Computer"
$connection.PSBase.Children | Where {$_.PSBase.SchemaClassName -eq 'group'} | Select-Object -ExpandProperty Name | Out-File("a")

#get-localgroupmember.ps1 -Group Administrateurs
[cmdletbinding()]
param(
 [Parameter(Mandatory=$false)]
 [String]$Computer=$env:COMPUTERNAME
 [Parameter(Mandatory=$true, HelpMessage="nom groupe obligatoire")]
 [String]$Group
)
$connection = [ADSI]"WinNT://$Computer/$Group,group"
$connection.PSBase.Invoke('Members') | foreach {$_.GetType().InvokeMember("Name", "GetProperty", $null, $_, $null)}

#get-localgroupmemberv2.ps1 -Group Administrateurs
[cmdletbinding()]
param(
 [Parameter(Mandatory=$false)]
 [String]$Computer=$env:COMPUTERNAME
 [Parameter(Mandatory=$true, HelpMessage="nom groupe obligatoire")]
 [String]$Group
)
$connection = [ADSI]"WinNT://$Computer/$Group,group"
(($connection.PSBase.Invoke('Members') | foreach {$_.GetType().InvokeMember("AdsPath", "GetProperty", $null, $_, $null)}) -replace 'WinNT://', '') -replace '\/', '\'

#ajouter user à un groupe
$connection = [ADSI]"WinNT://$Computer/$Group,group"
$connection.Add("WinNT://User")
$connection.Remove("WinNT://User")
$oGroup.Put('Description', $Description)
$oGroup = $connection.PSBase.Rename($newName)
$oGroup.SetInfo()
$connection = [ADSI]"WinNT://$Computer"
#get local user
$connection.PSBase.Children | Where {$_.PSBase.SchemaClassName -eq "user"} | Select-Object -ExpandProperty Name
#effacer utilisateur
$connection.Delete('user', $user)
#créer utilisateur
$oUser = $connection.Create('user', $user)
$oUser.setPassword("$Password")
$oUser.PSBase.InvokeSet('Description', $Description)
#créer un groupe
$oGroup = $connection.Create('group', $Group)
$oGroup = $connection.Delete('group', $Group)
$oGroup.Put('Description', $Description)
$oGroup.SetInfo()

$user = [ADSI]'WinNT://./Xalloc,user'
$user.PSAdapted
$user.PSBase.Properties
$user.InvokeGet("LastLogin")
$user.InvokeSet("AccountDisabled", $True)
$userFlag = $user.InvokeGet("UserFlags")
$user.PSBase.InvokeSet('UserFlags', $($(UserFlags -bor 2)) #ADS_UF_ACCOUNTDISABLE = 2
$user.PSBase.CommitChanges()
#http://msdn2.microsoft.com/en-us/library/aa772300.aspx

######## ENUM ########
Add-Type -TypeDefinition @"
   public enum MyShortDayOfWeek
   {
      Sun,
      Mon,
      Tue,
      Wed,
      Thr,
      Fri,
      Sat
   }
"@

[MyShortDayOfWeek]$Day=[MyShortDayOfWeek]::Tue
$Day  #Show Day

switch ($Day)
{
    "Sun" {"It's Sun"; continue } 
    "Mon" {"It's Mon"; continue } 
    "Tue" {"It's Tue"; continue } 
    "Wed" {"It's Wed"; continue } 
    "Thu" {"It's Thu"; continue } 
    "Fri" {"It's Fri"; continue } 
    "Sat" {"It's Sat"; continue } 
}
# powershell > 5
enum InventoryType {
    Full
    Registry
    Dig
}
[InventoryType]::Full
######## MISC ########
[Enum]::GetNames( [System.Security.AccessControl.RegistryRights]
[System.Security.AccessControl.RegistryRights]::ReadKey
[System.Security.AccessControl.RegistryRights]::Delete
[PowerShell]::Create().AddScript{sleep 5;'a done'}
[console]::WriteLine("abc") #write-output
#https://www.computerperformance.co.uk/powershell/win32-networkadapter/
(Get-WmiObject -Class Win32_Service -Filter "name='WinRM'" -ComputerName Server01).StopService()

([Wmiclass]'Win32_Process').GetMethodParameters('Create')
Invoke-WmiMethod -Path win32_process -Name create -ArgumentList notepad.exe

$np = Get-WmiObject -Query "select * from win32_process where name='notepad.exe'"
$np | Remove-WmiObject

# PowerShell cmdlet to display a disk’s free space
$Item = @("DeviceId", "MediaType", "Size", "FreeSpace")
# Next follows one command split over two lines by a backtick `
Get-WmiObject -query "Select * from win32_logicaldisk" | Format-Table $item -auto

# PowerShell -Query example
$Item = @("DeviceId", "MediaType", "Size", "FreeSpace")
# Next follows one command split over four lines by backticks (`)
Get-WmiObject -computer YourMachine -query "Select $([string]::Join(‘,’,$Item)) from win32_logicaldisk where MediaType=12" | sort MediaType, DeviceID | Format-Table $item -auto
Get-WmiObject -Class Win32_NetworkAdapter
Disable-NetAdapter -Name "VMGuestTrafficAdapter" -CimSession HyperVServer4

########## WINDOWS FEATURE ###########
Add-WindowsCapability
Enable-WindowsOptionalFeature
Install-WindowsFeature
Add-WindowsFeature
dism.exe
pkgmgr.exe

########## PERFORMANCE ORDINATEUR ###########
perfmon.exe
Get-Counter -ListSet * | Sort-Object CounterSetName | Format-Table CounterSetName, Description -Autosize
Get-Counter -ListSet * | Select-Object -ExpandProperty Paths
Get-Counter -ListSet * | Select-Object -Property CounterSetName, @{n='#Counters';e={$_.counter.count}} | Sort-Object -Property CounterSetName | Format-Table -Autosize
Get-Counter -Counter "\Processeur(*)\% temps processeur" -MaxSamples 5 -SampleInterval 1 -ComputerName srv2012-1, srv2012-2
#script1
$scriptblock = { Get-Counter -Counter '\Processeur(_total)\%temps processeur' }
$computers = @('srv2012-1', 'srv2012-2')
Invoke-Command -ComputerName $computers -Credential $cred -ScriptBlock $scriptblock
#script2
$scriptblock = {
	$counter = '\Processeur(_total)%temps processeur'
	Get-Counter -Counter $counter | foreach { $._CounterSamples }
}
$r = Invoke-Command -ScriptBlock $scriptblock -ComputerName srv2012-1
#script3
$scriptblock = {
	Update-TypeData -TypeName Microsoft.PowerShell.Commands.GetCounter.PerformanceCounterSampleSet -SerializationDepth 2 -force
	Get-Counter -Counter '\Processeur(_total)\% temps processeur'
}
$r = Invoke-Command -ComputerName 
$r | Receive-Job | Select-Object -ExpandProperty CounterSimple
#script 4
$counters = '\Processeur(_total)\% temps processeur',
			'\Mémoire\Octets validés',
			'\Mémoire\Octets disponibles', '\Mémoire\Pages/s',
			'\Processus(*)\Plage de travail - Privée',
			'\Disque physique(_Total)\Lectures disque/s',
			'\Disque physique(_Total)\Écritures disque/s'
$scriptblock = {Get-Counter $using:counters -Max 120 -Sample 60 | Export-Counter -Path C:\PerfLogs\capture2.blg -FileFormat blg }
Invoke-Command $scriptblock -ComputerName localhost -AsJob
Import-Counter -Path C:\PerfLogs\capture2.blg -Summary
Import-Counter -Path C:\PerfLogs\capture2.blg -ListSet *

$data = Import-Counter -Path C:\PerfLogs\capture2.blg -ErrorAction "SilentlyContinue"
$data[1].Timestamp - $data[0].Timestamp | Select TotalSeconds

$data = Import-Counter -Path C:\PerfLogs\capture2.blg -Counter '\\ws2012fr-1\processeur(_total)\% temps processeur'
#Overall average calc
$d = $data | Select-Object -ExpandProperty countersamples | Where-Object { $_.Status -eq 0 }
#Get-AvgCPULoad
Param(
	[parameter(Mandatory=$true)]
	[string]$File,
	[parameter(Mandatory=$false)]
	[int]$interval = 5
)
$counter = '\\*\processeur(_total)\% temps processeur'
$data = Import-Counter -path $file -Counter $counter
$d = $data | Select-Object { $_.status -eq 0 }
for ($i=1; $i -lt $d.count; $i+=$interval)
{
	New-Object -TypeName PSObject -Property @{
		Timestamp = $d[$i].Timestamp;
		CPUAvg 	  = $d[$i..($i+($interval -1))] |
			Measure-Object -Prop cookedvalue -Average |
			Select-Object -ExpandProperty Average
	}
}
./Get-AvgCPULoad.ps1 -File ./capture.blg -interval 10
#Get-AvgGlobalLoad.ps1 
Param(
	[parameter(Mandatory=$true)]
	[string]$file
	[parameter(Mandatory=$false)]
	[int]$interval = 5
)
$counter = '\\*\Processeur(_total)\% temps processeur',
		   '\\*\Mémoire\Octets validés',
		   '\\*\Mémoire\Octets Page/s'
$data = Import-Counter -path $file -Counter $counter
$d = $data | where-Object {$_.countersamples.status -eq 0}
for($i=1;$i -lt $d.count;$i+=$interval)
{
	$UBound = $i+($interval-1)
	New-Object -TypeName PSObject -Property ([Ordered]@{
		Timestamp = $d[$i].Timestamp
		CPUAvg = [int]($d[$i..$UBound] |
			where {$_.CounterSamples.Path -like $counter[0]}
			foreach {$_.countersamples[0].cookedvalue} |
			measure -Average
			Select-Object -ExpandProperty )
		MemoryAvailableByteAvg = [int](($d[$i..$UBound] |
			where {$_.CounterSamples.Path -like $counter[1]} |
			foreach {$_.countersamples[1].cookedvalue} |
			measure -Average |
			Select-Object -ExpandProperty Average) / 1MB)
		MemoryPageAvg = [int]($d[$i..$UBound] |
			where {$_.CounterSamples.Path -like $counter[2]} |
			foreach {$_.countersamples[2].cookedvalue} |
			measure -Average |
			Select-Object -ExpandProperty Average)
	})
}
./Get-AvgGlobalLoad.ps1 -File ./capture.blg -interval 10
## CREDENTIALS ##
$credential = Get-Credential
$credential | Export-CliXml -Path 'C:\cred.xml'
$credential = Import-CliXml -Path 'C:\cred.xml'

########## DSC ###########
#Aliases: Chef, Puppet, CFEngine, GPO, SCCM

########## REGISTRY #########
#https://docs.microsoft.com/en-us/powershell/scripting/samples/working-with-registry-entries?view=powershell-6
$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryHive, $Computer)
[Microsoft.Win32.RegistryHive]::ClassesRoot
[Microsoft.Win32.RegistryHive]::CurrentUser
[Microsoft.Win32.RegistryHive]::LocalMachine
[Microsoft.Win32.RegistryHive]::Users
[Microsoft.Win32.RegistryHive]::CurrentConfig
reg export HKLM C:\Users\Xalloc\Desktop\HKLM.reg #HKLM, HKCU, HKCR, HKU, HKCC
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion /v DevicePath
Get-RegistryInfo -ComputerName server01, member01 -RegistryHive Users -RegistryKeyPath S-1-5-18 -Type ChildKey
Get-RemoteRegistryInfo -ComputerName server01, member01 -RegistryHive Users -RegistryKeyPath S-1-5-18\Environment -Type ValueData

Copy-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -Destination hkcu: -Recurse
Remove-Item -Path HKCU:\CurrentVersion -Recurse # remove itself
Remove-Item -Path HKCU:\CurrentVersion\* -
Get-Item -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion | Select-Object -ExpandProperty Property
Get-ItemProperty -Path .
Get-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion -Name DevicePath
Set-ItemProperty -Path HKCU:\Environment -Name Path -Value $newpath
New-ItemProperty -Name PowerShellPath -PropertyType String -Value $PSHome `
  -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion, HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion
Rename-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion -Name PowerShellPath -NewName PSHome
Remove-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion -Name PowerShellPath

Get-ChildItem -Path . -Include *Windows* -Recurse | Select pSChildName
Get-ChildItem -Path C:\Windows\*.dll -Recurse -Exclude [a-y]*.dll
#La commande suivante recherche dans le dossier Program Files tous les exécutables modifiés après le 1er octobre 2005, dont la taille n’est pas inférieure à 1 Mo ou supérieure à 10 Mo :
Get-ChildItem -Path $env:ProgramFiles -Recurse -Include *.exe | Where-Object -FilterScript {($_.LastWriteTime -gt '2005-10-01') -and ($_.Length -ge 1mb) -and ($_.Length -le 10mb)}
New-Item -Path . -Name 'Boost Enginer'
New-ItemProperty -Path . -Name 'GrammarLevel' -Value 3
Get-ItemProperty -Path . -Name 'Instrinsiclevel'
Remove-ItemProperty -Path .
Set-ItemProperty -Path -Name 'ParserLevel'
New-Item -Path 'C:\temp\New Folder' -ItemType Directory
New-Item -Path 'C:\temp\New Folder\file.txt' -ItemType File
Remove-Item -Path C:\temp\DeleteMe -Recurse
Get-Content -Path C:\temp\DomainMembers.txt
#Registre windows
Get-ChildItem -Path Registry::HKEY_CURRENT_USER
Get-ChildItem -Path Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER
Get-ChildItem -Path Registry::HKCU
Get-ChildItem -Path Microsoft.PowerShell.Core\Registry::HKCU
Get-ChildItem HKCU:
#registre à distance
$rootkey=[Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey("CurrentUser","DCK12ML")
$rootkey | gm
$Booster = $rootkey.OpenSubKey("Software\Booster", $True)
$Booster.GetValueNames()
$Booster.GetValue("GrammarLevel")
$Booster.GetValue("GrammarLevel",3)
$Booster.Dispose()
$Rootkey.Dispose()
#disable Windows Update
Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name DisableWindowsUpdateAccess -Value 
########## MENDATORY PROFILE ###########
#https://docs.microsoft.com/fr-fr/windows/client-management/mandatory-user-profile
Configuration HelloWorld {

    # Import the module that contains the File resource.
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    # The Node statement specifies which targets to compile MOF files for, when this configuration is executed.
    Node 'localhost' {

        # The File resource can ensure the state of files, or copy them from a source to a destination with persistent updates.
        File HelloWorld {
            DestinationPath = "C:\Temp\HelloWorld.txt"
            Ensure = "Present"
            Contents   = "Hello World from DSC!"
        }
    }
}
Import-DscResource -ModuleName PsDesiredStateConfiguration
Import-DscResource -ModuleName xWebAdministration
Test-DSCConfiguration

########### GPO ############
#https://www.powershellgallery.com/packages/PolicyFileEditor/3.0.0
$RegPath = 'Software\Policies\Microsoft\Windows\Control Panel\Desktop'
$RegName = 'ScreenSaverIsSecure'
$RegData = '1'
$RegType = 'String'
Set-PolicyFileEntry -Path $UserDir -Key $RegPath -ValueName $RegName -Data $RegData -Type $RegT

########### DATABASE ############
#https://vwiki.co.uk/MySQL_and_PowerShell
#make sure you have the .NET connector installed 1st - http://dev.mysql.com/downloads/connector/net/
function Connect-MySQL([string]$user,[string]$pass,[string]$MySQLHost,[string]$database) { 
  # Load MySQL .NET Connector Objects 
  [void][system.reflection.Assembly]::LoadWithPartialName("MySql.Data") 

  # Open Connection 
  $connStr = "server=" + $MySQLHost + ";port=3306;uid=" + $user + ";pwd=" + $pass + ";database="+$database+";Pooling=FALSE" 
  $conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connStr) 
  $conn.Open() 
  return $conn 
} 

function Disconnect-MySQL($conn) {
  $conn.Close()
}
#EXEMPLE 1#
# Connection Variables 
$user = 'myuser' 
$pass = 'mypass' 
$database = 'mydatabase' 
$MySQLHost = 'database.server.com' 

# Connect to MySQL Database 
$conn = Connect-MySQL $user $pass $MySQLHost $database
#EXEMPLE 2#
function Connect-MySQL([string]$user, [string]$pass, [string]$MySQLHost, [string]$database) { 
    # Load MySQL .NET Connector Objects 
    [void][system.reflection.Assembly]::LoadWithPartialName("MySql.Data") 
 
    # Open Connection 
    $connStr = "server=" + $MySQLHost + ";port=3306;uid=" + $user + ";pwd=" + $pass + ";database="+$database+";Pooling=FALSE" 
    try {
        $conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connStr) 
        $conn.Open()
    } catch [System.Management.Automation.PSArgumentException] {
        Log "Unable to connect to MySQL server, do you have the MySQL connector installed..?"
        Log $_
        Exit
    } catch {
        Log "Unable to connect to MySQL server..."
        Log $_.Exception.GetType().FullName
        Log $_.Exception.Message
        exit
    }
    Log "Connected to MySQL database $MySQLHost\$database"

    return $conn 
}

#EXEMPLE 3#
function Execute-MySQLNonQuery($conn, [string]$query) { 
  $command = $conn.CreateCommand()                  # Create command object
  $command.CommandText = $query                     # Load query into object
  $RowsInserted = $command.ExecuteNonQuery()        # Execute command
  $command.Dispose()                                # Dispose of command object
  if ($RowsInserted) { 
    return $RowInserted 
  } else { 
    return $false 
  } 
} 

# So, to insert records into a table 
$query = "INSERT INTO test (id, name, age) VALUES (1, 'Joe', 33)" 
$Rows = Execute-MySQLNonQuery $conn $query 
Write-Host $Rows " inserted into database"
#EXEMPLE 4#
function Execute-MySQLQuery([string]$query) { 
  # NonQuery - Insert/Update/Delete query where no return data is required
  $cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connMySQL)    # Create SQL command
  $dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($cmd)      # Create data adapter from query command
  $dataSet = New-Object System.Data.DataSet                                    # Create dataset
  $dataAdapter.Fill($dataSet, "data")                                          # Fill dataset from data adapter, with name "data"              
  $cmd.Dispose()
  return $dataSet.Tables["data"]                                               # Returns an array of results
}

# So, to produce a table of results from a query...
$query = "SELECT * FROM subnets;"
$result = Execute-MySQLQuery $query
Write-Host ("Found " + $result.rows.count + " rows...")
$result | Format-Table

function Execute-MySQLScalar([string]$query) {
    # Scalar - Select etc query where a single value of return data is expected
    $cmd = $SQLconn.CreateCommand()                                             # Create command object
    $cmd.CommandText = $query                                                   # Load query into object
    $cmd.ExecuteScalar()                                                        # Execute command
}
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand("USE $database", $conn)

Basic escaping of text can be performed by...

function Escape-MySQLText([string]$text) {
    [regex]::replace($text, "'", "\'")
    [regex]::replace($text, "\\", "\\")
}
if ([System.DBNull]::Value.Equals($db_query_result)) {
    Write-Host "Result is NULL"
}

######### ENVIRONMENT Variable ############
[System.Environment]::SetEnvironmentVariable('Test3', "C:\Users\Xalloc\Desktop\Desktop\Bourse\Test3", [System.EnvironmentVariableTarget]::Machine)

######### INSTALL OPENSSH #########
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Online Name OpenSSH.Server~~~~0.0.1.0
Add-WindowsCapability -Online Name OpenSSH.Client~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*
#if firewall rule does not exist
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
#remove
Remove-WindowsCapability -Online Name OpenSSH.Client~~~~0.0.1.0
Remove-WindowsCapability -Online Name OpenSSH.Server~~~~0.0.1.0
