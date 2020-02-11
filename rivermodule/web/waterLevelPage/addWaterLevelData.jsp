<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-12-12
  Time: 16:18
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>添加水位数据</title>
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="../js/jquery-3.2.1.min.js"></script>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="../css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="../js/bootstrap.min.js"></script>
    <script>

        $(function () //入口函数
        {
            $("#waterLevelForm").submit(function ()
            {
                $.post("../AddWaterLevelDataServlet",$(this).serialize(),function (data)
                {
                    alert(data.msg);
                });

                return false;//阻止页面跳转
            });
        });

        function addWaterLevel()
        {
            $.post("../AddManyWaterLevelServlet",function (data)
            {
                alert(data.msg);
            });

        }


    </script>
</head>
<body style="background:url('../img/img01.jpg') repeat-x">
<div class="container">
    <div class="row">
        <div class="col-sm-12">
            <form id="waterLevelForm" action="AddWaterQualityDataServlet" method="post">
                <table class="table table-bordered">
                    <caption style="text-align: center;font-size: 24px">添加水位监测数据</caption>
                    <tr class="success">
                        <th  style="text-align: center">河流</th>
                        <th  style="text-align: center">站名</th>
                        <th  style="text-align: center">日期</th>
                        <th  style="text-align: center">水位（m）</th>
                        <th  style="text-align: center">流量</th>
                        <th  style="text-align: center">超警戒/汛限水位</th>
                    </tr>
                    <tr class="info">
                        <td><input name="riverName" placeholder="淮河"></td>
                        <td><input name="siteName" placeholder="站名"></td>
                        <td><input type="datetime-local" name="collectionDate"></td>
                        <td><input type="number" step="0.01" style="width: 80px" name="waterLevel"></td>
                        <td><input type="number" step="0.1" style="width: 80px" name="flow"></td>
                        <td><input type="number" step="0.01" style="width: 80px" name="over"></td>

                    </tr>
                    <tr class="info">
                        <td colspan="6" style="text-align: center"><input type="submit" value="添加" class="btn btn-info"></td>
                    </tr>

                </table>

            </form>

        </div><%--单元格的结尾--%>

    </div><%--row end--%>

    <div class="row">
        <div class="col-sm-4">
            <button class="btn btn-info" onclick="addWaterLevel();"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span>&nbsp;从淮河水文局同步数据到数据库</button>
        </div>


    </div>
    <div class="row" style="margin-top: 50px">
        <div class="col-sm-5">
            <form method="post" action="../UploadServlet2" enctype="multipart/form-data">
                <table class="table table-bordered">
                    <caption style="text-align: center;font-size: 24px" >文件上传方式</caption>
                    <tr>
                        <td>
                            <input type="file" name="file" class="btn btn-info" >

                        </td>
                        <td>
                            <input type="submit" value="开始上传水位数据" class="btn btn-info">
                        </td>
                    </tr>

                </table>


            </form>

        </div>

    </div>
</div>

</body>
</html>
