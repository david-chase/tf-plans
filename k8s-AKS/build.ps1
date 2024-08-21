cls
Write-Host ""
Write-Host ::: Build AKS Cluster v2 ::: -ForegroundColor Cyan
Write-Host ""

# Prompt for the user's name
Write-Host Please type your userid.  This is used to tag these cloud resources as yours -ForegroundColor Green 
$sOwner = Read-Host
$env:TF_VAR_owner = $sOwner

# Ask if we want to install kube-prometheus-stack
Write-Host Install kube-prometheus-stack? [Y/n] -ForegroundColor Green -NoNewline
$sDeployProm = Read-Host
if( $sDeployProm.ToLower() -eq "n" ) { 
    $bDeployProm = $false
    Write-Host "No" -ForegroundColor Cyan 
} 
else { 
    $bDeployProm = $true
    Write-Host "Yes" -ForegroundColor Cyan
}

# Ask if we want to install qa-inc namespace
Write-Host Install qa-inc demo namespace? [Y/n] -ForegroundColor Green -NoNewline
$sDeployQa = Read-Host
if( $sDeployQa.ToLower() -eq "n" ) { 
    $bDeployQa = $false
    Write-Host "No" -ForegroundColor Cyan 
} 
else { 
    $bDeployQa = $true
    Write-Host "Yes" -ForegroundColor Cyan
}

# Start a timer
$oStopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$oStopWatch.Start()

# Terraform init
Write-Host `nInitializing Terraform`n -ForegroundColor Cyan
terraform init -upgrade
if( $LastExitCode ) {
    Write-Error "Terraform init finished with error code $LastExitCode.  Exiting."
    [console]::beep(900,300)
    Exit
}

# Terraform plan
$iResult = Write-Host `nApplying Terraform plan`n -ForegroundColor Cyan
terraform apply -auto-approve
if( $LastExitCode ) {
    Write-Error "Terraform plan finished with error code $LastExitCode.  Exiting."
    [console]::beep(900,300)
    Exit
}

Write-Host `nUpdating kubeconfig`n -ForegroundColor Cyan
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)

# Write-Host `nCreating namespace`n -ForegroundColor Cyan
# kubectl create ns qa-inc

if( $bDeployProm ) {
    & ../install-kube-prometheus-stack.ps1
} # if( $bDeployProm )

if( $bDeployQa ) {
    cd qa-inc
    # Reset qa-inc.tf in case were were tampering with it last time we did the demo
    cp qa-inc.tf.original qa-inc.tf
    Write-Host `nIntializing Terraform`n -ForegroundColor Cyan
    terraform init -upgrade

    Write-Host `nApplying Terraform plan`n -ForegroundColor Cyan
    terraform apply -auto-approve
} # if( $bDeployQa )

# Stop the timer
$oStopWatch.Stop()
Write-Host Minutes elapsed: $oStopWatch.Elapsed.Minutes -ForegroundColor Cyan

[console]::beep(500,300)