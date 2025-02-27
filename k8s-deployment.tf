resource "kubernetes_namespace" "my_namespace" {
  metadata {
    name = "${var.k8s_name}-app"
  }
}

resource "kubernetes_deployment" "my_app" {
  metadata {
    name      = "${var.k8s_name}-deployment"
    namespace = kubernetes_namespace.my_namespace.metadata.0.name
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = var.k8s_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.k8s_name
        }
      }

      spec {
        container {
          name  = "${var.k8s_name}-container"
          image = "${azurerm_container_registry.acr.login_server}/myfrontendimage:latest"

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "my_service" {
  metadata {
    name      = "${var.k8s_name}-service"
    namespace = kubernetes_namespace.my_namespace.metadata.0.name
  }

  spec {
    selector = {
      app = var.k8s_name
    }

    port {
      protocol    = "TCP"
      port        = var.port
      target_port = var.target_port
    }

    type = "LoadBalancer"
  }
}
