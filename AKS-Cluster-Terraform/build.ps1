$sClusterName = "k8master"
$sResourceGroup = "k8master-rg"

# Start a timer
$oStopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$oStopWatch.Start()

Write-Host Intializing Terraform -ForegroundColor Cyan
terraform init -upgrade

Write-Host

Write-Host Applying Terraform plan -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host 

Write-Host Updating ~/.kube/config -ForegroundColor Cyan
az aks get-credentials --resource-group $sResourceGroup --name $sClusterName --file ~\.kube\config

Write-Host 

# Stop the timer
$oStopWatch.Stop()
Write-Host Minutes elapsed: $oStopWatch.Elapsed.Minutes -ForegroundColor Cyan

[console]::beep(500,300)