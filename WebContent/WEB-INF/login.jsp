<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Login</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        body {
            background: linear-gradient(135deg, #f5f3ff, #ffffff);
        }
    </style>
</head>

<body class="min-h-screen flex items-center justify-center">

<div class="w-full max-w-lg">

    <!-- Card -->
    <div class="bg-white shadow-xl rounded-2xl p-10 border border-gray-100">

        <!-- Logo -->
        <div class="flex flex-col items-center mb-6">
            <img
                    src="${pageContext.request.contextPath}/assets/img/logos/logo-horizontal.png"
                    class="h-12 object-contain">
            <p class="text-gray-500 text-sm mt-2">Bem-vindo de volta!</p>
        </div>

        <form action="" method="post" class="space-y-5">

            <!-- Email -->
            <div>
                <label class="text-sm text-gray-600">Email Address</label>
                <input
                        type="text"
                        name="email"
                        placeholder="alex@example.com"
                        class="w-full mt-1 px-4 py-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
                />
            </div>

            <!-- Password -->
            <div>
                <div class="flex justify-between items-center">
                    <label class="text-sm text-gray-600">Password</label>
                    <a href="#" class="text-xs text-purple-600 hover:underline">Forgot password?</a>
                </div>

                <input
                        type="password"
                        name="password"
                        class="w-full mt-1 px-4 py-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
                />
            </div>

            <!-- Button -->
            <button
                    type="submit"
                    class="w-full py-3 rounded-lg text-white font-medium
                           bg-gradient-to-r from-purple-600 to-purple-800
                           hover:opacity-90 transition"
            >
                Log in →
            </button>

        </form>

        <!-- Footer -->
        <p class="text-center text-sm text-gray-500 mt-6">
            Ainda não possui uma conta?
            <a href="${pageContext.request.contextPath}/register"
               class="text-purple-600 font-medium hover:underline">
                Criar conta
            </a>
        </p>

        <p class="text-center text-xs text-gray-400 mt-4">
            “1 hour of teaching = 60 Saber Credits. Learning made accessible for everyone.”
        </p>

    </div>
</div>

</body>
</html>