Write-Host ""
Write-Host ::: Build AWS Iaas Environment v1 ::: -ForegroundColor Cyan
Write-Host ""

# Start a timer
$oStopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$oStopWatch.Start()

Write-Host Copying main.tf.original to main.tf -ForegroundColor Cyan
cp main.tf.original main.tf

Write-Host

Write-Host Intializing Terraform -ForegroundColor Cyan
terraform init -upgrade

Write-Host

Write-Host Applying Terraform plan -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host 

# Stop the timer
$oStopWatch.Stop()
Write-Host Minutes elapsed: $oStopWatch.Elapsed.Minutes -ForegroundColor Cyan

[console]::beep(500,300)