const searchInput = document.getElementById("search-input");
const result = document.getElementById("result");

const loggedUserId = document.body.dataset.userid;
const contextPath = document.body.dataset.context;

function search() {

    const term = searchInput.value;

    const url = term
        ? `${contextPath}/autenticado/users/search?name=${term}`
        : `${contextPath}/autenticado/users/search?name=`;

    fetch(url)
        .then(response => response.json())

        .then(data => {

            result.innerHTML = "";

            if (data.length === 0) {

                result.innerHTML = `
                    <div class="col-span-full
                                flex flex-col items-center justify-center
                                py-20
                                text-center">

                        <div class="w-20 h-20
                                    rounded-3xl
                                    bg-slate-100
                                    flex items-center justify-center
                                    mb-5">

                            <svg xmlns="http://www.w3.org/2000/svg"
                                 fill="none"
                                 viewBox="0 0 24 24"
                                 stroke-width="1.5"
                                 stroke="currentColor"
                                 class="w-9 h-9 text-slate-400">

                                <path stroke-linecap="round"
                                      stroke-linejoin="round"
                                      d="m15.75 15.75-2.489-2.489m0 0a3.375 3.375 0 1 0-4.773-4.773 3.375 3.375 0 0 0 4.773 4.773Z" />
                            </svg>

                        </div>

                        <h2 class="text-lg font-semibold text-slate-700 mb-2">
                            Nenhum usuário encontrado
                        </h2>

                        <p class="text-sm text-slate-400">
                            Tente pesquisar com outro nome.
                        </p>

                    </div>
                `;

                return;
            }

            data.forEach(user_ => {

                if (user_.id != loggedUserId) {

                    let interestsList = "";

                    if (user_.interests && user_.interests.length > 0) {

                        user_.interests.forEach((interest, index) => {

                            const colors = [
                                "bg-indigo-50 border-indigo-100 text-indigo-600",
                                "bg-violet-50 border-violet-100 text-violet-600",
                                "bg-sky-50 border-sky-100 text-sky-600",
                                "bg-pink-50 border-pink-100 text-pink-600"
                            ];

                            const color = colors[index % colors.length];

                            interestsList += `
                                <span class="px-3 py-1
                                             rounded-full
                                             border
                                             text-[11px]
                                             font-semibold
                                             ${color}">
                                    ${interest.name}
                                </span>
                            `;
                        });

                    } else {

                        interestsList = `
                            <span class="text-xs italic text-slate-400">
                                Nenhum interesse cadastrado
                            </span>
                        `;
                    }

                    const initials = user_.name
                        .split(" ")
                        .map(n => n[0])
                        .join("")
                        .substring(0, 2)
                        .toUpperCase();

                    const card = document.createElement("div");

                    card.className = `
                        group
                        bg-white
                        border border-slate-200
                        rounded-3xl
                        p-5
                        min-h-[230px]
                        flex flex-col
                        justify-between
                        shadow-sm
                        hover:shadow-2xl
                        hover:-translate-y-1.5
                        hover:border-indigo-300
                        transition-all duration-300
                        cursor-pointer
                        relative
                        overflow-hidden
                    `;

                    card.onclick = function () {
                        window.location.href =
                            `${contextPath}/autenticado/users/profile?id=${user_.id}`;
                    };

                    card.innerHTML = `

                        <!-- glow -->
                        <div class="absolute
                                    top-0 right-0
                                    w-32 h-32
                                    bg-indigo-100/40
                                    blur-3xl
                                    rounded-full
                                    translate-x-10 -translate-y-10
                                    group-hover:bg-indigo-200/50
                                    transition-all duration-500">
                        </div>

                        <!-- topo -->
                        <div class="relative z-10">

                            <div class="flex items-start justify-between gap-4">

                                <div class="flex gap-4">

                                    <!-- avatar -->
                                    <div class="w-14 h-14
                                                rounded-2xl
                                                bg-gradient-to-br
                                                from-indigo-500
                                                to-violet-500
                                                text-white
                                                flex items-center justify-center
                                                font-bold text-lg
                                                shadow-lg
                                                shrink-0">

                                        ${initials}

                                    </div>

                                    <!-- infos -->
                                    <div>

                                        <h2 class="text-lg font-semibold text-slate-800 leading-tight">
                                            ${user_.name}
                                        </h2>

                                        <p class="text-sm text-slate-400 mt-1">
                                            Usuário da plataforma
                                        </p>

                                    </div>

                                </div>

                                <!-- badge -->
                                <div class="px-3 py-1
                                            rounded-xl
                                            bg-indigo-500
                                            text-white
                                            text-[10px]
                                            font-bold
                                            uppercase
                                            tracking-wide
                                            shadow-md">

                                    Perfil

                                </div>

                            </div>

                            <!-- detalhes -->
                            <div class="mt-6 space-y-3">

                                <div class="flex items-center gap-2 text-sm text-slate-600">

                                    <span class="font-semibold text-slate-800">
                                        Idade:
                                    </span>

                                    <span>
                                        ${user_.age}
                                    </span>

                                </div>

                                <div class="flex items-start gap-2 text-sm text-slate-600">

                                    <span class="font-semibold text-slate-800">
                                        Endereço:
                                    </span>

                                    <span class="line-clamp-2">
                                        ${user_.address}
                                    </span>

                                </div>

                            </div>

                        </div>

                        <!-- interesses -->
                        <div class="relative z-10 mt-6">

                            <p class="text-[11px]
                                      uppercase
                                      tracking-wider
                                      font-bold
                                      text-slate-400
                                      mb-3">

                                Interesses

                            </p>

                            <div class="flex flex-wrap gap-2">

                                ${interestsList}

                            </div>

                        </div>
                    `;

                    result.appendChild(card);
                }
            });
        })

        .catch(error => {

            console.error("Erro:", error);

            result.innerHTML = `
                <div class="col-span-full
                            bg-red-50
                            border border-red-200
                            text-red-600
                            rounded-2xl
                            p-5
                            text-sm">

                    Ocorreu um erro ao carregar os usuários.

                </div>
            `;
        });
}

searchInput.addEventListener("input", search);

window.onload = search;