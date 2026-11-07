<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session.getAttribute("utilisateur") != null) {
        response.sendRedirect(request.getContextPath() + "/tournois");
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>