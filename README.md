# 🚀 RustDesk API - Versão Customizada

## ✨ Modificações e Melhorias

### 🔐 Validações Aprimoradas

✅ **Username: 3-64 caracteres** (original: 2-32)
- Permite usar emails completos como username
- Exemplo: `usuario@empresa.com.br` funciona!
- Mínimo aumentado para 3 caracteres (mais seguro)

✅ **Senha: 8-128 caracteres** (original: 4-32)
- Senhas mais fortes (mínimo 8 caracteres)
- Suporta senhas complexas modernas (até 128 caracteres)
- Melhor segurança contra ataques de força bruta

✅ **Email: Validação de formato**
- Verifica se email está em formato válido
- Previne erros de digitação

✅ **Nickname: Limite de 50 caracteres**
- Previne nomes excessivamente longos
- Melhora performance do sistema

✅ **Remark: Limite de 500 caracteres**
- Campo de observações com limite controlado
- Otimização de armazenamento

## 📦 Usar Esta Imagem

```yaml
services:
  rustdesk-api:
    image: ghcr.io/mjrolin/rustdesk-api-custom:latest
    # ... resto da configuração
```

## 🔨 Build Local

```bash
./build-custom.sh
```

## 📝 Modificações nos Arquivos

### `http/request/api/user.go`
- **Linha 37:** Username `lte=32` → `lte=64`, `gte=2` → `gte=3`
- **Linha 38:** Password `gte=4,lte=32` → `gte=8,lte=128`

### `http/request/admin/user.go`
- **Linhas 9, 70:** Username `lte=32` → `lte=64`, `gte=2` → `gte=3`
- **Linhas 10, 57, 61, 62, 72, 73:** Password `gte=4,lte=32` → `gte=8,lte=128`
- **Linha 10:** Email validação habilitada
- **Linha 11:** Nickname limite de 50 caracteres
- **Linha 12:** Remark limite de 500 caracteres

---

## 📊 Comparação: Original vs Customizado

| Validação | Original | Customizado | Benefício |
|-----------|----------|-------------|-----------|
| Username (min) | 2 chars | **3 chars** | 🔒 Mais seguro |
| Username (max) | 32 chars | **64 chars** | ✅ Aceita emails |
| Senha (min) | 4 chars | **8 chars** | 🔒 Muito mais seguro |
| Senha (max) | 32 chars | **128 chars** | ✅ Senhas complexas |
| Email | Sem validação | **Validado** | ✅ Previne erros |
| Nickname | Sem limite | **50 chars** | ⚡ Performance |
| Remark | Sem limite | **500 chars** | ⚡ Performance |

---

**Versão:** 2.0.0
**Base:** lejianwen/rustdesk-api:latest
**Melhorias:** 7 validações aprimoradas
