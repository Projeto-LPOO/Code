function toggleEdit(button, meetingId, currentStatus, meetingType) {
    const card = button.closest(".meeting-card");
    const panel = card.querySelector(".editPanel");
    const isVisible = panel.style.display !== "none";

    if (isVisible) {
        panel.style.display = "none";
        return;
    }

    card.querySelector(".editId").value = meetingId;
    card.querySelector(".edit-descricao").value = "";
    card.querySelector(".edit-dataHora").value = "";

    const statusSelect = panel.querySelector("select[name='status']");
    if (statusSelect) {
        statusSelect.value = currentStatus;
    }

    const locationFields = card.querySelector(".camposLocalizacao");
    if (locationFields) {
        locationFields.style.display = (meetingType === "PRESENCIAL") ? "block" : "none";
    }

    panel.style.display = "block";
}

function validateEditForm(form, event) {
    clearEditErrors(form);
    let valid = true;

    const descricao = form.querySelector(".edit-descricao");
    if (!descricao.value.trim()) {
        showEditError(form, ".edit-erro-descricao", "Descrição é obrigatória.");
        valid = false;
    }

    const dataHora = form.querySelector(".edit-dataHora");
    if (!dataHora.value.trim()) {
        showEditError(form, ".edit-erro-dataHora", "Data e hora são obrigatórias.");
        valid = false;
    }

    const locationFields = form.querySelector(".camposLocalizacao");
    if (locationFields && locationFields.style.display !== "none") {
        const cidade = form.querySelector(".edit-cidade");
        const rua = form.querySelector(".edit-rua");
        const numero = form.querySelector(".edit-numero");
        if (!cidade.value.trim()) { showEditError(form, ".edit-erro-cidade", "Cidade é obrigatória."); valid = false; }
        if (!rua.value.trim()) { showEditError(form, ".edit-erro-rua", "Rua é obrigatória.");    valid = false; }
        if (!numero.value || numero.value <= 0) { showEditError(form, ".edit-erro-numero", "Número inválido."); valid = false; }
    }

    if (!valid) event.preventDefault();
    return valid;
}

function showEditError(form, selector, msg) {
    const el = form.querySelector(selector);
    if (el) el.textContent = msg;
}

function clearEditErrors(form) {
    form.querySelectorAll(".erro-campo").forEach(el => el.textContent = "");
}