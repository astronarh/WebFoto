<%--
  Created by IntelliJ IDEA.
  User: ShkerdinVA
  Date: 20.06.2018
  Time: 15:05
  To change this template use File | Settings | File Templates.
--%>
<div id="selector">
    <a href="${pageContext.request.contextPath}/?lang=ru"><img src="resources/statics/img/RUS.png" height="30"/></a>
    <a href="${pageContext.request.contextPath}/?lang=en"><img src="resources/statics/img/USA.png" height="30"/></a>
    <br/>
    <a href="${pageContext.request.contextPath}/?theme=light"><img src="resources/statics/img/light%20bulb.png" height="30"/></a>
    <a href="${pageContext.request.contextPath}/?theme=dark"><img src="resources/statics/img/dark%20bulb.png" height="30"/></a>
    <br/>
    <security:authorize access="hasRole('ROLE_USER')">
        <form action="logout" method="post">
            <a href="${pageContext.request.contextPath}/user"><img src="resources/statics/img/user.png" height="30"/></a>
            <input type="image" src="resources/statics/img/logout.png" border="0" alt="Submit" style="height: 25px;"/>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <br/>
            <security:authorize access="hasRole('ROLE_ADMIN')">
                <a href="${pageContext.request.contextPath}/admin"><img src="resources/statics/img/admin.png" height="30"/></a>
            </security:authorize>
        </form>
    </security:authorize>
    <security:authorize access="isAuthenticated()">
        <%--<security:authentication property="principal.username" />--%>
    </security:authorize>

</div>