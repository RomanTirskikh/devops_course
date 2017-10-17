provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Create a image nginx
resource "docker_image" "mynginx" {
  name = "nginx:latest"
#  keep_locally = "true"
}

# Create a image tomcat
resource "docker_image" "mytomcat" {
  name = "tomcat:latest"
#  keep_locally = "true"
}

# Create a container tomcat
resource "docker_container" "tomcat" {
  name  = "tomcat"
  image = "${docker_image.mytomcat.latest}"
  hostname = "tomcat"
  must_run = "true"
  restart = "on-failure"
  max_retry_count = "5"
#  provisioner "remote-exec" {
#   inline = [
#   "echo $(ip addr) > /tmp/ip_address.txt"
#   ]
#  }
  }

# Create a container nginx
resource "docker_container" "nginx" {
  name  = "nginx"
  image = "${docker_image.mynginx.latest}"
  hostname = "nginx"
  depends_on = ["docker_container.tomcat"]
  links = ["tomcat"]
  upload {
    content = "${var.tomcat_conf}"
#    content = "server {\n\n			 listen 80;\n server_name localhost;\n\n			 location / {\n			 proxy_set_header X-Forwarded-Host $host;\n			 proxy_set_header X-Forwarded-Server $host;\n			 proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n			 proxy_pass http://tomcat:8080;\n			 }\n}\n\n"
    file = "/etc/nginx/conf.d/default.conf"
  }
  ports {
    internal = "80"
    external = "80"
  }
  must_run = "true"
  restart = "on-failure"
  max_retry_count = "5"
}

# Create tomcat ip output
output "tomcat_ip" {
  value = "${docker_container.tomcat.ip_address}"
}

# Create nginx ip output
output "nginx_ip" {
  value = "${docker_container.nginx.ip_address}"
}

# Create minimal module
module "child" {
  source = "./child"
  memory = "1G"
}

# Create minimal module output
output "child_memory" {
  value = "${module.child.received}"
}

# Create backend consul
terraform {
  backend "consul" {
    address = "demo.consul.io"
    path    = "getting-started-fibvotngbeo"
    lock    = false
  }
}
