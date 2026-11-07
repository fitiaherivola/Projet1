<%@ page contentType="text/html;charset=UTF-8" import="model.Utilisateur" %>
<%
    Utilisateur _user = (Utilisateur) session.getAttribute("utilisateur");
    String _ctx = request.getContextPath();
    boolean _isAdmin = _user != null && ("ADMIN".equals(_user.getRole()) || "ORGANISATEUR".equals(_user.getRole()));
%>
<style>
    /* Design moderne, clair et épuré pour la barre de navigation */
    :root {
        --nav-bg: #ffffff;
        --nav-border: #e2e8f0;
        --nav-text: #0f172a;
        --nav-muted: #64748b;
        --nav-accent: #4f46e5;
        --nav-hover-bg: #f8fafc;
        --nav-danger: #ef4444;
    }

    nav {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color: var(--nav-bg);
        border-bottom: 1px solid var(--nav-border);
        padding: 0 24px;
        height: 64px;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
    }

    .nav-links-left, .nav-links-right {
        display: flex;
        align-items: center;
        gap: 8px;
        height: 100%;
    }

    nav a {
        display: inline-flex;
        align-items: center;
        color: var(--nav-muted);
        text-decoration: none;
        font-size: 0.95rem;
        font-weight: 500;
        padding: 8px 16px;
        border-radius: 6px;
        transition: all 0.2s ease;
    }

    nav a:hover {
        color: var(--nav-text);
        background-color: var(--nav-hover-bg);
    }

    nav a.brand {
        font-weight: 800;
        font-size: 1.1rem;
        color: var(--nav-text);
        letter-spacing: -0.02em;
        padding-left: 0;
        margin-right: 16px;
        background-color: transparent !important;
    }

    nav a.brand:hover {
        color: var(--nav-accent);
    }

    .user-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background-color: #f1f5f9;
        color: var(--nav-text);
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
        margin-right: 8px;
        border: 1px solid var(--nav-border);
    }

    .user-role {
        font-size: 0.75rem;
        color: var(--nav-accent);
        text-transform: uppercase;
        letter-spacing: 0.05em;
        background-color: rgba(79, 70, 229, 0.1);
        padding: 2px 6px;
        border-radius: 4px;
        margin-left: 4px;
    }

    nav a.btn-logout {
        color: var(--nav-danger);
    }

    nav a.btn-logout:hover {
        background-color: #fee2e2;
        color: var(--nav-danger);
    }

    /* Responsive basique pour mobile */
    @media (max-width: 640px) {
        nav {
            padding: 0 16px;
            height: auto;
            flex-direction: column;
            gap: 12px;
            padding-bottom: 12px;
            padding-top: 12px;
        }
        .nav-links-left, .nav-links-right {
            width: 100%;
            justify-content: center;
            flex-wrap: wrap;
            height: auto;
        }
        nav a.brand {
            margin-right: 0;
            padding: 0;
        }
    }
</style>

<nav>
    <div class="nav-links-left">
        <a class="brand" href="<%= _ctx %>/tournois"> Tournois Sportifs</a>
        <a href="<%= _ctx %>/tournois">Tournois</a>
        <% if (_isAdmin) { %>
            <a href="<%= _ctx %>/equipes">Équipes</a>
        <% } %>
    </div>
    
    <div class="nav-links-right">
        <% if (_user != null) { %>
            <span class="user-badge">
                 <%= _user.getNom() %> <span class="user-role"><%= _user.getRole() %></span>
            </span>
            <a href="<%= _ctx %>/login?action=logout" class="btn-logout">Déconnexion</a>
        <% } %>
    </div>
</nav>