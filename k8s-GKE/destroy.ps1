Write-Host ""
Write-Host ::: Destroy GKE Cluster v1 ::: -ForegroundColor Cyan
Write-Host ""

$sClusterName = "k8master"

Write-Host Destroying environment -ForegroundColor Cyan
terraform apply -destroy --auto-approve

Write-Host

Write-Host Deleting context $sClusterName from kubeconfig -ForegroundColor Cyan
kubectl config delete-context $sClusterName

[console]::beep(500,300)