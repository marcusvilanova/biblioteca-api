#!/bin/bash
# ------------------------------------------------------------
# 02 - Infra do Web App da API Biblioteca
# Cria o plano, o Web App (Java 17) e grava no Web App as variáveis de ambiente do banco.
# Rodar no Cloud Shell (Bash), depois do script 01.
# ------------------------------------------------------------

# Nomes (use o mesmo RM e a mesma região do script 01)
RM_GRUPO="rm562380"
REGIAO="centralus"
GRUPO_RECURSOS="rg-biblioteca-api"
PLANO_APP="plan-biblioteca-api"
NOME_WEBAPP="biblioteca-api-$RM_GRUPO"
RUNTIME_JAVA="JAVA:17-java17"
SERVIDOR_SQL="sql-biblioteca-$RM_GRUPO-$REGIAO"
BANCO_SQL="db-biblioteca"
USUARIO_SQL="user-biblioteca"

# Mesma senha do script 01: vem da variável SQL_SENHA ou é digitada agora
if [ -z "$SQL_SENHA" ]; then
  read -s -p "Digite a senha do administrador do SQL: " SQL_SENHA
  echo
fi
export SQL_SENHA

# Confere a senha no banco antes de configurar o Web App
if command -v pwsh > /dev/null; then
  pwsh -NoProfile -Command "Invoke-Sqlcmd -ServerInstance '$SERVIDOR_SQL.database.windows.net' -Database '$BANCO_SQL' -Username '$USUARIO_SQL' -Password \$env:SQL_SENHA -Query 'SELECT 1' -ErrorAction Stop | Out-Null" || { echo "Senha incorreta ou banco fora do ar."; exit 1; }
fi

az provider register --namespace Microsoft.Web

# Plano gratuito (F1) em Linux
az appservice plan create \
  --resource-group "$GRUPO_RECURSOS" \
  --name "$PLANO_APP" \
  --location "$REGIAO" \
  --is-linux \
  --sku F1

# Web App com Java 17
az webapp create \
  --resource-group "$GRUPO_RECURSOS" \
  --name "$NOME_WEBAPP" \
  --plan "$PLANO_APP" \
  --runtime "$RUNTIME_JAVA"

# Variáveis que o Spring lê para conectar no banco (o -o none evita mostrar a senha na tela)
URL_JDBC="jdbc:sqlserver://$SERVIDOR_SQL.database.windows.net:1433;database=$BANCO_SQL;encrypt=true;trustServerCertificate=false;loginTimeout=30;"
az webapp config appsettings set \
  --resource-group "$GRUPO_RECURSOS" \
  --name "$NOME_WEBAPP" \
  --settings \
    SPRING_DATASOURCE_URL="$URL_JDBC" \
    SPRING_DATASOURCE_USERNAME="$USUARIO_SQL" \
    SPRING_DATASOURCE_PASSWORD="$SQL_SENHA" \
  -o none

az webapp restart --resource-group "$GRUPO_RECURSOS" --name "$NOME_WEBAPP"

echo
echo "Web App no ar: https://$NOME_WEBAPP.azurewebsites.net"