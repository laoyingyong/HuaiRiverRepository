<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2020-02-11
  Time: 12:44
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"  isELIgnored="false" %>
<html>
<head>
    <title>文件上传</title>
    <script src="js/jquery-3.2.1.min.js"></script>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="js/bootstrap.min.js"></script>
</head>
<body style="background: url('img/img01.jpg') repeat-x;">


<h3>总共保存了${message}条记录！</h3><button class="btn-info btn" onclick="back();">返回</button>
<script>
    function back()
    {
      window.location.href="waterQualityPage/addWaterQualityData.jsp";
    }
</script>
</body>
</html>
