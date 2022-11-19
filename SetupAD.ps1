function Install-AADInternals {
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
	Install-Module AADInternals -Scope CurrentUser -RequiredVersion 0.7.8
	Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
}


$oldExecPolicy = Get-ExecutionPolicy
try {
	$oldExecPolicy = Get-ExecutionPolicy
	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

	Install-AADInternals
} catch {
	Set-ExecutionPolicy -ExecutionPolicy $oldExecPolicy -Scope Process
}