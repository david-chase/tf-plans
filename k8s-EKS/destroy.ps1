Write-Host ""
Write-Host ::: Destroy EKS Cluster v1 ::: -ForegroundColor Cyan
Write-Host ""

$sClusterName = $(terraform output -raw cluster_name)

Write-Host Destroying environment -ForegroundColor Cyan
terraform apply -destroy -auto-approve

Write-Host

Write-Host Deleting context $sClusterName from kubeconfig -ForegroundColor Cyan
kubectl config delete-context $sClusterName

aws eks --region $(terraform output -raw region) update-kubeconfig --name $sClusterName

[console]::beep(500,300)