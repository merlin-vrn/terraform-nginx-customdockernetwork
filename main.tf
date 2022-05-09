provider "docker" {}

provider "random" {}

resource "docker_image" "nginx" {
  name = "nginx:latest"
  keep_locally = true
}

resource "random_string" "nginx" {
  length = 4
  special = false
  upper = false
}

resource "docker_volume" "nginx" {
  name = "nginx-${random_string.nginx.id}"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name = "nginx-${random_string.nginx.id}"

  networks_advanced {
    name = "macvlan5"
  }

  volumes {
    container_path = "/usr/share/nginx/html"
    volume_name = docker_volume.nginx.id
  }

  log_opts = {
    max-size = "10m"
  }
}
