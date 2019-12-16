<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-12-11
  Time: 18:43
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>添加水质质量数据</title>
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="../js/jquery-3.2.1.min.js"></script>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="../css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="../js/bootstrap.min.js"></script>
    <script>
        $(function ()
        {
            $("#stationForm").submit(function ()
            {
                $.get("../AddWaterQualityDataServlet",$("#stationForm").serialize(),function (data)//serialize()千万别少写了括号哦
                {
                    var msg=data.msg;
                    var str='<div class="alert alert-warning alert-dismissible" role="alert">\n' +
                        '  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n' +
                        '  <strong>提示：</strong>'+msg+'\n' +
                        '</div>';
                    $("#msg_div").html(str);
                });

                return false;//阻止页面跳转
            });


            $("#waterQualityForm").submit(function ()
                {
                    $.post("../AddWaterQualityInfoServlet",$("#waterQualityForm").serialize(),function (data)
                    {
                        var msg = data.msg;
                        var str='<div class="alert alert-warning alert-dismissible" role="alert">\n' +
                            '  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n' +
                            '  <strong>提示：</strong>'+msg+'\n' +
                            '</div>';
                        $("#msg2_div").html(str);



                    });


                    return false;

                }
            );

        });
    </script>
</head>
<body style="background: url('../img/img01.jpg') repeat-x;">
<div class="container">
    <div class="row">
        <div class="col-sm-8 col-sm-offset-2">
            <form id="stationForm" action="AddWaterQualityDataServlet" method="post">
            <table class="table table-bordered">
                <caption style="text-align: center;font-size: 24px">添加水质监测站</caption>
                <tr class="success">
                    <th  style="text-align: center">监测站名称</th>
                    <th  style="text-align: center">所属断面</th>
                    <th  style="text-align: center">简介</th>
                </tr>
                <tr class="info">
                    <td><input name="stationName" placeholder="安徽宿州杨庄"></td>
                    <td><input name="section" placeholder="苏-皖省界"></td>
                    <td><textarea rows="5" cols="20" name="introduction" placeholder="安徽宿州杨庄水质自动监测站位于宿州市杨庄乡伊桥村。点位坐标北纬34度03分43秒，东经117度13分12秒。属淮河流域，奎河（苏-皖省界）。由安徽省宿州环境监测站管理。距水站77公里。建于2006年12月。"></textarea></td>
                </tr>
                <tr class="info">
                    <td style="text-align: center"><input id="addStation_Btn" type="submit" value="添加" class="btn btn-info"></td>
                    <td colspan="2"> <div id="msg_div"></div></td>
                </tr>

            </table>

            </form>

        </div><%--单元格的结尾--%>

    </div><%--row end--%>

    <div class="row" style="padding-top: 50px"><%--第二行--%>

        <div class="col-md-12">
            <form id="waterQualityForm" action="AddWaterQualityDataServlet" method="post">
                <table class="table table-bordered table-responsive table-condensed">
                    <caption style="text-align: center;font-size: 24px">添加水质监测数据</caption>
                    <tr class="success">
                        <th  style="text-align: center">所属测站名</th>
                        <th  style="text-align: center">PH</th>
                        <th  style="text-align: center">溶解氧</th>
                        <th  style="text-align: center">氨氮</th>
                        <th  style="text-align: center">高猛酸钾指数</th>
                        <th  style="text-align: center">总有机碳</th>
                        <th  style="text-align: center">水质类别</th>
                        <th  style="text-align: center">更新日期</th>
                        <th  style="text-align: center">更新时间</th>
                    </tr>
                    <tr class="info">
                        <td><input style="width: 120px" name="belongStation" placeholder="江苏盱眙"></td>
                        <td><input style="width: 120px" name="ph" placeholder="8.02"></td>
                        <td><input style="width: 110px" name="oxygen" placeholder="11.33"></td>
                        <td><input style="width: 120px" name="nitrogen" placeholder="1.39"></td>
                        <td><input style="width: 120px" name="permangan" placeholder="3.5"></td>
                        <td><input style="width: 120px" name="orgacarbon" placeholder="0.8"></td>
                        <td><input style="width: 120px" name="waterQuality" placeholder="IV"></td>
                        <td><input style="width: 140px" type="date" name="date" placeholder="2019-12-11"></td>
                        <td><input style="width: 120px" name="time"  placeholder="20:00:00"></td>
                    </tr>
                    <tr class="info">
                        <td colspan="4" style="text-align: center"><input id="addWaterQuality_Btn" type="submit" value="添加" class="btn btn-info"></td>
                        <td colspan="5"> <div id="msg2_div"></div></td>
                    </tr>

                </table>
            </form>

        </div><%--单元格的结尾--%>


    </div><%--第二行end--%>

</div><%--container容器end--%>


</body>
</html>
