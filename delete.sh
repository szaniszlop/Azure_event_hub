#!/bin/bash

./login.sh

. ./config.sh

az group delete --yes --name $AZ_RESOURCE_GROUP
