(function () {
    const contextPath = document.body.dataset.context;
    const preselectedSpan = document.getElementById("preselected-teacher-id");
    const teacherIdInput  = document.getElementById("teacherId");
    const typeSelect      = document.getElementById("tipoSelectCadastro");
    const onlineSection   = document.getElementById("cadastroOnline");
    const faceSection     = document.getElementById("cadastroPresencial");
    const categorySelect  = document.getElementById("selectCategoria");
    const interestSelect  = document.getElementById("selectInteresse");
    const interestHidden  = document.getElementById("interestIdHidden");
    const form            = document.getElementById("formCadastro");

    const teacherId = preselectedSpan ? preselectedSpan.dataset.value : "";

    function applyTypeToggle(type) {
        const isFace = type === "presencial";
        onlineSection.style.display = isFace ? "none" : "block";
        faceSection.style.display   = isFace ? "block" : "none";
    }

    typeSelect.addEventListener("change", function () {
        applyTypeToggle(this.value);
    });
    applyTypeToggle(typeSelect.value);

    if (teacherId) {
        loadMentorCategories(teacherId);
    }

    function loadMentorCategories(tid) {
        fetch(contextPath + "/autenticado/meeting/register?action=mentorCategories&teacherId=" + tid)
            .then(r => r.json())
            .then(categories => {
                categorySelect.innerHTML = "<option value=''>-- Selecione --</option>";
                categories.forEach(cat => {
                    const opt = document.createElement("option");
                    opt.value = cat.id;
                    opt.textContent = cat.name;
                    categorySelect.appendChild(opt);
                });
            })
            .catch(() => {
                categorySelect.innerHTML = "<option value=''>Erro ao carregar categorias</option>";
            });
    }

    categorySelect.addEventListener("change", function () {
        const categoryId = this.value;
        interestSelect.innerHTML = "<option value=''>-- Selecione --</option>";
        interestSelect.disabled = true;
        interestHidden.value = "";

        if (!categoryId || !teacherId) return;

        fetch(contextPath + "/autenticado/meeting/register?action=mentorInterests&teacherId=" + teacherId + "&categoryId=" + categoryId)
            .then(r => r.json())
            .then(interests => {
                if (interests.length === 0) {
                    interestSelect.innerHTML = "<option value=''>Nenhum conhecimento nesta categoria</option>";
                    return;
                }
                interestSelect.disabled = false;
                interests.forEach(i => {
                    const opt = document.createElement("option");
                    opt.value = i.idInterest !== undefined ? i.idInterest : i.id;
                    opt.textContent = i.name;
                    interestSelect.appendChild(opt);
                });
            })
            .catch(() => {
                interestSelect.innerHTML = "<option value=''>Erro ao carregar conhecimentos</option>";
            });
    });

    interestSelect.addEventListener("change", function () {
        interestHidden.value = this.value;
    });

    form.addEventListener("submit", function (e) {
        clearErrors();
        let valid = true;

        const descricao = document.getElementById("descricao");
        if (!descricao.value.trim()) {
            showError("erro-descricao", "Descrição é obrigatória.");
            valid = false;
        }

        const dataHora = document.getElementById("dataHora");
        if (!dataHora.value.trim()) {
            showError("erro-dataHora", "Data e hora são obrigatórias.");
            valid = false;
        }

        if (!teacherIdInput.value) {
            showError("erro-professor", "Selecione um professor na lista de usuários.");
            valid = false;
        }

        if (typeSelect.value === "online") {
            const link = document.getElementById("link");
            if (!link.value.trim()) {
                showError("erro-link", "Link/Plataforma é obrigatório.");
                valid = false;
            }
        } else {
            const cidade = document.getElementById("cidade");
            const rua    = document.getElementById("rua");
            const numero = document.getElementById("numero");
            if (!cidade.value.trim()) { showError("erro-cidade", "Cidade é obrigatória."); valid = false; }
            if (!rua.value.trim())    { showError("erro-rua",    "Rua é obrigatória.");    valid = false; }
            if (!numero.value || numero.value <= 0) { showError("erro-numero", "Número inválido."); valid = false; }
        }

        if (!valid) e.preventDefault();
    });

    function showError(id, msg) {
        const el = document.getElementById(id);
        if (el) el.textContent = msg;
    }

    function clearErrors() {
        document.querySelectorAll(".erro-campo").forEach(el => el.textContent = "");
    }
})();