<%--
  Created by IntelliJ IDEA.
  User: ShkerdinVA
  Date: 20.06.2018
  Time: 15:18
  To change this template use File | Settings | File Templates.
--%>
<div class="login-page">
    <div class="form">
        <form class="register-form">
            <input type="text" placeholder="name"/>
            <input type="password" placeholder="password"/>
            <input type="text" placeholder="email address"/>
            <button>create</button>
            <p class="message">Already registered? <a href="#">Sign In</a></p>
        </form>
        <form class="login-form"  action="<c:url value='/' />" method='POST'>
            <input type="text" placeholder="username" name='username'/>
            <input type="password" placeholder="password" name='password'/>
            <button name="submit" type="submit">login</button>
            <p class="message"><label> Remember me<input type="checkbox" name="remember-me" /> </label></p>
            <p class="message">Not registered? <a href="#">Create an account</a></p>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
    </div>
</div>