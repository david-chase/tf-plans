# Specify path of service account private-key json file
credentials_file = "../credentials/gcp-credentials.json"

# GKE Cluster Name
cluster_name = "k8master"

# Number of Nodes
node_count = "2"

# Name of your GCP project
project_id = "gke-testing-430322"

# The region in which to create resources
region = "northamerica-northeast2-a"

# The type of instance to place in the node pool
machine_type = "n1-standard-2"