document.addEventListener("DOMContentLoaded", () => {
    const profileTab = document.getElementById('profileTab');
    const reviewTab = document.getElementById('reviewTab');

    const profileSection = document.getElementById('profileSection');
    const reviewSection = document.getElementById('reviewSection');

    if (profileTab && reviewTab) {
        profileTab.addEventListener('click', () => {
            profileTab.className = "pb-3 text-sm font-semibold border-b-2 border-indigo-600 text-indigo-600 transition cursor-pointer";
            reviewTab.className = "pb-3 text-sm font-medium text-slate-400 hover:text-slate-600 transition cursor-pointer";

            profileSection.classList.remove('hidden');
            profileSection.classList.add('block');
            reviewSection.classList.remove('block');
            reviewSection.classList.add('hidden');
        });

        reviewTab.addEventListener('click', () => {
            reviewTab.className = "pb-3 text-sm font-semibold border-b-2 border-indigo-600 text-indigo-600 transition cursor-pointer";
            profileTab.className = "pb-3 text-sm font-medium text-slate-400 hover:text-slate-600 transition cursor-pointer";

            reviewSection.classList.remove('hidden');
            reviewSection.classList.add('block');
            profileSection.classList.remove('block');
            profileSection.classList.add('hidden');
        });
    }
});