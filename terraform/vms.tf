# === Образ Ubuntu ===
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# === Instance Group (Группа масштабирования приложения) ===
resource "yandex_compute_instance_group" "app_group" {
  name                = "app-ig"
  folder_id           = var.yandex_folder_id
  service_account_id  = yandex_iam_service_account.sa.id
  depends_on          = [yandex_resourcemanager_folder_iam_member.sa-editor]

  # Шаблон ВМ
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu.id
        size     = 10
      }
    }
    network_interface {
      network_id = yandex_vpc_network.develop.id
      subnet_ids = [yandex_vpc_subnet.develop_a.id]
      nat        = true
    }
    metadata = {
      # Убедись, что путь правильный
      ssh-keys = "ubuntu:${file("C:/Users/User/.ssh/id_ed25519.pub")}"
    }
  }

  # Сколько серверов держать (2 шт)
  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  # ВОТ ЧЕГО НЕ ХВАТАЛО: Политика распределения (Зона доступности)
  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }

  # Подключаем к Балансировщику
  application_load_balancer {
   target_group_name = "app-tg" 
  }
}

# === 2. Monitoring (Prometheus + Grafana) ===
resource "yandex_compute_instance" "monitoring" {
  name        = "monitoring-server"
  platform_id = "standard-v3"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 15
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_a.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

# === 3. Tools (SonarQube + Nexus) ===
resource "yandex_compute_instance" "tools" {
  name        = "tools-server"
  platform_id = "standard-v3"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 30
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_a.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}