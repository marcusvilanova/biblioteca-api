#!/bin/bash

#
# Script 01 - cria o Grupo de Recursos e o Banco SQL (PaaS) da API Biblioteca
#
# Execute no Azure Cloud Shell (Bash)
#
# Antes de rodar, confira se esta na assinatura correta
# az account show
# az account list -o table
# az account set --subscription "nome-da-assinatura-correta"
#

# Variáveis (troque o RM pelo seu e a região conforme a sua política)
RM="rm562380"
RESOURCE_GROUP_NAME="rg-biblioteca-api"
LOCATION="eastus2"
SQL_SERVER_NAME="sql-biblioteca-$RM"
SQL_DB_NAME="db-biblioteca"
SQL_ADMIN_USER="user-biblioteca"

# A senha não fica salva no script. Se a variável SQL_SENHA não existir, o script pergunta
if [ -z "$SQL_SENHA" ]; then
  read -s -p "Senha do administrador do SQL: " SQL_SENHA
  echo ""
fi

# Registrar o serviço utilizado
az provider register --namespace Microsoft.Sql

# Criação do Grupo de Recursos
az group create \
  --name $RESOURCE_GROUP_NAME \
  --location "$LOCATION"

# Criar o Servidor SQL
az sql server create \
  --name $SQL_SERVER_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location "$LOCATION" \
  --admin-user $SQL_ADMIN_USER \
  --admin-password "$SQL_SENHA" \
  --enable-public-network true

# Criar o Banco de Dados
az sql db create \
  --resource-group $RESOURCE_GROUP_NAME \
  --server $SQL_SERVER_NAME \
  --name $SQL_DB_NAME \
  --service-objective Basic \
  --backup-storage-redundancy Local \
  --zone-redundant false

# Liberar o acesso no Firewall do Servidor (somente para estudo, como vimos na aula)
az sql server firewall-rule create \
  --resource-group $RESOURCE_GROUP_NAME \
  --server $SQL_SERVER_NAME \
  --name liberaGeral \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255

# Criar as tabelas com o script.sql (ele fica na pasta acima da infra)
PASTA_DO_SCRIPT="$(cd "$(dirname "$0")" && pwd)"
if command -v sqlcmd > /dev/null; then
  export SQLCMDPASSWORD="$SQL_SENHA"
  sqlcmd -S "$SQL_SERVER_NAME.database.windows.net" -d "$SQL_DB_NAME" -U "$SQL_ADMIN_USER" -b -i "$PASTA_DO_SCRIPT/../script.sql"
else
  echo "sqlcmd não encontrado. Execute o script.sql pelo Editor de consultas do Portal."
fi

echo ""
echo "Banco criado: $SQL_SERVER_NAME.database.windows.net / $SQL_DB_NAME"
