<%--
  Created by IntelliJ IDEA.
  User: ShkerdinVA
  Date: 26.06.2018
  Time: 16:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <link href="<c:url value="/resources/statics/style/index.css" />" rel="stylesheet">

    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <%--
    <link type="text/css" rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
    <link type="text/css" rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" />
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/plug-ins/1.10.16/dataRender/datetime.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    --%>
    <script src="<c:url value="/resources/statics/js/webcamStream.js" />" type="text/javascript"></script>
    <title>Index</title>


    <style>
        #aboutFoto {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;

            background-color: #1d9ce5;
            z-index: 10000;

            display: none;
        }
    </style>
</head>
<body onload="showImages()">

<%@ include file="/WEB-INF/views/parts/menu.jsp" %>

<security:authorize access="isAnonymous()">
    <%@ include file="/WEB-INF/views/parts/authentication.jsp" %>
</security:authorize>

<%--@elvariable id="image" type="ru.astronarh.WebFoto.model.Image"--%>
<form:form name="string" method="post" action="/saveImage" modelAttribute="image" cssStyle="display: none;">
    <form:input path="name"/>
    <form:input id="bytes" path="bytes"/>
    <form:input id="user_id" path="user_id"/>
    <input type="submit" value="send">
</form:form>
<button onclick="send()" style="display: none;">Send by BOST</button>
<%--<img src="resources/statics/img/RUS.png" id="sourceImg">--%>
<canvas  id="myCanvas" width="400" height="350" style="display: none"></canvas>

<security:authorize access="isAuthenticated()">
    <div id="main_container" align="center" >
        <div class="main">
            <div class="main_in_main">
                <div class="content" id="content">
                    <div class="container">
                        <div class="app">
                            <%--<h3>Take a Selfie</h3>--%>

                            <a href="#" id="start-camera" class="visible">Touch here to start the app.</a>
                            <video id="camera-stream"></video>
                            <img id="snap">

                            <p id="error-message"></p>

                            <div class="controls">
                                <a href="#" id="note-photo" title="Note Photo in base" class="disabled"><i class="material-icons">note</i></a>

                                <a href="#" id="delete-photo" title="Delete Photo" class="disabled"><i class="material-icons">delete</i></a>
                                <a href="#" id="take-photo" title="Take Photo"><i class="material-icons">camera_alt</i></a>
                                <a href="#" id="download-photo" download="selfie.png" title="Save Photo In PC" class="disabled"><i class="material-icons">file_download</i></a>

                                <a href="#" id="save-photo" title="Save Photo In Base" class="disabled"><i class="material-icons">star_half</i></a>
                            </div>

                            <!-- Hidden canvas element. Used for taking snapshot of video. -->
                            <canvas></canvas>
                        </div>
                    </div>

                    <div class="container">
                        <table id="imagesRoll">
                            <tr id="trImageRoll">
                                <c:if test="${imageList.size() > 0}">
                                    <td valign="middle"><img src="resources/statics/img/previous.png"onclick="showImagesLeft()" style="cursor: pointer"></td>
                                    <td>
                                        <img id="td0" src="${imageList.get(0).bytes}" height="120" name="${imageList.get(0).id}" onclick="showHideAboutImage(this)" class="smalImage">
                                    </td>
                                    <td>
                                        <c:if test="${imageList.size() > 1}">
                                            <img id="td1" src="${imageList.get(1).bytes}" height="120" name="${imageList.get(1).id}" onclick="showHideAboutImage(this)" class="smalImage">
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${imageList.size() > 2}">
                                            <img id="td2" src="${imageList.get(2).bytes}" height="120" name="${imageList.get(2).id}" onclick="showHideAboutImage(this)" class="smalImage">
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${imageList.size() > 3}">
                                            <img id="td3" src="${imageList.get(3).bytes}" height="120" name="${imageList.get(3).id}" onclick="showHideAboutImage(this)" class="smalImage">
                                        </c:if>
                                    </td>
                                    <td valign="middle"><img src="resources/statics/img/next.png" onclick="showImagesRight()" style="cursor: pointer"></td>
                                </c:if>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</security:authorize>

<div id="aboutFoto">
    <img src="" id="bigImage" width="100%" style="display: block;" >
    <input type="text" id="idFoto" hidden>
    <div id="imageControl">
        <a href="#" id="closeFoto" title="Close" class="imageControlButtons"><i class="material-icons">close</i></a>
        <br/>
        <a href="#" id="saveFoto" title="Save Photo On PC" class="imageControlButtons" onclick="saveBase64AsFile()"><i class="material-icons">save</i></a>
        <br/>
        <a href="#" id="deleteFoto" title="Delete Foto" class="imageControlButtons"><i class="material-icons" onclick="deleteFoto()">delete_forever</i></a>
    </div>
</div>

<script>
    var images = [ "0", "0", "0", "0" ];
    var ids = [ "0", "0", "0", "0" ];
    var imgCounter = 0;
    var numberOfImages = ${numberOfImages};

    function showImagesRight() {
        if ((imgCounter + 4) === numberOfImages) return;
        $.ajax({
            url: "/images/" + ++imgCounter,
            type: "GET",
            dataType: "json",
            success : function(list) {
                // list is the list as Javascript array
                //alert(list);
                var counter = 0;
                $.each(list, function(index, image){
                    //alert(counter + " : " + image.bytes);
                    images[counter] = image.bytes;
                    ids[counter] = image.id;
                    counter++;
                });
                document.getElementById("td0").src = images[0];
                document.getElementById("td1").src = images[1];
                document.getElementById("td2").src = images[2];
                document.getElementById("td3").src = images[3];

                document.getElementById("td0").name = ids[0];
                document.getElementById("td1").name = ids[1];
                document.getElementById("td2").name = ids[2];
                document.getElementById("td3").name = ids[3];
            }
        });
    }

    function showImagesLeft() {
        if (imgCounter === 0) return;
        $.ajax({
            url: "/images/" + --imgCounter,
            type: "GET",
            dataType: "json",
            success : function(list) {
                // list is the list as Javascript array
                //alert(list);
                var counter = 0;
                $.each(list, function(index, image){
                    //alert(counter + " : " + image.bytes);
                    images[counter] = image.bytes;
                    counter++;
                });
                document.getElementById("td0").src = images[0];
                document.getElementById("td1").src = images[1];
                document.getElementById("td2").src = images[2];
                document.getElementById("td3").src = images[3];
            }
        });
    }
</script>
</body>
</html>
<script src="<c:url value="/resources/statics/js/index.js" />" type="text/javascript"></script>
