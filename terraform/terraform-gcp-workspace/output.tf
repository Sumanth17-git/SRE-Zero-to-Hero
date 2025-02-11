output "vm_ips" {
  value = {
    for idx, vm in google_compute_instance.vm_instance : idx => vm.network_interface[0].access_config[0].nat_ip
  }
}
