<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aura.user.models.User" %>
<%@ page import="com.aura.user.models.CommercialUser" %>
<%@ page import="com.aura.category.Category" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    User user = (User) session.getAttribute("user");
    CommercialUser mentor = (CommercialUser) request.getAttribute("mentor");
    List<Category> mentorCategories = (List<Category>) request.getAttribute("mentorCategories");
    Integer preselectedTeacherId = (Integer) request.getAttribute("preselectedTeacherId");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Meeting — Aura</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/meetingRegister.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body data-context="${pageContext.request.contextPath}"
      data-teacher-id="<%= preselectedTeacherId != null ? preselectedTeacherId : "" %>">
    <title>Cadastrar Meeting</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/meeting.css">
</head>

<body data-context="${pageContext.request.contextPath}">

<aside>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/autenticado/home">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/users">Explorar</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/availability">Agenda</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/meeting" class="nav-active">Meetings</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/users">Lista de usuários</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/availability">Agenda</a></li>
            <li><a href="${pageContext.request.contextPath}/autenticado/meeting">Meetings</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Sair</a></li>
        </ul>
    </nav>
</aside>

<main>

    <div class="mr-page-header">
        <div>
            <h1 class="mr-page-title">Agendar Meeting</h1>
            <p class="mr-page-sub">Escolha o tipo, data, horário e preencha os detalhes da sessão.</p>
        </div>
        <div class="mr-balance-badge">
            BALANCE <span class="mr-balance-value">240 CS</span>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="mr-server-error">${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${mentor == null}">
            <div class="mr-empty-state">
                <p class="mr-empty-title">Nenhum professor selecionado</p>
                <p class="mr-empty-text">Explore os professores disponíveis e escolha um para agendar.</p>
                <a href="${pageContext.request.contextPath}/autenticado/users" class="mr-btn-primary">
                    Explorar Professores
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <form id="meetingForm"
                  action="${pageContext.request.contextPath}/autenticado/meeting/register"
                  method="post">

                <input type="hidden" name="teacherId"  value="${mentor.id}">
                <input type="hidden" name="interestId" id="hiddenInterestId" value="">

                <div class="mr-grid">

                    <!-- ── COLUNA PRINCIPAL ── -->
                    <div class="mr-col-left">

                        <!-- Mentor -->
                        <div class="mr-card">
                            <div class="mr-mentor-row">
                                <div class="mr-mentor-info">
                                    <h2 class="mr-mentor-name">${mentor.name}</h2>
                                    <p class="mr-mentor-email">${mentor.email}</p>
                                </div>
                                <span class="mr-badge-verified">✓ Professor Verificado</span>
                            </div>
                        </div>

                        <!-- Tipo -->
                        <div class="mr-card">
                            <h3 class="mr-card-title">Tipo de Meeting</h3>
                            <div class="mr-tipo-grid" id="tipoOptions">
                                <label class="mr-tipo-opt mr-tipo-selected">
                                    <input type="radio" name="tipo" value="online" checked>
                                    Online
                                </label>
                                <label class="mr-tipo-opt">
                                    <input type="radio" name="tipo" value="presencial">
                                    Presencial
                                </label>
                            </div>
                        </div>

                        <!-- Categoria e Interesse -->
                        <div class="mr-card">
                            <h3 class="mr-card-title">Área de Conhecimento</h3>
                            <div class="mr-form-row">
                                <div class="mr-form-group">
                                    <label class="mr-label" for="selectCategoria">Categoria</label>
                                    <select id="selectCategoria" name="categoriaId" class="mr-select">
                                        <option value="">-- Selecione a categoria --</option>
                                        <c:forEach var="cat" items="${mentorCategories}">
                                            <option value="${cat.id}">${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mr-form-group">
                                    <label class="mr-label" for="selectInteresse">Interesse</label>
                                    <select id="selectInteresse" name="interestIdSelect" disabled class="mr-select">
                                        <option value="">-- Selecione primeiro a categoria --</option>
                                    </select>
                                </div>
                            </div>
                            <span class="mr-erro" id="erro-interesse"></span>
                        </div>

                        <!-- Disponibilidade -->
                        <div class="mr-card">
                            <h3 class="mr-card-title">Disponibilidade do Professor</h3>
                            <div id="availabilityInfo" class="mr-avail-loading">Carregando disponibilidade...</div>
                        </div>

                        <!-- Data e Hora -->
                        <div class="mr-card">
                            <h3 class="mr-card-title">Data e Hora</h3>
                            <div class="mr-form-row">
                                <div class="mr-form-group">
                                    <label class="mr-label" for="inputData">Data</label>
                                    <input type="date" id="inputData" class="mr-input">
                                </div>
                                <div class="mr-form-group">
                                    <label class="mr-label" for="inputHora">Hora</label>
                                    <input type="time" id="inputHora" class="mr-input">
                                </div>
                            </div>
                            <input type="hidden" name="dataHora" id="hiddenDataHora">
                            <span class="mr-erro" id="erro-dataHora"></span>
                        </div>

                        <!-- Descrição -->
                        <div class="mr-card">
                            <h3 class="mr-card-title">Descrição da Sessão</h3>
                            <textarea name="descricao" id="descricao" rows="3"
                                      placeholder="Descreva o que será abordado na sessão..."
                                      class="mr-textarea"><c:out value="${descricao}"/></textarea>
                            <span class="mr-erro" id="erro-descricao"></span>
                        </div>

                        <!-- Online -->
                        <div id="cardOnline" class="mr-card">
                            <h3 class="mr-card-title">Detalhes Online</h3>
                            <div class="mr-form-group">
                                <label class="mr-label" for="link">Link / Plataforma</label>
                                <input type="text" name="link" id="link"
                                       placeholder="Ex: https://meet.google.com/abc-defg"
                                       class="mr-input">
                                <span class="mr-erro" id="erro-link"></span>
                            </div>
                        </div>

                        <!-- Presencial -->
                        <div id="cardPresencial" class="mr-card mr-hidden">
                            <h3 class="mr-card-title">Endereço do Encontro</h3>
                            <div class="mr-form-row">
                                <div class="mr-form-group">
                                    <label class="mr-label" for="cidade">Cidade *</label>
                                    <input type="text" name="cidade" id="cidade"
                                           placeholder="Ex: São Paulo" class="mr-input">
                                </div>
                                <div class="mr-form-group">
                                    <label class="mr-label" for="bairro">Bairro</label>
                                    <input type="text" name="bairro" id="bairro"
                                           placeholder="Ex: Centro" class="mr-input">
                                </div>
                                <div class="mr-form-group">
                                    <label class="mr-label" for="rua">Rua *</label>
                                    <input type="text" name="rua" id="rua"
                                           placeholder="Ex: Rua das Flores" class="mr-input">
                                </div>
                                <div class="mr-form-group">
                                    <label class="mr-label" for="numero">Número *</label>
                                    <input type="number" name="numero" id="numero"
                                           placeholder="Ex: 123" min="1" class="mr-input">
                                </div>
                                <div class="mr-form-group mr-full">
                                    <label class="mr-label" for="referencia">Ponto de Referência</label>
                                    <input type="text" name="referencia" id="referencia"
                                           placeholder="Ex: Próximo ao metrô" class="mr-input">
                                </div>
                                <div class="mr-form-group mr-full">
                                    <label class="mr-label" for="instrucoes">Instruções Adicionais</label>
                                    <textarea name="instrucoes" id="instrucoes" rows="2"
                                              placeholder="Outras informações importantes..."
                                              class="mr-textarea"></textarea>
                                </div>
                            </div>
                            <span class="mr-erro" id="erro-presencial"></span>
                        </div>

                    </div><!-- /col-left -->

                    <!-- ── RESUMO ── -->
                    <div class="mr-col-right">
                        <div class="mr-card mr-summary-card">
                            <h3 class="mr-card-title">Resumo da Sessão</h3>
                            <p class="mr-summary-sub">Revise os detalhes antes de confirmar</p>

                            <div class="mr-summary-rows">
                                <div class="mr-summary-row">
                                    <span class="mr-summary-label">Professor</span>
                                    <span class="mr-summary-value">${mentor.name}</span>
                                </div>
                                <div class="mr-summary-row">
                                    <span class="mr-summary-label">Tipo</span>
                                    <span class="mr-summary-value" id="resumoTipo">Online</span>
                                </div>
                                <div class="mr-summary-row">
                                    <span class="mr-summary-label">Interesse</span>
                                    <span class="mr-summary-value" id="resumoInteresse">—</span>
                                </div>
                                <div class="mr-summary-row">
                                    <span class="mr-summary-label">Data/Hora</span>
                                    <span class="mr-summary-value" id="resumoDataHora">—</span>
                                </div>
                            </div>

                            <hr class="mr-divider">

                            <div class="mr-protection-box">
                                <strong>Proteção Aura</strong>
                                <span>Seu agendamento fica protegido até o professor confirmar.</span>
                            </div>

                            <button type="submit" id="btnConfirmar" class="mr-btn-submit">
                                Confirmar Agendamento
                            </button>
                            <span class="mr-erro mr-erro-center" id="erro-geral"></span>
                        </div>
                    </div>

                </div><!-- /mr-grid -->
            </form>
        </c:otherwise>
    </c:choose>

</main>

    <h1>Cadastrar Meeting</h1>

    <c:if test="${not empty error}">
        <p class="erro-campo server-error">${error}</p>
    </c:if>

    <span id="preselected-teacher-id"
          data-value="${not empty preselectedTeacherId ? preselectedTeacherId : ''}"
          style="display:none;"></span>

    <form id="formCadastro"
          action="${pageContext.request.contextPath}/autenticado/meeting/register"
          method="post">

        <label>Tipo:
            <select name="tipo" id="tipoSelectCadastro">
                <option value="online"     ${tipo == 'online'     ? 'selected' : ''}>Online</option>
                <option value="presencial" ${tipo == 'presencial' ? 'selected' : ''}>Presencial</option>
            </select>
        </label><br>

        <label>Descrição:
            <input type="text" name="descricao" id="descricao" value="${descricao}">
        </label>
        <span class="erro-campo" id="erro-descricao"></span><br>

        <label>Data/Hora (dd/MM/yyyy HH:mm):
            <input type="text" name="dataHora" id="dataHora" value="${dataHora}" placeholder="25/12/2025 14:00">
        </label>
        <span class="erro-campo" id="erro-dataHora"></span><br>

        <div id="cadastroOnline">
            <label>Link/Plataforma:
                <input type="text" name="link" id="link">
            </label>
            <span class="erro-campo" id="erro-link"></span><br>
        </div>

        <div id="cadastroPresencial" style="display:none;">
            <label>Cidade: <input type="text" name="cidade" id="cidade"></label>
            <span class="erro-campo" id="erro-cidade"></span><br>
            <label>Bairro: <input type="text" name="bairro" id="bairro"></label><br>
            <label>Rua: <input type="text" name="rua" id="rua"></label>
            <span class="erro-campo" id="erro-rua"></span><br>
            <label>Número: <input type="number" name="numero" id="numero"></label>
            <span class="erro-campo" id="erro-numero"></span><br>
            <label>Ponto de referência: <input type="text" name="referencia" id="referencia"></label><br>
            <label>Instruções (opcional): <input type="text" name="instrucoes" id="instrucoes"></label><br>
        </div>

        <fieldset id="mentorSection" style="margin-top:12px;">
            <legend>Professor</legend>

            <c:choose>
                <c:when test="${not empty mentor}">
                    <p id="mentorName">
                        <strong>${mentor.name}</strong>
                        <a href="${pageContext.request.contextPath}/autenticado/users"
                           style="font-size:0.85em; margin-left:8px;">Trocar</a>
                    </p>
                    <input type="hidden" name="teacherId" id="teacherId" value="${mentor.id}">
                </c:when>
                <c:otherwise>
                    <p class="erro-campo">
                        Nenhum professor selecionado.
                        <a href="${pageContext.request.contextPath}/autenticado/users">Selecionar na lista de usuários</a>
                    </p>
                    <input type="hidden" name="teacherId" id="teacherId" value="">
                </c:otherwise>
            </c:choose>
            <span class="erro-campo" id="erro-professor"></span>
        </fieldset>

        <fieldset id="categorySection" style="margin-top:12px;">
            <legend>Habilidade do Professor</legend>

            <label>Categoria:
                <select id="selectCategoria" name="categoriaId">
                    <option value="">-- Selecione --</option>
                </select>
            </label><br>

            <label>Conhecimento (Interesse):
                <select id="selectInteresse" name="interestId" disabled>
                    <option value="">-- Selecione a categoria primeiro --</option>
                </select>
            </label>
            <input type="hidden" name="interestId" id="interestIdHidden">
            <br>
        </fieldset>

        <br>
        <button type="submit" id="submitBtn">Cadastrar</button>
        <a href="${pageContext.request.contextPath}/autenticado/meeting">← Voltar</a>
        <p class="erro-campo" id="erro-geral"></p>
    </form>
</main>

<style>
    .erro-campo { color: red; font-size: 0.85em; }
    .server-error { font-weight: bold; margin-bottom: 10px; }
</style>

<script src="${pageContext.request.contextPath}/assets/js/meetingRegister.js"></script>

</body>
</html>