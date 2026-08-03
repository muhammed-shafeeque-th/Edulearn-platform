#!/usr/bin/env bash

set -Eeuo pipefail

#############################################
# Paths
#############################################

TF_OUTPUTS="/mnt/d/edulearn-platform/infra/terraform/environments/dev/outputs.yaml"
GROUP_VARS="/mnt/d/edulearn-platform/infra/ansible/inventory/dev/group_vars/all/main.yml"
HOSTS_INI="/mnt/d/edulearn-platform/infra/ansible/inventory/dev/hosts.ini"

KEY_SOURCE="/mnt/d/edulearn-platform/infra/terraform/environments/dev/bastion-key.pem"
KEY_DEST="$HOME/.ssh/bastion-key.pem"

#############################################
# Validation
#############################################

for file in "$TF_OUTPUTS" "$GROUP_VARS" "$HOSTS_INI" "$KEY_SOURCE"; do
    [[ -f "$file" ]] || {
        echo "File not found: $file"
        exit 1
    }
done

#############################################
# Install SSH key
#############################################

mkdir -p "$HOME/.ssh"
cp "$KEY_SOURCE" "$KEY_DEST"
chmod 600 "$KEY_DEST"

#############################################
# Update YAML helper
#############################################

update_yaml() {

    local key="$1"
    local value="$2"

    # Escape characters for sed replacement
    value=$(printf '%s' "$value" | sed 's/[\/&]/\\&/g')

    if grep -Eq "^[[:space:]]*\"?${key}\"?[[:space:]]*:" "$GROUP_VARS"; then
        sed -Ei \
            "s|^[[:space:]]*\"?${key}\"?[[:space:]]*:.*|${key}: ${value}|" \
            "$GROUP_VARS"
    else
        echo "${key}: ${value}" >> "$GROUP_VARS"
    fi
}

#############################################
# Parse Terraform outputs
#############################################

declare -A outputs

while IFS=: read -r key value; do

    # Skip blank lines
    [[ -z "$key" ]] && continue

    key=$(echo "$key" | tr -d '" ')
    value=$(echo "$value" | sed 's/^ *//' | sed 's/^"//' | sed 's/"$//')

    outputs["$key"]="$value"

    update_yaml "$key" "$value"

done < "$TF_OUTPUTS"

#############################################
# Variables
#############################################

cluster_name="${outputs[cluster_name]}"
bastion_ip="${outputs[bastion_public_ip]}"
vpc_id="${outputs[vpc_id]}"
eks_endpoint="${outputs[eks_cluster_endpoint]}"

#############################################
# Update inventory
#############################################

sed -Ei "s|(ansible_host=).*|\1${bastion_ip}|" "$HOSTS_INI"

#############################################
# Summary
#############################################

echo
echo "====================================="
echo "Configuration updated successfully"
echo "====================================="
echo "Cluster Name : $cluster_name"
echo "Bastion IP   : $bastion_ip"
echo "VPC ID       : $vpc_id"
echo "EKS Endpoint : $eks_endpoint"
echo