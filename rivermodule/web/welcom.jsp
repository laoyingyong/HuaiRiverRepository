<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2020-01-29
  Time: 17:00
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>欢迎界面</title>
    <script src="js/jquery-3.2.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        html {
            position: relative;
            min-height: 100%;
        }

        body {
            /* Margin bottom by footer height */
            margin-bottom: 60px;
        }

        .footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            /* Set the fixed height of the footer here */
            height: 50px;
            background-color: #f5f5f5;
        }
    </style>

</head>
<body style="background: url('img/img01.jpg') repeat-x;padding-top: 52px">
<div id="particles-js" style="height: 550px;z-index: 2000;">
    <div style="">
        <h3 style="margin-left: 450px;text-shadow:1px 1px 5px red,2px 2px 5px orange">欢迎使用淮河水量水质监测系统</h3>
    </div>
</div>

<footer class="footer">
    <div class="container">
        <div class="row" >
            <div class="col-sm-5 col-sm-offset-4">
                <strong>Copyright &copy; 2019-2020 <a href="https://blog.csdn.net/Deep_rooted">Yingyong Lao</a>.</strong> All rights reserved.
            </div>
        </div>
    </div>
</footer>

<script src="js/animation/particles.js"></script>
<script src="js/animation/app.js"></script>
</body>
</html>
