package model;

import java.sql.Date;

public class Tournoi {
    private int id;
    private String nom;
    private String sport;
    private String type;
    private String lieu;
    private Date dateDebut;
    private Date dateFin;
    private int nbEquipes;
    private int dureeMatch;
    private int terrainsDisponibles;
    private int pointsVictoire;
    private int pointsNul;
    private int pointsDefaite;
    private boolean matchAllerRetour;
    private String statut;
    private int organisateurId;
    private String organisateurNom;

    // Getters et setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getSport() { return sport; }
    public void setSport(String sport) { this.sport = sport; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getLieu() { return lieu; }
    public void setLieu(String lieu) { this.lieu = lieu; }
    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }
    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }
    public int getNbEquipes() { return nbEquipes; }
    public void setNbEquipes(int nbEquipes) { this.nbEquipes = nbEquipes; }
    public int getDureeMatch() { return dureeMatch; }
    public void setDureeMatch(int dureeMatch) { this.dureeMatch = dureeMatch; }
    public int getTerrainsDisponibles() { return terrainsDisponibles; }
    public void setTerrainsDisponibles(int terrainsDisponibles) { this.terrainsDisponibles = terrainsDisponibles; }
    public int getPointsVictoire() { return pointsVictoire; }
    public void setPointsVictoire(int pointsVictoire) { this.pointsVictoire = pointsVictoire; }
    public int getPointsNul() { return pointsNul; }
    public void setPointsNul(int pointsNul) { this.pointsNul = pointsNul; }
    public int getPointsDefaite() { return pointsDefaite; }
    public void setPointsDefaite(int pointsDefaite) { this.pointsDefaite = pointsDefaite; }
    public boolean isMatchAllerRetour() { return matchAllerRetour; }
    public void setMatchAllerRetour(boolean matchAllerRetour) { this.matchAllerRetour = matchAllerRetour; }
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    public int getOrganisateurId() { return organisateurId; }
    public void setOrganisateurId(int organisateurId) { this.organisateurId = organisateurId; }
    public String getOrganisateurNom() { return organisateurNom; }
    public void setOrganisateurNom(String organisateurNom) { this.organisateurNom = organisateurNom; }
}