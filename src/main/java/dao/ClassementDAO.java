package dao;

import model.Classement;
import model.Tournoi;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClassementDAO {

    public List<Classement> listerParTournoi(int tournoiId) {
        List<Classement> liste = new ArrayList<>();
        String sql = "SELECT c.*, e.nom AS equipe_nom FROM classement c " +
                     "JOIN equipes e ON c.equipe_id = e.id " +
                     "WHERE c.tournoi_id = ? " +
                     "ORDER BY c.points DESC, c.difference_buts DESC, c.buts_marques DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, tournoiId);
            ResultSet rs = ps.executeQuery();
            int rang = 1;
            while (rs.next()) {
                Classement cl = new Classement();
                cl.setId(rs.getInt("id"));
                cl.setTournoiId(rs.getInt("tournoi_id"));
                cl.setEquipeId(rs.getInt("equipe_id"));
                cl.setEquipeNom(rs.getString("equipe_nom"));
                cl.setPoints(rs.getInt("points"));
                cl.setMatchsJoues(rs.getInt("matchs_joues"));
                cl.setVictoires(rs.getInt("victoires"));
                cl.setNuls(rs.getInt("nuls"));
                cl.setDefaites(rs.getInt("defaites"));
                cl.setButsMarques(rs.getInt("buts_marques"));
                cl.setButsEncaisses(rs.getInt("buts_encaisses"));
                cl.setDifferenceButs(rs.getInt("difference_buts"));
                cl.setRang(rang++);
                liste.add(cl);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return liste;
    }

    public void initialiserClassement(int tournoiId, int equipeId) {
        String sql = "INSERT IGNORE INTO classement (tournoi_id, equipe_id) VALUES (?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, tournoiId);
            ps.setInt(2, equipeId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void recalculer(int tournoiId, Tournoi tournoi) {
        String reset = "UPDATE classement SET points=0, matchs_joues=0, victoires=0, nuls=0, " +
                       "defaites=0, buts_marques=0, buts_encaisses=0, difference_buts=0 WHERE tournoi_id=?";
        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(reset)) {
                ps.setInt(1, tournoiId);
                ps.executeUpdate();
            }
            String sqlMatchs = "SELECT * FROM matchs WHERE tournoi_id=? AND statut='TERMINE'";
            try (PreparedStatement ps = con.prepareStatement(sqlMatchs)) {
                ps.setInt(1, tournoiId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    int e1 = rs.getInt("equipe1_id");
                    int e2 = rs.getInt("equipe2_id");
                    int s1 = rs.getInt("score1");
                    int s2 = rs.getInt("score2");
                    mettreAJourEquipe(con, tournoiId, e1, s1, s2, tournoi);
                    mettreAJourEquipe(con, tournoiId, e2, s2, s1, tournoi);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private void mettreAJourEquipe(Connection con, int tournoiId, int equipeId,
                                    int butsMarques, int butsEncaisses, Tournoi tournoi) throws SQLException {
        int pts = 0, v = 0, n = 0, d = 0;
        if (butsMarques > butsEncaisses) { pts = tournoi.getPointsVictoire(); v = 1; }
        else if (butsMarques == butsEncaisses) { pts = tournoi.getPointsNul(); n = 1; }
        else { pts = tournoi.getPointsDefaite(); d = 1; }

        String sql = "UPDATE classement SET " +
                     "matchs_joues = matchs_joues + 1, " +
                     "points = points + ?, " +
                     "victoires = victoires + ?, " +
                     "nuls = nuls + ?, " +
                     "defaites = defaites + ?, " +
                     "buts_marques = buts_marques + ?, " +
                     "buts_encaisses = buts_encaisses + ?, " +
                     "difference_buts = difference_buts + ? " +
                     "WHERE tournoi_id=? AND equipe_id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, pts);
            ps.setInt(2, v);
            ps.setInt(3, n);
            ps.setInt(4, d);
            ps.setInt(5, butsMarques);
            ps.setInt(6, butsEncaisses);
            ps.setInt(7, butsMarques - butsEncaisses);
            ps.setInt(8, tournoiId);
            ps.setInt(9, equipeId);
            ps.executeUpdate();
        }
    }
}