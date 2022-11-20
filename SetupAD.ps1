function Install-AADInternals {
	Install-Module AADInternals -Scope CurrentUser -RequiredVersion 0.7.8
}

function Install-MicroBurst {
	Invoke-WebRequest https://github.com/NetSPI/MicroBurst/archive/refs/heads/master.zip -OutFile temp\MicroBurst-master.zip
	Expand-Archive temp\MicroBurst-master.zip -DestinationPath C:\CloudAK\Tools\Azure
	Move-Item C:\CloudAK\Tools\Azure\MicroBurst-master C:\CloudAK\Tools\Azure\MicroBurst

	Install-Module Az -Scope CurrentUser -RequiredVersion 9.1.1
	Install-Module AzureAD -Scope CurrentUser -RequiredVersion 2.0.2.140
	Install-Module MSOnline -Scope CurrentUser -RequiredVersion 1.1.183.66

	Import-Module C:\CloudAK\Tools\Azure\MicroBurst\MicroBurst.psm1
}

function Install-Python3 {
	cd temp
	Invoke-WebRequest https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe -OutFile python-3.11.0-amd64.exe

	$p = Start-Process ./python-3.11.0-amd64.exe -ArgumentList "PrependPath=1 Include_test=0 InstallAllUsers=0 DefaultJustForMeTargetDir=C:\Python311"
	Wait-Process -Id $p.Id

	cd ../
}

function Install-Python2 {
	cd temp
	Invoke-WebRequest https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi -OutFile python-2.7.18.amd64.msi
	
	$p = Start-Process msiexec.exe -ArgumentList "/i python-2.7.18.amd64.msi ALLUSERS=0 TARGETDIR=c:\python27 ADDLOCAL=DefaultFeature,Extensions,Tools,PrependPath,pip_feature" -PassThru
	Wait-Process -Id $p.Id

	cd ../
}


function Install-O365creeper {
	C:\python27\python.exe -m pip install requests
	Invoke-WebRequest https://raw.githubusercontent.com/LMGsec/o365creeper/master/o365creeper.py -OutFile C:\CloudAK\Tools\Azure\o365creeper.py
}

$oldExecPolicy = Get-ExecutionPolicy
$psRepoTrustPolicy = Get-PSRepository -Name PSGallery

try {
	mkdir temp
	mkdir C:\CloudAK\Tools\Azure

	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

	Install-AADInternals
	Install-Python2
	# Install-Python3
	Install-O365creeper
	Install-MicroBurst
} finally {
	Remove-Item temp
	Set-ExecutionPolicy -ExecutionPolicy $oldExecPolicy -Scope Process
	Set-PSRepository -Name PSGallery -InstallationPolicy $psRepoTrustPolicy.InstallationPolicy
}
