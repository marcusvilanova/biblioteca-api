#!/bin/bash
# ------------------------------------------------------------
# 01 - Infra do banco da API Biblioteca
# Cria o grupo de recursos, o servidor SQL, o banco (PaaS) e as tabelas.
# Rodar no Cloud Shell (Bash), com a assinatura certa selecionada:
#   az account show
#   az account set --subscription "<nome da assinatura>"
# ------------------------------------------------------------

# Nomes dos recursos (troque o RM e a região conforme o seu grupo e a política da assinatura)
RM_GRUPO="rm562380"
REGIAO="centralus"
GRUPO_RECURSOS="rg-biblioteca-api"
SERVIDOR_SQL="sql-biblioteca-$RM_GRUPO-$REGIAO"
BANCO_SQL="db-biblioteca"
USUARIO_SQL="user-biblioteca"

# A senha nunca fica no arquivo: vem da variável SQL_SENHA ou é digitada agora
if [ -z "$SQL_SENHA" ]; then
  read -s -p "Digite a senha do administrador do SQL: " SQL_SENHA
  echo
fi
export SQL_SENHA

echo "1/5 Registrando o provedor do SQL..."
az provider register --namespace Microsoft.Sql

echo "2/5 Criando o grupo de recursos $GRUPO_RECURSOS..."
az group create --location "$REGIAO" --name "$GRUPO_RECURSOS"

echo "3/5 Criando o servidor $SERVIDOR_SQL..."
az sql server create \
  --resource-group "$GRUPO_RECURSOS" \
  --name "$SERVIDOR_SQL" \
  --location "$REGIAO" \
  --admin-user "$USUARIO_SQL" \
  --admin-password "$SQL_SENHA" \
  --enable-public-network true

echo "4/5 Criando o banco $BANCO_SQL (Basic) e liberando o firewall..."
az sql db create \
  --resource-group "$GRUPO_RECURSOS" \
  --server "$SERVIDOR_SQL" \
  --name "$BANCO_SQL" \
  --service-objective Basic \
  --backup-storage-redundancy Local \
  --zone-redundant false

# Libera todos os IPs, como na aula. Só serve para estudo
az sql server firewall-rule create \
  --resource-group "$GRUPO_RECURSOS" \
  --server "$SERVIDOR_SQL" \
  --name liberaGeral \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255

echo "5/5 Criando as tabelas com o script.sql..."
PASTA_ATUAL="$(cd "$(dirname "$0")" && pwd)"
if command -v pwsh > /dev/null; then
  pwsh -NoProfile -Command "Invoke-Sqlcmd -ServerInstance '$SERVIDOR_SQL.database.windows.net' -Database '$BANCO_SQL' -Username '$USUARIO_SQL' -Password \$env:SQL_SENHA -InputFile '$PASTA_ATUAL/../script.sql' -ErrorAction Stop"
else
  echo "pwsh não encontrado. Rode o script.sql pelo Editor de consultas do Portal."
fi

echo
echo "Pronto: $SERVIDOR_SQL.database.windows.net / $BANCO_SQL"