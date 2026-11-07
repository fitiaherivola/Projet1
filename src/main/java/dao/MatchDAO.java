package dao;

import model.Match;
import model.Equipe;
import model.Tournoi;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MatchDAO {

    private Match mapper(ResultSet rs) throws SQLException {
        Match m = new Match();
        m.setId(rs.getInt("id"));
        m.setTournoiId(rs.getInt("tournoi_id"));
        m.setEquipe1Id(rs.getInt("equipe1_id"));
        m.setEquipe2Id(rs.getInt("equipe2_id"));
        m.setEquipe1Nom(rs.getString("equipe1_nom"));
        m.setEquipe2Nom(rs.getString("equipe2_nom"));
        int s1 = rs.getInt("score1"); m.setScore1(rs.wasNull() ? null : s1);
        int s2 = rs.getInt("score2"); m.setScore2(rs.wasNull() ? null : s2);
        m.setDateMatch(rs.getTimestamp("date_match"));
        m.setTerrain(rs.getString("terrain"));
        m.setPhase(rs.getString("phase"));
        m.setTour(rs.getInt("tour"));
        m.setStatut(rs.getString("statut"));
        m.setProlongation(rs.getInt("prolongation") == 1);
        m.setTirsAuBut(rs.getInt("tirs_au_but") == 1);
        return m;
    }

    public List<Match> listerParTournoi(int tournoiId) {
        List<Match> liste = new ArrayList<>();
        String sql = "SELECT m.*, e1.nom AS equipe1_nom, e2.nom AS equipe2_nom " +
                     "FROM matchs m " +
                     "JOIN equipes e1 ON m.equipe1_id = e1.id " +
                     "JOIN equipes e2 ON m.equipe2_id = e2.id " +
                     "WHERE m.tournoi_id = ? ORDER BY m.tour, m.date_match";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, tournoiId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) liste.add(mapper(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return liste;
    }

    public Match trouverParId(int id) {
        String sql = "SELECT m.*, e1.nom AS equipe1_nom, e2.nom AS equipe2_nom " +
                     "FROM matchs m " +
                     "JOIN equipes e1 ON m.equipe1_id = e1.id " +
                     "JOIN equipes e2 ON m.equipe2_id = e2.id " +
                     "WHERE m.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapper(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean inserer(Match m) {
        String sql = "INSERT INTO matchs (tournoi_id, equipe1_id, equipe2_id, date_match, terrain, phase, tour, statut) " +
                     "VALUES (?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, m.getTournoiId());
            ps.setInt(2, m.getEquipe1Id());
            ps.setInt(3, m.getEquipe2Id());
            ps.setTimestamp(4, m.getDateMatch());
            ps.setString(5, m.getTerrain());
            ps.setString(6, m.getPhase());
            ps.setInt(7, m.getTour());
            ps.setString(8, "PLANIFIE");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean saisirScore(int matchId, int score1, int score2, boolean prolongation, boolean tirsAuBut) {
        String sql = "UPDATE matchs SET score1=?, score2=?, prolongation=?, tirs_au_but=?, statut='TERMINE' WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, score1);
            ps.setInt(2, score2);
            ps.setInt(3, prolongation ? 1 : 0);
            ps.setInt(4, tirsAuBut ? 1 : 0);
            ps.setInt(5, matchId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM matchs WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public void genererMatchsChampionnat(Tournoi tournoi, List<Equipe> equipes) {
        int n = equipes.size();
        int tour = 1;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO matchs (tournoi_id, equipe1_id, equipe2_id, phase, tour, statut) VALUES (?,?,?,'POULE',?,?)";
            for (int i = 0; i < n; i++) {
                for (int j = i + 1; j < n; j++) {
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setInt(1, tournoi.getId());
                        ps.setInt(2, equipes.get(i).getId());
                        ps.setInt(3, equipes.get(j).getId());
                        ps.setInt(4, tour);
                        ps.setString(5, "PLANIFIE");
                        ps.executeUpdate();
                    }
                    if (tournoi.isMatchAllerRetour()) {
                        try (PreparedStatement ps = con.prepareStatement(sql)) {
                            ps.setInt(1, tournoi.getId());
                            ps.setInt(2, equipes.get(j).getId());
                            ps.setInt(3, equipes.get(i).getId());
                            ps.setInt(4, tour + 1);
                            ps.setString(5, "PLANIFIE");
                            ps.executeUpdate();
                        }
                    }
                }
                tour += 2;
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void genererMatchsElimination(Tournoi tournoi, List<Equipe> equipes) {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO matchs (tournoi_id, equipe1_id, equipe2_id, phase, tour, statut) VALUES (?,?,?,?,?,?)";
            String phase = getPhaseLabel(equipes.size());
            for (int i = 0; i < equipes.size(); i += 2) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, tournoi.getId());
                    ps.setInt(2, equipes.get(i).getId());
                    ps.setInt(3, equipes.get(i + 1).getId());
                    ps.setString(4, phase);
                    ps.setInt(5, 1);
                    ps.setString(6, "PLANIFIE");
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void genererTourSuivant(int tournoiId, int tourActuel) {
        List<Integer> vainqueurs = new ArrayList<>();
        String sqlSelect = "SELECT m.id, m.equipe1_id, m.equipe2_id, m.score1, m.score2 " +
                           "FROM matchs m WHERE m.tournoi_id = ? AND m.tour = ? AND m.statut = 'TERMINE'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            ps.setInt(1, tournoiId);
            ps.setInt(2, tourActuel);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int s1 = rs.getInt("score1");
                int s2 = rs.getInt("score2");
                int vainqueur = (s1 > s2) ? rs.getInt("equipe1_id") : rs.getInt("equipe2_id");
                vainqueurs.add(vainqueur);
            }
        } catch (SQLException e) { e.printStackTrace(); return; }

        if (vainqueurs.size() < 2) return;

        String phase = getPhaseLabel(vainqueurs.size());
        int nouveauTour = tourActuel + 1;
        String sqlInsert = "INSERT INTO matchs (tournoi_id, equipe1_id, equipe2_id, phase, tour, statut) VALUES (?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlInsert)) {
            for (int i = 0; i < vainqueurs.size(); i += 2) {
                ps.setInt(1, tournoiId);
                ps.setInt(2, vainqueurs.get(i));
                ps.setInt(3, vainqueurs.get(i + 1));
                ps.setString(4, phase);
                ps.setInt(5, nouveauTour);
                ps.setString(6, "PLANIFIE");
                ps.executeUpdate();
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private String getPhaseLabel(int nbEquipes) {
        if (nbEquipes == 2) return "FINALE";
        if (nbEquipes == 4) return "DEMI-FINALE";
        if (nbEquipes == 8) return "QUART-DE-FINALE";
        return "TOUR_" + nbEquipes;
    }
}