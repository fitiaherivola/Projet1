package model;

public class Classement {
    private int id;
    private int tournoiId;
    private int equipeId;
    private String equipeNom;
    private int points;
    private int matchsJoues;
    private int victoires;
    private int nuls;
    private int defaites;
    private int butsMarques;
    private int butsEncaisses;
    private int differenceButs;
    private int rang;

    // Getters et setters (inchangés)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getTournoiId() { return tournoiId; }
    public void setTournoiId(int tournoiId) { this.tournoiId = tournoiId; }
    public int getEquipeId() { return equipeId; }
    public void setEquipeId(int equipeId) { this.equipeId = equipeId; }
    public String getEquipeNom() { return equipeNom; }
    public void setEquipeNom(String equipeNom) { this.equipeNom = equipeNom; }
    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }
    public int getMatchsJoues() { return matchsJoues; }
    public void setMatchsJoues(int matchsJoues) { this.matchsJoues = matchsJoues; }
    public int getVictoires() { return victoires; }
    public void setVictoires(int victoires) { this.victoires = victoires; }
    public int getNuls() { return nuls; }
    public void setNuls(int nuls) { this.nuls = nuls; }
    public int getDefaites() { return defaites; }
    public void setDefaites(int defaites) { this.defaites = defaites; }
    public int getButsMarques() { return butsMarques; }
    public void setButsMarques(int butsMarques) { this.butsMarques = butsMarques; }
    public int getButsEncaisses() { return butsEncaisses; }
    public void setButsEncaisses(int butsEncaisses) { this.butsEncaisses = butsEncaisses; }
    public int getDifferenceButs() { return differenceButs; }
    public void setDifferenceButs(int differenceButs) { this.differenceButs = differenceButs; }
    public int getRang() { return rang; }
    public void setRang(int rang) { this.rang = rang; }
}