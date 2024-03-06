terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
# Настройка провайдера Yandex Cloud
provider "yandex"{
token     = var.yandex_cloud_token # переменная для токена
cloud_id  = "b1g6i6egsm3t5v5eb3ak"
folder_id = "b1ghu4p1loak83ulpmm5"
zone      = "ru-central1-a"
}

# Объявление переменной для токена
variable "yandex_cloud_token"{
type        = string
description = "Данная переменная потребует ввести секретный токен в консоли при запуске terraform plan/apply"
}

# Создание сети
resource "yandex_vpc_network""network-1"{
name = "network1"
}

# Создание подсети
resource "yandex_vpc_subnet""subnet-1"{
name           = "subnet1"
zone           = "ru-central1-a"
network_id     = yandex_vpc_network.network-1.id
v4_cidr_blocks = [
    "192.168.10.0/24"
  ]
}

# Создание двух идентичных виртуальных машин с помощью аргумента count
resource "yandex_compute_instance""vmi"{
count = 2
name  = "vmi-${count.index + 1}"
labels = {
    "type" = "web-server"
  }
resources {
cores  = 2
memory = 2
  }
boot_disk {
initialize_params {
image_id = "fd87kbts7j40q5b9rpjr"
    }
  }
network_interface {
subnet_id = yandex_vpc_subnet.subnet-1.id
nat       = true
  }
metadata = {
user-data = "${file("./meta.txt")}"
  }
depends_on = [yandex_vpc_subnet.subnet-1
  ]
}

# Создание таргет-группы и добавление в нее виртуальных машин
resource "yandex_lb_target_group""mytargetgroup"{
name      = "mytargetgroup"
folder_id = "b1ghu4p1loak83ulpmm5"
region_id = "ru-central1"

target {
subnet_id = yandex_vpc_subnet.subnet-1.id
address   = yandex_compute_instance.vmi[
      0
    ].network_interface.0.ip_address
  }
target {
subnet_id = yandex_vpc_subnet.subnet-1.id
address   = yandex_compute_instance.vmi[
      1
    ].network_interface.0.ip_address
  }
}

# Создание сетевого балансировщика нагрузки
resource "yandex_lb_network_load_balancer""nlb"{
name      = "nlb"
folder_id = "b1ghu4p1loak83ulpmm5"
region_id = "ru-central1"

listener {
name         = "listener"
port         = 80
target_port  = 80
  }

attached_target_group {
target_group_id = yandex_lb_target_group.mytargetgroup.id
healthcheck {
name = "healthcheck"
http_options {
port = 80
path = "/"
      }
    }
  }
}