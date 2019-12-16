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

            var status;

            $(function ()
            {
                $("#status").change(function ()
                {
                    status=$("#status").val();
                });

            });
            function addWaterLevel()
            {

                var name=$("#name").val();
                var waterLevel=$("#waterLevel").val();
                var over=$("#over").val();
                var collectionDate=$("#collectionDate").val();

                $.post("../AddWaterLevelDataServlet",{name:name,waterLevel:waterLevel,over:over,status:status,collectionDate:collectionDate},function (data)
                {
                    var msg = data.msg;
                    var str='<div class="alert alert-warning alert-dismissible" role="alert">\n' +
                        '  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n' +
                        '  <strong>提示：</strong>'+msg+'\n' +
                        '</div>';
                    $("#msg_div").html(str);

                });

            }





    </script>
</head>
<body style="background:url('../img/img01.jpg') repeat-x">
<div class="container">
    <div class="row">
        <div class="col-sm-8 col-sm-offset-2">
            <form id="waterLevelForm" action="AddWaterQualityDataServlet" method="post">
                <table class="table table-bordered">
                    <caption style="text-align: center;font-size: 24px">添加水位监测数据</caption>
                    <tr class="success">
                        <th  style="text-align: center">地点</th>
                        <th  style="text-align: center">水位（m）</th>
                        <th  style="text-align: center">超过警戒线（m）</th>
                        <th  style="text-align: center">状态</th>
                        <th  style="text-align: center">采集日期</th>
                    </tr>
                    <tr class="info">
                        <td><input id="name" name="name" placeholder="王家坝控制站"></td>
                        <td><input id="waterLevel" type="number" step="0.01" min="0" name="waterLevel" placeholder="21.43"></td>
                        <td><input id="over" name="over" type="number" min="0" step="0.01" placeholder="0.01"></td>
                        <td><select id="status"><option>--请选择--</option><option value="OK">正常</option><option value="NO">异常</option></select></td>
                        <td><input id="collectionDate" name="collectionDate" type="date"></td>

                    </tr>
                    <tr class="info">
                        <td colspan="2" style="text-align: center"><input onclick="addWaterLevel();" type="button" value="添加" class="btn btn-info"></td>
                        <td colspan="3"> <div id="msg_div"></div></td>
                    </tr>

                </table>

            </form>

        </div><%--单元格的结尾--%>

    </div><%--row end--%>
</div>

</body>
</html>
