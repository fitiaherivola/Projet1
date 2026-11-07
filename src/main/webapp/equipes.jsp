<%@ page contentType="text/html;charset=UTF-8" import="java.util.*,model.*" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) { response.sendRedirect(request.getContextPath()+"/login"); return; }
    Equipe e           = (Equipe)          request.getAttribute("equipe");
    List<Tournoi> tournois = (List<Tournoi>) request.getAttribute("tournois");
    boolean edit = (e != null);
    String ctx   = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title><%= edit ? "Modifier" : "Nouvelle" %> Équipe</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        /* Modernisation globale du style sans casser la structure */
        :root {
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --secondary-color: #f3f4f6;
            --secondary-hover: #e5e7eb;
            --text-color: #1f2937;
            --text-muted: #6b7280;
            --bg-color: #f9fafb;
            --card-bg: #ffffff;
            --border-color: #d1d5db;
            --focus-ring: rgba(79, 70, 229, 0.2);
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 0;
            line-height: 1.5;
        }

        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 0 20px;
        }

        h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-color);
            margin-bottom: 24px;
        }

        .form-card {
            background: var(--card-bg);
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 6px;
            color: var(--text-color);
        }

        .form-group input[type="text"],
        .form-group select {
            width: 100%;
            padding: 10px 14px;
            font-size: 0.95rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            background-color: #fff;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px var(--focus-ring);
        }

        .form-group select {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%234b5563' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            background-size: 16px;
            padding-right: 40px;
        }

        .form-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 28px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 20px;
            font-size: 0.95rem;
            font-weight: 500;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            color: var(--text-color);
        }

        .btn-secondary:hover {
            background-color: var(--secondary-hover);
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <h1><%= edit ? "✏ Modifier l'Équipe" : " Nouvelle Équipe" %></h1>
    <div class="form-card">
        <form action="<%= ctx %>/equipes" method="post">
            <% if (edit) { %>
                <input type="hidden" name="id" value="<%= e.getId() %>">
            <% } %>

            <div class="form-group">
                <label>Nom de l'équipe *</label>
                <input type="text" name="nom" value="<%= edit ? e.getNom() : "" %>" required placeholder="Ex: Les Lions">
            </div>

            <div class="form-group">
                <label>Contact</label>
                <input type="text" name="contact" value="<%= edit && e.getContact() != null ? e.getContact() : "" %>" placeholder="Email ou téléphone">
            </div>

            <div class="form-group">
                <label>Tournoi *</label>
                <select name="tournoi_id" required>
                    <option value="">-- Sélectionner un tournoi --</option>
                    <% if (tournois != null) { for (Tournoi t : tournois) { %>
                    <option value="<%= t.getId() %>" <%= edit && e.getTournoiId() == t.getId() ? "selected" : "" %>>
                        <%= t.getNom() %> (<%= t.getSport() %>)
                    </option>
                    <% } } %>
                </select>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary"><%= edit ? "Enregistrer" : "Ajouter l'équipe" %></button>
                <a href="<%= ctx %>/equipes" class="btn btn-secondary">Annuler</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>