# Checks if the AzureAD module is installed an imported
# Check if a current connection to AzureAD exists
if(!(Get-Module -Name "AzureAD")){
    Write-Host "Installing and importing the AzureAD module" -ForegroundColor Yellow
    try{Install-Module AzureAD}
    catch{Write-Host "Could not install AzureAD module. Please try again." -ForegroundColor Red}
    try{Import-Module AzureAD}
    catch{Write-Host "Could not import AzureAD module. Please try again." -ForegroundColor Red}
    Write-Host "AzureAD module has installed imported successfully" -ForegroundColor Green
}

try{
    Write-Host "Connecting to AzureAD - please see the login prompt" -ForegroundColor Yellow
    Connect-AzureAD -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
    Write-Host "Connected to AzureAD" -ForegroundColor Green
}catch{
    Write-Host "Could not connect to AzureAD. Please try again." -ForegroundColor Red
    exit
}

# ObjectID's of each group we want to check which users are not a member of
$groupids = @("bf17af58-9f5b-481a-b5ea-cb609a681537", 
"0e16df75-efd2-4e7c-8f2d-20e461f66f81",
"26ef0c17-1238-490a-951b-8139faadc6f3",
"3a6a595b-6c8c-427a-8770-f9e1f03d7ae0",
"7219fa87-071d-441a-9392-dce69b682c00",
"7dcf78e5-0e58-4530-9839-e18e1de7fd6e",
"8a1c57a2-a67d-42f1-ac40-f359ade80139",
"96e4a45d-ece0-400c-82fd-116a27f0e012",
"9d520817-28b9-461f-94cb-1824f4057201",
"ae56a641-2d7e-4a3a-917c-ca8508ddd49d",
"b0ba1a01-c918-4696-9d44-d8a3be9970e0",
"cbd12591-f1d2-422b-a551-16ecdad98fa8",
"0e57a54f-a100-43ae-95b8-0ff5b470f2c8",
"5d85adca-1227-4b38-bb19-cb3c28b92f9f",
"fe03a817-9dbe-432c-9a51-d664baf9ccd5")

# Hashtable
$userht = @{} 

# Add all active accounts to the has table
Get-AzureADUser -All $true -Filter 'accountEnabled eq true' | foreach-object {$userht.Add($_.ObjectId, $_.UserPrincipalName)}

# Loops through the $groupId array and check if each user in the hash table is a member of that group, if the user is a member of the group then remove them from the hash table
ForEach($id  in  $groupids){
    Get-AzureADGroupMember -All $true -ObjectId $id | foreach-object { $userht.Remove($_.ObjectId) }
}

# Output the results to a .txt file
$userht | Out-File -FilePath "C:\temp\donedddsafe.txt"  
