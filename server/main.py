from http.server import SimpleHTTPRequestHandler, HTTPServer
import time
import socket # Necessário para acessar as opções do socket

PORT = 80
ADDRESS = "0.0.0.0"
# Definimos um valor ALTO (maior que o sysctl de 4096) para garantir que
# o limite de 4096 configurado no kernel (via docker-compose) seja o TETO efetivo.
MAX_BACKLOG = 8192 

class RequestHandler(SimpleHTTPRequestHandler):
    # Método chamado quando uma requisição HTTP COMPLETA (Camada 7) é recebida
    def do_GET(self):
        # NOTA IMPORTANTE: Durante o SYN Flood, esta função NÃO será chamada, 
        # pois o handshake TCP (Camada 4) nunca é completado. 
        # Isso prova que o ataque está funcionando.

        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(b"<h1>Server HTTP esta no ar (Alvo)!</h1>")
        
        # Loga a requisição legítima para provar que o servidor ESTA ativo
        print(f"[{time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())}] Requisição legitima recebida de: {self.client_address[0]}")

if __name__ == "__main__":
    try:
        # Cria o objeto do servidor
        httpd = HTTPServer((ADDRESS, PORT), RequestHandler)
        
        # O PASSO CRUCIAL: Força o socket da aplicação a aceitar um backlog alto.
        # O limite final será o MIN(MAX_BACKLOG, net.core.somaxconn)
        # Como somaxconn está 4096 e MAX_BACKLOG é 8192, o limite real será 4096.
        httpd.socket.listen(MAX_BACKLOG) 
        
        print("==========================================")
        print(f"Servidor HTTP iniciado em http://{ADDRESS}:{PORT}")
        print(f"Aplicacao configurada com backlog de: {MAX_BACKLOG}.")
        print("Status: Aguardando Handshakes TCP (Camada 4).")
        print("==========================================")
        
        # Inicia o loop principal que mantém o container 'Up'
        httpd.serve_forever()
        
    except KeyboardInterrupt:
        print("\nServidor parado (Keyboard Interrupt).")
        httpd.socket.close()