# Installs the AD DS Windows feature and promotes this server to a brand
# new Active Directory forest. Runs once, automatically, right after the
# VM boots for the first time.

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment

$dsrmPassword = ConvertTo-SecureString "DSRM_PASSWORD" -AsPlainText -Force

Install-ADDSForest `
    -DomainName "DOMAIN_NAME" `
    -DomainNetbiosName "DOMAIN_NETBIOS" `
    -ForestMode "WinThreshold" `
    -DomainMode "WinThreshold" `
    -InstallDns:$true `
    -SafeModeAdministratorPassword $dsrmPassword `
    -Force:$true `
    -NoRebootOnCompletion:$false
# The VM reboots here on its own. That's expected — AD DS can't finish
# turning on until Windows restarts.