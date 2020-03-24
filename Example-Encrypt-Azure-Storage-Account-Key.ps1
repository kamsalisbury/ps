# Adapted from credit: https://stackoverflow.com/questions/23538200/encrypt-azure-storage-account-name-and-key-in-powershell-script/23541332#23541332
# To create the encrypted key file
#$KeyFile = 'Path\to\secure.key'
#$EncryptedStorageKey = Read-Host -Prompt "Enter Storage Key" -AsSecureString #From Azure Portal, Storage Account, Access Keys 
#ConvertFrom-SecureString $EncryptedStorageKey | Set-Content $KeyFile

# Examples using encrypted key file to authenticate to Azure Storage Account
$StorageAccountName = 'MyStorageAccount1'
$StorageContainerName = "MyContainer1"
$EncryptedStorageKey = Get-Content $KeyFile |  ConvertTo-SecureString
$DecryptedKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($EncryptedStorageKey));
$StorageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $DecryptedKey

# Copy everything under $SourcePath to $StorageContext $StorageContainer
$SourcePath = "Path\to\data\to\copy\to\blob"
Get-ChildItem -File -Recurse $SourcePath | Set-AzStorageBlobContent -Context $StorageContext -Container $StorageContainerName

# Copy everything under $SourcePath to $StorageContext $StorageContainer if modified in last 5 days
Get-ChildItem -File -Recurse $SourcePath | ?{$_.LastWriteTime -gt (Get-Date).AddDays(-5)} | Set-AzStorageBlobContent -Context $StorageContext -Container $StorageContainerName