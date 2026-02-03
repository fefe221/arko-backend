# Estágio 1: Build (Onde o código é compilado)
FROM golang:1.25-alpine AS builder

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos de dependências (equivalente ao requirements.txt)
COPY go.mod go.sum ./

# Baixa as dependências (Aqui ele vai baixar o Gin que colocamos no main.go)
RUN go mod download

# Copia o resto do código
COPY . .

# Compila o projeto (Gera um arquivo binário chamado 'main')
RUN go build -o main main.go

# Estágio 2: Execução (Onde o código roda - muito mais leve)
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .

# Porta que a API vai expor
EXPOSE 8080

# Comando para rodar o binário
CMD ["./main"]
