# 📚 Infinity Aura

> Sistema desenvolvido para a disciplina de **Linguagem e Programação Orientada a Objetos** — IF Baiano.

---

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

- Contém apenas versões **totalmente testadas e aprovadas**
- Nenhum commit é feito diretamente nesta branch
- Atualizações chegam **exclusivamente via Pull Request** vindo da `release`
- Exige **2 aprovações** de revisores antes do merge

---

### `release` — Homologação 🧪

> **Integração e testes robustos do sistema.**

- Recebe o código da `dev` quando um conjunto de funcionalidades está pronto
- Utilizada para **testes de integração**, correções de bugs e ajustes finais
- Após validação completa, é promovida para a `main`
- Exige **1 aprovação** de revisor antes do merge

---

### `dev` — Desenvolvimento 🛠️

> **Branch principal de desenvolvimento contínuo.**

- Concentra o trabalho ativo da equipe
- Recebe merges das branches de **feature** ao longo do desenvolvimento
- Base para a criação de todas as novas branches temporárias
- Exige **1 aprovação** de revisor antes do merge

---

### `feature/*` — Funcionalidades ✨

> **Branches temporárias para novas funcionalidades.**

- Criadas a partir da `dev` para cada nova funcionalidade ou tarefa
- Nomenclatura sugerida: `feature/nome-da-funcionalidade`
- Após concluídas, são integradas de volta à `dev` via Pull Request e **removidas**

**Exemplo de criação:**
```bash
git checkout dev
git checkout -b feature/cadastro-usuario
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

## 🔒 Regras de Proteção das Branches

| Branch    | Merge direto | Pull Request | Aprovações necessárias |
|-----------|:------------:|:------------:|:----------------------:|
| `main`    | ❌           | ✅           | 2                      |
| `release` | ❌           | ✅           | 1                      |
| `dev`     | ❌           | ✅           | 1                      |
| `feature/*` | ✅         | —            | —                      |

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

## 🛠️ Tecnologias

- **Java** — Linguagem principal
- **Git & GitHub** — Versionamento e colaboração

---

<p align="center">
  Desenvolvido com ❤️ para a disciplina de LPOO — IF Baiano
</p>
