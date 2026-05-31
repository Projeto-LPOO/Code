<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Aura — Plataforma de Mentorias</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Plus+Jakarta+Sans:wght@300;400;500&display=swap" rel="stylesheet">

  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            serif: ['Lora', 'Georgia', 'serif'],
            sans: ['Plus Jakarta Sans', 'sans-serif'],
          },
          colors: {
            cream:  '#faf8f5',
            parchment: '#f3efe8',
            lilac:  '#f5f3ff',
            'lilac-mid': '#ede9fe',
            'violet-soft': '#7c3aed',
            'violet-muted': '#8b5cf6',
            'violet-pale': '#c4b5fd',
            'warm-gray': '#6b7280',
            'warm-dark': '#374151',
          }
        }
      }
    }
  </script>

  <style>
    html  { scroll-behavior: smooth; }
    body  { font-family: 'Plus Jakarta Sans', sans-serif; background: #ffffff; color: #374151; }
    .font-serif { font-family: 'Lora', Georgia, serif; }

    /* Reveal on scroll */
    .reveal { opacity: 0; transform: translateY(18px); transition: opacity 0.65s ease, transform 0.65s ease; }
    .reveal.visible { opacity: 1; transform: translateY(0); }

    /* Paper card */
    .paper {
      background: #ffffff;
      border: 1px solid #e9e5de;
      border-radius: 16px;
      transition: box-shadow 0.3s ease, transform 0.3s ease;
    }
    .paper:hover { box-shadow: 0 8px 32px rgba(124,58,237,0.07); transform: translateY(-3px); }

    /* Soft lilac card */
    .card-lilac {
      background: #f5f3ff;
      border: 1px solid #ede9fe;
      border-radius: 16px;
    }

    /* Section label */
    .label {
      display: inline-block;
      font-size: 11px;
      font-weight: 500;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      color: #7c3aed;
      background: #f5f3ff;
      border: 1px solid #ede9fe;
      border-radius: 100px;
      padding: 4px 14px;
    }

    /* Soft divider */
    .divider { width: 40px; height: 2px; background: #c4b5fd; border-radius: 2px; }

    /* Avatar ring */
    .avatar-ring { border: 2.5px solid #ede9fe; border-radius: 14px; object-fit: cover; }

    /* Feature number */
    .feat-num {
      font-family: 'Lora', serif;
      font-size: 13px;
      color: #c4b5fd;
    }

    /* Tech pill */
    .tech-pill {
      display: flex; align-items: center; gap: 10px;
      padding: 14px 20px;
      background: #faf8f5;
      border: 1px solid #e9e5de;
      border-radius: 14px;
      transition: border-color 0.2s, background 0.2s;
    }
    .tech-pill:hover { border-color: #c4b5fd; background: #f5f3ff; }

    /* Stat */
    .stat-big { font-family: 'Lora', serif; font-size: clamp(2.8rem,6vw,4.5rem); line-height:1; color: #374151; }

    /* Nav */
    nav { transition: padding 0.3s ease; }
    nav a { transition: color 0.2s; }
    nav a:hover { color: #7c3aed; }

    /* Hero quote mark */
    .quote-mark {
      font-family: 'Lora', serif;
      font-size: 220px;
      line-height: 1;
      color: #f5f3ff;
      pointer-events: none;
      user-select: none;
    }

    /* Horizontal rule */
    hr.warm { border: none; border-top: 1px solid #e9e5de; }

    /* Subtle bg pattern */
    .dot-bg {
      background-image: radial-gradient(circle, #d8d3ea 1px, transparent 1px);
      background-size: 28px 28px;
    }
  </style>
</head>
<body>

<!-- ─── NAV ────────────────────────────────────────── -->
<nav id="nav" class="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-8 py-4 bg-white/90 backdrop-blur-md"
     style="border-bottom: 1px solid #f0ece4;">

  <img src="${pageContext.request.contextPath}/assets/img/logos/logo-horizontal.png" alt="Aura" class="h-12 w-auto">

  <div class="hidden md:flex items-center gap-8 text-sm text-warm-gray font-light">
    <a href="#sobre">Sobre</a>
    <a href="#funcionalidades">Funcionalidades</a>
    <a href="#tecnologias">Tecnologias</a>
    <a href="#equipe">Equipe</a>
  </div>

  <span class="label">IF Baiano · ADS</span>
</nav>


<!-- ─── HERO ────────────────────────────────────────── -->
<section class="relative min-h-screen flex items-center overflow-hidden" style="background:#faf8f5;">

  <!-- Dot texture top-right -->
  <div class="absolute top-0 right-0 w-80 h-80 dot-bg opacity-60 pointer-events-none"
       style="mask-image: radial-gradient(ellipse at top right, black 20%, transparent 80%);
              -webkit-mask-image: radial-gradient(ellipse at top right, black 20%, transparent 80%);"></div>

  <!-- Decorative quote mark -->
  <div class="absolute -left-8 top-1/2 -translate-y-1/2 quote-mark select-none hidden lg:block">"</div>

  <div class="relative z-10 max-w-6xl mx-auto px-8 pt-28 pb-20 grid lg:grid-cols-2 gap-16 items-center">

    <!-- Left: text -->
    <div>
      <span class="label mb-8 inline-block">Projeto Acadêmico — LPOO</span>

      <h1 class="font-serif text-[clamp(3rem,7vw,5.5rem)] leading-[1.08] text-warm-dark mt-4 mb-6">
        Aprender<br>
        <em class="text-violet-soft">juntos,</em><br>
        crescer juntos.
      </h1>

      <p class="text-warm-gray text-base font-light leading-8 max-w-md mb-10">
        Aura é uma plataforma colaborativa que conecta pessoas curiosas
        com pessoas generosas — aquelas que têm conhecimento e querem
        compartilhá-lo.
      </p>

      <div class="flex flex-wrap gap-3">
        <a href="#sobre"
           class="px-7 py-3.5 rounded-full text-sm font-medium text-white transition-all duration-200"
           style="background: #7c3aed; box-shadow: 0 4px 18px rgba(124,58,237,0.25);"
           onmouseover="this.style.boxShadow='0 6px 24px rgba(124,58,237,0.35)'"
           onmouseout="this.style.boxShadow='0 4px 18px rgba(124,58,237,0.25)'">
          Conhecer o projeto
        </a>
        <a href="#equipe"
           class="px-7 py-3.5 rounded-full text-sm font-medium text-warm-dark border hover:border-violet-pale transition-all duration-200"
           style="border-color:#e9e5de; background:#ffffff;">
          Ver equipe
        </a>
      </div>

      <!-- small social proof -->
      <div class="mt-12 flex items-center gap-4">
        <div class="flex -space-x-2">
          <% String[] avatarColors = {"#ddd6fe","#c4b5fd","#a78bfa","#8b5cf6"}; %>
          <% for(String c : avatarColors) { %>
          <div class="w-8 h-8 rounded-full border-2 border-white flex items-center justify-center text-xs font-medium text-violet-soft"
               style="background:<%= c %>;">
          </div>
          <% } %>
        </div>
        <p class="text-warm-gray text-xs font-light leading-5">
          Desenvolvido por<br>
          <strong class="text-warm-dark font-medium">5 estudantes</strong> do IF Baiano
        </p>
      </div>
    </div>

    <!-- Right -->

    <!-- Right -->

    <div class="hidden lg:block">

      <div class="relative">

        ```
        <div class="overflow-hidden rounded-[32px] shadow-sm border border-gray-100 bg-white">
          <img
                  src="${pageContext.request.contextPath}/assets/img/mentoria.jpg"
                  alt="Pessoas aprendendo juntas"
                  class="w-full h-[540px] object-cover">
        </div>

        <!-- selo discreto -->
        <div class="absolute top-5 left-5 bg-white/90 backdrop-blur-sm px-4 py-2 rounded-full border border-gray-100 shadow-sm">
  <span class="text-xs tracking-wide text-violet-600 font-medium uppercase">
    Aprendizado colaborativo
  </span>
        </div>
        ```

      </div>

      <div class="mt-6 flex items-center justify-between">

        ```

        <div class="flex items-center gap-2">
          <div class="w-2 h-2 rounded-full bg-violet-400"></div>
          <div class="w-2 h-2 rounded-full bg-violet-300"></div>
          <div class="w-2 h-2 rounded-full bg-violet-200"></div>
        </div>
        ```

      </div>

    </div>


  </div>
</section>


<!-- ─── SOBRE ────────────────────────────────────────── -->
<section id="sobre" class="py-28 px-8 bg-white">
  <div class="max-w-5xl mx-auto">

    <div class="reveal mb-16">
      <span class="label">O projeto</span>
      <h2 class="font-serif text-[clamp(2rem,4vw,3rem)] text-warm-dark mt-5 mb-5 leading-tight">
        Por que o Aura existe?
      </h2>
      <div class="divider"></div>
    </div>

    <div class="grid lg:grid-cols-2 gap-8 reveal">

      <!-- Problema -->
      <div class="paper p-8">
        <div class="w-9 h-9 rounded-full flex items-center justify-center mb-5" style="background:#fef3c7;">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        </div>
        <h3 class="font-serif text-lg text-warm-dark mb-4">O problema</h3>
        <p class="text-warm-gray text-sm font-light leading-8">
          Muitas pessoas têm vontade de aprender novas habilidades, mas não conseguem
          encontrar alguém disposto a ensinar de forma estruturada. Quem tem conhecimento,
          por sua vez, não encontra um espaço para compartilhá-lo e ser valorizado por isso.
        </p>
      </div>

      <!-- Solução -->
      <div class="paper p-8" style="background:#faf8f5;">
        <div class="w-9 h-9 rounded-full flex items-center justify-center mb-5" style="background:#ede9fe;">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#7c3aed" stroke-width="2" stroke-linecap="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        </div>
        <h3 class="font-serif text-lg text-warm-dark mb-4">A solução</h3>
        <p class="text-warm-gray text-sm font-light leading-8">
          Aura conecta alunos e mentores por compatibilidade de interesses. A plataforma
          organiza sessões, distribui créditos para quem ensina, coleta avaliações e mantém
          um ambiente de confiança entre todos os participantes.
        </p>
      </div>

    </div>

    <!-- Objetivo -->
    <div class="mt-8 reveal rounded-2xl p-10" style="background:#f5f3ff; border:1px solid #ede9fe;">
      <p class="font-serif  text-2xl text-warm-dark leading-relaxed max-w-3xl">
        "Tornar o acesso ao aprendizado mais simples, colaborativo e acessível —
        valorizando quem ensina tanto quanto quem aprende."
      </p>
      <p class="text-xs text-warm-gray font-light mt-5 uppercase tracking-widest">Objetivo do projeto</p>
    </div>

  </div>
</section>


<!-- ─── STATS ────────────────────────────────────────── -->
<section class="py-20 px-8" style="background:#faf8f5; border-top:1px solid #e9e5de; border-bottom:1px solid #e9e5de;">
  <div class="max-w-4xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
    <div class="reveal">
      <div class="stat-big">2</div>
      <p class="text-warm-gray text-xs font-light mt-2 uppercase tracking-widest">Perfis</p>
    </div>
    <div class="reveal">
      <div class="stat-big">12</div>
      <p class="text-warm-gray text-xs font-light mt-2 uppercase tracking-widest">Funcionalidades</p>
    </div>
    <div class="reveal">
      <div class="stat-big">5</div>
      <p class="text-warm-gray text-xs font-light mt-2 uppercase tracking-widest">Tecnologias</p>
    </div>
    <div class="reveal">
      <div class="stat-big" style="color:#7c3aed;">100%</div>
      <p class="text-warm-gray text-xs font-light mt-2 uppercase tracking-widest">Acadêmico</p>
    </div>
  </div>
</section>


<!-- ─── FUNCIONALIDADES ──────────────────────────────── -->
<section id="funcionalidades" class="py-28 px-8 bg-white">
  <div class="max-w-5xl mx-auto">

    <div class="reveal mb-16">
      <span class="label">Recursos</span>
      <h2 class="font-serif text-[clamp(2rem,4vw,3rem)] text-warm-dark mt-5 mb-5 leading-tight">
        O que a plataforma faz
      </h2>
      <div class="divider"></div>
    </div>

    <div class="grid md:grid-cols-2 gap-4">

      <%
        String[][] features = {
                {"01", "Cadastro de usuários", "Criação e gerenciamento de perfis de alunos e mentores."},
                {"02", "Interesses e habilidades", "Cada usuário define o que quer aprender e o que pode ensinar."},
                {"03", "Sugestão automática de mentores", "Sistema que conecta pessoas por compatibilidade de perfil."},
                {"04", "Gestão de mentorias", "Solicite, aceite, agende e acompanhe sessões com facilidade."},
                {"05", "Sistema de créditos", "Mentores ganham créditos por cada sessão realizada."},
                {"06", "Avaliação de mentores", "Alunos avaliam mentores após cada encontro."},
                {"07", "Reportação de reuniões", "Registro estruturado dos encontros realizados."},
                {"08", "Envio de evidências", "Materiais e comprovantes anexados às reportações."},
                {"09", "Notificações", "Alertas em tempo real para solicitações e confirmações."},
                {"10", "Agenda do mentor", "Mentores gerenciam sua disponibilidade com calendário próprio."},
                {"11", "Painel administrativo", "Visão geral e controles de moderação da plataforma."},
                {"12", "Gestão de ocorrências", "Revisão de evidências e tratamento de irregularidades."}
        };
      %>

      <% for(String[] f : features) { %>
      <div class="reveal flex items-start gap-5 paper p-6">
        <span class="feat-num mt-0.5 w-7 shrink-0"><%= f[0] %></span>
        <div>
          <h3 class="text-sm font-medium text-warm-dark mb-1"><%= f[1] %></h3>
          <p class="text-warm-gray text-xs font-light leading-6"><%= f[2] %></p>
        </div>
      </div>
      <% } %>

    </div>

  </div>
</section>


<!-- ─── TECNOLOGIAS ──────────────────────────────────── -->
<section id="tecnologias" class="py-28 px-8" style="background:#faf8f5; border-top:1px solid #e9e5de;">
  <div class="max-w-5xl mx-auto">

    <div class="reveal mb-16">
      <span class="label">Stack técnico</span>
      <h2 class="font-serif text-[clamp(2rem,4vw,3rem)] text-warm-dark mt-5 mb-5 leading-tight">
        Tecnologias utilizadas
      </h2>
      <div class="divider"></div>
    </div>

    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4 reveal">

      <%
        String[][] techs = {
                {"☕", "Java", "Backend e lógica de negócio"},
                {"📄", "JSP", "Templates e renderização server-side"},
                {"🎨", "Tailwind CSS", "Estilização e interface"},
                {"🗄️", "PostgreSQL", "Banco de dados relacional"},
                {"🐳", "Docker", "Containerização e deploy"}
        };
      %>
      <% for(String[] t : techs) { %>
      <div class="tech-pill flex-col text-center py-7 px-4 reveal" style="border-radius:16px;">
        <span class="text-3xl mb-3 block"><%= t[0] %></span>
        <p class="text-sm font-medium text-warm-dark mb-1"><%= t[1] %></p>
        <p class="text-xs text-warm-gray font-light leading-5"><%= t[2] %></p>
      </div>
      <% } %>

    </div>

  </div>
</section>


<!-- ─── EQUIPE ───────────────────────────────────────── -->
<section id="equipe" class="py-28 px-8 bg-white">
  <!-- ─── EQUIPE ───────────────────────────────────────── -->

  <section id="equipe" class="py-32 px-8 bg-white">
    <div class="max-w-7xl mx-auto">

      ```
      <!-- Cabeçalho -->
      <div class="reveal mb-20 text-center">
        <span class="label">Pessoas</span>

        <h2 class="font-serif text-[clamp(2.5rem,5vw,4rem)] text-warm-dark mt-5 leading-tight">
          Quem construiu o Aura
        </h2>

        <div class="divider mx-auto mt-6"></div>

        <p class="text-warm-gray text-base font-light mt-6 max-w-2xl mx-auto leading-8">
          Um projeto desenvolvido por estudantes de Análise e Desenvolvimento de Sistemas
          do Instituto Federal Baiano, unindo tecnologia, colaboração e aprendizado.
        </p>
      </div>

      <!-- Orientador -->
      <div class="reveal mb-16 rounded-3xl overflow-hidden shadow-sm"
           style="background:#f5f3ff; border:1px solid #ede9fe;">

        <div class="grid lg:grid-cols-[380px_1fr]">

          <img src="${pageContext.request.contextPath}/assets/img/team/woquiton.enc"
               alt="Prof. Woquiton Fernandes"
               class="w-full h-[420px] object-cover">

          <div class="p-12 flex flex-col justify-center">

      <span class="label w-fit mb-5">
        Orientador
      </span>

            <h3 class="font-serif text-4xl text-warm-dark">
              Woquiton Fernandes
            </h3>

            <p class="text-warm-gray mt-5 text-lg leading-9 max-w-3xl">
              Professor responsável pela disciplina de Linguagem de Programação
              Orientada a Objetos (LPOO) e orientador do desenvolvimento do
              Aura, acompanhando a equipe desde a concepção da ideia até a
              implementação final da plataforma.
            </p>

          </div>

        </div>
      </div>

      <!-- Integrantes -->
      <%
        String[][] members = {
                {"jeovana.jpeg",  "Jeovana Miranda",    "Tech Lead · Desenvolvedora · Analista"},
                {"daniel.jpeg",   "Daniel Oliveira",    "DevOps · Desenvolvedor · Analista"},
                {"livia.jpeg",    "Lívia Alkimim",      "Desenvolvedora · Analista"},
                {"erick.jpeg",    "Erick Sanches",      "Desenvolvedor · Analista"},
                {"vinicius.jpeg", "Vinícius Benevides", "Analista"}
        };
      %>

      <div class="grid md:grid-cols-2 xl:grid-cols-5 gap-6">

        <% for(String[] m : members) { %>

        <div class="reveal bg-white rounded-3xl overflow-hidden border border-gray-100 shadow-sm hover:shadow-xl transition-all duration-300 hover:-translate-y-1">

          <img src="${pageContext.request.contextPath}/assets/img/team/<%= m[0] %>"
               alt="<%= m[1] %>"
               class="w-full h-96 object-cover">

          <div class="p-6">

            <h3 class="font-serif text-xl text-warm-dark leading-tight">
              <%= m[1] %>
            </h3>

            <p class="text-warm-gray text-sm font-light mt-3 leading-6">
              <%= m[2] %>
            </p>

          </div>

        </div>

        <% } %>

      </div>
      ```

    </div>
  </section>

</section>


<!-- ─── ACADÊMICO ────────────────────────────────────── -->
<section class="py-20 px-8" style="background:#faf8f5; border-top:1px solid #e9e5de;">
  <div class="max-w-4xl mx-auto reveal">
    <div class="rounded-2xl p-10" style="background:#fff; border:1px solid #e9e5de;">
      <span class="label mb-6 inline-block">Informação acadêmica</span>
      <p class="text-warm-gray text-sm font-light leading-9 mt-2">
        Este sistema foi desenvolvido como atividade prática da disciplina de
        <strong class="text-warm-dark font-medium">Linguagem de Programação Orientada a Objetos (LPOO)</strong>,
        no curso de <strong class="text-warm-dark font-medium">Análise e Desenvolvimento de Sistemas</strong>
        do <strong class="text-warm-dark font-medium">Instituto Federal Baiano</strong>,
        sob orientação do professor Woquiton Fernandes.
      </p>
      <p class="text-warm-gray text-sm font-light leading-9 mt-4">
        O objetivo é aplicar na prática conceitos de programação orientada a objetos,
        arquitetura em camadas, banco de dados e desenvolvimento web — por meio
        de uma solução real, construída integralmente pela equipe.
      </p>
    </div>
  </div>
</section>


<!-- ─── FOOTER ───────────────────────────────────────── -->
<footer class="bg-white border-t py-14 px-8" style="border-color:#e9e5de;">
  <div class="max-w-5xl mx-auto flex flex-col md:flex-row items-start md:items-center justify-between gap-8">

    <div>
      <span class="font-serif text-2xl text-warm-dark">Aura</span>
      <p class="text-warm-gray text-xs font-light mt-2 max-w-xs leading-6">
        Plataforma colaborativa de mentorias — projeto acadêmico
        para fins de aprendizagem e integração de conhecimentos.
      </p>
    </div>

    <div class="text-right">
      <p class="text-warm-gray text-xs font-light">Instituto Federal Baiano</p>
      <p class="text-warm-gray text-xs font-light mt-1">ADS · Linguagem de Programação Orientada a Objetos</p>
    </div>

  </div>
</footer>


<script>
  // Scroll reveal
  const obs = new IntersectionObserver((entries) => {
    entries.forEach((e, i) => {
      if (e.isIntersecting) {
        setTimeout(() => e.target.classList.add('visible'), i * 55);
        obs.unobserve(e.target);
      }
    });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => obs.observe(el));

  // Nav border on scroll
  const nav = document.getElementById('nav');
  window.addEventListener('scroll', () => {
    nav.style.borderBottomColor = window.scrollY > 40 ? '#e9e5de' : 'transparent';
  });
</script>

</body>
</html>