# Usamos uma imagem base leve com Python
FROM python:3.9-slim

# Instalação das ferramentas de debug (ss e netstat)
# Mantenha esta linha para as verificações de backlog (Camada 4)
RUN apt-get update && \
    apt-get install -y iproute2 net-tools && \
    rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia o script do servidor para o container
COPY main.py .

# A porta 80 é a que o servidor Python usará
EXPOSE 80

# Comando para iniciar o servidor
# -u é necessário para o output sem buffer, útil para logs em tempo real
CMD ["python", "-u", "main.py"] 