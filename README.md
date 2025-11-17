# 🚀 RustDesk API - Versão Customizada

## ✨ Modificações

✅ **Username aceita até 64 caracteres** (original: 32)
- Permite usar emails completos como username
- Exemplo: `b33dddo.lddma@npsdfdfdfdenfo.com.br` funciona!

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

- `http/request/api/user.go:37` - lte=32 → lte=64
- `http/request/admin/user.go:9` - lte=32 → lte=64
- `http/request/admin/user.go:70` - lte=32 → lte=64

---

**Versão:** 1.0.0
**Base:** lejianwen/rustdesk-api:latest
