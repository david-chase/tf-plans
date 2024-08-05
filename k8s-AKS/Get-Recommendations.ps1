Write-Host Exporting recommendations for cluster k8master to densify.auto.tfvars... -Foregroundcolor Cyan

..\ExportTo-Tf\ExportTo-Tf.ps1 -instance partner1 -analysisid 27af69b8-2f0b-4d2f-b255-99052402774c > densify.auto.tfvars.backup

Write-Host `nDone! -Foregroundcolor Cyan