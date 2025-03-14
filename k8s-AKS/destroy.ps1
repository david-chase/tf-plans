Write-Host ""
Write-Host ::: Destroy AKS Cluster v2 ::: -ForegroundColor Cyan
Write-Host ""

# Delete the kubeconfig context
$sCurrentContext = kubectl config current-context
kubectl config delete-context $sCurrentContext

Write-Host Destroying environment -ForegroundColor Cyan
terraform apply -destroy -auto-approve

Write-Host

# Write-Host Deleting eks-config.txt -ForegroundColor Cyan
# rm ~/.kube/eks-config.txt
# $env:KUBECONFIG = $env:OLD_KUBECONFIG
# $env:OLD_KUBECONFIG = ""

[console]::beep(500,300)