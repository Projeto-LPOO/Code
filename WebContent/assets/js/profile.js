/*document.addEventListener("DOMContentLoaded", () => {
    const profileTab = document.getElementById('profileTab');
    const reviewTab = document.getElementById('reviewTab');

    const profileSection = document.getElementById('profileSection');
    const reviewSection = document.getElementById('reviewSection');

    // Classes exatas do roxo do seu sistema para a aba ativa
    const activeTabClass = "flex-1 py-4 text-center text-sm font-semibold border-b-2 border-violet-700 text-violet-700 transition cursor-pointer";
    // Classes para a aba inativa
    const inactiveTabClass = "flex-1 py-4 text-center text-sm font-medium text-slate-400 hover:text-slate-600 bg-slate-50/50 transition cursor-pointer";

    if (profileTab && reviewTab && profileSection && reviewSection) {

        // Alternar para Perfil & Skills
        profileTab.addEventListener('click', () => {
            profileTab.className = activeTabClass;
            reviewTab.className = inactiveTabClass;

            profileSection.classList.remove('hidden');
            profileSection.classList.add('block');

            reviewSection.classList.remove('block');
            reviewSection.classList.add('hidden');
        });

        // Alternar para Avaliações
        reviewTab.addEventListener('click', () => {
            reviewTab.className = activeTabClass;
            profileTab.className = inactiveTabClass;

            reviewSection.classList.remove('hidden');
            reviewSection.classList.add('block');

            profileSection.classList.remove('block');
            profileSection.classList.add('hidden');
        });
    }
});