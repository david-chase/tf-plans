$sGkeProject = "gke-testing-430322"
$sClusterName = "k8master"
$sRegion = "northamerica-northeast2-a"

# Start a timer
$oStopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$oStopWatch.Start()

Write-Host Intializing Terraform -ForegroundColor Cyan
terraform init

Write-Host

Write-Host Applying Terraform plan -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host 

Write-Host Setting GCP project -ForegroundColor Cyan
gcloud config set project $sGkeProject

Write-Host 

Write-Host Updating ~/.kube/config -ForegroundColor Cyan
gcloud container clusters get-credentials $sClusterName --region=$sRegion

Write-Host 

# Stop the timer
$oStopWatch.Stop()
Write-Host Minutes elapsed: $oStopWatch.Elapsed.Minutes -ForegroundColor Cyan