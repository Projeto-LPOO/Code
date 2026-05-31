package com.aura.shared.filter;

import com.aura.user.models.Admin;
import com.aura.user.models.CommercialUser;
import com.aura.user.models.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/autenticado/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest servletRequest,
            ServletResponse servletResponse,
            FilterChain filterChain
    )
            throws IOException, ServletException {

        HttpServletRequest request =
                (HttpServletRequest) servletRequest;

        HttpServletResponse response =
                (HttpServletResponse) servletResponse;

        HttpSession session =
                request.getSession(false);

        // NÃO LOGADO
        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/"
            );

            return;
        }

        User user =
                (User) session.getAttribute("user");

        String uri =
                request.getRequestURI();

        // ADMIN
        if (uri.startsWith(
                request.getContextPath()
                        + "/autenticado/admin")
                && !(user instanceof Admin)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Acesso negado."
            );

            return;
        }

        // COMMERCIAL USER
        if (!uri.startsWith(
                request.getContextPath()
                        + "/autenticado/admin")
                && !(user instanceof CommercialUser)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Acesso negado."
            );

            return;
        }

        // NO CACHE
        response.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate"
        );

        response.setHeader(
                "Pragma",
                "no-cache"
        );

        response.setHeader(
                "Expires",
                "0"
        );

        filterChain.doFilter(
                request,
                response
        );
    }
}