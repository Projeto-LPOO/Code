const searchInput = document.getElementById("search-input");
const result = document.getElementById("result");

const loggedUserId = document.body.dataset.userid;
const contextPath = document.body.dataset.context;

function search() {
    const term = searchInput.value;
    const url = contextPath + "/autenticado/users/search?name=" + encodeURIComponent(term);

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

                    result.innerHTML +=
                        "<div class='user-card' style='cursor:pointer;' onclick=\"window.location='" +
                        contextPath + "/autenticado/meeting/register?teacherId=" + user_.id + "'\">" +
                        "<p>Name: " + user_.name + "</p>" +
                        "<p>Age: " + user_.age + "</p>" +
                        "<p>Address: " + user_.address + "</p>" +
                        "<p>Interesses: " + interestsList + "</p>" +
                        "</div>";
                }
            });
        })
        .catch(error => {
            console.error("Erro:", error);
        });
}

searchInput.addEventListener("input", search);
window.onload = search;