output "load_balancer_ip" {
  description = "Public IP of the Application Load Balancer"
  value       = yandex_alb_load_balancer.app_alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "monitoring_ip" {
  value = yandex_compute_instance.monitoring.network_interface.0.nat_ip_address
}

output "tools_ip" {
  value = yandex_compute_instance.tools.network_interface.0.nat_ip_address
}