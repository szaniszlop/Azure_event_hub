#!/bin/bash

subscription_id="$(az account show --query 'id' --out tsv)"

if [[ -z "$subscription_id" ]]; then
	az login
	subscription_id="$(az account show --query 'id' --out tsv)"
fi

if [[ -z "$subscription_id" ]]; then
	echo "Could not log in to Azure"
	exit -1
fi

echo "Logged in to $subscription_id"
