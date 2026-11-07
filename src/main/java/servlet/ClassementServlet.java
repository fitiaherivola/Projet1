package servlet;

import dao.ClassementDAO;

import dao.TournoiDAO;
import model.Utilisateur;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;

@WebServlet("/classement")

public class ClassementServlet extends HttpServlet {

    private final ClassementDAO clDAO = new ClassementDAO();
    private final TournoiDAO tournoiDAO = new TournoiDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int tournoiId = Integer.parseInt(req.getParameter("tournoiId"));
        req.setAttribute("classement", clDAO.listerParTournoi(tournoiId));
        req.setAttribute("tournoi", tournoiDAO.trouverParId(tournoiId));
        req.getRequestDispatcher("/classement.jsp").forward(req, resp);
    }
}