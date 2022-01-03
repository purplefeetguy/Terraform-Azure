#Setup Variables
$DCRoot = "DC=ad,DC=stiglab"
$STIGLabDCRoot = "OU=STIGLab,DC=ad,DC=STIGLab"
#Create Root Lab OU
New-ADOrganizationalUnit -Name "STIGLab" -Path $DCRoot -ProtectedFromAccidentalDeletion $False -Description "STIG Lab Environment"
#Create Other OUs
New-ADOrganizationalUnit -Name "Users" -Path $STIGLabDCRoot -ProtectedFromAccidentalDeletion $False -Description "STIG Lab Users"
New-ADOrganizationalUnit -Name "Service Accounts" -Path $STIGLabDCRoot -ProtectedFromAccidentalDeletion $False -Description "STIG Lab Service Accounts"
New-ADOrganizationalUnit -Name "Servers" -Path $STIGLabDCRoot -ProtectedFromAccidentalDeletion $False -Description "STIG Lab Servers"
New-ADOrganizationalUnit -Name "WVD" -Path $STIGLabDCRoot -ProtectedFromAccidentalDeletion $False -Description "STIG Lab WVD Session Hosts"
New-ADOrganizationalUnit -Name "Computers" -Path $STIGLabDCRoot -ProtectedFromAccidentalDeletion $False -Description "STIG Lab Computers"
New-ADOrganizationalUnit -Name "ANF" -Path $STIGLabDCRoot -ProtectedFromAccidentalDeletion $False -Description "STIG Lab ANF Objects"