#!/bin/bash

./login.sh

. ./config.sh

# Create resource group
az group create \
    --name $AZ_RESOURCE_GROUP \
    --location $AZ_LOCATION

# Create event hub namespace
az eventhubs namespace create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_EVENTHUBS_NAMESPACE_NAME \
    --location $AZ_LOCATION

# Create event hub instance
az eventhubs eventhub create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_EVENTHUB_NAME \
    --namespace-name $AZ_EVENTHUBS_NAMESPACE_NAME

# Prepare authorization for signed in user
# Get event hub namespace ID
export AZURE_RESOURCE_ID=$(az resource show \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_EVENTHUBS_NAMESPACE_NAME \
    --resource-type Microsoft.EventHub/Namespaces \
    --query "id" \
    --output tsv | sed -e 's/\r//g')    
# Get logged in user ID
export AZURE_ACCOUNT_ID=$(az ad signed-in-user show \
    --query "id" --output tsv | sed -e 's/\r//g')
# Grant user the necessary roles
az role assignment create \
    --assignee $AZURE_ACCOUNT_ID \
    --role "Azure Event Hubs Data Receiver" \
    --scope $AZURE_RESOURCE_ID

az role assignment create \
    --assignee $AZURE_ACCOUNT_ID \
    --role "Azure Event Hubs Data Sender" \
    --scope $AZURE_RESOURCE_ID


