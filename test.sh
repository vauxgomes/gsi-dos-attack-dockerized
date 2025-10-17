# Executa os 3 comandos de verificação para ter certeza
echo "Verificando tcp_max_syn_backlog:"
docker exec synflood_server sysctl net.ipv4.tcp_max_syn_backlog

echo "Verificando somaxconn:"
docker exec synflood_server sysctl net.core.somaxconn

echo "Verificando tcp_syncookies:"
docker exec synflood_server sysctl net.ipv4.tcp_syncookies