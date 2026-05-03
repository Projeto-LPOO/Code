const contextPath = document.body.dataset.context;

function toggleCadastro() {
    const tipo = document.getElementById('tipoSelectCadastro').value;
    document.getElementById('cadastroOnline').style.display = tipo === 'online' ? 'block' : 'none';
    document.getElementById('cadastroPresencial').style.display = tipo === 'presencial' ? 'block' : 'none';
}


const buscaInput = document.getElementById('buscaUsuario');
const resultadoDiv = document.getElementById('resultadoUsuarios');

buscaInput.addEventListener('input',function () {
    const termo = this.value.trim();

    if (termo.length === 0) {
        resultadoDiv.style.display = 'none';
        resultadoDiv.innerHTML = '';
        return;
    }

    fetch(contextPath + '/autenticado/users/search?name=' + encodeURIComponent(termo))
        .then(res => res.json())
        .then(usuarios => {
            resultadoDiv.innerHTML = '';

            if (usuarios.length === 0) {
                resultadoDiv.innerHTML = '<p style="padding:8px;">Nenhum usuário encontrado.</p>';
                resultadoDiv.style.display = 'block';
                return;
            }

            usuarios.forEach(u => {
                const item = document.createElement('div');
                item.style.cssText = 'padding:8px; cursor:pointer; border-bottom:1px solid #eee;';
                item.textContent = u.name + (u.age ? ' — ' + u.age + ' anos' : '');

                item.addEventListener('mouseover',() => item.style.background = '#f0f0f0');
                item.addEventListener('mouseout',() => item.style.background = '');

                item.addEventListener('click', () => selecionarUsuario(u.id, u.name));
                resultadoDiv.appendChild(item);
            });

            resultadoDiv.style.display = 'block';
        })
        .catch(err => console.error('Erro ao buscar usuários:', err));
});

function selecionarUsuario(id, nome) {
    document.getElementById('usuarioId').value = id;
    document.getElementById('usuarioSelecionadoNome').textContent = nome;
    document.getElementById('usuarioSelecionadoLabel').style.display = 'block';
    resultadoDiv.style.display = 'none';
    buscaInput.value = '';
}

function limparUsuario() {
    document.getElementById('usuarioId').value = '';
    document.getElementById('usuarioSelecionadoNome').textContent = '';
    document.getElementById('usuarioSelecionadoLabel').style.display = 'none';
}

// Fecha quando clicar fora
document.addEventListener('click', function (e) {
    if (!buscaInput.contains(e.target) && !resultadoDiv.contains(e.target)) {
        resultadoDiv.style.display = 'none';
    }
});


function validarCadastro(e) {
    let valido = true;

    limparErros(['erro-descricao', 'erro-dataHora', 'erro-link',
        'erro-cidade', 'erro-rua', 'erro-numero', 'erro-geral']);

    const tipo = document.getElementById('tipoSelectCadastro').value;
    const descricao = document.getElementById('descricao').value.trim();
    const dataHora = document.getElementById('dataHora').value.trim();

    if (!descricao) {
        mostrarErro('erro-descricao', 'Descrição é obrigatória.');
        valido = false;
    }

    if (!validarFormatoData(dataHora)) {
        mostrarErro('erro-dataHora', 'Use o formato dd/MM/yyyy HH:mm.');
        valido = false;
    } else if (dataNoPassado(dataHora)) {
        mostrarErro('erro-dataHora', 'A data não pode ser no passado.');
        valido = false;
    }

    if (tipo === 'online') {
        const link = document.getElementById('link').value.trim();
        if (!link) {
            mostrarErro('erro-link', 'Link/Plataforma é obrigatório para meeting online.');
            valido = false;
        }
    }

    if (tipo === 'presencial') {
        const cidade = document.getElementById('cidade').value.trim();
        const rua = document.getElementById('rua').value.trim();
        const numero = document.getElementById('numero').value.trim();

        if (!cidade) { mostrarErro('erro-cidade', 'Cidade é obrigatória.'); valido = false; }
        if (!rua) { mostrarErro('erro-rua','Rua é obrigatória.');    valido = false; }
        if (!numero || isNaN(numero) || parseInt(numero) <= 0) {
            mostrarErro('erro-numero', 'Número inválido.');
            valido = false;
        }
    }

    if (!valido) e.preventDefault();
    return valido;
}


function validarEdicao(form, e) {
    let valido = true;

    // Limpa erros
    form.querySelectorAll('.erro-campo').forEach(el => el.textContent = '');

    const descricao = form.querySelector('.edit-descricao').value.trim();
    const dataHora = form.querySelector('.edit-dataHora').value.trim();

    if (!descricao) {
        form.querySelector('.edit-erro-descricao').textContent = 'Descrição é obrigatória.';
        valido = false;
    }

    if (!validarFormatoData(dataHora)) {
        form.querySelector('.edit-erro-dataHora').textContent = 'Use o formato dd/MM/yyyy HH:mm.';
        valido = false;
    }

    const locDiv = form.querySelector('.camposLocalizacao');
    if (locDiv.style.display === 'block') {
        const cidade = form.querySelector('.edit-cidade').value.trim();
        const rua = form.querySelector('.edit-rua').value.trim();
        const numero = form.querySelector('.edit-numero').value.trim();

        if (!cidade) { form.querySelector('.edit-erro-cidade').textContent = 'Cidade é obrigatória.'; valido = false; }
        if (!rua) { form.querySelector('.edit-erro-rua').textContent = 'Rua é obrigatória.';    valido = false; }
        if (!numero || isNaN(numero) || parseInt(numero) <= 0) {
            form.querySelector('.edit-erro-numero').textContent = 'Número inválido.';
            valido = false;
        }
    }

    if (!valido) e.preventDefault();
    return valido;
}


function toggleEdit(btn, id, status, tipo) {
    const card  = btn.closest('div');
    const panel = card.querySelector('.editPanel');

    if (panel.style.display === 'block') {
        panel.style.display = 'none';
        return;
    }

    panel.querySelector('.editId').value = id;

    const statusSelect = panel.querySelector('select[name="status"]');
    Array.from(statusSelect.options).forEach(opt => {
        opt.selected = opt.value === status;
    });

    const locDiv = panel.querySelector('.camposLocalizacao');
    locDiv.style.display = tipo === 'PRESENCIAL' ? 'block' : 'none';

    panel.style.display = 'block';
}


function validarFormatoData(str) {
    if (!str) return false;
    const regex = /^\d{2}\/\d{2}\/\d{4} \d{2}:\d{2}$/;
    if (!regex.test(str)) return false;

    const [datePart, timePart] = str.split(' ');
    const [dd, mm, yyyy] = datePart.split('/').map(Number);
    const [hh, min] = timePart.split(':').map(Number);

    const d = new Date(yyyy, mm - 1, dd, hh, min);
    return d.getDate() === dd && d.getMonth() === mm - 1 &&
        d.getFullYear() === yyyy && hh < 24 && min < 60;
}

function dataNoPassado(str) {
    const [datePart, timePart] = str.split(' ');
    const [dd, mm, yyyy] = datePart.split('/').map(Number);
    const [hh, min] = timePart.split(':').map(Number);
    return new Date(yyyy, mm - 1, dd, hh, min) < new Date();
}

function mostrarErro(id, msg) {
    const el = document.getElementById(id);
    if (el) el.textContent = msg;
}

function limparErros(ids) {
    ids.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.textContent = '';
    });
}