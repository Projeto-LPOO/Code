/*
 Controla o formulário de cadastro de meeting.
*/
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
    const hiddenDuracao    = document.getElementById('hiddenDuracao');

    const availabilityInfo = document.getElementById('availabilityInfo');

    const cardOnline       = document.getElementById('cardOnline');
    const cardPresencial   = document.getElementById('cardPresencial');

    const resumoTipo       = document.getElementById('resumoTipo');
    const resumoInteresse  = document.getElementById('resumoInteresse');
    const resumoDataHora   = document.getElementById('resumoDataHora');
    const resumoCusto      = document.getElementById('resumoCusto');
    const badgeBalance     = document.getElementById('badgeBalance');

    const duracaoOptions   = document.getElementById('duracaoOptions');

    function init() {
        configurarTipo();
        configurarCategoriaInteresse();
        configurarDataHora();
        configurarDuracao();
        carregarDisponibilidade();

        if (form) {
            form.addEventListener('submit', validarFormulario);
        }
    }

    /*
       TIPO DE MEETING
    */

    function configurarTipo() {
        if (!tipoOptions) return;

        tipoOptions.querySelectorAll('.mr-tipo-opt').forEach(function (label) {
            label.addEventListener('click', function () {
                tipoOptions.querySelectorAll('.mr-tipo-opt').forEach(function (l) {
                    l.classList.remove('mr-tipo-selected',
                        'border-violet-600', 'bg-violet-50', 'text-violet-700', 'font-semibold');
                    l.classList.add('border-gray-200', 'text-gray-600');
                });

                label.classList.add('mr-tipo-selected',
                    'border-violet-600', 'bg-violet-50', 'text-violet-700', 'font-semibold');
                label.classList.remove('border-gray-200', 'text-gray-600');

                const radio = label.querySelector('input[type="radio"]');
                const tipo  = radio ? radio.value : 'online';

                atualizarCardsTipo(tipo);

                if (resumoTipo) {
                    resumoTipo.textContent = tipo === 'presencial' ? 'Presencial' : 'Online';
                }
            });
        });
    }

    function getTipo() {
        if (!tipoOptions) return 'online';
        const checked = tipoOptions.querySelector('input[type="radio"]:checked');
        return checked ? checked.value : 'online';
    }

    function atualizarCardsTipo(tipo) {
        if (!cardOnline || !cardPresencial) return;
        if (tipo === 'presencial') {
            cardOnline.classList.add('hidden');
            cardPresencial.classList.remove('hidden');
        } else {
            cardOnline.classList.remove('hidden');
            cardPresencial.classList.add('hidden');
        }
    }

    /*
       DURAÇÃO
    */

    function configurarDuracao() {
        if (!duracaoOptions) return;

        const btns = duracaoOptions.querySelectorAll('.duracao-btn');

        btns.forEach(function (btn) {
            btn.addEventListener('click', function () {
                // Remove seleção de todos
                btns.forEach(function (b) {
                    b.classList.remove(
                        'border-violet-600', 'bg-violet-600', 'text-white', 'selected'
                    );
                    b.classList.add('border-gray-200', 'text-gray-600');
                });

                // Marca o clicado
                btn.classList.add('border-violet-600', 'bg-violet-600', 'text-white', 'selected');
                btn.classList.remove('border-gray-200', 'text-gray-600');

                const minutos = btn.dataset.minutos;
                const custo   = btn.dataset.custo;

                if (hiddenDuracao) hiddenDuracao.value = minutos;
                if (resumoCusto)   resumoCusto.textContent = custo + ' CS';

                // Limpa erro de duração
                const erroDuracao = document.getElementById('erro-duracao');
                if (erroDuracao) erroDuracao.textContent = '';
            });
        });
    }

    function getDuracaoSelecionada() {
        if (!duracaoOptions) return 60;
        const btn = duracaoOptions.querySelector('.duracao-btn.selected');
        return btn ? parseInt(btn.dataset.minutos) : 60;
    }

    /*
       CATEGORIA / INTERESSE
    */

    function configurarCategoriaInteresse() {
        if (!selectCategoria || !selectInteresse) return;

        selectCategoria.addEventListener('change', function () {
            const categoryId = this.value;
            resetInteresse();

            if (!categoryId || !teacherId) return;

            const url =
                contextPath +
                '/autenticado/meeting/register' +
                '?action=mentorInterests' +
                '&teacherId=' + encodeURIComponent(teacherId) +
                '&categoryId=' + encodeURIComponent(categoryId);

            selectInteresse.disabled = true;
            selectInteresse.innerHTML = '<option value="">Carregando...</option>';

            fetch(url)
                .then(function (res) {
                    if (!res.ok) throw new Error('Erro ao carregar interesses');
                    return res.json();
                })
                .then(function (interests) {
                    selectInteresse.innerHTML = '<option value="">-- Selecione um interesse --</option>';

                    interests.forEach(function (interest) {
                        const option = document.createElement('option');
                        option.value = interest.idInterest !== undefined
                            ? interest.idInterest
                            : interest.id;
                        option.textContent = interest.name;
                        selectInteresse.appendChild(option);
                    });

                    if (interests.length === 0) {
                        selectInteresse.innerHTML = '<option value="">Nenhum interesse nesta categoria</option>';
                        selectInteresse.disabled = true;
                    } else {
                        selectInteresse.disabled = false;
                    }
                })
                .catch(function () {
                    selectInteresse.innerHTML = '<option value="">Erro ao carregar interesses</option>';
                    selectInteresse.disabled = true;
                });
        });

        selectInteresse.addEventListener('change', function () {
            if (hiddenInterestId) hiddenInterestId.value = this.value;

            if (resumoInteresse) {
                const option = this.options[this.selectedIndex];
                resumoInteresse.textContent = option && option.value ? option.text : '—';
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

    /*
       DATA / HORA
    */

    function configurarDataHora() {
        if (!inputData || !inputHora) return;

        const hoje = new Date();
        const dd   = String(hoje.getDate()).padStart(2, '0');
        const mm   = String(hoje.getMonth() + 1).padStart(2, '0');
        const yyyy = hoje.getFullYear();
        inputData.min = yyyy + '-' + mm + '-' + dd;

        inputData.addEventListener('change', sincronizarDataHora);
        inputHora.addEventListener('change', sincronizarDataHora);
    }

    function sincronizarDataHora() {
        const data = inputData ? inputData.value : '';
        const hora = inputHora ? inputHora.value : '';

        if (data && hora) {
            const partes   = data.split('-');
            const formatado = partes[2] + '/' + partes[1] + '/' + partes[0] + ' ' + hora;

            if (hiddenDataHora) hiddenDataHora.value = formatado;

            if (resumoDataHora) {
                resumoDataHora.textContent =
                    partes[2] + '/' + partes[1] + '/' + partes[0] + ' às ' + hora;
            }
        } else {
            if (hiddenDataHora) hiddenDataHora.value = '';
            if (resumoDataHora) resumoDataHora.textContent = '—';
        }
    }

    /*
       DISPONIBILIDADE
    */

    function carregarDisponibilidade() {
        if (!availabilityInfo || !teacherId) return;

        const url =
            contextPath +
            '/autenticado/meeting/register' +
            '?action=mentorSlots&teacherId=' +
            encodeURIComponent(teacherId);

        fetch(url)
            .then(function (res) {
                if (!res.ok) throw new Error('Erro ao carregar disponibilidade');
                return res.json();
            })
            .then(renderizarDisponibilidade)
            .catch(function () {
                availabilityInfo.innerHTML =
                    '<span class="text-sm text-gray-400 italic">' +
                    'Não foi possível carregar a disponibilidade.' +
                    '</span>';
            });
    }

    function renderizarDisponibilidade(slots) {
        if (!availabilityInfo) return;

        if (!slots || slots.length === 0) {
            availabilityInfo.innerHTML =
                '<span class="text-sm text-gray-400 italic">' +
                'Este professor ainda não cadastrou disponibilidade.' +
                '</span>';
            return;
        }

        const porDia = {};
        slots.forEach(function (slot) {
            const dia = slot.dayLabel || slot.day;
            if (!porDia[dia]) porDia[dia] = [];
            porDia[dia].push(fmtHora(slot.start) + ' – ' + fmtHora(slot.end));
        });

        let html = '<div class="flex flex-wrap gap-2">';
        Object.keys(porDia).forEach(function (dia) {
            porDia[dia].forEach(function (horario) {
                html +=
                    '<span class="inline-flex items-center gap-1.5 bg-violet-50 text-violet-800 text-xs font-semibold px-3 py-1 rounded-full">' +
                    '<strong>' + dia + '</strong>' +
                    '<span class="font-normal text-violet-600">' + horario + '</span>' +
                    '</span>';
            });
        });
        html += '</div>';

        availabilityInfo.innerHTML = html;
    }

    function fmtHora(timeStr) {
        if (!timeStr) return '';
        const partes = timeStr.split(':');
        return partes[0] + ':' + partes[1];
    }

    /*
       VALIDAÇÃO
    */

    function validarFormulario(e) {
        limparErros();
        let valido = true;

        const descricao = document.getElementById('descricao');
        if (!descricao || !descricao.value.trim()) {
            mostrarErro('erro-descricao', 'A descrição é obrigatória.');
            valido = false;
        }

        if (!hiddenDataHora || !hiddenDataHora.value) {
            mostrarErro('erro-dataHora', 'Selecione uma data e horário.');
            valido = false;
        }

        const duracao = getDuracaoSelecionada();
        if (![60, 90, 120].includes(duracao)) {
            mostrarErro('erro-duracao', 'Selecione uma duração.');
            valido = false;
        }

        const tipo = getTipo();

        if (tipo === 'online') {
            const link = document.getElementById('link');
            if (!link || !link.value.trim()) {
                mostrarErro('erro-link', 'Informe o link ou plataforma.');
                valido = false;
            }
        } else {
            const cidade = document.getElementById('cidade');
            const rua    = document.getElementById('rua');
            const numero = document.getElementById('numero');

            if (!cidade || !cidade.value.trim()) {
                mostrarErro('erro-presencial', 'Cidade é obrigatória.');
                valido = false;
            } else if (!rua || !rua.value.trim()) {
                mostrarErro('erro-presencial', 'Rua é obrigatória.');
                valido = false;
            } else if (!numero || !numero.value || parseInt(numero.value) <= 0) {
                mostrarErro('erro-presencial', 'Número inválido.');
                valido = false;
            }
        }

        if (!valido) e.preventDefault();
    }

    function mostrarErro(id, mensagem) {
        const el = document.getElementById(id);
        if (el) el.textContent = mensagem;
    }

    function limparErros() {
        document.querySelectorAll('[id^="erro-"]').forEach(function (el) {
            el.textContent = '';
        });
    }

    init();

})();


/*
   meetingList.js — funções de edição inline
   (mantidas no mesmo arquivo por compatibilidade com o carregamento do script)
   e principalmente PQ A GNT GOSTA É DA BAGUNÇAAAAAA
 */

function toggleEdit(button, meetingId, currentStatus, meetingType) {
    const card      = button.closest('.meeting-card');
    const panel     = card.querySelector('.editPanel');
    const isHidden  = panel.classList.contains('hidden');

    if (!isHidden) {
        panel.classList.add('hidden');
        return;
    }

    card.querySelector('.editId').value         = meetingId;
    card.querySelector('.edit-descricao').value = '';
    card.querySelector('.edit-dataHora').value  = '';

    const statusSelect = panel.querySelector("select[name='status']");
    if (statusSelect) statusSelect.value = currentStatus;

    const locationFields = card.querySelector('.camposLocalizacao');
    if (locationFields) {
        if (meetingType === 'PRESENCIAL') {
            locationFields.classList.remove('hidden');
        } else {
            locationFields.classList.add('hidden');
        }
    }

    panel.classList.remove('hidden');
}

function validateEditForm(form, event) {
    clearEditErrors(form);
    let valid = true;

    const descricao = form.querySelector('.edit-descricao');
    if (!descricao.value.trim()) {
        showEditError(form, '.edit-erro-descricao', 'Descrição é obrigatória.');
        valid = false;
    }

    const dataHora = form.querySelector('.edit-dataHora');
    if (!dataHora.value.trim()) {
        showEditError(form, '.edit-erro-dataHora', 'Data e hora são obrigatórias.');
        valid = false;
    }

    const locationFields = form.querySelector('.camposLocalizacao');
    if (locationFields && !locationFields.classList.contains('hidden')) {
        const cidade = form.querySelector('.edit-cidade');
        const rua    = form.querySelector('.edit-rua');
        const numero = form.querySelector('.edit-numero');
        if (!cidade.value.trim()) { showEditError(form, '.edit-erro-cidade',  'Cidade é obrigatória.'); valid = false; }
        if (!rua.value.trim())    { showEditError(form, '.edit-erro-rua',     'Rua é obrigatória.');    valid = false; }
        if (!numero.value || numero.value <= 0) { showEditError(form, '.edit-erro-numero', 'Número inválido.'); valid = false; }
    }

    if (!valid) event.preventDefault();
    return valid;
}

function showEditError(form, selector, msg) {
    const el = form.querySelector(selector);
    if (el) el.textContent = msg;
}

function clearEditErrors(form) {
    form.querySelectorAll('[class*="edit-erro"]').forEach(function (el) {
        el.textContent = '';
    });
}
