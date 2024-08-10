Write-Host ""
Write-Host ::: Build GKE Cluster v2 ::: -ForegroundColor Cyan
Write-Host ""

$sGkeProject = "gke-testing-430322"
$sClusterName = "k8master"
$sRegion = "northamerica-northeast2-a"

# Start a timer
$oStopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$oStopWatch.Start()

Write-Host `nIntializing Terraform -ForegroundColor Cyan
terraform init -upgrade

Write-Host `nApplying Terraform plan -ForegroundColor Cyan
terraform apply --auto-approve

Write-Host `nSetting GCP project -ForegroundColor Cyan
gcloud config set project $sGkeProject

Write-Host `nUpdating ~/.kube/config -ForegroundColor Cyan
gcloud container clusters get-credentials $sClusterName --region=$sRegion

# Now we can create the Kubernetes resources
# This first line is a hack.  Terraform seems to choke on creating namespaces
kubectl create ns qa-inc
cd qa-inc
Write-Host `nCopying qa-inc.tf.original to qa-inc.tf -ForegroundColor Cyan
cp qa-inc.tf.original qa-inc.tf
Write-Host `nRe-applying Terraform plan with Kuberetes resources`n -ForegroundColor Cyan
terraform apply -auto-approve
cd ..

# Stop the timer
$oStopWatch.Stop()
Write-Host Minutes elapsed: $oStopWatch.Elapsed.Minutes -ForegroundColor Cyan

[console]::beep(500,300)