Write-Host ""
Write-Host ::: Destroy EKS Cluster v2 ::: -ForegroundColor Cyan
Write-Host ""

# Delete the kubeconfig context
kubectl config delete-context ${kubectl config current-context}

Write-Host Destroying environment`n -ForegroundColor Cyan
terraform apply -destroy -auto-approve

# Write-Host Deleting eks-config.txt -ForegroundColor Cyan
# rm ~/.kube/eks-config.txt
# $env:KUBECONFIG = $env:OLD_KUBECONFIG
# $env:OLD_KUBECONFIG = ""

[console]::beep(500,300)