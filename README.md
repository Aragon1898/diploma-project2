# DevOps Infrastructure Project on Yandex Cloud

![Architecture](diagrams/devops_infrastructure_-_yandex_cloud.png)

Проект разворачивает отказоустойчивую инфраструктуру для веб-приложения с использованием IaC и CI/CD практик.

##  Технологический стек
*   **Cloud:** Yandex Cloud
*   **IaC:** Terraform
*   **Config Management:** Ansible
*   **Containerization:** Docker
*   **CI/CD:** GitHub Actions
*   **Monitoring:** Prometheus + Grafana
*   **Code Quality:** SonarQube

##  Структура проекта
*   `/terraform` - Описание инфраструктуры (VPC, VM, Compute).
*   `/ansible` - Плейбуки для настройки серверов.
*   `/src` - Исходный код веб-приложения.
*   `/docker` - Dockerfile для сборки.

##  Как запустить
1.  Установить Terraform и Ansible.
2.  В папке `terraform` выполнить `terraform apply`.
3.  Внести IP-адреса в `ansible/hosts.ini`.
4.  Запустить плейбуки: `ansible-playbook -i hosts.ini install_docker.yml`.

##  Доступы
*   **Web App:** http://<APP_IP>
*   **Grafana:** http://<MONITORING_IP>:3000
*   **SonarQube:** http://<TOOLS_IP>:9000