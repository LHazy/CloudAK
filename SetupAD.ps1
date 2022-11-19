function Install-AADInternals {
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
	Install-Module AADInternals -Scope CurrentUser -RequiredVersion 0.7.8
	Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
}

function Install-Python3 {
	cd temp
	Invoke-WebRequest https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe -OutFile python-3.11.0-amd64.exe

	$p = Start-Process ./python-3.11.0-amd64.exe -ArgumentList "PrependPath=1 Include_test=0 InstallAllUsers=0 DefaultJustForMeTargetDir=C:\Python311"
	while ($null -ne (Get-Process -Id $p.Id -ErrorAction SilentlyContinue)) {
		Start-Sleep -Seconds 5
		Write-Host "installing python"
	}

	write-host "installed python"
	cd ../
}

function Install-Python2 {
	cd temp
	Invoke-WebRequest https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi -OutFile python-2.7.18.amd64.msi
	
	$p = Start-Process msiexec.exe -ArgumentList "/a /ju python-2.7.18.amd64.msi ALLUSERS=0 TARGETDIR=c:\\python27 ADDLOCAL=DefaultFeature,Extensions,Tools,PrependPath,pip_feature" -PassThru
	Wait-Process -Id $p.Id
}


function Install-O365creeper {
	Invoke-WebRequest https://raw.githubusercontent.com/LMGsec/o365creeper/master/o365creeper.py -OutFile C:\Tools\Azure\o365creeper.py
}

$oldExecPolicy = Get-ExecutionPolicy
try {
	mkdir temp
	mkdir C:\Tools\Azure

	$oldExecPolicy = Get-ExecutionPolicy
	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

	Install-AADInternals
	Install-Python3
	Install-O365creeper
} catch {
	Remove-Item temp
	Set-ExecutionPolicy -ExecutionPolicy $oldExecPolicy -Scope Process
}