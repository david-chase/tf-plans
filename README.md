<img src="https://www.densify.com/wp-content/uploads/densify.png" width="250">

tf-plans
========

This repo contains a set of Terraform / OpenTofu infrastructure files and scripts to build demo environments in AWS, Azure, and GCP that mirror a small portion of the infrastructure in the Densify "partner1" instance.  These environments can then be used to demo automating Densify recommendations using Terraform, or simply be used as test environments.

Folders
-------
| Folder | Contents
| ------ | --------
| credentials | This folder holds your GCP credentials |
| Iaas-AWS | Builds 3 VMs in AWS |
| Iaas-Azure | Builds 3 VMs in Azure |
| Iaas-GCE | Builds 3 VMs in GCE |
| k8s-AKS | Builds a simple 2-node AKS cluster in Azure |
| k8s-EKS | Builds a simple 2-node EKS cluster in AWS |
| k8s-GKE | Builds a simple 2-node EKS cluster in GCP |

Credentials
-----------
For AWS and Azure you must have installed the corresponding CLI tool and used it to authenticate to your test environment.  The scripts will assume you are already authenticated and will fail if you are not.
For GCP, you must export the credentials for your test project in json format.  Save it in the \credentials folder with the name gcp-credentials.json.  

Folder Contents
---------------
The contents of each folder are similar and follow the following general format:

| File | Purpose |
| ---- | ------- |
| build.ps1 | This is a simple PowerShell script to build the infrastructure |
| densify.auto.tfvars | Contains an export of a single Densify analysis in Terraform format^* |
| destroy.ps1 | This is a simple PowerShell script to destroy the infrastructure after you've used it. |
| main.tf | Contains the actual resource definitions we're deploying |
| main.tf.original | In many of the demos you will edit the main.tf file live.  This file will be used to overwrite main.tf afet the demo is done to reset your changes |
| providers.tf | Contains the definitions for any providers |
| terraform.tfvars | Declares any additional variables used in the demo |
| variables.tf | Declares any variables used in the demo, including "densify_recommendations" |
