package model;

import java.sql.Timestamp;

public class Match {
    private int id;
    private int tournoiId;
    private int equipe1Id;
    private int equipe2Id;
    private String equipe1Nom;
    private String equipe2Nom;
    private Integer score1;
    private Integer score2;
    private Timestamp dateMatch;
    private String terrain;
    private String phase;
    private int tour;
    private String statut;
    private boolean prolongation;
    private boolean tirsAuBut;

    // Getters et setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getTournoiId() { return tournoiId; }
    public void setTournoiId(int tournoiId) { this.tournoiId = tournoiId; }
    public int getEquipe1Id() { return equipe1Id; }
    public void setEquipe1Id(int equipe1Id) { this.equipe1Id = equipe1Id; }
    public int getEquipe2Id() { return equipe2Id; }
    public void setEquipe2Id(int equipe2Id) { this.equipe2Id = equipe2Id; }
    public String getEquipe1Nom() { return equipe1Nom; }
    public void setEquipe1Nom(String equipe1Nom) { this.equipe1Nom = equipe1Nom; }
    public String getEquipe2Nom() { return equipe2Nom; }
    public void setEquipe2Nom(String equipe2Nom) { this.equipe2Nom = equipe2Nom; }
    public Integer getScore1() { return score1; }
    public void setScore1(Integer score1) { this.score1 = score1; }
    public Integer getScore2() { return score2; }
    public void setScore2(Integer score2) { this.score2 = score2; }
    public Timestamp getDateMatch() { return dateMatch; }
    public void setDateMatch(Timestamp dateMatch) { this.dateMatch = dateMatch; }
    public String getTerrain() { return terrain; }
    public void setTerrain(String terrain) { this.terrain = terrain; }
    public String getPhase() { return phase; }
    public void setPhase(String phase) { this.phase = phase; }
    public int getTour() { return tour; }
    public void setTour(int tour) { this.tour = tour; }
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    public boolean isProlongation() { return prolongation; }
    public void setProlongation(boolean prolongation) { this.prolongation = prolongation; }
    public boolean isTirsAuBut() { return tirsAuBut; }
    public void setTirsAuBut(boolean tirsAuBut) { this.tirsAuBut = tirsAuBut; }
}