Write-Host ""
Write-Host ::: Build EKS Cluster v1 ::: -ForegroundColor Cyan
Write-Host ""

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
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

Write-Host 

# Stop the timer
$oStopWatch.Stop()
Write-Host Minutes elapsed: $oStopWatch.Elapsed.Minutes -ForegroundColor Cyan

[console]::beep(500,300)