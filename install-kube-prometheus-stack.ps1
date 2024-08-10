Write-Host ""
Write-Host ::: Install-Kube-prometheus-stack v1 ::: -ForegroundColor Cyan
Write-Host ""

Write-Host Adding Helm repo... -ForegroundColor Cyan
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

Write-Host `nUpdating Helm repos... -ForegroundColor Cyan
helm repo update

Write-Host `nInstalling Helm chart... -ForegroundColor Cyan
helm install prometheus prometheus-community/kube-prometheus-stack `
    -n monitoring `
    --set alertmanager.persistentVolume.storageClass="default" `
    --set server.persistentVolume.storageClass="default" `
    --create-namespace 
    # --set adminPassword='yM73txhrUpRJ' 

# Disable data collection for system namespaces
Write-Host `nUpdating Helm deployment... -ForegroundColor Cyan

helm upgrade prometheus `
    prometheus-community/kube-prometheus-stack `
    --namespace monitoring `
    --set kubeEtcd.enabled=false `
    --set kubeControllerManager.enabled=false `
    --set kubeScheduler.enabled=false 