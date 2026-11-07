<%@ page contentType="text/html;charset=UTF-8" import="java.util.*,model.*" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) { response.sendRedirect(request.getContextPath()+"/login"); return; }
    Tournoi t = (Tournoi) request.getAttribute("tournoi");
    if (t == null) { response.sendRedirect(request.getContextPath() + "/tournois"); return; }
    List<Equipe> equipes = (List<Equipe>) request.getAttribute("equipes");
    List<Match> matchs = (List<Match>) request.getAttribute("matchs");
    List<Classement> classement = (List<Classement>) request.getAttribute("classement");
    boolean isAdmin = "ADMIN".equals(user.getRole()) || "ORGANISATEUR".equals(user.getRole());
    String ctx = request.getContextPath();
    int termines = 0;
    int maxTour = 0;
    if (matchs != null) {
        for (Match m : matchs) {
            if ("TERMINE".equals(m.getStatut())) termines++;
            if (m.getTour() > maxTour) maxTour = m.getTour();
        }
    }
    // Vérifier si on peut générer un tour suivant (élimination directe)
    boolean peutGenererTourSuivant = false;
    if ("ELIMINATION".equals(t.getType()) && matchs != null && !matchs.isEmpty()) {
        boolean dernierTourTermine = true;
        int nbMatchsDernierTour = 0;
        for (Match m : matchs) {
            if (m.getTour() == maxTour) {
                nbMatchsDernierTour++;
                if (!"TERMINE".equals(m.getStatut())) {
                    dernierTourTermine = false;
                }
            }
        }
        peutGenererTourSuivant = dernierTourTermine && nbMatchsDernierTour > 1;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Tournoi : <%= t.getNom() %></title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        /* Modernisation complète vers un design de tableau de bord SaaS moderne */
        :root {
            --bg-global: #f8fafc;
            --surface-card: #ffffff;
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-light: #e2e8f0;
            --radius-main: 12px;
            
            /* Statuses colors */
            --success: #10b981;
            --success-bg: #ecfdf5;
            --warning: #f59e0b;
            --warning-bg: #fffbeb;
            --danger: #ef4444;
            --danger-bg: #fef2f2;
            --info: #0ea5e9;
            --info-bg: #f0f9ff;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-global);
            color: var(--text-dark);
            min-height: 100vh;
            line-height: 1.5;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 24px;
        }

        /* En-tête */
        .header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 16px;
        }

        h1 {
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -0.02em;
        }

        h2 {
            font-size: 1.3rem;
            font-weight: 700;
            margin: 40px 0 16px 0;
            letter-spacing: -0.01em;
            color: var(--text-dark);
        }

        /* Grille d'informations (Kpis) */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            gap: 16px;
            margin-bottom: 32px;
        }

        .info-card {
            background: var(--surface-card);
            padding: 16px 20px;
            border-radius: 10px;
            border: 1px solid var(--border-light);
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }

        .info-card .value {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 4px;
        }

        .info-card .label {
            font-size: 0.8rem;
            font-weight: 500;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.02em;
        }

        /* Zone d'actions Admin */
        .admin-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 32px;
            padding: 16px;
            background-color: #fff;
            border-radius: 10px;
            border: 1px solid var(--border-light);
        }

        /* Tableaux modernisés */
        .table-container {
            background: var(--surface-card);
            border-radius: var(--radius-main);
            border: 1px solid var(--border-light);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            overflow-x: auto;
            margin-bottom: 24px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.95rem;
        }

        th {
            background-color: #f8fafc;
            color: var(--text-muted);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            padding: 14px 20px;
            border-bottom: 1px solid var(--border-light);
        }

        td {
            padding: 14px 20px;
            border-bottom: 1px solid var(--border-light);
            color: var(--text-dark);
            vertical-align: middle;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background-color: #fafafa;
        }

        /* Boutons personnalisés */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 9px 16px;
            font-size: 0.9rem;
            font-weight: 600;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-sm { padding: 6px 12px; font-size: 0.8rem; border-radius: 4px; }
        .btn-primary { background-color: var(--primary-color); color: #fff; }
        .btn-primary:hover { background-color: var(--primary-hover); }
        .btn-secondary { background-color: #f1f5f9; color: var(--text-muted); border: 1px solid var(--border-light); }
        .btn-secondary:hover { background-color: #e2e8f0; color: var(--text-dark); }
        .btn-success { background-color: var(--success-bg); color: var(--success); border: 1px solid #a7f3d0; }
        .btn-success:hover { background-color: #d1fae5; }
        .btn-warning { background-color: var(--warning-bg); color: var(--warning); border: 1px solid #fde68a; }
        .btn-warning:hover { background-color: #fef3c7; }
        .btn-danger { background-color: var(--danger-bg); color: var(--danger); border: 1px solid #fca5a5; }
        .btn-danger:hover { background-color: #fee2e2; }

        /* Badges de Statut */
        .badge {
            display: inline-flex;
            padding: 4px 10px;
            font-size: 0.8rem;
            font-weight: 600;
            border-radius: 20px;
        }
        .badge-termine { background-color: #f1f5f9; color: var(--text-muted); }
        .badge-encours { background-color: var(--warning-bg); color: var(--warning); border: 1px solid #fde68a; }
        .badge-planifie { background-color: var(--info-bg); color: var(--info); border: 1px solid #bae6fd; }

        .empty-text {
            color: var(--text-muted);
            font-style: italic;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            border: 1px dashed var(--border-light);
            text-align: center;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    
    <div class="header-row">
        <h1>🏆 <%= t.getNom() %></h1>
        <a href="<%= ctx %>/tournois" class="btn btn-secondary btn-sm">← Retour</a>
    </div>

    <div class="info-grid">
        <div class="info-card"><div class="value"><%= t.getSport() %></div><div class="label">Sport</div></div>
        <div class="info-card">
            <div class="value">
                <% if ("ELIMINATION".equals(t.getType())) { %><span style="color: var(--danger);">KO</span>
                <% } else { %><span style="color: var(--info);">Championnat</span><% } %>
            </div>
            <div class="label">Format</div>
        </div>
        <div class="info-card"><div class="value"><%= equipes != null ? equipes.size() : 0 %></div><div class="label">Équipes</div></div>
        <div class="info-card"><div class="value"><%= matchs != null ? matchs.size() : 0 %></div><div class="label">Matchs Total</div></div>
        <div class="info-card"><div class="value"><%= termines %></div><div class="label">Matchs Joués</div></div>
        <div class="info-card"><div class="value"><%= t.getLieu() != null ? t.getLieu() : "-" %></div><div class="label">Lieu</div></div>
    </div>

    <% if (isAdmin) { %>
    <div class="admin-actions">
        <a href="<%= ctx %>/equipes?action=nouveau" class="btn btn-success">+ Ajouter Équipe</a>
        <% if (equipes != null && equipes.size() >= 2 && (matchs == null || matchs.isEmpty())) { %>
        <a href="<%= ctx %>/tournois?action=genererMatchs&id=<%= t.getId() %>"
           class="btn btn-primary"
           onclick="return confirm('Générer automatiquement tous les matchs ?')">⚡ Générer les Matchs</a>
        <% } %>
        <% if (peutGenererTourSuivant) { %>
        <a href="<%= ctx %>/tournois?action=tourSuivant&id=<%= t.getId() %>&tour=<%= maxTour %>"
           class="btn btn-primary">➡️ Générer tour suivant</a>
        <% } %>
        <a href="<%= ctx %>/tournois?action=editer&id=<%= t.getId() %>" class="btn btn-warning">✏️ Modifier</a>
    </div>
    <% } %>

    <% if ("CHAMPIONNAT".equals(t.getType()) && classement != null && !classement.isEmpty()) { %>
    <h2>📊 Classement en temps réel</h2>
    <div class="table-container">
        <table>
            <thead>
                <tr><th>#</th><th>Équipe</th><th>MJ</th><th>V</th><th>N</th><th>D</th>
                    <th>BP</th><th>BE</th><th>DB</th><th>Pts</th></tr>
            </thead>
            <tbody>
            <% for (Classement cl : classement) { %>
                <tr>
                    <td><strong><%= cl.getRang() %></strong></td>
                    <td><strong><%= cl.getEquipeNom() %></strong></td>
                    <td><%= cl.getMatchsJoues() %></td>
                    <td style="color:var(--success);font-weight:bold;"><%= cl.getVictoires() %></td>
                    <td><%= cl.getNuls() %></td>
                    <td style="color:var(--danger);"><%= cl.getDefaites() %></td>
                    <td><%= cl.getButsMarques() %></td>
                    <td><%= cl.getButsEncaisses() %></td>
                    <td style="font-weight: 500;"><%= cl.getDifferenceButs() >= 0 ? "+" : "" %><%= cl.getDifferenceButs() %></td>
                    <td><strong style="font-size:16px;color:var(--primary-color);"><%= cl.getPoints() %></strong></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>

    <h2> Équipes participantes</h2>
    <% if (equipes == null || equipes.isEmpty()) { %>
        <p class="empty-text">Aucune équipe ajoutée pour le moment.</p>
    <% } else { %>
    <div class="table-container">
        <table>
            <thead><tr><th>#</th><th>Nom de l'équipe</th><th>Contact</th><% if(isAdmin){%><th>Action</th><%}%></tr></thead>
            <tbody>
            <% int idx=1; for (Equipe e : equipes) { %>
                <tr>
                    <td><%= idx++ %></td>
                    <td><strong><%= e.getNom() %></strong></td>
                    <td><%= e.getContact() != null ? e.getContact() : "-" %></td>
                    <% if (isAdmin) { %>
                    <td>
                        <div style="display:flex; gap:6px;">
                            <a href="<%= ctx %>/equipes?action=editer&id=<%= e.getId() %>" class="btn btn-warning btn-sm">Modifier</a>
                            <a href="<%= ctx %>/equipes?action=supprimer&id=<%= e.getId() %>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Supprimer cette équipe ?')">Supprimer</a>
                        </div>
                    </td>
                    <% } %>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>

    <h2> Calendrier des Matchs</h2>
    <% if (matchs == null || matchs.isEmpty()) { %>
        <p class="empty-text">Aucun match généré pour le moment.</p>
    <% } else { %>
    <div class="table-container">
        <table>
            <thead>
                <tr><th>Phase</th><th>Tour</th><th>Équipe 1</th><th style="text-align:center;">Score</th><th>Équipe 2</th>
                    <th>Date</th><th>Terrain</th><th>Statut</th><% if(isAdmin){%><th>Action</th><%}%></tr>
            </thead>
            <tbody>
            <% for (Match m : matchs) { %>
                <tr>
                    <td><span style="font-size: 0.85rem; font-weight:600; color:var(--text-muted);"><%= m.getPhase() != null ? m.getPhase() : "-" %></span></td>
                    <td>Tour <%= m.getTour() %></td>
                    <td><strong><%= m.getEquipe1Nom() %></strong></td>
                    <td style="text-align:center;font-weight:bold; font-size: 1.1rem; background-color: #fafafa;">
                        <% if ("TERMINE".equals(m.getStatut()) && m.getScore1() != null) { %>
                            <%= m.getScore1() %> – <%= m.getScore2() %>
                            <% if (m.isTirsAuBut()) { %>
                                <br><small style="font-size: 0.7rem; color: var(--text-muted); font-weight: normal;">(TAB)</small>
                            <% } else if (m.isProlongation()) { %>
                                <br><small style="font-size: 0.7rem; color: var(--text-muted); font-weight: normal;">(Prol.)</small>
                            <% } %>
                        <% } else { %>
                            <span style="color:var(--text-muted); font-weight: normal; font-size: 0.9rem;">vs</span>
                        <% } %>
                    </td>
                    <td><strong><%= m.getEquipe2Nom() %></strong></td>
                    <td style="font-size: 0.85rem;"><%= m.getDateMatch() != null ? m.getDateMatch().toString().substring(0,16) : "-" %></td>
                    <td><%= m.getTerrain() != null ? m.getTerrain() : "-" %></td>
                    <td>
                        <% if ("TERMINE".equals(m.getStatut())) { %>
                            <span class="badge badge-termine">Terminé</span>
                        <% } else if ("EN_COURS".equals(m.getStatut())) { %>
                            <span class="badge badge-encours">En cours</span>
                        <% } else { %>
                            <span class="badge badge-planifie">Planifié</span>
                        <% } %>
                    </td>
                    <% if (isAdmin) { %>
                    <td>
                        <% if (!"TERMINE".equals(m.getStatut())) { %>
                            <a href="<%= ctx %>/matchs?action=score&id=<%= m.getId() %>" class="btn btn-success btn-sm">Saisir Score</a>
                        <% } %>
                    </td>
                    <% } %>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>
</body>
</html>