cluster_name = "k8master"
resource_group_name = "k8master-rg"
resource_group_name_nodepool = "k8master-nodepool-rg"
resource_group_location="canadacentral"
node_count = "2"
vm_size = "Standard_D2_v2"
nodepool_name = "k8masternp"
kubernetes_version = "1.30"
max_nodes = 3

# User name for the cluster
username = "dchase"