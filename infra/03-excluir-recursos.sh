#!/bin/bash

#
# Script 03 - exclui o Grupo de Recursos e tudo o que existe dentro dele
# Rode somente quando o trabalho já tiver sido corrigido, para não gastar crédito
#

RESOURCE_GROUP_NAME="rg-biblioteca-api"

az group delete --name $RESOURCE_GROUP_NAME --yes --no-wait
