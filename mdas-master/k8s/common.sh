location='westeurope'
group='mdas-group'
cluster='mdas-cluster'
registry='mdasregistry'
subscription='6acd2c32-dc10-4160-a7b4-6b70cedf78f9'
deployment='mdas-aks'

get_credentials(){
   az aks get-credentials --resource-group $group --name $cluster
   kubectl config set-context $cluster
   kubectl get nodes
}

create_registry(){
  az acr create \
    --resource-group $group \
    --name $registry \
    --sku Basic

  # Get the ACR registry resource id
  ACR_ID=$(az acr show \
    --name $registry \
    --resource-group $group \
    --query "id" --output tsv)

  # Create role assignment
  az role assignment create --assignee ${CLIENT_ID} --role Reader --scope $ACR_ID
}