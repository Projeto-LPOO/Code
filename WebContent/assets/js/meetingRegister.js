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

        if (form) {
            form.addEventListener('submit', validarFormulario);
        }
    }

    /* =========================================================
       TIPO DE MEETING
    ========================================================== */

    function configurarTipo() {
        if (!tipoOptions) return;

        tipoOptions.querySelectorAll('.mr-tipo-opt').forEach(function (label) {

            label.addEventListener('click', function () {

                tipoOptions.querySelectorAll('.mr-tipo-opt').forEach(function (l) {
                    l.classList.remove('mr-tipo-selected');
                });

                label.classList.add('mr-tipo-selected');

                const radio = label.querySelector('input[type="radio"]');
                const tipo  = radio ? radio.value : 'online';

                atualizarCardsTipo(tipo);

                if (resumoTipo) {
                    resumoTipo.textContent =
                        tipo === 'presencial'
                            ? 'Presencial'
                            : 'Online';
                }
            });
        });
    }

    function getTipo() {
        if (!tipoOptions) return 'online';

        const checked = tipoOptions.querySelector(
            'input[type="radio"]:checked'
        );

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

    /* =========================================================
       CATEGORIA / INTERESSE
    ========================================================== */

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
            selectInteresse.innerHTML =
                '<option value="">Carregando...</option>';

            fetch(url)
                .then(function (res) {

                    if (!res.ok) {
                        throw new Error('Erro ao carregar interesses');
                    }

                    return res.json();
                })

                .then(function (interests) {

                    selectInteresse.innerHTML =
                        '<option value="">-- Selecione um interesse --</option>';

                    interests.forEach(function (interest) {

                        const option = document.createElement('option');

                        option.value =
                            interest.idInterest !== undefined
                                ? interest.idInterest
                                : interest.id;

                        option.textContent = interest.name;

                        selectInteresse.appendChild(option);
                    });

                    if (interests.length === 0) {

                        selectInteresse.innerHTML =
                            '<option value="">Nenhum interesse nesta categoria</option>';

                        selectInteresse.disabled = true;

                    } else {

                        selectInteresse.disabled = false;
                    }
                })

                .catch(function () {

                    selectInteresse.innerHTML =
                        '<option value="">Erro ao carregar interesses</option>';

                    selectInteresse.disabled = true;
                });
        });

        selectInteresse.addEventListener('change', function () {

            if (hiddenInterestId) {
                hiddenInterestId.value = this.value;
            }

            if (resumoInteresse) {

                const option = this.options[this.selectedIndex];

                resumoInteresse.textContent =
                    option && option.value
                        ? option.text
                        : '—';
            }
        });
    }

    function resetInteresse() {

        if (!selectInteresse) return;

        selectInteresse.innerHTML =
            '<option value="">-- Selecione primeiro a categoria --</option>';

        selectInteresse.disabled = true;

        if (hiddenInterestId) {
            hiddenInterestId.value = '';
        }

        if (resumoInteresse) {
            resumoInteresse.textContent = '—';
        }
    }

    /* =========================================================
       DATA / HORA
    ========================================================== */

    function configurarDataHora() {

        if (!inputData || !inputHora) return;

        const hoje = new Date();

        const dd =
            String(hoje.getDate()).padStart(2, '0');

        const mm =
            String(hoje.getMonth() + 1).padStart(2, '0');

        const yyyy =
            hoje.getFullYear();

        inputData.min = yyyy + '-' + mm + '-' + dd;

        inputData.addEventListener('change', sincronizarDataHora);
        inputHora.addEventListener('change', sincronizarDataHora);
    }

    function sincronizarDataHora() {

        const data = inputData ? inputData.value : '';
        const hora = inputHora ? inputHora.value : '';

        if (data && hora) {

            const partes = data.split('-');

            const formatado =
                partes[2] + '/' +
                partes[1] + '/' +
                partes[0] + ' ' +
                hora;

            if (hiddenDataHora) {
                hiddenDataHora.value = formatado;
            }

            if (resumoDataHora) {

                resumoDataHora.textContent =
                    partes[2] + '/' +
                    partes[1] + '/' +
                    partes[0] +
                    ' às ' +
                    hora;
            }

        } else {

            if (hiddenDataHora) {
                hiddenDataHora.value = '';
            }

            if (resumoDataHora) {
                resumoDataHora.textContent = '—';
            }
        }
    }

    /* =========================================================
       DISPONIBILIDADE
    ========================================================== */

    function carregarDisponibilidade() {

        if (!availabilityInfo || !teacherId) return;

        const url =
            contextPath +
            '/autenticado/meeting/register' +
            '?action=mentorSlots&teacherId=' +
            encodeURIComponent(teacherId);

        fetch(url)

            .then(function (res) {

                if (!res.ok) {
                    throw new Error('Erro ao carregar disponibilidade');
                }

                return res.json();
            })

            .then(renderizarDisponibilidade)

            .catch(function () {

                availabilityInfo.innerHTML =
                    '<span class="mr-avail-loading">' +
                    'Não foi possível carregar a disponibilidade.' +
                    '</span>';
            });
    }

    function renderizarDisponibilidade(slots) {

        if (!availabilityInfo) return;

        if (!slots || slots.length === 0) {

            availabilityInfo.innerHTML =
                '<span class="mr-avail-loading">' +
                'Este professor ainda não cadastrou disponibilidade.' +
                '</span>';

            return;
        }

        const porDia = {};

        slots.forEach(function (slot) {

            const dia =
                slot.dayLabel || slot.day;

            if (!porDia[dia]) {
                porDia[dia] = [];
            }

            porDia[dia].push(
                fmtHora(slot.start) +
                ' – ' +
                fmtHora(slot.end)
            );
        });

        let html = '<div class="mr-avail-wrap">';

        Object.keys(porDia).forEach(function (dia) {

            porDia[dia].forEach(function (horario) {

                html +=
                    '<span class="mr-avail-badge">' +
                    '<strong>' + dia + '</strong>' +
                    '<span class="mr-avail-time">' +
                    horario +
                    '</span>' +
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

    /* =========================================================
       VALIDAÇÃO
    ========================================================== */

    function validarFormulario(e) {

        limparErros();

        let valido = true;

        const descricao =
            document.getElementById('descricao');

        if (!descricao || !descricao.value.trim()) {

            mostrarErro(
                'erro-descricao',
                'A descrição é obrigatória.'
            );

            valido = false;
        }

        if (!hiddenDataHora || !hiddenDataHora.value) {

            mostrarErro(
                'erro-dataHora',
                'Selecione uma data e horário.'
            );

            valido = false;
        }

        const tipo = getTipo();

        if (tipo === 'online') {

            const link =
                document.getElementById('link');

            if (!link || !link.value.trim()) {

                mostrarErro(
                    'erro-link',
                    'Informe o link ou plataforma.'
                );

                valido = false;
            }

        } else {

            const cidade =
                document.getElementById('cidade');

            const rua =
                document.getElementById('rua');

            const numero =
                document.getElementById('numero');

            if (!cidade || !cidade.value.trim()) {

                mostrarErro(
                    'erro-presencial',
                    'Cidade é obrigatória.'
                );

                valido = false;

            } else if (!rua || !rua.value.trim()) {

                mostrarErro(
                    'erro-presencial',
                    'Rua é obrigatória.'
                );

                valido = false;

            } else if (
                !numero ||
                !numero.value ||
                parseInt(numero.value) <= 0
            ) {

                mostrarErro(
                    'erro-presencial',
                    'Número inválido.'
                );

                valido = false;
            }
        }

        if (!valido) {
            e.preventDefault();
        }
    }

    function mostrarErro(id, mensagem) {

        const elemento =
            document.getElementById(id);

        if (elemento) {
            elemento.textContent = mensagem;
        }
    }

    function limparErros() {

        document
            .querySelectorAll('.mr-erro')
            .forEach(function (elemento) {

                elemento.textContent = '';
            });
    }

    init();

})();