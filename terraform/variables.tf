variable "yandex_cloud_token" {
  description = "Yandex Cloud API Token"
  type        = string
  sensitive   = true # Скрывает значение в логах
}

variable "yandex_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  default     = "b1g7v5bfi1tuc786esc8" # Твой Folder ID
}

variable "yandex_zone" {
  description = "Default Availability Zone"
  type        = string
  default     = "ru-central1-a"
}