const searchInput = document.getElementById("search-input");
const result = document.getElementById("result");

const loggedUserId = document.body.dataset.userid;
const contextPath = document.body.dataset.context;

function search() {
    const term = searchInput.value;

    const url = term
        ? contextPath + "/autenticado/users/search?name=" + term
        : contextPath + "/autenticado/users/search?name=";

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
                            interestsList += "<span>" + interest.name + "</span> ";
                        });
                    } else {
                        interestsList = "Nenhum interesse cadastrado";
                    }

                    result.innerHTML +=
                        "<div class='user-card'>" +
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