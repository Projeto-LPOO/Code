(function () {
    'use strict';

    const contextPath = document.body.dataset.context;
    const teacherId   = document.body.dataset.teacherId;

    const form             = document.getElementById('meetingForm');
    const tipoOptions      = document.getElementById('tipoOptions');
    const selectCategoria  = document.getElementById('selectCategoria');
    const selectInteresse  = document.getElementById('selectInteresse');
    const hiddenInterestId = document.getElementById('hiddenInterestId');
    const inputData        = document.getElementById('inputData');
    const inputHora        = document.getElementById('inputHora');
    const hiddenDataHora   = document.getElementById('hiddenDataHora');
    const availabilityInfo = document.getElementById('availabilityInfo');
    const cardOnline       = document.getElementById('cardOnline');
    const cardPresencial   = document.getElementById('cardPresencial');
    const resumoTipo       = document.getElementById('resumoTipo');
    const resumoInteresse  = document.getElementById('resumoInteresse');
    const resumoDataHora   = document.getElementById('resumoDataHora');

    function init() {
        configurarTipo();
        configurarCategoriaInteresse();
        configurarDataHora();
        carregarDisponibilidade();
        if (form) form.addEventListener('submit', validarFormulario);
    }

    function configurarTipo() {
        if (!tipoOptions) return;
        tipoOptions.querySelectorAll('.mr-tipo-opt').forEach(function (label) {
            label.addEventListener('click', function () {
                tipoOptions.querySelectorAll('.mr-tipo-opt').forEach(function (l) {
                    l.classList.remove('mr-tipo-selected');
                });
                label.classList.add('mr-tipo-selected');
                var radio = label.querySelector('input[type="radio"]');
                var tipo  = radio ? radio.value : 'online';
                atualizarCardsTipo(tipo);
                if (resumoTipo) resumoTipo.textContent = tipo === 'presencial' ? 'Presencial' : 'Online';
            });
        });
    }

    function getTipo() {
        if (!tipoOptions) return 'online';
        var checked = tipoOptions.querySelector('input[type="radio"]:checked');
        return checked ? checked.value : 'online';
    }

    function atualizarCardsTipo(tipo) {
        if (!cardOnline || !cardPresencial) return;
        if (tipo === 'presencial') {
            cardOnline.classList.add('mr-hidden');
            cardPresencial.classList.remove('mr-hidden');
        } else {
            cardOnline.classList.remove('mr-hidden');
            cardPresencial.classList.add('mr-hidden');
        }
    }

    function configurarCategoriaInteresse() {
        if (!selectCategoria || !selectInteresse) return;

        selectCategoria.addEventListener('change', function () {
            var categoryId = this.value;
            resetInteresse();
            if (!categoryId || !teacherId) return;

            var url = contextPath + '/autenticado/meeting/register'
                + '?action=mentorInterests'
                + '&teacherId='  + encodeURIComponent(teacherId)
                + '&categoryId=' + encodeURIComponent(categoryId);

            selectInteresse.disabled = true;
            selectInteresse.innerHTML = '<option value="">Carregando...</option>';

            fetch(url)
                .then(function (res) { if (!res.ok) throw new Error('Erro'); return res.json(); })
                .then(function (interests) {
                    selectInteresse.innerHTML = '<option value="">-- Selecione um interesse --</option>';
                    interests.forEach(function (i) {
                        var opt = document.createElement('option');
                        opt.value       = i.idInterest !== undefined ? i.idInterest : i.id;
                        opt.textContent = i.name;
                        selectInteresse.appendChild(opt);
                    });
                    selectInteresse.disabled = interests.length === 0;
                    if (interests.length === 0)
                        selectInteresse.innerHTML = '<option value="">Nenhum interesse nesta categoria</option>';
                })
                .catch(function () {
                    selectInteresse.innerHTML = '<option value="">Erro ao carregar</option>';
                    selectInteresse.disabled = true;
                });
        });

        selectInteresse.addEventListener('change', function () {
            if (hiddenInterestId) hiddenInterestId.value = this.value;
            if (resumoInteresse) {
                var opt = this.options[this.selectedIndex];
                resumoInteresse.textContent = (opt && opt.value) ? opt.text : '—';
            }
        });
    }

    function resetInteresse() {
        if (!selectInteresse) return;
        selectInteresse.innerHTML = '<option value="">-- Selecione primeiro a categoria --</option>';
        selectInteresse.disabled = true;
        if (hiddenInterestId) hiddenInterestId.value = '';
        if (resumoInteresse) resumoInteresse.textContent = '—';
    }

    function configurarDataHora() {
        if (!inputData || !inputHora) return;
        var hoje = new Date();
        var dd   = String(hoje.getDate()).padStart(2, '0');
        var mm   = String(hoje.getMonth() + 1).padStart(2, '0');
        var yyyy = hoje.getFullYear();
        inputData.min = yyyy + '-' + mm + '-' + dd;
        inputData.addEventListener('change', sincronizarDataHora);
        inputHora.addEventListener('change', sincronizarDataHora);
    }

    function sincronizarDataHora() {
        var data = inputData ? inputData.value : '';
        var hora = inputHora ? inputHora.value : '';
        if (data && hora) {
            var p = data.split('-');
            var formatado = p[2] + '/' + p[1] + '/' + p[0] + ' ' + hora;
            if (hiddenDataHora) hiddenDataHora.value = formatado;
            if (resumoDataHora) resumoDataHora.textContent = p[2] + '/' + p[1] + '/' + p[0] + ' às ' + hora;
        } else {
            if (hiddenDataHora) hiddenDataHora.value = '';
            if (resumoDataHora) resumoDataHora.textContent = '—';
        }
    }

    function carregarDisponibilidade() {
        if (!availabilityInfo || !teacherId) return;
        var url = contextPath + '/autenticado/meeting/register'
            + '?action=mentorSlots&teacherId=' + encodeURIComponent(teacherId);
        fetch(url)
            .then(function (res) { if (!res.ok) throw new Error('Erro'); return res.json(); })
            .then(renderizarDisponibilidade)
            .catch(function () {
                availabilityInfo.innerHTML = '<span class="mr-avail-loading">Não foi possível carregar a disponibilidade.</span>';
            });
    }

    function renderizarDisponibilidade(slots) {
        if (!availabilityInfo) return;
        if (!slots || slots.length === 0) {
            availabilityInfo.innerHTML = '<span class="mr-avail-loading">Este professor ainda não cadastrou disponibilidade.</span>';
            return;
        }
        var porDia = {};
        slots.forEach(function (slot) {
            var dia = slot.dayLabel || slot.day;
            if (!porDia[dia]) porDia[dia] = [];
            porDia[dia].push(fmtHora(slot.start) + ' – ' + fmtHora(slot.end));
        });
        var html = '<div class="mr-avail-wrap">';
        Object.keys(porDia).forEach(function (dia) {
            porDia[dia].forEach(function (horario) {
                html += '<span class="mr-avail-badge"><strong>' + dia + '</strong>'
                    + '<span class="mr-avail-time">' + horario + '</span></span>';
            });
        });
        html += '</div>';
        availabilityInfo.innerHTML = html;
    }

    function fmtHora(timeStr) {
        if (!timeStr) return '';
        var p = timeStr.split(':');
        return p[0] + ':' + p[1];
    }

    function validarFormulario(e) {
        limparErros();
        var valido = true;
        var descricao = document.getElementById('descricao');
        if (!descricao || !descricao.value.trim()) {
            mostrarErro('erro-descricao', 'A descrição é obrigatória.');
            valido = false;
        }
        if (!hiddenDataHora || !hiddenDataHora.value) {
            mostrarErro('erro-dataHora', 'Selecione uma data e horário.');
            valido = false;
        }
        var tipo = getTipo();
        if (tipo === 'online') {
            var link = document.getElementById('link');
            if (!link || !link.value.trim()) {
                mostrarErro('erro-link', 'Informe o link ou plataforma da reunião.');
                valido = false;
            }
        } else {
            var cidade = document.getElementById('cidade');
            var rua    = document.getElementById('rua');
            var numero = document.getElementById('numero');
            if (!cidade || !cidade.value.trim()) {
                mostrarErro('erro-presencial', 'Cidade é obrigatória.');
                valido = false;
            } else if (!rua || !rua.value.trim()) {
                mostrarErro('erro-presencial', 'Rua é obrigatória.');
                valido = false;
            } else if (!numero || !numero.value || parseInt(numero.value) <= 0) {
                mostrarErro('erro-presencial', 'Número deve ser positivo.');
                valido = false;
            }
        }
        if (!valido) e.preventDefault();
    }

    function mostrarErro(id, msg) {
        var el = document.getElementById(id);
        if (el) el.textContent = msg;
    }

    function limparErros() {
        document.querySelectorAll('.mr-erro').forEach(function (el) { el.textContent = ''; });
    }

    init();

})();