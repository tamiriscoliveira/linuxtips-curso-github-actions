#!/usr/bin/env bash
# script.sh
set -euo pipefail

ARQUIVO="resultado.csv"

data_execucao=$(date '+%Y-%m-%d %H:%M:%S')
nome_host=$(hostname)
usuario_atual=$(whoami)
diretorio_atual=$(pwd)

{
  echo "=== Resultado do Script ==="
  echo "Data de execução: ${data_execucao}"
  echo "Hostname: ${nome_host}"
  echo "Usuário atual: ${usuario_atual}"
  echo "Diretório atual: ${diretorio_atual}"
  echo "-----------------------------"
} > "${ARQUIVO}"

echo "Arquivo ${ARQUIVO} criado com sucesso!"
