package servlet;

import dao.EquipeDAO;

import dao.TournoiDAO;
import dao.ClassementDAO;
import model.Equipe;
import model.Utilisateur;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;

@WebServlet("/equipes")
public class EquipeServlet extends HttpServlet {

    private final EquipeDAO equipeDAO = new EquipeDAO();
    private final TournoiDAO tournoiDAO = new TournoiDAO();
    private final ClassementDAO clDAO = new ClassementDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = (Utilisateur) req.getSession().getAttribute("utilisateur");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        if (action == null) action = "liste";

        switch (action) {
            case "nouveau":
                req.setAttribute("tournois", tournoiDAO.listerTous());
                req.getRequestDispatcher("/equipe_form.jsp").forward(req, resp);
                break;
            case "editer":
                int idE = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("equipe", equipeDAO.trouverParId(idE));
                req.setAttribute("tournois", tournoiDAO.listerTous());
                req.getRequestDispatcher("/equipe_form.jsp").forward(req, resp);
                break;
            case "supprimer":
                equipeDAO.supprimer(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/equipes");
                break;
            default:
                req.setAttribute("equipes", equipeDAO.listerTous());
                req.getRequestDispatcher("/equipes.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = (Utilisateur) req.getSession().getAttribute("utilisateur");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String idStr = req.getParameter("id");
        Equipe e = new Equipe();
        e.setNom(req.getParameter("nom"));
        e.setContact(req.getParameter("contact"));
        e.setTournoiId(Integer.parseInt(req.getParameter("tournoi_id")));

        if (idStr != null && !idStr.isEmpty()) {
            e.setId(Integer.parseInt(idStr));
            equipeDAO.modifier(e);
        } else {
            equipeDAO.inserer(e);
            clDAO.initialiserClassement(e.getTournoiId(), e.getId());
        }
        resp.sendRedirect(req.getContextPath() + "/equipes");
    }
}