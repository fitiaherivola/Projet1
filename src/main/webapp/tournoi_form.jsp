<%@ page contentType="text/html;charset=UTF-8" import="model.*" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) { response.sendRedirect(request.getContextPath()+"/login"); return; }
    Tournoi t = (Tournoi) request.getAttribute("tournoi");
    boolean edit = (t != null);
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
    <title><%= edit ? "Modifier" : "Nouveau" %> Tournoi</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        /* Design moderne, clair et épuré en harmonie avec les autres pages */
        :root {
            --bg-global: #f8fafc;
            --surface-card: #ffffff;
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-light: #e2e8f0;
            --focus-ring: rgba(79, 70, 229, 0.15);
            --radius-main: 12px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-global);
            color: var(--text-dark);
            min-height: 100vh;
            line-height: 1.5;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 24px;
        }

        h1 {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 24px;
            letter-spacing: -0.02em;
        }

        h2 {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 32px 0 16px 0;
            padding-top: 16px;
            border-top: 1px dashed var(--border-light);
            letter-spacing: -0.01em;
        }

        .form-card {
            background: var(--surface-card);
            padding: 36px;
            border-radius: var(--radius-main);
            border: 1px solid var(--border-light);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
        }

        /* Disposition en grille flexible pour aligner les champs */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 4px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 6px;
            color: var(--text-dark);
        }

        /* Styles unifiés pour les contrôles de formulaire */
        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group input[type="date"],
        .form-group select {
            width: 100%;
            padding: 10px 14px;
            font-size: 0.95rem;
            border: 1px solid var(--border-light);
            border-radius: 8px;
            background-color: #fff;
            color: var(--text-dark);
            transition: all 0.2s ease;
            box-sizing: border-box;
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px var(--focus-ring);
        }

        /* Design personnalisé des éléments select */
        .form-group select {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2364748b' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            background-size: 16px;
            padding-right: 40px;
        }

        /* Case à cocher personnalisée */
        .checkbox-label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-dark);
            cursor: pointer;
            margin-top: 8px;
        }

        .checkbox-label input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--primary-color);
            cursor: pointer;
        }

        /* Zone d'actions */
        .form-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 36px;
            padding-top: 24px;
            border-top: 1px solid var(--border-light);
        }

        .btn {
            flex: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 11px 20px;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.2s ease, transform 0.1s ease;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: #ffffff;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
        }

        .btn-secondary {
            background-color: #f1f5f9;
            color: var(--text-muted);
            border: 1px solid var(--border-light);
        }

        .btn-secondary:hover {
            background-color: #e2e8f0;
            color: var(--text-dark);
        }

        .btn:active {
            transform: scale(0.99);
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <h1><%= edit ? "✏️ Modifier le Tournoi" : "➕ Nouveau Tournoi" %></h1>

    <div class="form-card">
        <form action="<%= ctx %>/tournois" method="post">
            <% if (edit) { %><input type="hidden" name="id" value="<%= t.getId() %>"><% } %>

            <div class="form-row">
                <div class="form-group">
                    <label>Nom du tournoi *</label>
                    <input type="text" name="nom" value="<%= edit ? t.getNom() : "" %>" required placeholder="Ex: Tournoi de Printemps">
                </div>
                <div class="form-group">
                    <label>Sport *</label>
                    <input type="text" name="sport" value="<%= edit ? t.getSport() : "" %>" required placeholder="Ex: Football, Basketball...">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Type de tournoi *</label>
                    <select name="type" required>
                        <option value="ELIMINATION" <%= edit && "ELIMINATION".equals(t.getType()) ? "selected" : "" %>>Élimination directe (KO)</option>
                        <option value="CHAMPIONNAT" <%= edit && "CHAMPIONNAT".equals(t.getType()) ? "selected" : "" %>>Championnat (Round-Robin)</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Lieu</label>
                    <input type="text" name="lieu" value="<%= edit && t.getLieu()!=null ? t.getLieu() : "" %>" placeholder="Ex: Stade Municipal">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Date de début *</label>
                    <input type="date" name="date_debut" value="<%= edit ? t.getDateDebut() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Date de fin *</label>
                    <input type="date" name="date_fin" value="<%= edit ? t.getDateFin() : "" %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Nombre d'équipes</label>
                    <input type="number" name="nb_equipes" value="<%= edit ? t.getNbEquipes() : 8 %>" min="2" max="64">
                </div>
                <div class="form-group">
                    <label>Durée d'un match (min)</label>
                    <input type="number" name="duree_match" value="<%= edit ? t.getDureeMatch() : 90 %>" min="10">
                </div>
                <div class="form-group">
                    <label>Terrains disponibles</label>
                    <input type="number" name="terrains_disponibles" value="<%= edit ? t.getTerrainsDisponibles() : 1 %>" min="1">
                </div>
            </div>

            <h2>⚙️ Règles de points (Championnat)</h2>
            <div class="form-row">
                <div class="form-group">
                    <label>Points Victoire</label>
                    <input type="number" name="points_victoire" value="<%= edit ? t.getPointsVictoire() : 3 %>" min="0">
                </div>
                <div class="form-group">
                    <label>Points Nul</label>
                    <input type="number" name="points_nul" value="<%= edit ? t.getPointsNul() : 1 %>" min="0">
                </div>
                <div class="form-group">
                    <label>Points Défaite</label>
                    <input type="number" name="points_defaite" value="<%= edit ? t.getPointsDefaite() : 0 %>" min="0">
                </div>
            </div>

            <div class="form-group">
                <label class="checkbox-label">
                    <input type="checkbox" name="match_aller_retour" <%= edit && t.isMatchAllerRetour() ? "checked" : "" %>>
                    Matchs aller-retour
                </label>
            </div>

            <% if (edit) { %>
            <div class="form-group">
                <label>Statut</label>
                <select name="statut">
                    <option value="PREPARATION" <%= "PREPARATION".equals(t.getStatut()) ? "selected" : "" %>>Préparation</option>
                    <option value="EN_COURS" <%= "EN_COURS".equals(t.getStatut()) ? "selected" : "" %>>En cours</option>
                    <option value="TERMINE" <%= "TERMINE".equals(t.getStatut()) ? "selected" : "" %>>Terminé</option>
                </select>
            </div>
            <% } %>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary"><%= edit ? "Enregistrer" : "Créer le tournoi" %></button>
                <a href="<%= ctx %>/tournois" class="btn btn-secondary">Annuler</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>