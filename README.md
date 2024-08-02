tf-plans
========

<img src="https://www.densify.com/wp-content/uploads/densify.png" width="250">

This repo contains a set of Terraform / OpenTofu infrastructure files and scripts to build demo environments in AWS, Azure, and GCP that mirror a small portion of the infrastructure in the Densify "partner1" instance.  These environments can then be used to demo automating Densify recommendations using Terraform, or simply be used as test environments.

Folders
-------
credentials - This folder holds your GCP credentials.  
Iaas-AWS - Builds 3 VMs in AWS
Iaas-Azure - Builds 3 VMs in Azure
Iaas-GCE - Builds 3 VMs in GCE
k8s-AKS - Builds a simple 2-node AKS cluster in Azure
k8s-EKS - Builds a simple 2-node EKS cluster in AWS
k8s-GKE - Builds a simple 2-node EKS cluster in GCP

Credentials
-----------
For AWS and Azure you must have installed the corresponding CLI tool and used it to authenticate to your test environment.  The scripts will assume you are already authenticated and will fail if you are not.
For GCP, you must export the credentials for your test project in json format.  Save it in the \credentials folder with the name gcp-credentials.json.  
