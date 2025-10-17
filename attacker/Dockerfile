# attacker/Dockerfile
FROM kalilinux/kali-rolling

# Atualiza os pacotes e instala o hping3 e o 'timeout' (parte do coreutils)
RUN apt-get update && apt-get install -y hping3 coreutils iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Copia o script para o container
COPY synflood.sh /usr/bin/synflood.sh

# Dá permissão de execução
RUN chmod +x /usr/bin/synflood.sh

# Define o comando padrão para rodar o shell (modo interativo)
# Mantemos o shell para que o usuário possa escolher QUANDO rodar o ataque.
CMD ["/bin/bash"]