package dao;

import model.Tournoi;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TournoiDAO {

    private Tournoi mapper(ResultSet rs) throws SQLException {
        Tournoi t = new Tournoi();
        t.setId(rs.getInt("id"));
        t.setNom(rs.getString("nom"));
        t.setSport(rs.getString("sport"));
        t.setType(rs.getString("type"));
        t.setLieu(rs.getString("lieu"));
        t.setDateDebut(rs.getDate("date_debut"));
        t.setDateFin(rs.getDate("date_fin"));
        t.setNbEquipes(rs.getInt("nb_equipes"));
        t.setDureeMatch(rs.getInt("duree_match"));
        t.setTerrainsDisponibles(rs.getInt("terrains_disponibles"));
        t.setPointsVictoire(rs.getInt("points_victoire"));
        t.setPointsNul(rs.getInt("points_nul"));
        t.setPointsDefaite(rs.getInt("points_defaite"));
        t.setMatchAllerRetour(rs.getInt("match_aller_retour") == 1);
        t.setStatut(rs.getString("statut"));
        t.setOrganisateurId(rs.getInt("organisateur_id"));
        try { t.setOrganisateurNom(rs.getString("organisateur_nom")); } catch (SQLException ignored) {}
        return t;
    }

    public List<Tournoi> listerTous() {
        List<Tournoi> liste = new ArrayList<>();
        String sql = "SELECT t.*, u.nom AS organisateur_nom FROM tournois t " +
                     "JOIN utilisateurs u ON t.organisateur_id = u.id ORDER BY t.date_debut DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) liste.add(mapper(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return liste;
    }

    public Tournoi trouverParId(int id) {
        String sql = "SELECT t.*, u.nom AS organisateur_nom FROM tournois t " +
                     "JOIN utilisateurs u ON t.organisateur_id = u.id WHERE t.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapper(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean inserer(Tournoi t) {
        String sql = "INSERT INTO tournois (nom, sport, type, lieu, date_debut, date_fin, nb_equipes, " +
                     "duree_match, terrains_disponibles, points_victoire, points_nul, points_defaite, " +
                     "match_aller_retour, statut, organisateur_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getNom());
            ps.setString(2, t.getSport());
            ps.setString(3, t.getType());
            ps.setString(4, t.getLieu());
            ps.setDate(5, t.getDateDebut());
            ps.setDate(6, t.getDateFin());
            ps.setInt(7, t.getNbEquipes());
            ps.setInt(8, t.getDureeMatch());
            ps.setInt(9, t.getTerrainsDisponibles());
            ps.setInt(10, t.getPointsVictoire());
            ps.setInt(11, t.getPointsNul());
            ps.setInt(12, t.getPointsDefaite());
            ps.setInt(13, t.isMatchAllerRetour() ? 1 : 0);
            ps.setString(14, "PREPARATION");
            ps.setInt(15, t.getOrganisateurId());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) t.setId(rs.getInt(1));
            }
            return affected > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean modifier(Tournoi t) {
        String sql = "UPDATE tournois SET nom=?, sport=?, type=?, lieu=?, date_debut=?, date_fin=?, " +
                     "nb_equipes=?, duree_match=?, terrains_disponibles=?, points_victoire=?, " +
                     "points_nul=?, points_defaite=?, match_aller_retour=?, statut=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t.getNom());
            ps.setString(2, t.getSport());
            ps.setString(3, t.getType());
            ps.setString(4, t.getLieu());
            ps.setDate(5, t.getDateDebut());
            ps.setDate(6, t.getDateFin());
            ps.setInt(7, t.getNbEquipes());
            ps.setInt(8, t.getDureeMatch());
            ps.setInt(9, t.getTerrainsDisponibles());
            ps.setInt(10, t.getPointsVictoire());
            ps.setInt(11, t.getPointsNul());
            ps.setInt(12, t.getPointsDefaite());
            ps.setInt(13, t.isMatchAllerRetour() ? 1 : 0);
            ps.setString(14, t.getStatut());
            ps.setInt(15, t.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM tournois WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}