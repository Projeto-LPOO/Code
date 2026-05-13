function showTab(name) {
    document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.add('hidden'));
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.remove('border-violet-600', 'text-violet-700');
        btn.classList.add('border-transparent', 'text-gray-500');
    });

    document.getElementById('pane-' + name).classList.remove('hidden');

    const activeBtn = document.getElementById('tab-' + name);
    activeBtn.classList.remove('border-transparent', 'text-gray-500');
    activeBtn.classList.add('border-violet-600', 'text-violet-700');
}

// mantém o estado da aba ao voltar da ação
(function () {
    const params = new URLSearchParams(window.location.search);
    const tab = params.get('tab');
    if (tab) {
        showTab(tab);
    }
})();