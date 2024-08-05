Write-Host ""
Write-Host ::: Build AKS Cluster v1 ::: -ForegroundColor Cyan
Write-Host ""

$sClusterName = "k8master"
$sResourceGroup = "k8master-rg"

# Start a timer
$oStopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$oStopWatch.Start()

# We can't have the Kubernetes resources in the plan or they will error out because the cluster isn't even created yet.  So delete them.
rm qa-inc.tf

Write-Host Intializing Terraform`n -ForegroundColor Cyan
terraform init -upgrade

Write-Host `nApplying Terraform plan`n -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host `nUpdating ~/.kube/config`n -ForegroundColor Cyan
az aks get-credentials --resource-group $sResourceGroup --name $sClusterName --file ~\.kube\config

# Now we can create the Kubernetes resources
# This first line is a hack.  Terraform seems to choke on creating namespaces, at least in Azure
kubectl create ns qa-inc
Write-Host `nCopying qa-inc.tf.original to qa-inc.tf -ForegroundColor Cyan
cp qa-inc.tf.original qa-inc.tf
Write-Host `nRe-applying Terraform plan with Kuberetes resources`n -ForegroundColor Cyan
terraform apply -auto-approve

# Stop the timer
$oStopWatch.Stop()
Write-Host `nMinutes elapsed: $oStopWatch.Elapsed.Minutes -ForegroundColor Cyan

[console]::beep(500,300)