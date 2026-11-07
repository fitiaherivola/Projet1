package dao;

import model.Equipe;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EquipeDAO {

    private Equipe mapper(ResultSet rs) throws SQLException {
        Equipe e = new Equipe();
        e.setId(rs.getInt("id"));
        e.setNom(rs.getString("nom"));
        e.setContact(rs.getString("contact"));
        e.setTournoiId(rs.getInt("tournoi_id"));
        try { e.setTournoiNom(rs.getString("tournoi_nom")); } catch (SQLException ignored) {}
        return e;
    }

    public List<Equipe> listerParTournoi(int tournoiId) {
        List<Equipe> liste = new ArrayList<>();
        String sql = "SELECT e.*, t.nom AS tournoi_nom FROM equipes e " +
                     "JOIN tournois t ON e.tournoi_id = t.id WHERE e.tournoi_id = ? ORDER BY e.nom";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, tournoiId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) liste.add(mapper(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return liste;
    }

    public List<Equipe> listerTous() {
        List<Equipe> liste = new ArrayList<>();
        String sql = "SELECT e.*, t.nom AS tournoi_nom FROM equipes e " +
                     "JOIN tournois t ON e.tournoi_id = t.id ORDER BY t.nom, e.nom";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) liste.add(mapper(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return liste;
    }

    public Equipe trouverParId(int id) {
        String sql = "SELECT e.*, t.nom AS tournoi_nom FROM equipes e " +
                     "JOIN tournois t ON e.tournoi_id = t.id WHERE e.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapper(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean inserer(Equipe e) {
        String sql = "INSERT INTO equipes (nom, contact, tournoi_id) VALUES (?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getNom());
            ps.setString(2, e.getContact());
            ps.setInt(3, e.getTournoiId());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) e.setId(rs.getInt(1));
            }
            return affected > 0;
        } catch (SQLException ex) { ex.printStackTrace(); }
        return false;
    }

    public boolean modifier(Equipe e) {
        String sql = "UPDATE equipes SET nom=?, contact=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, e.getNom());
            ps.setString(2, e.getContact());
            ps.setInt(3, e.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) { ex.printStackTrace(); }
        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM equipes WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}