<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Connexion — Tournois Sportifs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
            --danger-color: #ef4444;
            --danger-bg: #fef2f2;
            --danger-border: #fca5a5;
            --focus-ring: rgba(79, 70, 229, 0.15);
            --radius-main: 12px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: var(--bg-global);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            color: var(--text-dark);
            padding: 20px;
            line-height: 1.5;
        }

        .login-box {
            background: var(--surface-card);
            padding: 40px;
            border-radius: var(--radius-main);
            width: 100%;
            max-width: 400px;
            border: 1px solid var(--border-light);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
        }

        .login-box h1 {
            text-align: center;
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--text-dark);
            letter-spacing: -0.02em;
            margin-bottom: 6px;
        }

        .login-box p.sub {
            text-align: center;
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-bottom: 28px;
        }

        /* Message d'erreur */
        .msg-error {
            background-color: var(--danger-bg);
            color: var(--danger-color);
            border: 1px solid var(--danger-border);
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 20px;
            text-align: center;
        }

        /* Formulaire */
        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 6px;
            color: var(--text-dark);
        }

        .form-group input {
            width: 100%;
            padding: 10px 14px;
            font-size: 0.95rem;
            border: 1px solid var(--border-light);
            border-radius: 8px;
            background-color: #fff;
            color: var(--text-dark);
            transition: all 0.2s ease;
            box-sizing: border-box;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px var(--focus-ring);
        }

        /* Bouton */
        .btn {
            width: 100%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 11px;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: background-color 0.2s ease, transform 0.1s ease;
            margin-top: 10px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: #ffffff;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
        }

        .btn-primary:active {
            transform: scale(0.99);
        }

        /* Informations de test */
        .test-accounts {
            text-align: center;
            margin-top: 24px;
            font-size: 0.8rem;
            color: var(--text-muted);
            background-color: #fafafa;
            padding: 10px;
            border-radius: 6px;
            border: 1px dashed var(--border-light);
        }
    </style>
</head>
<body>
<div class="login-box">
    <h1> Tournois Sportifs</h1>
    <p class="sub">Connectez-vous pour accéder à l'application</p>

    <% String erreur = (String) request.getAttribute("erreur"); %>
    <% if (erreur != null) { %>
        <div class="msg-error"> <%= erreur %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="form-group">
            <label for="email">Adresse email</label>
            <input type="email" id="email" name="email" placeholder="exemple@email.com" required>
        </div>
        <div class="form-group">
            <label for="mot_de_passe">Mot de passe</label>
            <input type="password" id="mot_de_passe" name="mot_de_passe" placeholder="••••••••" required>
        </div>
        <button type="submit" class="btn btn-primary">Se connecter</button>
    </form>
    
    <div class="test-accounts">
        Comptes test : <strong>admin@tournois.mg</strong> / <strong>admin123</strong>
    </div>
</div>
</body>
</html>