# 2. Группа Бэкендов
resource "yandex_alb_backend_group" "app_bg" {
  name = "app-backend-group"

  http_backend {
    name             = "app-http-backend"
    weight           = 1
    port             = 80
    
  
    target_group_ids = [yandex_compute_instance_group.app_group.application_load_balancer[0].target_group_id]
    
    load_balancing_config {
      panic_threshold = 90
    }    
    healthcheck {
      timeout = "10s"
      interval = "2s"
      healthy_threshold = 10
      unhealthy_threshold = 15 
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# 3. HTTP Роутер
resource "yandex_alb_http_router" "app_router" {
  name = "app-http-router"
}

resource "yandex_alb_virtual_host" "app_host" {
  name           = "app-virtual-host"
  http_router_id = yandex_alb_http_router.app_router.id
  route {
    name = "main-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.app_bg.id
        timeout          = "60s"
      }
    }
  }
}

# 4. Балансировщик
resource "yandex_alb_load_balancer" "app_alb" {
  name        = "app-load-balancer"
  network_id  = yandex_vpc_network.develop.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.develop_a.id
    }
  }

  listener {
    name = "app-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.app_router.id
      }
    }
  }
}