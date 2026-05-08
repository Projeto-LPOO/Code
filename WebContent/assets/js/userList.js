const searchInput = document.getElementById("search-input");
const result = document.getElementById("result");

const loggedUserId = document.body.dataset.userid;
const contextPath = document.body.dataset.context;

function search() {
    const term = searchInput.value;
    const url = term
        ? contextPath + "/users/search?name=" + term
        : contextPath + "/users/search?name=";

    fetch(url)
        .then(response => response.json())
        .then(data => {
            result.innerHTML = "";

            if (data.length === 0) {
                result.innerHTML = "<p>Nenhum usuário encontrado</p>";
                return;
            }

            data.forEach(user_ => {
                if (user_.id != loggedUserId) {
                    let interestsList = "";
                    if (user_.interests && user_.interests.length > 0) {
                        user_.interests.forEach(interest => {
                            interestsList += "<span class='interest-tag' style='background: #f1f5f9; padding: 2px 8px; border-radius: 4px; margin-right: 4px; font-size: 12px; color: #475569;'>" + interest.name + "</span> ";
                        });
                    } else {
                        interestsList = "<span style='color: #94a3b8; font-style: italic;'>Nenhum interesse cadastrado</span>";
                    }

                    // CRIAMOS O ELEMENTO DO CARD PARA PODER ADICIONAR O EVENTO DE CLIQUE
                    const card = document.createElement("div");
                    card.className = "user-card";
                    card.style.cursor = "pointer"; // Cursor de mãozinha para indicar que é clicável

                    // AÇÃO: AO CLICAR NO CARD, REDIRECIONA PARA O PERFIL
                    card.onclick = function() {
                        window.location.href = contextPath + "/users?action=profile&id=" + user_.id;
                    };

                    // CONTEÚDO DO CARD
                    card.innerHTML = `
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; width: 100%;">
                            <div style="flex: 1;">
                                <p style="margin: 0 0 8px 0;"><strong>Name:</strong> ${user_.name}</p>
                                <p style="margin: 0 0 4px 0; color: #64748b;"><strong>Age:</strong> ${user_.age}</p>
                                <p style="margin: 0 0 4px 0; color: #64748b;"><strong>Address:</strong> ${user_.address}</p>
                                <div style="margin-top: 12px;">
                                    <p style="margin: 0 0 4px 0; font-size: 12px; font-weight: bold; color: #94a3b8; text-transform: uppercase;">Interesses</p>
                                    <div style="display: flex; flex-wrap: wrap; gap: 4px;">${interestsList}</div>
                                </div>
                            </div>
                            
                            <div style="margin-left: 15px;">
                                <span style="background-color: #6366f1; color: white; padding: 6px 12px; border-radius: 6px; font-weight: bold; font-size: 11px; text-transform: uppercase; white-space: nowrap;">
                                   Perfil
                                </span>
                            </div>
                        </div>
                    `;

                    result.appendChild(card);
                }
            });
        })
        .catch(error => {
            console.error("Erro:", error);
        });
}

searchInput.addEventListener("input", search);
window.onload = search;