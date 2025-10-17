#!/bin/bash

TARGET_SERVER="synflood_server"
ATTACK_SERVER="synflood_attacker"
ATTACK_DURATION=30
ATTACK_SCRIPT="/usr/bin/synflood.sh"

echo "=========================================="
echo "1. Iniciando/Reconstruindo o ambiente Docker Compose..."
echo "=========================================="
# ATENÇÃO: Descomente para garantir que as sysctls e o iproute2 estejam aplicados!
docker compose up -d --build --force-recreate

echo ""
echo "Aguardando 3 segundos para o servidor iniciar..."
sleep 3 # Deixamos o sleep ativo para garantir que o servidor esteja 'Up'

echo ""
echo "=========================================="
echo "2. Logs de Inicialização do Servidor (Alvo):"
echo "=========================================="
docker logs $TARGET_SERVER

echo ""
echo "=========================================="
echo "3. Informações iniciais do Servidor (Alvo):"
echo "   Limite de Memória: 256MiB | SYN Backlog: 4096 (via sysctls)"
echo "=========================================="
# Exibe um snapshot estático dos recursos antes do ataque
docker stats $TARGET_SERVER --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"

echo ""
echo "========================================================================="
echo "AMBIENTE PRONTO PARA O ATAQUE"
echo "========================================================================="
echo "PASSO 1: MONITORAMENTO"
echo "Abra um novo terminal para MONITORAR RECURSOS e a FILA SYN:"
echo "  - Terminal 1 (Recursos): docker stats $TARGET_SERVER"
echo "  - Terminal 2 (SYN Backlog): docker exec -t $TARGET_SERVER ss -t -a | grep SYN-RECV | wc -l"
echo ""
echo "PASSO 2: EXECUÇÃO DO ATAQUE"
echo "Abra um terceiro terminal e execute o ataque (por $ATTACK_DURATION segundos):"
echo "  - Terminal 3 (Attacker): docker exec -it $ATTACK_SERVER $ATTACK_SCRIPT $ATTACK_DURATION"
echo "========================================================================="

# 4. (Opcional) Deixe o 'docker compose down' no final para que os alunos limpem o ambiente
# docker compose down