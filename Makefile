cluster_name = realeks
service = my-service

eks-init:
	terraform init
	terraform apply --auto-approve
	aws eks update-kubeconfig --name $(cluster_name)
	kubectl apply -f aws_auth/config_map_aws_auth.yaml
	sleep 90
	kubectl get nodes
	sleep 10
	kubectl apply -f ./counter/counter.yaml
	sleep 15
	kubectl describe svc $(service) | grep -i Ingress



eks-destroy:
	kubectl delete -f ./counter/counter.yaml
	sleep 30
	terraform destroy --auto-approve
	rm -rf aws_auth
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
	rm -rf terraform.tfstate
	rm -rf terraform.tfstate.backup