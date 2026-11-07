package model;

public class Equipe {
    private int id;
    private String nom;
    private String contact;
    private int tournoiId;
    private String tournoiNom;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
    public int getTournoiId() { return tournoiId; }
    public void setTournoiId(int tournoiId) { this.tournoiId = tournoiId; }
    public String getTournoiNom() { return tournoiNom; }
    public void setTournoiNom(String tournoiNom) { this.tournoiNom = tournoiNom; }
}