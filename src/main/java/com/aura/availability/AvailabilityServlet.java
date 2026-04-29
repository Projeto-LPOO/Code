package com.aura.availability;

import java.io.IOException;
import java.time.DayOfWeek;
import java.util.List;

import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AvailabilityServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private AvailabilityController controller = new AvailabilityController();
    private static final String VIEW_BASE = "/WEB-INF/views/autenticado/";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        int userId = user.getId();
        String acao = request.getParameter("acao");
        String idParam = request.getParameter("id");

        if ("remover".equals(acao) && idParam != null) {
            try {
                controller.RemoveAvailability(Integer.parseInt(idParam));
            } catch (Exception e) {
                request.setAttribute("erro", "Erro ao remover: " + e.getMessage());
            }
        }

        List<Availability> horarios = controller.findAllAvailability(userId);
        if (horarios != null) {
            horarios.sort((h1, h2) -> {
                int diaComp = h1.getDayWeek().compareTo(h2.getDayWeek());
                if (diaComp == 0) {
                    return h1.getHourStart().compareTo(h2.getHourStart());
                }
                return diaComp;
            });
        }

        request.setAttribute("horarios", horarios);
        forward(request, response, "availability.jsp");
       
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String acao = request.getParameter("acao");
        User user = (User) request.getSession().getAttribute("user");
        int userId = user.getId();

        try {
            if ("alternar".equals(acao)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Availability disp = controller.getById(id);
                if (disp != null) {
                    controller.ChangeStatus(id, !disp.isActive());
                }
            } 
            else if ("salvar".equals(acao)) {
                int dia = Integer.parseInt(request.getParameter("diaSemana"));
                String inicio = request.getParameter("inicio");
                String fim = request.getParameter("fim");
                controller.registerAvailability(userId, DayOfWeek.of(dia), inicio, fim);
            } 
            else if ("editar".equals(acao)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int dia = Integer.parseInt(request.getParameter("diaSemana"));
                String inicio = request.getParameter("inicio");
                String fim = request.getParameter("fim");
                controller.UpdateAvailability(id, userId, DayOfWeek.of(dia), inicio, fim);
            }
        } catch (Exception e) {
            request.setAttribute("erro", e.getMessage());
        }

        doGet(request, response);
    }
    private void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {

        req.getRequestDispatcher(VIEW_BASE + view)
                .forward(req, resp);
    }
}