output "vpc_id" {
  description = "VPC ID for both clusters"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "Subnet IDs keyed by cluster"
  value = {
    dev_test   = aws_subnet.dev_test_cluster.id
    production = aws_subnet.production_cluster.id
  }
}

output "cluster_nodes" {
  description = "Instance details for all cluster nodes"
  value = {
    for node_name, instance in aws_instance.cluster_nodes : node_name => {
      id         = instance.id
      private_ip = instance.private_ip
      public_ip  = instance.public_ip
      cluster    = instance.tags["Cluster"]
      role       = instance.tags["Role"]
    }
  }
}

output "devtest_control_plane_public_ip" {
  description = "Public IP for Dev/Test control plane node"
  value       = aws_instance.cluster_nodes["devtest_control_plane"].public_ip
}

output "production_control_plane_public_ip" {
  description = "Public IP for Production control plane node"
  value       = aws_instance.cluster_nodes["production_control_plane"].public_ip
}
