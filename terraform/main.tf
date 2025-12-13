terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

# Настройка провайдера
provider "yandex" {
  token     = var.yandex_cloud_token
  folder_id = var.yandex_folder_id
  zone      = var.yandex_zone
}


#  Создаем пустую сеть (VPC)
resource "yandex_vpc_network" "develop" {
  name = "develop-network"
}

#  Создаем подсеть (subnet)
# В этой подсети будут жить наши виртуальные машины
resource "yandex_vpc_subnet" "develop_a" {
  name           = "develop-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

# === IAM (Права доступа для Группы ВМ) ===
resource "yandex_iam_service_account" "sa" {
  name = "my-robot-sa"
}

# Даем роботу права "editor", чтобы он мог управлять ВМ
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yandex_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}