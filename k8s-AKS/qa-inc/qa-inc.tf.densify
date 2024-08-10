resource "kubernetes_manifest" "namespace_qa_inc" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Namespace"
    "metadata" = {
      "annotations" = {
        "mayfly.cloud.namecheap.com/expire" = "1h"
      }
      "name" = "qa-inc"
    }
  }
}

resource "kubernetes_manifest" "deployment_qa_inc_webserver_deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "webserver-deployment"
      "namespace" = "qa-inc"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "den-web"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "den-web"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "nginx"
              "imagePullPolicy" = "Always"
              "name" = "den-web"
              "ports" = [
                {
                  "containerPort" = 80
                  "name" = "http"
                },
              ]
              "resources" = {
                "limits" = {
                  # ----------
                  # Edit here
                  # ----------
                  "cpu" = "${ floor( var.densify_recommendations.webserver-deployment__den-web.recommendedCpuLimit ) }m"
                  "memory" = "${ floor( var.densify_recommendations.webserver-deployment__den-web.recommendedMemLimit ) }Mi"
                  # "cpu" = "200m"
                  # "memory" = "200Mi"
                }
                "requests" = {
                  # ----------
                  # Edit here
                  # ----------
                  "cpu" = "${ floor( var.densify_recommendations.webserver-deployment__den-web.recommendedCpuRequest ) }m"
                  "memory" = "${ floor( var.densify_recommendations.webserver-deployment__den-web.recommendedMemRequest ) }Mi"
                  # "cpu" = "100m"
                  # "memory" = "100Mi"
                }
              }
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_qa_inc_den_web_svc" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "den-web-svc"
      "namespace" = "qa-inc"
    }
    "spec" = {
      "ports" = [
        {
          "port" = 80
          "protocol" = "TCP"
          "targetPort" = 80
        },
      ]
      "selector" = {
        "app" = "den-web"
      }
      "type" = "NodePort"
    }
  }
}

resource "kubernetes_manifest" "ingress_qa_inc_den_web_ingress" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind" = "Ingress"
    "metadata" = {
      "name" = "den-web-ingress"
      "namespace" = "qa-inc"
    }
    "spec" = {
      "rules" = [
        {
          "host" = "den-web"
          "http" = {
            "paths" = [
              {
                "backend" = {
                  "service" = {
                    "name" = "den-web-svc"
                    "port" = {
                      "number" = 80
                    }
                  }
                }
                "path" = "/"
                "pathType" = "Prefix"
              },
            ]
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "deployment_qa_inc_audit_deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "audit-deployment"
      "namespace" = "qa-inc"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "den-audit"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "den-audit"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "nginx"
              "imagePullPolicy" = "Always"
              "name" = "den-audit"
              "resources" = {
                "limits" = {
                  # ----------
                  # Edit here
                  # ----------
                  "cpu" = "${ floor( var.densify_recommendations.audit-deployment__den-audit.recommendedCpuLimit ) }m"
                  "memory" = "${ floor( var.densify_recommendations.audit-deployment__den-audit.recommendedMemLimit ) }Mi"
                  # "cpu" = "200m"
                  # "memory" = "200Mi"
                }
                "requests" = {
                  # ----------
                  # Edit here
                  # ----------
                  "cpu" = "${ floor( var.densify_recommendations.audit-deployment__den-audit.recommendedCpuRequest ) }m"
                  "memory" = "${ floor( var.densify_recommendations.audit-deployment__den-audit.recommendedMemRequest ) }Mi"
                  # "cpu" = "100m"
                  # "memory" = "100Mi"
                }
              }
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_qa_inc_environment_deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "environment-deployment"
      "namespace" = "qa-inc"
    }
    "spec" = {
      "replicas" = 3
      "selector" = {
        "matchLabels" = {
          "app" = "den-env"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "den-env"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "nginx"
              "imagePullPolicy" = "Always"
              "name" = "den-env"
              "resources" = {
                "limits" = {
                  # ----------
                  # Edit here
                  # ----------
                  "cpu" = "${ floor( var.densify_recommendations.environment-deployment__den-env.recommendedCpuLimit ) }m"
                  "memory" = "${ floor( var.densify_recommendations.environment-deployment__den-env.recommendedMemLimit ) }Mi"
                  # "cpu" = "200m"
                  # "memory" = "200Mi"
                }
                "requests" = {
                  # ----------
                  # Edit here
                  # ----------
                  "cpu" = "${ floor( var.densify_recommendations.environment-deployment__den-env.recommendedCpuRequest ) }m"
                  "memory" = "${ floor( var.densify_recommendations.environment-deployment__den-env.recommendedMemRequest ) }Mi"
                  # "cpu" = "100m"
                  # "memory" = "100Mi"
                }
              }
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_qa_inc_loader_deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "loader-deployment"
      "namespace" = "qa-inc"
    }
    "spec" = {
      "replicas" = 2
      "selector" = {
        "matchLabels" = {
          "app" = "den-loader"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "den-loader"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "nginx"
              "imagePullPolicy" = "Always"
              "name" = "den-loader"
              "resources" = {
                "limits" = {
                  # ----------
                  # Edit here
                  # ----------
                  "cpu" = "${ floor( var.densify_recommendations.loader-deployment__den-loader.recommendedCpuLimit ) }m"
                  "memory" = "${ floor( var.densify_recommendations.loader-deployment__den-loader.recommendedMemLimit ) }Mi"
                  # "cpu" = "200m"
                  # "memory" = "200Mi"
                }
                "requests" = {
                  # ----------
                  # Edit here
                  # ----------
                  "cpu" = "${ floor( var.densify_recommendations.loader-deployment__den-loader.recommendedCpuRequest ) }m"
                  "memory" = "${ floor( var.densify_recommendations.loader-deployment__den-loader.recommendedMemRequest ) }Mi"
                  # "cpu" = "100m"
                  # "memory" = "100Mi"
                }
              }
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_qa_inc_scheduler_deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "scheduler-deployment"
      "namespace" = "qa-inc"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "den-sched"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "den-sched"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "nginx"
              "imagePullPolicy" = "Always"
              "name" = "den-sched"
              "resources" = {
                "limits" = {
                  # ----------
                  # Edit here
                  # ----------
                  "cpu" = "${ floor( var.densify_recommendations.scheduler-deployment__den-sched.recommendedCpuLimit ) }m"
                  "memory" = "${ floor( var.densify_recommendations.scheduler-deployment__den-sched.recommendedMemLimit ) }Mi"
                  # "cpu" = "200m"
                  # "memory" = "200Mi"
                }
                "requests" = {
                  # ----------
                  # Edit here
                  # ----------
                  "cpu" = "${ floor( var.densify_recommendations.scheduler-deployment__den-sched.recommendedCpuRequest ) }m"
                  "memory" = "${ floor( var.densify_recommendations.scheduler-deployment__den-sched.recommendedMemRequest ) }Mi"
                  # "cpu" = "100m"
                  # "memory" = "100Mi"
                }
              }
            },
          ]
        }
      }
    }
  }
}
