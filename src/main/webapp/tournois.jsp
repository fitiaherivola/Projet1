<%@ page contentType="text/html;charset=UTF-8" import="java.util.*,model.*" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) { response.sendRedirect(request.getContextPath()+"/login"); return; }
    List<model.Tournoi> tournois = (List<model.Tournoi>) request.getAttribute("tournois");
    boolean isAdmin = "ADMIN".equals(user.getRole()) || "ORGANISATEUR".equals(user.getRole());
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Tournois</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <h1>🏆 Liste des Tournois</h1>

    <% if (isAdmin) { %>
    <a href="<%= ctx %>/tournois?action=nouveau" class="btn btn-primary" style="margin-bottom:16px;">+ Nouveau Tournoi</a>
    <% } %>

    <% String msg = (String) session.getAttribute("msg"); if(msg!=null){ session.removeAttribute("msg"); %>
    <div class="msg-success"><%= msg %></div>
    <% } %>

    <table>
        <thead>
            <tr><th>#</th><th>Nom</th><th>Sport</th><th>Type</th>
                <th>Lieu</th><th>Date début</th><th>Date fin</th>
                <th>Statut</th><th>Actions</th>
        </thead>
        <tbody>
        <% if (tournois == null || tournois.isEmpty()) { %>
            <tr><td colspan="9" style="text-align:center;color:#888;padding:20px;">Aucun tournoi enregistré.</td></tr>
        <% } else { for (model.Tournoi t : tournois) { %>
            <tr>
                <td><%= t.getId() %></td>
                <td><strong><%= t.getNom() %></strong></td>
                <td><%= t.getSport() %></td>
                <td>
                    <% if ("ELIMINATION".equals(t.getType())) { %>
                        <span class="badge badge-elim">KO</span>
                    <% } else { %>
                        <span class="badge badge-champ">Championnat</span>
                    <% } %>
                </td>
                <td><%= t.getLieu() != null ? t.getLieu() : "-" %></td>
                <td><%= t.getDateDebut() %></td>
                <td><%= t.getDateFin() %></td>
                <td>
                    <% if ("PREPARATION".equals(t.getStatut())) { %>
                        <span class="badge badge-prep">Préparation</span>
                    <% } else if ("EN_COURS".equals(t.getStatut())) { %>
                        <span class="badge badge-encours">En cours</span>
                    <% } else { %>
                        <span class="badge badge-termine">Terminé</span>
                    <% } %>
                 </td>
                <td>
                    <a href="<%= ctx %>/tournois?action=detail&id=<%= t.getId() %>" class="btn btn-info btn-sm">Détail</a>
                    <% if (isAdmin) { %>
                    <a href="<%= ctx %>/tournois?action=editer&id=<%= t.getId() %>" class="btn btn-warning btn-sm">Modifier</a>
                    <a href="<%= ctx %>/tournois?action=supprimer&id=<%= t.getId() %>"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Supprimer ce tournoi ?')">Supprimer</a>
                    <% } %>
                 </td>
            </tr>
        <% } } %>
        </tbody>
    </table>
</div>
</body>
</html>