package servlet;

import dao.TournoiDAO;

import dao.EquipeDAO;
import dao.MatchDAO;
import dao.ClassementDAO;
import model.Tournoi;
import model.Equipe;
import model.Utilisateur;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.annotation.WebServlet;

@WebServlet("/tournois")

public class TournoiServlet extends HttpServlet {

    private final TournoiDAO tournoiDAO = new TournoiDAO();
    private final EquipeDAO equipeDAO = new EquipeDAO();
    private final MatchDAO matchDAO = new MatchDAO();
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
                req.getRequestDispatcher("/tournoi_form.jsp").forward(req, resp);
                break;
            case "editer":
                int idE = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("tournoi", tournoiDAO.trouverParId(idE));
                req.getRequestDispatcher("/tournoi_form.jsp").forward(req, resp);
                break;
            case "detail":
                int idD = Integer.parseInt(req.getParameter("id"));
                Tournoi t = tournoiDAO.trouverParId(idD);
                req.setAttribute("tournoi", t);
                req.setAttribute("equipes", equipeDAO.listerParTournoi(idD));
                req.setAttribute("matchs", matchDAO.listerParTournoi(idD));
                if ("CHAMPIONNAT".equals(t.getType())) {
                    req.setAttribute("classement", clDAO.listerParTournoi(idD));
                }
                req.getRequestDispatcher("/tournoi_detail.jsp").forward(req, resp);
                break;
            case "supprimer":
                int idS = Integer.parseInt(req.getParameter("id"));
                tournoiDAO.supprimer(idS);
                resp.sendRedirect(req.getContextPath() + "/tournois");
                break;
            case "genererMatchs":
                int idG = Integer.parseInt(req.getParameter("id"));
                Tournoi tG = tournoiDAO.trouverParId(idG);
                List<Equipe> equipes = equipeDAO.listerParTournoi(idG);
                if (equipes == null || equipes.size() < 2) {
                    req.getSession().setAttribute("msg", "Il faut au moins 2 équipes pour générer les matchs.");
                    resp.sendRedirect(req.getContextPath() + "/tournois?action=detail&id=" + idG);
                    return;
                }
                if ("CHAMPIONNAT".equals(tG.getType())) {
                    matchDAO.genererMatchsChampionnat(tG, equipes);
                } else {
                    matchDAO.genererMatchsElimination(tG, equipes);
                }
                resp.sendRedirect(req.getContextPath() + "/tournois?action=detail&id=" + idG);
                break;
            case "tourSuivant":
                int idTS = Integer.parseInt(req.getParameter("id"));
                int tourActuel = Integer.parseInt(req.getParameter("tour"));
                matchDAO.genererTourSuivant(idTS, tourActuel);
                resp.sendRedirect(req.getContextPath() + "/tournois?action=detail&id=" + idTS);
                break;
            default:
                req.setAttribute("tournois", tournoiDAO.listerTous());
                req.getRequestDispatcher("/tournois.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = (Utilisateur) req.getSession().getAttribute("utilisateur");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String idStr = req.getParameter("id");
        Tournoi t = new Tournoi();
        t.setNom(req.getParameter("nom"));
        t.setSport(req.getParameter("sport"));
        t.setType(req.getParameter("type"));
        t.setLieu(req.getParameter("lieu"));
        t.setDateDebut(Date.valueOf(req.getParameter("date_debut")));
        t.setDateFin(Date.valueOf(req.getParameter("date_fin")));
        t.setNbEquipes(Integer.parseInt(req.getParameter("nb_equipes")));
        t.setDureeMatch(Integer.parseInt(req.getParameter("duree_match")));
        t.setTerrainsDisponibles(Integer.parseInt(req.getParameter("terrains_disponibles")));
        t.setPointsVictoire(Integer.parseInt(req.getParameter("points_victoire")));
        t.setPointsNul(Integer.parseInt(req.getParameter("points_nul")));
        t.setPointsDefaite(Integer.parseInt(req.getParameter("points_defaite")));
        t.setMatchAllerRetour("on".equals(req.getParameter("match_aller_retour")));
        t.setStatut(req.getParameter("statut") != null ? req.getParameter("statut") : "PREPARATION");
        t.setOrganisateurId(user.getId());

        if (idStr != null && !idStr.isEmpty()) {
            t.setId(Integer.parseInt(idStr));
            tournoiDAO.modifier(t);
        } else {
            tournoiDAO.inserer(t);
        }
        resp.sendRedirect(req.getContextPath() + "/tournois");
    }
}