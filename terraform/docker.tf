resource "azurerm_container_group" "cg" {
  for_each            = toset(local.regions)
  name                = module.naming[each.key].container_group.name
  location            = each.key
  resource_group_name = azurerm_resource_group.rg[each.key].name
  ip_address_type     = "Private"
  # dns_name_label      = "aci-ansible"
  os_type    = "Linux"
  subnet_ids = [module.avm-res-network-virtualnetwork[each.key].subnets["container_group"].resource_id]

  # identity = {
  #     type = system_assigned, user_assigned #          = true
  #     identity_ids = [
  #       module.avm-res-managedidentity-userassignedidentity[each.key].resource_id
  #     ]
  #     # user_assigned_resource_ids = [module.avm-res-managedidentity-userassignedidentity[each.key].resource_id]
  #   }


  container {
    name   = "ansible"
    image  = "ubuntu:latest"
    cpu    = "1.0"
    memory = "2.0"

    ports {
      port     = 22
      protocol = "TCP"
    }
  }

  # container {
  #   name   = "sidecar"
  #   image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
  #   cpu    = "0.5"
  #   memory = "1.5"
  # }
}
