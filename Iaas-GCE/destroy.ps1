Write-Host Copying main.tf.original to main.tf -ForegroundColor Cyan
cp main.tf.original main.tf

Write-Host

Write-Host Destroying environment -ForegroundColor Cyan
terraform apply -destroy -auto-approve

[console]::beep(500,300)