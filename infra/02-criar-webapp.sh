#!/bin/bash

#
# Script 02 - cria o Plano, o Web App (Java 17) e configura as variáveis de ambiente
#
# Execute no Azure Cloud Shell (Bash), depois do script 01
#

# Variáveis (troque o RM pelo seu e a região conforme a sua política)
RM="rm562380"
RESOURCE_GROUP_NAME="rg-biblioteca-api"
LOCATION="centralus"
APP_SERVICE_PLAN="plan-biblioteca-api"
WEBAPP_NAME="biblioteca-api-$RM"
RUNTIME="JAVA:17-java17"
SQL_SERVER_NAME="sql-biblioteca-$RM-$LOCATION"
SQL_DB_NAME="db-biblioteca"
SQL_ADMIN_USER="user-biblioteca"

# A senha não fica salva no script. Se a variável SQL_SENHA não existir, o script pergunta
if [ -z "$SQL_SENHA" ]; then
  read -s -p "Senha do administrador do SQL: " SQL_SENHA
  echo ""
fi
export SQL_SENHA

# Testa a senha no banco antes de configurar o Web App
if command -v pwsh > /dev/null; then
  pwsh -NoProfile -Command "Invoke-Sqlcmd -ServerInstance '$SQL_SERVER_NAME.database.windows.net' -Database '$SQL_DB_NAME' -Username '$SQL_ADMIN_USER' -Password \$env:SQL_SENHA -Query 'SELECT 1' -ErrorAction Stop | Out-Null" || { echo "Senha incorreta ou banco indisponível."; exit 1; }
fi

# Registrar o serviço utilizado
az provider register --namespace Microsoft.Web

# Criar o Plano de Serviço (F1 é o gratuito)
az appservice plan create \
  --name $APP_SERVICE_PLAN \
  --resource-group $RESOURCE_GROUP_NAME \
  --location "$LOCATION" \
  --sku F1 \
  --is-linux

# Criar o Serviço de Aplicativo
az webapp create \
  --name $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --plan $APP_SERVICE_PLAN \
  --runtime "$RUNTIME"

# Montar a URL JDBC do banco
URL="jdbc:sqlserver://$SQL_SERVER_NAME.database.windows.net:1433;database=$SQL_DB_NAME;encrypt=true;trustServerCertificate=false;loginTimeout=30;"

# Configurar as variáveis de ambiente que o Spring lê (o -o none evita mostrar a senha na tela)
az webapp config appsettings set \
  --name "$WEBAPP_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --settings \
    SPRING_DATASOURCE_URL="$URL" \
    SPRING_DATASOURCE_USERNAME="$SQL_ADMIN_USER" \
    SPRING_DATASOURCE_PASSWORD="$SQL_SENHA" \
  -o none

# Reiniciar o Web App
az webapp restart --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP_NAME

echo ""
echo "Web App criado: https://$WEBAPP_NAME.azurewebsites.net"
