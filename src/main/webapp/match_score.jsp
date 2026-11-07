<%@ page contentType="text/html;charset=UTF-8" import="model.*" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) { response.sendRedirect(request.getContextPath()+"/login"); return; }
    Match m  = (Match) request.getAttribute("match");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Saisir Score</title>
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
            --success-color: #10b981;
            --success-hover: #059669;
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
            max-width: 520px;
            margin: 40px auto;
            padding: 0 20px;
        }

        h1 {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 24px;
            letter-spacing: -0.02em;
        }

        .score-card {
            background: var(--surface-card);
            padding: 36px;
            border-radius: var(--radius-main);
            border: 1px solid var(--border-light);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
        }

        /* Badge de phase */
        .phase-badge-wrapper {
            text-align: center;
            margin-bottom: 24px;
        }

        .custom-badge {
            display: inline-block;
            padding: 6px 14px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-radius: 20px;
            background-color: #f1f5f9;
            color: var(--text-muted);
            border: 1px solid var(--border-light);
        }

        /* Ligne des équipes */
        .teams-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 28px;
        }

        .team-name {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-dark);
            text-align: center;
            flex: 1;
            word-break: break-word;
        }

        .vs-sep {
            font-size: 0.9rem;
            color: var(--text-muted);
            font-weight: 800;
            background: #f1f5f9;
            padding: 4px 8px;
            border-radius: 6px;
            letter-spacing: 0.05em;
        }

        /* Entrées des scores */
        .score-inputs {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
            margin-bottom: 28px;
        }

        .score-inputs input {
            width: 80px;
            height: 70px;
            text-align: center;
            font-size: 2rem;
            font-weight: 800;
            padding: 10px;
            border: 2px solid var(--border-light);
            border-radius: 10px;
            background-color: #fff;
            color: var(--text-dark);
            transition: all 0.2s ease;
            -moz-appearance: textfield;
        }

        .score-inputs input::-webkit-outer-spin-button,
        .score-inputs input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .score-inputs input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px var(--focus-ring);
        }

        .score-inputs span {
            font-size: 1.5rem;
            color: var(--text-muted);
            font-weight: 600;
        }

        /* Checkboxes optionnelles */
        .options-group {
            display: flex;
            justify-content: center;
            gap: 24px;
            margin-bottom: 32px;
            padding: 12px;
            background-color: #fafafa;
            border-radius: 8px;
            border: 1px dashed var(--border-light);
        }

        .options-group label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-dark);
            cursor: pointer;
        }

        .options-group input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--primary-color);
            cursor: pointer;
        }

        /* Actions */
        .form-actions {
            display: flex;
            align-items: center;
            gap: 12px;
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

        .btn-success {
            background-color: var(--success-color);
            color: white;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        }

        .btn-success:hover {
            background-color: var(--success-hover);
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
    <h1>🏆 Saisie du Score</h1>
    <div class="score-card">
        <div class="phase-badge-wrapper">
            <span class="custom-badge"><%= m.getPhase() %> — Tour <%= m.getTour() %></span>
        </div>

        <div class="teams-row">
            <div class="team-name"><%= m.getEquipe1Nom() %></div>
            <div class="vs-sep">VS</div>
            <div class="team-name"><%= m.getEquipe2Nom() %></div>
        </div>

        <form action="<%= ctx %>/matchs" method="post">
            <input type="hidden" name="match_id"   value="<%= m.getId() %>">
            <input type="hidden" name="tournoi_id" value="<%= m.getTournoiId() %>">

            <div class="score-inputs">
                <input type="number" name="score1" value="<%= (m.getScore1() != null) ? m.getScore1() : 0 %>" min="0" max="99" required>
                <span>–</span>
                <input type="number" name="score2" value="<%= (m.getScore2() != null) ? m.getScore2() : 0 %>" min="0" max="99" required>
            </div>

            <div class="options-group">
                <label><input type="checkbox" name="prolongation" <%= (m.isProlongation() ? "checked" : "") %>> Prolongation</label>
                <label><input type="checkbox" name="tirs_au_but" <%= (m.isTirsAuBut() ? "checked" : "") %>> Tirs au but</label>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-success">Enregistrer le score</button>
                <a href="<%= ctx %>/tournois?action=detail&id=<%= m.getTournoiId() %>" class="btn btn-secondary">Annuler</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>