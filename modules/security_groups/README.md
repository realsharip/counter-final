Module created by Sharip Alikhanov

This is AWS security groups module where we can define inbound and outbound traffic.
Tricky part was link security group with VPC. To do that, we need provide vpc_id in security group resource block.
Also we need define environment variable for "vpc_id" and leave it empty, because we will pass value in root module.
To extract "vpc_id" we need create output for it in VPC module. Finaly we need provide this output value in root module in security group section in following format: module.vpc_eks(name of module).vpc_id(name of output)