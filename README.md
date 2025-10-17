# Demonstração de Ataque SYN Flood (DoS) com Docker

Este projeto demonstra um ataque de negação de serviço (DoS) do tipo **SYN Flood** usando Docker e `hping3`. O objetivo é puramente educacional, permitindo visualizar como um ataque SYN Flood pode exaurir os recursos de um servidor ao sobrecarregar sua fila de conexões TCP semi-abertas (SYN-RECV).

## O que é um Ataque SYN Flood?

Um ataque SYN Flood explora o funcionamento do handshake TCP de três vias. O atacante envia um grande volume de pacotes TCP com a flag `SYN` para o servidor alvo, muitas vezes com endereços de IP de origem falsificados (`spoofed`).

1.  O atacante envia um pacote `SYN`.
2.  O servidor responde com um pacote `SYN-ACK` e aloca recursos (memória) para aguardar o `ACK` final do cliente, colocando a conexão em um estado `SYN-RECV`.
3.  O atacante nunca envia o pacote `ACK` final.

Ao inundar o servidor com pacotes `SYN`, o atacante força o servidor a alocar recursos para um grande número de conexões "meio-abertas". Eventualmente, a fila de conexões pendentes (backlog) fica cheia, e o servidor começa a recusar novas conexões legítimas, resultando em uma negação de serviço.

---

## Pré-requisitos

Para executar esta demonstração, você precisará ter instalado:

-   Docker
-   Docker Compose

---

## Como Executar a Demonstração

O projeto inclui um script (`run.sh`) que automatiza a configuração do ambiente. Siga os passos abaixo.

### 1. Clone o Repositório

```bash
git clone <url-do-seu-repositorio>
cd <nome-do-repositorio>
```

### 2. Execute o Script de Configuração

Torne o script executável e rode-o. Ele irá construir as imagens Docker, criar os contêineres e exibir as instruções para o ataque.

```bash
chmod +x run.sh
./run.sh
```

### 3. Siga as Instruções do Terminal

Após executar `./run.sh`, o ambiente estará pronto. O script irá instruí-lo a abrir **três terminais separados** para realizar as seguintes ações simultaneamente:

#### Terminal 1: Monitorar Recursos do Servidor

Este comando exibe em tempo real o consumo de CPU e memória do contêiner do servidor.

```bash
docker stats synflood_server
```

> **O que observar:** Durante o ataque, você verá um aumento significativo no uso de memória (`MEM USAGE`) e, possivelmente, da CPU.

#### Terminal 2: Monitorar a Fila de Conexões `SYN-RECV`

Este comando conta quantas conexões estão no estado `SYN-RECV` no servidor.

```bash
docker exec -t synflood_server ss -t -a | grep SYN-RECV | wc -l
```

> **O que observar:** Antes do ataque, o valor será `0`. Durante o ataque, este número subirá rapidamente para o limite configurado (4096), provando que a fila de backlog está cheia.

#### Terminal 3: Lançar o Ataque

Este comando executa o script `synflood.sh` dentro do contêiner do atacante, iniciando o SYN Flood por 30 segundos.

```bash
docker exec -it synflood_attacker /usr/bin/synflood.sh 30
```

> **O que observar:** Enquanto o ataque estiver em andamento, tente acessar o servidor em seu navegador: **http://localhost:8080**. A página não carregará ou levará muito tempo, pois o servidor não consegue aceitar novas conexões legítimas. Assim que o ataque terminar, a página voltará a carregar normalmente.

---

## Estrutura do Projeto

-   `docker-compose.yml`: Define os dois serviços (`server` e `attacker`), a rede e as configurações de kernel (`sysctls`) para o servidor. As `sysctls` são ajustadas para tornar o efeito do ataque mais visível (desabilitando `tcp_syncookies` e aumentando o `tcp_max_syn_backlog`).
-   `run.sh`: Script principal para orquestrar a construção do ambiente e guiar o usuário.
-   `server/`: Contém o `Dockerfile` e o código-fonte (`main.py`) de um servidor web simples em Python, que é o alvo do ataque.
-   `attacker/`: Contém o `Dockerfile` para instalar o `hping3` e o script de ataque (`synflood.sh`).
-   `test.sh`: Um script utilitário para verificar se as configurações de `sysctl` foram aplicadas corretamente no contêiner do servidor.

---

## Limpando o Ambiente

Após concluir a demonstração, você pode parar e remover os contêineres, redes e volumes criados pelo Docker Compose com o seguinte comando:

```bash
docker compose down
```

---

> ### ⚠️ Aviso Legal
>
> Este projeto foi criado exclusivamente para fins educacionais e de pesquisa em segurança. O uso das ferramentas e técnicas aqui demonstradas para atacar alvos sem consentimento prévio e explícito é ilegal. O autor não se responsabiliza por qualquer uso indevido deste material.
