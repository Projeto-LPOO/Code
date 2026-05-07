<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Lista de Interesses</title>

    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>

<body class="bg-white min-h-screen px-6 py-10">
<main class="w-full max-w-screen-2xl mx-auto">

    <div class="bg-white rounded-3xl shadow-sm overflow-hidden">

        <!-- Conteúdo -->
        <div class="px-8 py-10">

            <!-- Título -->
            <div class="text-center mb-10">

                <h2 class="text-4xl font-bold text-gray-800 mb-3">
                    Bem-vindo ao Aura
                </h2>
                <p class="text-gray-800 mb-3">
                    Vamos personalizar sua experiência para encontrar a combinação perfeita de conhecimento.
                </p>

            </div>

            <!-- Steps -->
            <div class="flex items-center justify-center gap-16 mb-12">

                <div class="flex flex-col items-center">
                        <div class="w-8 h-8 rounded-full bg-purple-600 text-white flex items-center justify-center text-sm font-semibold">
                            1
                        </div>

                        <span class="text-sm text-purple-600 mt-2 font-medium">
                            Learn
                        </span>
                </div>

                <div class="flex flex-col items-center opacity-50">
                        <div class="w-8 h-8 rounded-full bg-gray-300 text-gray-700 flex items-center justify-center text-sm font-semibold">
                            2
                        </div>

                        <span class="text-sm mt-2">
                            Skills
                        </span>
                </div>

            </div>
            <!-- Card -->
            <div class="w-full border border-gray-200 rounded-3xl p-8 bg-white">

                <div class="mb-8">

                    <h3 class="text-2xl font-semibold text-gray-800">
                        What interests you?
                    </h3>

                    <p class="text-gray-500 text-sm mt-2">
                        Select at least 3 categories to personalize your feed.
                    </p>

                </div>

                <form action="${pageContext.request.contextPath}/autenticado/interest/learn"
                      method="post">

                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">

                        <c:forEach var="category" items="${categories}">

                            <label class="cursor-pointer">

                                <div class="
                                    border border-gray-200 rounded-2xl p-6
                                    hover:border-purple-400 hover:shadow-sm
                                    transition duration-200
                                ">

                                    <div class="flex flex-col items-center text-center">

                                        <img
                                                src="${pageContext.request.contextPath}/${category.imgUrl}"
                                                class="w-14 h-14 object-contain mb-4"
                                        >

                                        <h2 class="font-semibold text-gray-800 mb-5">
                                                ${category.name}
                                        </h2>

                                        <!-- INTERESSES -->
                                        <div class="flex flex-wrap gap-2 justify-center">

                                            <c:forEach var="inter"
                                                       items="${interestsByCategory[category.id]}">

                                                <label class="cursor-pointer">

                                                    <input
                                                            type="checkbox"
                                                            name="interests"
                                                            value="${inter.id}"
                                                            class="peer hidden"
                                                    >

                                                    <div class="
                            px-3 py-2 rounded-full text-sm
                            border border-gray-200
                            bg-gray-50 text-gray-700
                            transition duration-200

                            hover:border-purple-400
                            hover:bg-purple-50

                            peer-checked:bg-purple-600
                            peer-checked:text-white
                            peer-checked:border-purple-600
                        ">
                                                            ${inter.name}
                                                    </div>

                                                </label>

                                            </c:forEach>

                                        </div>

                                    </div>

                                </div>

                            </label>

                        </c:forEach>

                    </div>

                    <!-- Footer -->
                    <div class="flex items-center justify-between mt-10">

                        <div class="flex items-center gap-5">

                            <button type="submit"
                                    class="bg-purple-600 hover:bg-purple-700 transition text-white px-6 py-3 rounded-xl font-medium">
                                Next
                            </button>

                        </div>

                    </div>

                </form>

            </div>

        </div>

    </div>

</main>

</body>
</html>