resource "local_file" "inventory" {
  filename = "../ansible/inventory.ini"
  content = templatefile("../ansible/inventory.ini.tftpl", {
    
    web_instance_id = module.web_server.id
    web_private_ip = module.web_server.private_ip

    controller_instance_id = module.controller_server.id
    controller_private_ip = module.controller_server.private_ip

    monitoring_instance_id = module.monitoring_server.id
    monitoring_private_ip = module.monitoring_server.private_ip

  })
}