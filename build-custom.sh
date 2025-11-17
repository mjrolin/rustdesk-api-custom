#!/bin/bash
# Script de Build Customizado para RustDesk API
# Autor: Gerado automaticamente
# Data: 2025-11-17

set -e

echo "=========================================="
echo "  RustDesk API - Build Customizado"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Diretório base
BASE_DIR="/opt/rustdesk-api-master/rustdesk-api-master"
cd "$BASE_DIR"

# 1. Aplicar modificações no código
echo -e "${BLUE}[1/6]${NC} Aplicando modificações no código (username: 32 -> 64 caracteres)..."

# Modificar http/request/api/user.go
sed -i 's/validate:"required,gte=2,lte=32" label:"用户名"/validate:"required,gte=2,lte=64" label:"用户名"/g' \
    http/request/api/user.go

# Modificar http/request/admin/user.go (2 ocorrências)
sed -i 's/validate:"required,gte=2,lte=32"/validate:"required,gte=2,lte=64"/g' \
    http/request/admin/user.go

echo -e "${GREEN}✓${NC} Modificações aplicadas com sucesso"

# 2. Baixar dependências
echo -e "${BLUE}[2/6]${NC} Baixando dependências Go..."
go mod download
go mod tidy
echo -e "${GREEN}✓${NC} Dependências prontas"

# 3. Compilar o código
echo -e "${BLUE}[3/6]${NC} Compilando código Go..."
rm -rf release
export CGO_ENABLED=0
export GOOS=linux
export GOARCH=amd64
go build -o release/apimain cmd/apimain.go

# Copiar recursos
cp -ar resources release/
cp -ar docs release/
cp -ar conf release/
mkdir -p release/data release/runtime

echo -e "${GREEN}✓${NC} Compilação concluída ($(ls -lh release/apimain | awk '{print $5}'))"

# 4. Extrair frontend admin da imagem oficial
echo -e "${BLUE}[4/6]${NC} Extraindo frontend admin da imagem oficial..."
docker pull lejianwen/rustdesk-api:latest > /dev/null 2>&1
docker create --name temp-extract-admin lejianwen/rustdesk-api:latest > /dev/null 2>&1
docker cp temp-extract-admin:/app/resources/admin release/resources/ > /dev/null 2>&1
docker rm temp-extract-admin > /dev/null 2>&1
echo -e "${GREEN}✓${NC} Frontend admin extraído"

# 5. Criar .dockerignore temporário
echo -e "${BLUE}[5/6]${NC} Preparando build Docker..."
cat > .dockerignore.build << 'EOF'
docker-compose.yaml
docker-compose-dev.yaml
Dockerfile
Dockerfile.dev
docker-dev.sh
data/
.git/
*.log
*.tmp
*.swp
.vscode/
.idea/
bin/
*.exe
*.out
EOF

mv .dockerignore .dockerignore.original 2>/dev/null || true
mv .dockerignore.build .dockerignore

# 6. Construir imagem Docker
echo -e "${BLUE}[6/6]${NC} Construindo imagem Docker customizada..."
docker build -t rustdesk-api:custom -f Dockerfile.custom . -q
echo -e "${GREEN}✓${NC} Imagem Docker criada: rustdesk-api:custom"

# Restaurar .dockerignore
mv .dockerignore.original .dockerignore 2>/dev/null || true

echo ""
echo -e "${GREEN}=========================================="
echo "  ✓ Build concluído com sucesso!"
echo "==========================================${NC}"
echo ""
echo "Imagem criada: rustdesk-api:custom"
echo "Tamanho da imagem: $(docker images rustdesk-api:custom --format '{{.Size}}')"
echo ""
echo "Para exportar a imagem, execute:"
echo "  docker save rustdesk-api:custom | gzip > rustdesk-api-custom.tar.gz"
echo ""
