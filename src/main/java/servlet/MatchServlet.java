package servlet;

import dao.MatchDAO;

import dao.TournoiDAO;
import dao.EquipeDAO;
import dao.ClassementDAO;
import model.Utilisateur;
import model.Tournoi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;

@WebServlet("/matchs")

public class MatchServlet extends HttpServlet {

    private final MatchDAO matchDAO = new MatchDAO();
    private final TournoiDAO tournoiDAO = new TournoiDAO();
    private final EquipeDAO equipeDAO = new EquipeDAO();
    private final ClassementDAO clDAO = new ClassementDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = (Utilisateur) req.getSession().getAttribute("utilisateur");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        if (action == null) action = "liste";

        switch (action) {
            case "score":
                int idS = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("match", matchDAO.trouverParId(idS));
                req.getRequestDispatcher("/match_score.jsp").forward(req, resp);
                break;
            default:
                String param = req.getParameter("tournoiId");
                if (param == null) {
                    resp.sendRedirect(req.getContextPath() + "/tournois");
                    return;
                }
                int tournoiId = Integer.parseInt(param);
                req.setAttribute("matchs", matchDAO.listerParTournoi(tournoiId));
                req.setAttribute("tournoi", tournoiDAO.trouverParId(tournoiId));
                req.getRequestDispatcher("/matchs.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = (Utilisateur) req.getSession().getAttribute("utilisateur");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        int matchId = Integer.parseInt(req.getParameter("match_id"));
        int score1 = Integer.parseInt(req.getParameter("score1"));
        int score2 = Integer.parseInt(req.getParameter("score2"));
        int tournoiId = Integer.parseInt(req.getParameter("tournoi_id"));
        boolean prol = "on".equals(req.getParameter("prolongation"));
        boolean tab = "on".equals(req.getParameter("tirs_au_but"));

        matchDAO.saisirScore(matchId, score1, score2, prol, tab);

        Tournoi t = tournoiDAO.trouverParId(tournoiId);
        if ("CHAMPIONNAT".equals(t.getType())) {
            clDAO.recalculer(tournoiId, t);
        }
        resp.sendRedirect(req.getContextPath() + "/tournois?action=detail&id=" + tournoiId);
    }
}