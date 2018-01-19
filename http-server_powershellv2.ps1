# Preparation
# runs with PowerShell v2 (check with: get-host|Select-Object version)
# Windows 7
# run powershell as admin
# if you get the error "... running scripts is disabled on this system." you need to check your current policy that might be "restricted" with:
# Get-ExecutionPolicy
# then allow running scripts with:
# Set-ExecutionPolicy RemoteSigned
# confirm with "Y"
# and when you don't need to run the script anymore you can revert to restricted (or whatever it was before):
# Set-ExecutionPolicy restricted

# CONFIGURE HERE
$YourIP = "192.168.1.10";
$Port = 80;



# PROGRAM

# get local IP addresses
if (Get-Command "Get-NetIPAddress" -errorAction SilentlyContinue)
{
    Write-Host "[Info] found the following systems IP addresses: ";
    Get-NetIPAddress -AddressFamily IPv4 | Select IPAddress | Format-Table;
}


$currentpath = split-path -parent $MyInvocation.MyCommand.Definition;
$www_root = $currentpath + "\www";
$httpSourceFilePath = $currentpath + "\http_powershellv2.cs";

$source = Get-Content -Path $httpSourceFilePath;

if ('HttpFileServer' -as [type]) {
  Write-Host 'Class HttpFileServer is already loaded';
}
else
{
    Add-Type -Path $httpSourceFilePath;
}

$webServer = New-Object HttpFileServer($www_root, $Port, $YourIP, $true);

# keep the process running and wait for user input
[void](Read-Host 'Press Enter to stop the server')  ;

# stop the server and remove the process
$webServer.Dispose();

