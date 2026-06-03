# 📚 Aura
> Sistema desenvolvido para a disciplina de **Linguagem e Programação Orientada a Objetos** — IF Baiano.
---

## Como compilar
```
1. Dê git clone a partir de SSh ou link do repositório
2. git switch dev
3. docker compose down -v
4. docker compose up -d --build
5. Acesse: http://localhost:8080/aura
```

## Primeiro Acesso
```
1. Logar com usuário comercial, ex: bruno@gmail.com   // senha: 123456
                                    xiomara@gmail.com // senha: 123456

2. Logar com usuário admin: alice@gmail.com // senha: 123456
```

## Acesso ao banco de dados (Pg Admin)
```
1. acesse http://localhost:5080 ou http://localhost:5080/login?next=/
2. Login: admin@admin.com
3. Senha: admin
4. No painel, adicione um server em "new server"
5. Na aba general, defina name = aura-db

6. na aba connection, defina: Host name/ adress = aura-db
                              Port = 5432
                              Maintenence database = postgres
                              Username = postgres
                              Password = dsoliveira06
```

## 🌿 Estrutura de Branches
Este repositório adota uma estratégia de branches baseada em **GitFlow simplificado**, garantindo organização, rastreabilidade e estabilidade em cada etapa do desenvolvimento.
```
feature/* ──┐
feature/* ──┼──► dev ──► release ──► main
feature/* ──┘
```
---
### `main` — Produção 🚀
> **Código 100% estável e pronto para deploy.**

---
### `release` — Homologação 🧪
> **Integração e testes robustos do sistema.**

---
### `dev` — Desenvolvimento 🛠️
> **Branch principal de desenvolvimento contínuo.**

---
### `feature/*` — Funcionalidades ✨
> **Branches temporárias para novas funcionalidades.**

**Exemplo de criação:**
```bash
git checkout dev
git checkout -b feature/cadastro-usuario origin/dev
```
---
## 🔄 Fluxo de Trabalho
```
1. Crie uma branch feature a partir de dev
2. Desenvolva e faça commits na sua feature
3. Abra um Pull Request: feature/* → dev
4. Após aprovação, merge na dev
5. Quando pronto para testes, abra PR: dev → release
6. Após testes e aprovação, abra PR: release → main
```
---

## 🚀 Como Contribuir
```bash
# 1. Clone o repositório
git clone git@github.com:Projeto-LPOO/Code.git
cd Code

# 2. Crie sua branch de feature a partir da dev
git checkout dev
git checkout -b feature/minha-funcionalidade

# 3. Desenvolva, adicione e faça commits
git add .
git commit -m "feat: descrição da funcionalidade"

# 4. Envie para o repositório remoto
git push origin feature/minha-funcionalidade

# 5. Abra um Pull Request para a branch dev no GitHub
```
---
## 🐳 Ambiente Docker

O projeto utiliza Docker para garantir que todos os desenvolvedores rodem o sistema em um ambiente idêntico, independente do sistema operacional ou configuração local.

### Pré-requisitos

- Docker Desktop instalado e rodando

---

### Estrutura dos arquivos Docker

```
aura/
├── Dockerfile          ← build multi-stage: Maven compila → Tomcat executa
├── docker-compose.yml  ← orquestra os serviços app e banco de dados
├── entrypoint.sh       ← configura o banco antes do Tomcat subir
├── aura_dump.sql       ← dump real do banco (estrutura + dados)
├── .env                ← suas credenciais locais (NÃO commitar)
└── .dockerignore       ← arquivos ignorados pelo Docker no build
```

---

### Configuração do `.env`

O arquivo `.env` **não está versionado** no repositório por conter credenciais. Cada desenvolvedor deve criá-lo manualmente na raiz do projeto com o seguinte conteúdo:

```env
# DATABASE
POSTGRES_HOST=host.docker.internal
POSTGRES_PORT=5433
POSTGRES_DB=aura_projeto
POSTGRES_USER=postgres
POSTGRES_PASSWORD=sua_senha_aqui
POSTGRES_HOST_PORT=5434

# --- Pool de Conexões HikariCP ---
DB_POOL_MAX_SIZE=10
DB_POOL_MIN_IDLE=2
DB_POOL_IDLE_TIMEOUT=30000
DB_POOL_CONNECTION_TIMEOUT=30000

# --- Aplicação ---
APP_HOST_PORT=8080
TOMCAT_CONTEXT_PATH=/aura
JAVA_OPTS=-Xms256m -Xmx512m

#--- Pg Admin ---
PGADMIN_EMAIL=admin@admin.com
PGADMIN_PASSWORD=admin
PGADMIN_HOST_PORT=5080
```

> Substitua `sua_senha_aqui` pela senha do PostgreSQL definida no seu ambiente.

---

### Primeira execução

```bash
# 1. Crie o .env conforme o modelo acima
rode: 'nano .env' em seu terminal

# 2. Suba o ambiente
docker compose up -d --build

# 3. Acesse a aplicação
http://localhost:8080/aura

# 4. Para o Pg Admin
http://localhost:5080
```

Na primeira subida o Docker irá:
1. Baixar as imagens necessárias (Maven, Tomcat, PostgreSQL)
2. Compilar o projeto com Maven dentro do container
3. Criar o banco de dados e importar o `aura_dump.sql` automaticamente
4. Subir o Tomcat com a aplicação pronta

> A primeira execução pode demorar alguns minutos por conta do download das imagens e compilação. As próximas serão muito mais rápidas.

---

### Comandos do dia a dia

```bash
# Subir o ambiente em background
docker compose up -d

# Parar o ambiente (dados do banco são preservados)
docker compose down

# Ver logs da aplicação em tempo real
docker compose logs -f app

# Ver logs do banco em tempo real
docker compose logs -f db

# Rebuild após mudanças no código
docker compose down
docker compose build --no-cache
docker compose up -d

# Reset total — apaga o banco e reimporta o dump
docker compose down -v
docker compose up -d
```

---

### Atualização do banco de dados

Sempre que houver alterações no banco, exporte um novo dump e substitua o `aura_dump.sql` no repositório:

```bash
pg_dump -U postgres -d aura_projeto -f aura_dump.sql
sed -i '/SET transaction_timeout/d' aura_dump.sql
```

Para que os colegas recebam o banco atualizado após um `git pull`:

```bash
docker compose down -v
docker compose up -d
```

---

## 🛠️ Tecnologias

- **Java 21** — Linguagem principal
- **Maven** — Gerenciamento de dependências e build
- **Apache Tomcat 10.1** — Servidor de aplicação
- **PostgreSQL 18** — Banco de dados
- **HikariCP** — Pool de conexões
- **Docker & Docker Compose** — Containerização do ambiente
- **Git & GitHub** — Versionamento e colaboração

---

<p align="center">
  Desenvolvido com ❤️ para a disciplina de LPOO — IF Baiano
</p>
