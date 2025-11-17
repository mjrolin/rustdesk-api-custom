#!/bin/bash
# Publicar Versão 2.0 com Melhorias

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Publicando RustDesk API v2.0${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo ""

# Ler token
if [ ! -f "/opt/.github-token" ]; then
    echo -e "${RED}✗ Token não encontrado em /opt/.github-token${NC}"
    exit 1
fi

TOKEN=$(cat /opt/.github-token)

# Login no GitHub Container Registry
echo -e "${YELLOW}[1/4]${NC} Fazendo login no GitHub Container Registry..."
echo "$TOKEN" | docker login ghcr.io -u mjrolin --password-stdin
echo -e "${GREEN}✓${NC} Login realizado"
echo ""

# Tag da imagem
echo -e "${YELLOW}[2/4]${NC} Criando tags da imagem..."
docker tag rustdesk-api:custom ghcr.io/mjrolin/rustdesk-api-custom:latest
docker tag rustdesk-api:custom ghcr.io/mjrolin/rustdesk-api-custom:v2.0
echo -e "${GREEN}✓${NC} Tags criadas: latest, v2.0"
echo ""

# Push latest
echo -e "${YELLOW}[3/4]${NC} Enviando imagem:latest..."
docker push ghcr.io/mjrolin/rustdesk-api-custom:latest
echo -e "${GREEN}✓${NC} latest enviado"
echo ""

# Push v2.0
echo -e "${YELLOW}[4/4]${NC} Enviando imagem:v2.0..."
docker push ghcr.io/mjrolin/rustdesk-api-custom:v2.0
echo -e "${GREEN}✓${NC} v2.0 enviado"
echo ""

echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}✅ VERSÃO 2.0 PUBLICADA COM SUCESSO!${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo ""
echo "Imagens disponíveis:"
echo "  • ghcr.io/mjrolin/rustdesk-api-custom:latest"
echo "  • ghcr.io/mjrolin/rustdesk-api-custom:v2.0"
echo ""
echo "Melhorias nesta versão:"
echo "  ✅ Username: 3-64 caracteres"
echo "  ✅ Senha: 8-128 caracteres (mais seguro)"
echo "  ✅ Email: Validação de formato"
echo "  ✅ Nickname: Limite de 50 caracteres"
echo "  ✅ Remark: Limite de 500 caracteres"
echo ""
