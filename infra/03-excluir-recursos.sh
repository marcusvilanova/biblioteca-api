#!/bin/bash
# 03 - Apaga o grupo de recursos e tudo o que foi criado nos scripts 01 e 02
# Só rode depois que o trabalho for corrigido, para não perder a demonstração

GRUPO_RECURSOS="rg-biblioteca-api"

az group delete --name "$GRUPO_RECURSOS" --yes --no-wait
echo "A exclusão de $GRUPO_RECURSOS foi iniciada. Pode levar alguns minutos."