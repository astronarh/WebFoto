<%--
  Created by IntelliJ IDEA.
  User: ShkerdinVA
  Date: 26.06.2018
  Time: 16:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Image</title>
</head>
<body>
Image
${name}
<br/>
${bytes}
<script>
    var image = new Image();
    image.src = '${bytes}';
    document.body.appendChild(image);
</script>
</body>
</html>
