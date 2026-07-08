# Terraform

Tf project

#First create a vpc and subnets configurations
#Do not forget to create a route in the route table that connects the subnet to internet gateway

Every fresh terraform init starts you on the default workspace. It's good practice to always run terraform workspace show before a plan or apply to confirm you're on the right environment, especially before touching prod.
