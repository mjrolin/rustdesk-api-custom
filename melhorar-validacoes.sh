#!/bin/bash
# Script para Melhorar Validações do RustDesk API

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Melhorando Validações da API${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""

cd /opt/rustdesk-api-master/rustdesk-api-master

echo "Escolha o que deseja melhorar:"
echo ""
echo "  1) Senha: 4-32 → 8-128 caracteres (RECOMENDADO)"
echo "  2) Email: Validar formato"
echo "  3) Nickname: Adicionar limite de 50 caracteres"
echo "  4) Remark: Adicionar limite de 500 caracteres"
echo "  5) Username: Mínimo 2 → 3 caracteres"
echo "  6) TUDO (todas as melhorias acima)"
echo ""
read -p "Opção [1-6]: " OPCAO

case $OPCAO in
    1)
        echo ""
        echo -e "${YELLOW}Aplicando melhoria 1: Senha 8-128 caracteres...${NC}"

        # http/request/api/user.go
        sed -i 's/validate:"gte=4,lte=32"/validate:"gte=8,lte=128"/g' http/request/api/user.go

        # http/request/admin/user.go
        sed -i 's/validate:"required,gte=4,lte=32"/validate:"required,gte=8,lte=128"/g' http/request/admin/user.go

        echo -e "${GREEN}✓ Senha agora aceita 8-128 caracteres${NC}"
        ;;

    2)
        echo ""
        echo -e "${YELLOW}Aplicando melhoria 2: Validação de email...${NC}"

        # Descomentar validação de email
        sed -i 's|//validate:"required,email"|validate:"omitempty,email"|g' http/request/admin/user.go

        echo -e "${GREEN}✓ Email agora é validado (opcional mas com formato)${NC}"
        ;;

    3)
        echo ""
        echo -e "${YELLOW}Aplicando melhoria 3: Limite de nickname...${NC}"

        # Adicionar validação ao nickname
        sed -i 's|Nickname string.*`json:"nickname"`|Nickname string `json:"nickname" validate:"omitempty,gte=2,lte=50"`|g' http/request/admin/user.go

        echo -e "${GREEN}✓ Nickname limitado a 50 caracteres${NC}"
        ;;

    4)
        echo ""
        echo -e "${YELLOW}Aplicando melhoria 4: Limite de remark...${NC}"

        # Adicionar validação ao remark
        sed -i 's|Remark.*string.*`json:"remark"`|Remark string `json:"remark" validate:"omitempty,lte=500"`|g' http/request/admin/user.go

        echo -e "${GREEN}✓ Remark limitado a 500 caracteres${NC}"
        ;;

    5)
        echo ""
        echo -e "${YELLOW}Aplicando melhoria 5: Username mínimo 3 caracteres...${NC}"

        # Atualizar username mínimo
        sed -i 's/validate:"required,gte=2,lte=64"/validate:"required,gte=3,lte=64"/g' http/request/api/user.go
        sed -i 's/validate:"required,gte=2,lte=64"/validate:"required,gte=3,lte=64"/g' http/request/admin/user.go

        echo -e "${GREEN}✓ Username agora exige mínimo 3 caracteres${NC}"
        ;;

    6)
        echo ""
        echo -e "${YELLOW}Aplicando TODAS as melhorias...${NC}"
        echo ""

        # Melhoria 1: Senha
        echo -e "${BLUE}[1/5]${NC} Senha 8-128 caracteres..."
        sed -i 's/validate:"gte=4,lte=32"/validate:"gte=8,lte=128"/g' http/request/api/user.go
        sed -i 's/validate:"required,gte=4,lte=32"/validate:"required,gte=8,lte=128"/g' http/request/admin/user.go
        echo -e "${GREEN}✓${NC}"

        # Melhoria 2: Email
        echo -e "${BLUE}[2/5]${NC} Validação de email..."
        sed -i 's|//validate:"required,email"|validate:"omitempty,email"|g' http/request/admin/user.go
        echo -e "${GREEN}✓${NC}"

        # Melhoria 3: Nickname
        echo -e "${BLUE}[3/5]${NC} Limite de nickname..."
        sed -i 's|Nickname string.*`json:"nickname"`|Nickname string `json:"nickname" validate:"omitempty,gte=2,lte=50"`|g' http/request/admin/user.go
        echo -e "${GREEN}✓${NC}"

        # Melhoria 4: Remark
        echo -e "${BLUE}[4/5]${NC} Limite de remark..."
        sed -i 's|Remark.*string.*`json:"remark"`|Remark string `json:"remark" validate:"omitempty,lte=500"`|g' http/request/admin/user.go
        echo -e "${GREEN}✓${NC}"

        # Melhoria 5: Username
        echo -e "${BLUE}[5/5]${NC} Username mínimo 3 caracteres..."
        sed -i 's/validate:"required,gte=2,lte=64"/validate:"required,gte=3,lte=64"/g' http/request/api/user.go
        sed -i 's/validate:"required,gte=2,lte=64"/validate:"required,gte=3,lte=64"/g' http/request/admin/user.go
        echo -e "${GREEN}✓${NC}"

        echo ""
        echo -e "${GREEN}✓ Todas as melhorias aplicadas!${NC}"
        ;;

    *)
        echo "Opção inválida"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Melhorias aplicadas com sucesso!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""
echo "Próximos passos:"
echo "  1. Recompilar: ./build-custom.sh"
echo "  2. Publicar: docker tag e docker push"
echo "  3. Atualizar produção: docker compose pull && up -d"
echo ""
