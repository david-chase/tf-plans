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
The contents of each folder are similar and follow this general format:

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

Comments
--------
* To make permanent changes to the main.tf file you need to make them in main.tf.original.  Any changes made in main.tf itself will be overwritten when you run destroy.ps1.
* Do not overwrite the densify.auto.tfvars files in each folder.  Some of the data in partner1 is stale and (for example) references instance types that are no longer available ot invalid instance names.  I've manually modified the contents of densify.auto.tfvars so that it doesn't generate errors.  This means that in some cases there will be small differences between what you see in the UI for partner1 and what you see in your demo environment.  Sorry, can't be avoided.
