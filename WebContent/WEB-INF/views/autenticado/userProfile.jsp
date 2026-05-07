<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${user.name} | Infinity Aura</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/userProfile.css">
</head>

<body>

<div class="layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <div class="sidebar-top">

            <div class="sidebar-logo">
                <img
                        src="${pageContext.request.contextPath}/assets/img/logo-aura.png"
                        alt="Infinity Aura"
                        class="logo-img"
                >

                <span>Aura</span>
            </div>

            <nav class="sidebar-nav">

                <a href="${pageContext.request.contextPath}/autenticado/home"
                   class="nav-link">

                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <rect x="3" y="3" width="7" height="7" rx="1.5"/>
                        <rect x="14" y="3" width="7" height="7" rx="1.5"/>
                        <rect x="3" y="14" width="7" height="7" rx="1.5"/>
                        <rect x="14" y="14" width="7" height="7" rx="1.5"/>
                    </svg>

                    Dashboard
                </a>

                <a href="${pageContext.request.contextPath}/users"
                   class="nav-link active">

                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <circle cx="11" cy="11" r="7"/>
                        <path d="m21 21-4.35-4.35"/>
                    </svg>

                    Explorar
                </a>

                <a href="${pageContext.request.contextPath}/autenticado/availability"
                   class="nav-link">

                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <rect x="3" y="4" width="18" height="18" rx="2"/>
                        <path d="M16 2v4M8 2v4M3 10h18"/>
                    </svg>

                    Calendário
                </a>

                <a href="#"
                   class="nav-link">

                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                    </svg>

                    Mensagens
                </a>

                <a href="#"
                   class="nav-link">

                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <rect x="2" y="5" width="20" height="14" rx="2"/>
                        <path d="M2 10h20"/>
                    </svg>

                    Carteira
                </a>

            </nav>

        </div>

        <a href="${pageContext.request.contextPath}/logout"
           class="nav-logout">

            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                <polyline points="16 17 21 12 16 7"/>
                <line x1="21" y1="12" x2="9" y2="12"/>
            </svg>

            Sair
        </a>

    </aside>

    <!-- MAIN -->
    <main class="main-content">

        <div class="main-wrapper">

            <c:if test="${empty user}">

                <div class="not-found">

                    <svg fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                        <circle cx="12" cy="8" r="4"/>
                        <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
                    </svg>

                    <h2>Usuário não encontrado</h2>

                    <a href="${pageContext.request.contextPath}/users">
                        Voltar
                    </a>

                </div>

            </c:if>

            <c:if test="${not empty user}">

                <!-- BREADCRUMB -->
                <nav class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/users">
                        Usuários
                    </a>

                    <span>/</span>

                    <span class="current">${user.name}</span>
                </nav>

                <!-- PROFILE CARD -->
                <section class="profile-card fade-up">

                    <div class="profile-banner"></div>

                    <div class="profile-content">

                        <div class="profile-avatar">
                                ${user.name.substring(0,1).toUpperCase()}
                        </div>

                        <div class="profile-header">

                            <div class="profile-user-info">

                                <div class="profile-name-row">

                                    <h1 class="profile-name">
                                            ${user.name}
                                    </h1>

                                    <a href="${pageContext.request.contextPath}/autenticado/schedule"
                                       class="btn-primary">
                                        Agendar Sessão
                                    </a>

                                </div>

                                <p class="profile-role">
                                    Principal Software Architect
                                </p>

                            </div>

                        </div>

                        <!-- STATS -->
                        <div class="stats-grid">

                            <div class="stat-item">

                                <div class="stat-icon">

                                    <svg fill="none" stroke="currentColor" stroke-width="2"
                                         viewBox="0 0 24 24">
                                        <circle cx="12" cy="12" r="10"/>
                                        <path d="M12 6v6l4 2"/>
                                    </svg>

                                </div>

                                <h3>482</h3>
                                <span>Horas Ensinadas</span>

                            </div>

                            <div class="stat-item">

                                <div class="stat-icon">

                                    <svg fill="none" stroke="currentColor" stroke-width="2"
                                         viewBox="0 0 24 24">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                        <circle cx="9" cy="7" r="4"/>
                                    </svg>

                                </div>

                                <h3>124</h3>
                                <span>Aprendizes Ativos</span>

                            </div>

                            <div class="stat-item">

                                <div class="stat-icon">

                                    <svg fill="currentColor" viewBox="0 0 20 20">
                                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                                    </svg>

                                </div>

                                <h3>4.9</h3>
                                <span>Avaliação Média</span>

                            </div>

                        </div>

                    </div>

                </section>

                <!-- JORNADA -->
                <section class="content-card fade-up">

                    <div class="section-title">

                        <div class="section-icon">
                            ✦
                        </div>

                        <h2>Minha Jornada</h2>

                    </div>

                    <p class="journey-text">
                        Aqui serão evidenciadas as experiências, trajetória,
                        projetos, conhecimentos e evolução profissional do usuário
                        dentro da plataforma Infinity Aura.
                    </p>

                </section>

                <!-- INTERESSES -->
                <section class="content-card fade-up">

                    <div class="section-title">

                        <div class="section-icon">
                            ✦
                        </div>

                        <h2>Interesses & Habilidades</h2>

                    </div>

                    <div class="skills-grid">

                        <c:choose>

                            <c:when test="${not empty user.interests}">

                                <c:forEach items="${user.interests}" var="interest">

                                    <div class="skill-card">

                                        <h3>${interest.name}</h3>

                                        <p>

                                            <c:choose>

                                                <c:when test="${not empty interest.category}">
                                                    ${interest.category.name}
                                                </c:when>

                                                <c:otherwise>
                                                    Interesse
                                                </c:otherwise>

                                            </c:choose>

                                        </p>

                                    </div>

                                </c:forEach>

                            </c:when>

                            <c:otherwise>

                                <div class="empty-state">
                                    Nenhum interesse cadastrado.
                                </div>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </section>

                <!-- INFORMAÇÕES -->
                <section class="content-card fade-up">

                    <div class="section-title">

                        <div class="section-icon">
                            ✦
                        </div>

                        <h2>Informações Pessoais</h2>

                    </div>

                    <div class="info-grid">

                        <div class="info-item">
                            <span>IDADE</span>
                            <strong>${user.age} anos</strong>
                        </div>

                        <div class="info-item">
                            <span>TELEFONE</span>
                            <strong>${user.phone}</strong>
                        </div>

                        <div class="info-item full">
                            <span>ENDEREÇO</span>
                            <strong>${user.address}</strong>
                        </div>

                    </div>

                </section>

                <!-- DISPONIBILIDADE -->
                <section class="content-card fade-up">

                    <div class="action-wrapper">

                        <div class="section-title no-margin">

                            <div class="section-icon">
                                ✦
                            </div>

                            <h2>Disponibilidade</h2>

                        </div>

                        <a href="${pageContext.request.contextPath}/autenticado/availability"
                           class="btn-secondary">

                            Acessar Disponibilidade

                        </a>

                    </div>

                </section>

                <!-- AVALIAÇÕES -->
                <section class="content-card fade-up">

                    <div class="action-wrapper">

                        <div class="section-title no-margin">

                            <div class="section-icon">
                                ✦
                            </div>

                            <h2>Avaliações</h2>

                        </div>

                        <a href="${pageContext.request.contextPath}/reviews"
                           class="btn-secondary">

                            Acessar Avaliações de Aprendizes

                        </a>

                    </div>

                </section>

            </c:if>

        </div>

    </main>

</div>

<footer class="footer">
    © 2026 Aura. Conectando pessoas pelo conhecimento.
</footer>

<script src="${pageContext.request.contextPath}/assets/js/userProfile.js"></script>

</body>
</html>